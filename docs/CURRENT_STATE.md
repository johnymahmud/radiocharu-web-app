# Radio Charu: Current State & System Health

- **Current Version**: `v0.5.0-rj-panel`
- **Active Branch**: `feature/04-rj-admin-panel`
- **Current Phase**: **Phase 5: Broadcaster Admin Control Panel — IN PROGRESS**
- **Next Milestone**: **Phase 6: 24/7 Production Server Shift & Mobile Client Integration**
- **Last Updated**: 2026-10-03
- **Overall Health**: 🟢 Core Broadcast Engine, Listener Web App, and RJ Control Suite Live

---

## Active Status & System Snapshot

| Component | Status | Target Host / Port | Details |
| :--- | :--- | :--- | :--- |
| **Directory Scaffolding** | ✅ Completed | Local workspace | `docs/`, `server/icecast/`, `server/tunnel/`, `web/`, `admin/`, `shared/` initialized |
| **AI Memory Kit** | ✅ Completed | `docs/` | `AGENT_RULES.md`, `MASTER_BLUEPRINT.md`, `CURRENT_STATE.md`, `PROJECT_LOG.md`, `NEXT_STEPS.md` |
| **Root Git Configuration** | ✅ Completed | `.gitignore` | Configured for Node, Docker logs, OS metadata, and environment secrets |
| **Icecast Engine Docker** | 🟢 Running & Healthy | `localhost:8000` | Verified Alpine Icecast 2.4 container, clean global CORS, `/live` & `/status-json.xsl` live |
| **Cloudflare Tunnel Gateway** | ⏸️ Paused / Deferred | `stream.yourdomain.com` | Container scaffolding complete in `docker-compose.yml`. Awaiting custom domain & token |
| **Signal-Driven Web App & PWA** | 🟢 Verified & Stable | `web/` & Firebase | Direct HTML5 audio streaming, real-time ON AIR telemetry, clean PWA manifest/icons |
| **RJ Admin Control Panel** | 🟢 Ground-Truth & Light UI | `admin/` & `web/admin/` | Caster.fm Cloud layout, dual status pills (Server & Broadcast), 1-click copy, strict 2.5s polling |

---

## Phase 5 Implementation Details (Caster.fm Parity & Strict Telemetry)

* **Broadcaster Dashboard Architecture (`admin/` & `web/admin/`)**:
  - `admin/index.html`: Caster.fm Cloud light dashboard featuring pure white card panels on light slate background, dual top-right navbar status pills:
    * `Server: [ Online (Green) / Offline (Red) ]`
    * `Broadcast: [ On Air (Green) / Off Air (Red) ]`
  - `admin/css/admin.css`: Clean light control room UI (`#f1f5f9` slate base, crisp `#ffffff` cards, `#0f172a` top navbar, JetBrains Mono parameters).
  - `admin/js/admin-config.js`: Centralized broadcast parameters (Host, Port, Mount `/live`, User, Source password) and admin passkey (`charuAdmin2026`).
  - `admin/js/admin.js`: Strict ground-truth telemetry engine polling `/status-json.xsl` every 2500ms without artificial state or timeouts. Real-time track title, listeners, peak stats, and live uptime calculation.
  - Setup guide accordions for BUTT, Mixxx, and Mobile encoders.

---

## Completed Milestones
- [x] Repository created and cloned locally.
- [x] Antigravity IDE workspace initialized with AI Memory Kit.
- [x] `server/.env.example` & `server/.env` configured with broadcast credentials and limits.
- [x] `server/icecast/icecast.xml` created with Dhaka location, clean global CORS headers, and `/live` mountpoint.
- [x] `server/icecast/Dockerfile` & `server/icecast/entrypoint.sh` created with lightweight Alpine base.
- [x] `server/docker-compose.yml` configured for `radiocharu_icecast` and `radiocharu_tunnel` services.
- [x] `server/tunnel/quick-tunnel.bat` & `server/tunnel/quick-tunnel.sh` created for test references.
- [x] `docs/CLOUDFLARE_TUNNEL_GUIDE.md` authored with bilingual (English & বাংলা) setup procedures.
- [x] Phase 3 state preserved and documented as deferred without blocking frontend development.
- [x] Phase 4 Signal-Driven Listener Web App, PWA shell, PWA PNG icons, and Firebase hosting configuration verified and stable.
- [x] Phase 5 Broadcaster Admin Control Panel (Caster.fm parity suite) implemented and accessible.

---

## Active Blockers & Known Issues
- None. Ready for local RJ panel verification and preparation for mobile client / 24/7 dedicated laptop deployment.
