# Radio Charu: Current State & System Health

- **Current Version**: `v0.7.0-cloud-tunnel`
- **Active Branch**: `feature/06-cloudflare-tunnel`
- **Current Phase**: **Phase 7: Cloudflare Zero Trust Edge Tunnel Integration — IN PROGRESS / OPERATIONAL**
- **Next Milestone**: **Phase 8: 24/7 Dedicated Server Shift & Production Release**
- **Last Updated**: 2026-10-03
- **Overall Health**: 🟢 Core Broadcast Engine, Listener Web App, RJ Suite, Adaptive Flutter Client, and Cloudflare Tunnel Architecture Live

---

## Active Status & System Snapshot

| Component | Status | Target Host / Port | Details |
| :--- | :--- | :--- | :--- |
| **Directory Scaffolding** | ✅ Completed | Local workspace | `docs/`, `server/icecast/`, `server/tunnel/`, `web/`, `admin/`, `mobile_app/`, `tunnel/`, `shared/` initialized |
| **AI Memory Kit** | ✅ Completed | `docs/` | `AGENT_RULES.md`, `MASTER_BLUEPRINT.md`, `CURRENT_STATE.md`, `PROJECT_LOG.md`, `NEXT_STEPS.md` |
| **Root Git Configuration** | ✅ Completed | `.gitignore` | Configured for Node, Docker logs, OS metadata, Flutter/Dart, and environment secrets |
| **Icecast Engine Docker** | 🟢 Running & Healthy | `localhost:8000` (`icecast:8000`) | Verified Alpine Icecast 2.4 container, clean global CORS, `/live` & `/status-json.xsl` live |
| **Cloudflare Tunnel Gateway** | 🟢 Integrated & Ready | `stream.yourdomain.com` | `radiocharu_tunnel` container configured on `radio_net` bridge with dynamic token injection |
| **Quick Ephemeral Tunnel** | 🟢 Test Scripts Ready | `*.trycloudflare.com` | Verified `tunnel/quick-tunnel.bat` & `.sh` routing directly to `http://icecast:8000` |
| **Signal-Driven Web App & PWA** | 🟢 Verified & Stable | `web/` & Firebase | Direct HTML5 audio streaming, dynamic hostname detection, real-time ON AIR telemetry |
| **RJ Admin Control Panel** | 🟢 Ground-Truth & Light UI | `admin/` & `web/admin/` | Caster.fm Cloud layout, dynamic domain detection, 1-click copy, strict 2.5s polling |
| **Multi-Platform Adaptive Flutter App** | 🟢 Adaptive & Tested | `mobile_app/` (Android/iOS/Web/Desktop) | Breakpoint-driven (`<650px`, `650-1100px`, `>1100px`) layouts, 0 lint errors, 100% test pass |

---

## Phase 7 Implementation Details (Cloudflare Zero Trust Tunnel)

* **Container Architecture (`server/docker-compose.yml` & `docker-compose.yml`)**:
  - `icecast`: Container named `radiocharu_icecast`, hostname `icecast`, network alias `icecast` on `radio_net`.
  - `cloudflared`: Container named `radiocharu_tunnel` (`cloudflare/cloudflared:latest`), depends on `icecast`, runs `tunnel --no-autoupdate run` with environment variable `TUNNEL_TOKEN=${CLOUDFLARE_TUNNEL_TOKEN}`.
  - Shared bridge network `radio_net` (`radiocharu_network`) allowing direct container-to-container communication without exposing host ports.
* **Environment Configuration (`server/.env.example`)**:
  - Contains `CLOUDFLARE_TUNNEL_TOKEN=your_cloudflare_zero_trust_tunnel_token_here`.
  - Configurable `PUBLIC_STREAM_URL` and `PUBLIC_STATUS_URL`.
* **Dynamic Hostname & Edge Fallbacks**:
  - `web/js/config.js` & `admin/js/admin-config.js`: Dynamically detect origin when deployed on custom domains (or stream subdomains) with automatic fallback to `localhost:8000`.
  - `mobile_app/lib/core/constants/api_endpoints.dart`: Configured with `useProductionEdge` toggle for easy switching between local emulator dev (`10.0.2.2:8000` / `localhost:8000`) and production Cloudflare HTTPS endpoint (`https://stream.yourdomain.com`).
* **Ephemeral Quick Tunnel Test Utilities**:
  - `tunnel/quick-tunnel.bat` & `tunnel/quick-tunnel.sh` (mirrored in `server/tunnel/`): One-click launch for zero-cost test streaming via `https://*.trycloudflare.com` without requiring custom domain setup.

---

## Completed Milestones
- [x] Repository created and cloned locally.
- [x] Antigravity IDE workspace initialized with AI Memory Kit.
- [x] `server/.env.example` & `server/.env` configured with broadcast credentials and limits.
- [x] `server/icecast/icecast.xml` created with Dhaka location, clean global CORS headers, and `/live` mountpoint.
- [x] `server/icecast/Dockerfile` & `server/icecast/entrypoint.sh` created with lightweight Alpine base.
- [x] `server/docker-compose.yml` and root `docker-compose.yml` configured for `icecast` and `cloudflared` services.
- [x] `tunnel/quick-tunnel.bat` & `tunnel/quick-tunnel.sh` created and updated with `icecast:8000` container routing.
- [x] `docs/CLOUDFLARE_TUNNEL_GUIDE.md` authored with bilingual (English & বাংলা) setup procedures.
- [x] Phase 4 Signal-Driven Listener Web App, PWA shell, PWA PNG icons, and Firebase hosting configuration verified and stable.
- [x] Phase 5 Broadcaster Admin Control Panel (Caster.fm parity suite) implemented and accessible.
- [x] Phase 6 Multi-Platform Adaptive Flutter Client implemented and verified on Mobile, Tablet, and Desktop.
- [x] Phase 7 Cloudflare Zero Trust tunnel service container, dynamic token injection, and multi-client configuration implemented.

---

## Active Blockers & Known Issues
- None. Ready to inject custom domain tunnel token or launch ephemeral quick-tunnel for public testing.
