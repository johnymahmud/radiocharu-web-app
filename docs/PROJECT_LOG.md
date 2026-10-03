# Radio Charu: Project History & Decision Ledger

All architectural decisions, major implementation milestones, and key sessions are recorded here in reverse chronological order.

---

### [2026-10-03] - Phase 3: Cloudflare Zero Trust Architecture Completed & Deferred for Domain Configuration
- **Branch**: `feature/02-cloudflare-tunnel`
- **Author**: Antigravity Assistant & DevSecOps Lead
- **Action Items & Decisions**:
  1. Configured 2-container compose architecture with `tunnel_gateway` (`cloudflare/cloudflared:latest`) linked to `icecast_engine:8000` via `radiocharu_network`.
  2. Conducted technical audit on ephemeral vs named tunnels:
     - Ephemeral quick tunnels (`trycloudflare.com`) experienced periodic upstream EOF dropouts unsuitable for stable audio streaming.
     - Dedicated Named Tunnels in Cloudflare Zero Trust require account card verification/custom domain setup.
  3. **Architectural Decision**: Formally paused / deferred edge domain provisioning to avoid blocking downstream progress. Decoupled the edge transport layer from frontend application development.
  4. Preserved all scaffolding, Docker definitions, bilingual manuals ([`docs/CLOUDFLARE_TUNNEL_GUIDE.md`](file:///f:/Vibecoding/radiocharu-web-app/docs/CLOUDFLARE_TUNNEL_GUIDE.md)), and fallback scripts.
  5. Transitioned active milestone to **Phase 4: Listener Web App & PWA Interface** running against local streaming endpoints (`http://localhost:8000`).

---

### [2026-10-03] - Phase 2: Dockerized Icecast2 Core Server Environment
- **Branch**: `feature/01-docker-icecast`
- **Author**: Antigravity Assistant & Streaming Architect
- **Action Items Completed**:
  1. Configured environment variables in `server/.env.example` and generated `server/.env` (ignored by git).
  2. Implemented `server/icecast/icecast.xml` with Dhaka location, CORS headers, `/live` mountpoint, and status JSON aliases.
  3. Created `server/icecast/Dockerfile` and `server/icecast/entrypoint.sh` using Alpine 3.20 with `su-exec` rootless runtime.
  4. Created `server/docker-compose.yml` with service `icecast_engine` (`radiocharu_icecast`).
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
