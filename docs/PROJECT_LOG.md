# Radio Charu: Project History & Decision Ledger

All architectural decisions, major implementation milestones, and key sessions are recorded here in reverse chronological order.

---

### [2026-10-03] - Phase 2: Dockerized Icecast2 Core Server Environment
- **Branch**: `feature/01-docker-icecast`
- **Author**: Antigravity Assistant & Streaming Architect
- **Action Items Completed**:
  1. Configured environment variables in `server/.env.example` and generated `server/.env` (ignored by git):
     - `ICECAST_PORT=8000`
     - `ICECAST_SOURCE_PASSWORD=CharuLiveSource2026!`
     - `ICECAST_RELAY_PASSWORD=CharuLiveRelay2026!`
     - `ICECAST_ADMIN_USER=admin`
     - `ICECAST_ADMIN_PASSWORD=CharuAdminSecure2026!`
     - `ICECAST_MAX_CLIENTS=1000`
     - `ICECAST_BURST_SIZE=65535`
  2. Implemented `server/icecast/icecast.xml` with:
     - Location set to `Dhaka, Bangladesh` and admin contact `admin@radiocharu.local`.
     - Mountpoint `/live` (192kbps, public, CORS enabled for Web Audio API visualizers).
     - Mountpoint `/fallback` for ambient/AutoDJ offline backup.
     - Aliases for `/` -> `/status.xsl` and `/status.json` -> `/status-json.xsl`.
  3. Created `server/icecast/Dockerfile` and `server/icecast/entrypoint.sh` using Alpine 3.20 with `su-exec` rootless runtime, healthchecks, and proper permissions.
  4. Created `server/docker-compose.yml` with service `icecast_engine` (`radiocharu_icecast`), network isolation, volume mappings, and auto-restart policy.
  5. Authored `server/README.md` with complete CLI operations and step-by-step connection guide for BUTT and Mixxx live broadcasting.
  6. Fixed container volume permission crash: Updated `entrypoint.sh` to safely chown writable directories only (`/var/log/icecast2` and `/tmp`), removed `:ro` from docker-compose volume, and eliminated redundant changeowner warnings. Validated container health and JSON endpoint.
- **Architectural Rationale**: Containerizing Icecast ensures identical runtime behavior across developer workstations and the 24/7 dedicated broadcast laptop. Adding CORS headers directly in `icecast.xml` enables zero-friction Web Audio API canvas visualizers in downstream web apps.

---

### [2026-10-03] - Phase 1: Repository Scaffolding & Memory Kit Initialization
- **Author**: Antigravity Assistant & Lead Architect
- **Action Items Completed**:
  1. Created modular directory structure (`docs/`, `server/icecast/`, `server/tunnel/`, `web/`, `admin/`, `shared/`).
  2. Established comprehensive root `.gitignore` to safeguard secrets (`.env*`, tunnel credentials), suppress OS metadata, and ignore Docker/Icecast logs.
  3. Formulated and authored the AI Memory Kit in `docs/` (`AGENT_RULES.md`, `MASTER_BLUEPRINT.md`, `CURRENT_STATE.md`, `PROJECT_LOG.md`, `NEXT_STEPS.md`).
- **Architectural Rationale**: Establishing strict modularity and memory kits upfront prevents context decay across long sessions and simplifies continuous testing on local and production machines.
