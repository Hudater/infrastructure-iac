#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "pyyaml",
#     "requests",
# ]
# ///
"""
Technitium DNS Blocklist & Whitelist Synchronizer
Fetches list-of-lists blocklists and whitelist sources defined in config.yaml,
displays diffs, and applies updates to Technitium DNS nodes via REST API.
"""

import argparse
import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple

import requests
import yaml

SCRIPT_DIR = Path(__file__).parent.resolve()
DEFAULT_CONFIG = SCRIPT_DIR / "config.yaml"
DEFAULT_ENV = SCRIPT_DIR / ".env"
DEFAULT_BLOCKLIST_OUT = SCRIPT_DIR / "blocklists.txt"


def load_env(env_path: Path) -> None:
    """Load key-value pairs from .env file into os.environ if not already set."""
    if not env_path.is_file():
        return
    with open(env_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, val = line.split("=", 1)
                key = key.strip()
                val = val.strip().strip("\"'")
                if key and key not in os.environ:
                    os.environ[key] = val


def parse_adblock_domain(line: str) -> str | None:
    """Parse a domain or wildcard from plain text or Adblock Plus syntax."""
    line = line.strip()
    if not line or line.startswith("#") or line.startswith("!"):
        return None

    # Strip ABP rule syntax: @@||, ||, |, @
    domain = re.sub(r"^[|@]+", "", line)
    # Strip trailing delimiters: /^, ^, / and parameters
    domain = re.sub(r"[\/\^]+.*$", "", domain)
    domain = domain.strip().lower()

    if not domain:
        return None

    # Validate standard domain or wildcard pattern
    if re.match(r"^(\*\.)?[a-zA-Z0-9_\-\.]+$", domain):
        return domain
    return None


def fetch_blocklist_sources(config: dict) -> List[str]:
    """Fetch blocklist URLs from configured lists-of-lists and direct lists."""
    combined_urls: Set[str] = set()

    # 1. Fetch lists-of-lists
    meta_lists = config.get("list_of_lists", [])
    for item in meta_lists:
        if not item.get("enabled", True):
            continue
        name = item.get("name", "Unnamed")
        url = item.get("url")
        if not url:
            continue

        print(f"[*] Fetching list-of-lists: {name} ({url})...")
        try:
            resp = requests.get(url, timeout=15)
            resp.raise_for_status()
            lines = [l.strip() for l in resp.text.splitlines() if l.strip() and not l.startswith("#")]
            print(f"    -> Retrieved {len(lines)} URLs from {name}")
            combined_urls.update(lines)
        except Exception as e:
            print(f"[!] Warning: Failed to fetch {name} ({url}): {e}", file=sys.stderr)

    # 2. Add direct blocklists
    direct = config.get("direct_blocklists", [])
    if direct:
        print(f"[*] Adding {len(direct)} direct blocklist URLs...")
        combined_urls.update([d.strip() for d in direct if d.strip()])

    sorted_urls = sorted(list(combined_urls))
    print(f"[+] Total unique blocklist URLs gathered: {len(sorted_urls)}")
    return sorted_urls


def fetch_whitelist_domains(config: dict) -> List[str]:
    """Fetch and parse whitelist domains from URLs, local fallback, and manual entries."""
    whitelist_cfg = config.get("whitelist", {})
    domains: Set[str] = set()
    fetched_from_remote = False

    # 1. Fetch remote whitelist URLs
    remote_urls = whitelist_cfg.get("urls", [])
    for url in remote_urls:
        if not url:
            continue
        print(f"[*] Fetching whitelist from: {url}...")
        try:
            resp = requests.get(url, timeout=15)
            resp.raise_for_status()
            for line in resp.text.splitlines():
                parsed = parse_adblock_domain(line)
                if parsed:
                    domains.add(parsed)
            fetched_from_remote = True
            print(f"    -> Extracted {len(domains)} domains from {url}")
        except Exception as e:
            print(f"[!] Warning: Failed to fetch remote whitelist ({url}): {e}", file=sys.stderr)

    # 2. Local fallback if remote URLs failed or were not specified
    if not fetched_from_remote:
        fallback_path = whitelist_cfg.get("local_fallback")
        if fallback_path:
            p = Path(fallback_path).expanduser().resolve()
            if p.is_file():
                print(f"[*] Reading whitelist from local fallback: {p}...")
                with open(p, "r", encoding="utf-8") as f:
                    for line in f:
                        parsed = parse_adblock_domain(line)
                        if parsed:
                            domains.add(parsed)
                print(f"    -> Extracted {len(domains)} domains from local fallback")
            else:
                print(f"[!] Warning: Local fallback file not found: {p}", file=sys.stderr)

    # 3. Add manual domains
    manual = whitelist_cfg.get("manual_domains", [])
    for d in manual:
        parsed = parse_adblock_domain(d)
        if parsed:
            domains.add(parsed)

    sorted_domains = sorted(list(domains))
    print(f"[+] Total unique whitelist domains gathered: {len(sorted_domains)}")
    return sorted_domains


class TechnitiumClient:
    def __init__(self, base_url: str, token: str):
        self.base_url = base_url.rstrip("/")
        self.token = token
        self.session = requests.Session()
        self.session.params = {"token": token}

    def get_server_domain(self) -> str:
        url = f"{self.base_url}/api/settings/get"
        resp = self.session.get(url, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        return data.get("response", {}).get("dnsServerDomain", self.base_url)

    def get_blocklists(self) -> List[str]:
        url = f"{self.base_url}/api/settings/get"
        resp = self.session.get(url, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        if data.get("status") != "ok":
            raise RuntimeError(f"API Error ({self.base_url}): {data.get('errorMessage')}")
        return data.get("response", {}).get("blockListUrls") or []

    def set_blocklists(self, urls: List[str]) -> None:
        url = f"{self.base_url}/api/settings/set"
        payload = {"blockListUrls": urls}
        resp = self.session.post(url, json=payload, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        if data.get("status") != "ok":
            raise RuntimeError(f"Failed to set blocklists ({self.base_url}): {data.get('errorMessage')}")

    def force_update_blocklists(self) -> None:
        url = f"{self.base_url}/api/settings/forceUpdateBlockLists"
        resp = self.session.post(url, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        if data.get("status") != "ok":
            raise RuntimeError(f"Failed to force update blocklists ({self.base_url}): {data.get('errorMessage')}")

    def get_allowed_zones(self) -> List[str]:
        url = f"{self.base_url}/api/allowed/export"
        resp = self.session.get(url, timeout=15)
        resp.raise_for_status()
        lines = [l.strip().lower() for l in resp.text.splitlines() if l.strip()]
        return lines

    def import_allowed_zones(self, domains: List[str], chunk_size: int = 100) -> None:
        url = f"{self.base_url}/api/allowed/import"
        for i in range(0, len(domains), chunk_size):
            chunk = domains[i : i + chunk_size]
            data = [("allowedZones", d) for d in chunk]
            resp = self.session.post(url, data=data, timeout=30)
            resp.raise_for_status()
            res_data = resp.json()
            if res_data.get("status") != "ok":
                raise RuntimeError(f"Failed to import allowed zones ({self.base_url}): {res_data.get('errorMessage')}")

    def delete_allowed_zone(self, domain: str) -> None:
        url = f"{self.base_url}/api/allowed/delete"
        resp = self.session.get(url, params={"domain": domain}, timeout=10)
        resp.raise_for_status()


def display_diff(name: str, current: List[str], new: List[str]) -> Tuple[Set[str], Set[str]]:
    curr_set = set(current)
    new_set = set(new)
    added = new_set - curr_set
    removed = curr_set - new_set

    print(f"\n--- {name} Summary ---")
    print(f"Current count: {len(curr_set)}")
    print(f"New count:     {len(new_set)}")
    print(f"To add:        +{len(added)}")
    print(f"To remove:     -{len(removed)}")

    if added and len(added) <= 10:
        print("Sample additions:")
        for a in sorted(list(added))[:5]:
            print(f"  + {a}")
    if removed and len(removed) <= 10:
        print("Sample removals:")
        for r in sorted(list(removed))[:5]:
            print(f"  - {r}")

    return added, removed


def main():
    parser = argparse.ArgumentParser(description="Synchronize blocklists & allowlists to Technitium DNS")
    parser.add_argument("-c", "--config", type=Path, default=DEFAULT_CONFIG, help="Path to config.yaml")
    parser.add_argument("-e", "--env", type=Path, default=DEFAULT_ENV, help="Path to .env file")
    parser.add_argument("-y", "--yes", action="store_true", help="Apply changes non-interactively without prompt")
    parser.add_argument("--dry-run", action="store_true", help="Fetch and calculate diffs without making changes")
    parser.add_argument("--prune-allowed", action="store_true", help="Remove allowed domains that are not in whitelist")
    parser.add_argument("--save-blocklists", type=Path, default=DEFAULT_BLOCKLIST_OUT, help="Path to write blocklists.txt")
    args = parser.parse_args()

    # 1. Load Environment & Config
    load_env(args.env)
    if not args.config.is_file():
        print(f"ERROR: Config file not found: {args.config}", file=sys.stderr)
        sys.exit(1)

    with open(args.config, "r", encoding="utf-8") as f:
        config = yaml.safe_load(f) or {}

    tech_cfg = config.get("technitium", {})
    raw_urls = tech_cfg.get("urls") or [tech_cfg.get("url")]
    server_urls = [u for u in raw_urls if u]
    if not server_urls:
        env_url = os.environ.get("TECHNITIUM_URL")
        if env_url:
            server_urls = [env_url]
        else:
            print("ERROR: No Technitium URL specified in config or environment", file=sys.stderr)
            sys.exit(1)

    token_env_name = tech_cfg.get("token_env", "TECHNITIUM_TOKEN")
    token = os.environ.get(token_env_name) or os.environ.get("TECHNITIUM_TOKEN")
    if not token:
        print(f"ERROR: Missing API token in environment variable '{token_env_name}'", file=sys.stderr)
        sys.exit(1)

    print("==================================================")
    print("      Technitium DNS List Synchronizer")
    print("==================================================")

    # 2. Fetch list-of-lists blocklists
    new_blocklists = fetch_blocklist_sources(config)
    if args.save_blocklists:
        with open(args.save_blocklists, "w", encoding="utf-8") as f:
            for url in new_blocklists:
                f.write(f"{url}\n")
        print(f"[+] Saved {len(new_blocklists)} URLs to {args.save_blocklists}")

    # 3. Fetch whitelist
    new_whitelist = fetch_whitelist_domains(config)

    # 4. Connect to Technitium server(s) and get current state
    clients: List[TechnitiumClient] = []
    for s_url in server_urls:
        client = TechnitiumClient(s_url, token)
        try:
            domain = client.get_server_domain()
            print(f"[+] Connected to Technitium: {s_url} ({domain})")
            clients.append(client)
        except Exception as e:
            print(f"[!] Warning: Could not connect to {s_url}: {e}", file=sys.stderr)

    if not clients:
        print("ERROR: Could not connect to any configured Technitium server.", file=sys.stderr)
        sys.exit(1)

    # Use first reachable client for diff reference
    ref_client = clients[0]
    curr_blocklists = ref_client.get_blocklists()
    curr_allowed = ref_client.get_allowed_zones()

    # 5. Display diffs
    bl_added, bl_removed = display_diff("Blocklists", curr_blocklists, new_blocklists)
    wl_added, wl_removed = display_diff("Whitelist / Allowed Zones", curr_allowed, new_whitelist)

    any_bl_diff = any(set(c.get_blocklists()) != set(new_blocklists) for c in clients)
    any_wl_diff = any(bool(set(new_whitelist) - set(c.get_allowed_zones())) for c in clients)
    any_wl_prune = args.prune_allowed and any(bool(set(c.get_allowed_zones()) - set(new_whitelist)) for c in clients)
    has_changes = any_bl_diff or any_wl_diff or any_wl_prune

    if args.dry_run:
        print("\n[INFO] Dry-run enabled. No changes applied.")
        return

    if not has_changes:
        print("\n[OK] All Technitium nodes are already fully in sync with configured lists.")
        return

    # 6. Prompt confirmation
    if not args.yes:
        print("\n" + "=" * 50)
        try:
            choice = input("Apply these changes to Technitium DNS? [y/N]: ").strip().lower()
        except (KeyboardInterrupt, EOFError):
            print("\nAborted.")
            sys.exit(1)

        if choice not in ("y", "yes"):
            print("Operation aborted by user.")
            sys.exit(0)

    # 7. Apply updates to all reachable nodes
    print("\n[*] Applying changes to Technitium nodes...")
    for client in clients:
        server_id = client.base_url
        print(f"\n--> Updating {server_id}...")

        # 7a. Set blocklists
        node_bl = set(client.get_blocklists())
        if node_bl != set(new_blocklists):
            print(f"    - Setting {len(new_blocklists)} blocklist URLs...")
            client.set_blocklists(new_blocklists)
            print("    - Triggering background blocklist compile & download...")
            client.force_update_blocklists()
        else:
            print("    - Blocklist URLs already up-to-date.")

        # 7b. Import new allowed zones
        node_allowed = set(client.get_allowed_zones())
        node_wl_added = set(new_whitelist) - node_allowed
        if node_wl_added:
            print(f"    - Importing {len(node_wl_added)} new allowed zones (batch import)...")
            client.import_allowed_zones(sorted(list(node_wl_added)))
        else:
            print("    - Allowed zones already up-to-date.")

        # 7c. Prune stale allowed zones if requested
        if args.prune_allowed:
            node_wl_removed = node_allowed - set(new_whitelist)
            if node_wl_removed:
                print(f"    - Pruning {len(node_wl_removed)} obsolete allowed zones...")
                for d in sorted(list(node_wl_removed)):
                    client.delete_allowed_zone(d)

        print(f"[✔] Successfully synchronized {server_id}")

    print("\n==================================================")
    print("  Synchronization Complete! DNS is Protected 🛡️")
    print("==================================================")


if __name__ == "__main__":
    main()
