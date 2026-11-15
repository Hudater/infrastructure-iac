# Technitium DNS Blocklist & Whitelist Synchronizer

Automated pipeline to fetch, parse, and synchronize blocklists and allowlists directly to Technitium DNS servers via REST API.

## Features

- **YAML Configuration (`config.yaml`):** Configure all list-of-lists sources, direct blocklists, and whitelist sources in a single declarative file.
- **List-of-lists:** Automatically resolves meta-sources (e.g., Firebog Ticked, Firebog Adult) into individual blocklist URLs and deduplicates them.
- **Whitelist / Allowlist:**
  - Pulls latest allowlist from GitHub (or custom remote URLs) with automatic local filesystem fallback.
  - Automatically parses and strips Adblock Plus formatting (`||domain^`, `||*.domain.com/^`).
  - Supports wildcard domains (`*.example.com`).
- **Cluster Aware:** Synchronizes across all configured Technitium DNS endpoints (`10.2.0.7` on-prem, `10.70.0.103` bom-arm).
- **Safe Execution:** Displays a diff summary and requires user confirmation before making changes (with `-y` / `--yes` flag for non-interactive automation/cron).

## Files

- [config.yaml](file:///mnt/files/Projects/projects-personal-devops/infra_lab/local-dns/blacklist-generator/config.yaml): Main configuration file.
- [sync.py](file:///mnt/files/Projects/projects-personal-devops/infra_lab/local-dns/blacklist-generator/sync.py): Unified synchronization script.
- [.env](file:///mnt/files/Projects/projects-personal-devops/infra_lab/local-dns/blacklist-generator/.env): API tokens and local environment variables.
- [env.example](file:///mnt/files/Projects/projects-personal-devops/infra_lab/local-dns/blacklist-generator/env.example): Example environment configuration.
- [blocklists.txt](file:///mnt/files/Projects/projects-personal-devops/infra_lab/local-dns/blacklist-generator/blocklists.txt): Generated combined list of resolved blocklist URLs.

## Usage

### 1. Dry Run (Preview changes without applying)
```bash
./sync.py --dry-run
# Or with uv:
uv run sync.py --dry-run
```

### 2. Interactive Run (Prompts for confirmation)
```bash
./sync.py
```

### 3. Non-interactive Run (Cron / Automated)
```bash
./sync.py --yes
```

### 4. Optional: Prune Obsolete Allowed Zones
```bash
./sync.py --yes --prune-allowed
```
