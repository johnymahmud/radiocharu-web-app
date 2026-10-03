# Radio Charu: Project History & Decision Ledger

All architectural decisions, major implementation milestones, and key sessions are recorded here in reverse chronological order.

---

### [2026-10-03] - Phase 4: Listener Web App & PWA Implementation
- **Branch**: `feature/03-listener-web-app`
- **Author**: Antigravity Assistant & Frontend Architect
- **Action Items Completed**:
  1. Built modern, zero-dependency, mobile-first Web App in `web/`:
     - `web/index.html`: Semantic layout featuring header, dynamic ON AIR badge, 3-card metrics grid (Status, Listeners, Bitrate), Audio Spectrum Visualizer, player controls, community shoutbox preview, and RJ panel link.
     - `web/css/style.css`: Glassmorphic dark aesthetic utilizing Forest Green (`#1a472a`), Amber (`#e8871e`), Gold (`#dcae1d`), and Neon Live Green (`#2ecc71`) with responsive layout.
     - `web/manifest.json` & `web/sw.js`: PWA support enabling offline caching for the application shell and network bypass for live streaming and telemetry.
     - `web/icons/logo.svg`: SVG brand identity badge with radio waves and microphone styling.
  2. Implemented Web Audio & Streaming Logic:
     - `web/js/config.js`: Central runtime endpoints (`/live`, `/status-json.xsl`) with query param override support.
     - `web/js/audio-player.js`: Resilient HTML5 Audio with auto-reconnect, Web Audio API `AnalyserNode` integration, and animated Canvas spectrum visualizer.
     - `web/js/telemetry.js`: Periodic Icecast JSON parser mapping real-time listener counts, song titles, bitrates, and live broadcast state.
     - `web/js/app.js`: Master UI coordinator with keyboard shortcuts (Space, M, Arrow Keys) and PWA install prompt handler.
  3. Scaffolding for Firebase Hosting:
     - Created root `firebase.json` and `.firebaserc.example` with cache-control headers and single-page routing.
  4. Resolved Cross-Origin Telemetry Synchronization:
     - Configured global `<http-headers>` with `Access-Control-Allow-Origin: *` in `server/icecast/icecast.xml` so status endpoints (`/status-json.xsl`) emit CORS headers.
     - Enhanced `web/js/telemetry.js` with audio-playback state awareness and sanitized title formatting.
  5. Streamlined Native HTML5 Audio Engine:
     - Stripped out all Web Audio API graph dependencies (`AudioContext`, `AnalyserNode`, canvas rendering loop) to eliminate buffer interference and CORS audio blocks.
     - Implemented direct native `Audio()` instance with timestamp cache-busting (`?t=${Date.now()}`), zero-latency stop/start, volume controls, and compact track info UI.
  6. Adopted Signal-Driven Radio Pipeline Architecture:
     - Eliminated duplicate CORS headers from `server/icecast/icecast.xml` to guarantee pristine single-header responses.
     - Generated standard PWA icons (`icon-192.png`, `icon-512.png`) to eliminate manifest 404s.
     - Formally defined the web layer as an ultra-lightweight stream receiver and live telemetry monitor; delegated stateful player controls and visualizers to the upcoming Flutter Mobile Client.
     - Phase 4 core audio pipeline and status detection marked as VERIFIED and STABLE.
- **Architectural Rationale**: Decoupling the stream transport pipeline from stateful UI controls prevents autoplay race conditions and live buffer stalls, delivering rock-solid 24/7 playback stability.

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

---

### [2026-10-03] - Phase 1: Repository Scaffolding & Memory Kit Initialization
- **Author**: Antigravity Assistant & Lead Architect
- **Action Items Completed**:
  1. Created modular directory structure (`docs/`, `server/icecast/`, `server/tunnel/`, `web/`, `admin/`, `shared/`).
  2. Established comprehensive root `.gitignore` to safeguard secrets (`.env*`, tunnel credentials), suppress OS metadata, and ignore Docker/Icecast logs.
  3. Formulated and authored the AI Memory Kit in `docs/` (`AGENT_RULES.md`, `MASTER_BLUEPRINT.md`, `CURRENT_STATE.md`, `PROJECT_LOG.md`, `NEXT_STEPS.md`).
