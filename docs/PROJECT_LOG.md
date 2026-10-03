# Radio Charu: Project History & Decision Ledger

All architectural decisions, major implementation milestones, and key sessions are recorded here in reverse chronological order.

---

### [2026-10-03] - Phase 7: Cloudflare Zero Trust Tunnel Integration & Edge Network Architecture
- **Branch**: `feature/06-cloudflare-tunnel`
- **Author**: Antigravity Assistant & Cloudflare DevSecOps Lead
- **Action Items Completed**:
  1. Updated Multi-Container Architecture (`server/docker-compose.yml` and root `docker-compose.yml`):
     - Integrated `cloudflared` tunnel container (`cloudflare/cloudflared:latest`) with dynamic environment token injection (`TUNNEL_TOKEN=${CLOUDFLARE_TUNNEL_TOKEN}`).
     - Connected `icecast` and `cloudflared` services on a unified custom bridge network (`radio_net`), allowing the tunnel container to communicate with `http://icecast:8000` internally without host port bindings.
  2. Environment & Central Configurations:
     - `server/.env.example`: Added `CLOUDFLARE_TUNNEL_TOKEN=your_cloudflare_zero_trust_tunnel_token_here` placeholder and public endpoint variables.
     - `web/js/config.js` & `admin/js/admin-config.js`: Added dynamic hostname and origin detection with automatic fallback to `localhost:8000` when running in local development mode.
     - `mobile_app/lib/core/constants/api_endpoints.dart`: Configured `useProductionEdge` toggle for seamless switching between Android emulator dev (`10.0.2.2:8000`) and Cloudflare HTTPS edge (`https://stream.yourdomain.com`).
  3. Ephemeral Quick Tunnel Verification:
     - Created and updated `tunnel/quick-tunnel.bat` and `tunnel/quick-tunnel.sh` (mirrored in `server/tunnel/`) configured with `http://icecast:8000` for testing live audio streams over `trycloudflare.com` without a custom domain.
  4. Quality & Compliance:
     - Verified Flutter app test pass (`3/3 tests passing`) and zero static analysis issues.
- **Architectural Rationale**: Cloudflare Zero Trust Tunnels eliminate public IP exposure, prevent inbound firewall/port-forwarding risks, and provision free global Anycast SSL certificates automatically for stable live audio delivery.

---

### [2026-10-03] - Phase 6: Multi-Platform Adaptive & Responsive Layout Architecture
- **Branch**: `feature/05-flutter-client`
- **Author**: Antigravity Assistant & Flutter Architect
- **Action Items Completed**:
  1. Built Responsive Architecture in `mobile_app/lib/core/utils/responsive_builder.dart`:
     - Breakpoints: Mobile (`<650px`), Tablet (`650-1100px`), Desktop / Web (`>=1100px`).
  2. Implemented Adaptive Layout Variants in `mobile_app/lib/features/radio_player/views/layouts/`:
     - `mobile_layout.dart`: Native vertical card stack with compact layout flexibility.
     - `tablet_layout.dart`: Balanced dual-column layout (`maxWidth: 960px`) optimized for landscape tablets.
     - `desktop_web_layout.dart`: Premium Studio 2-column layout (`maxWidth: 1140px`) with ambient festive backdrop and online studio connectivity info.
  3. Integrated `ResponsiveBuilder` in `radio_home_screen.dart` to automatically adapt across Mobile, Chrome/Web, and Desktop.
  4. Verified layout resilience: `flutter analyze` 0 issues, `flutter test` 100% passing across all 3 viewports.

---

### [2026-10-03] - Phase 6: Decoupled Flutter Mobile Client Scaffolding
- **Branch**: `feature/05-flutter-client`
- **Author**: Antigravity Assistant & Flutter Architect
- **Action Items Completed**:
  1. Built decoupled, feature-first Flutter mobile application in `mobile_app/`:
     - `mobile_app/lib/core/theme/app_theme.dart`: Authentic Bangladeshi Folk Festive design system (festiveGreen `#0E7A3D`, festiveAmber `#FF7A00` / `#F37021`, festiveYellow `#FFC107`, canvasCream `#FFFDEE`, cardBackground `#FFFFFF` with 2px amber borders & 16px radius, crimsonRed `#E53935`, Google Fonts `Hind Siliguri`).
     - `mobile_app/lib/core/constants/api_endpoints.dart`: Configured for localhost, `10.0.2.2` (Android emulator fallback), and public stream fallback.
     - `mobile_app/lib/core/constants/app_strings.dart`: Complete Bengali station strings, metadata labels, and greetings.
     - `mobile_app/lib/core/services/audio_handler.dart`: Dedicated background audio handler wrapping `just_audio` & `audio_session` with cache-busting timestamping and interruption handling.
     - `mobile_app/lib/core/services/telemetry_service.dart`: Resilient parser for Icecast `/status-json.xsl`.
     - `mobile_app/lib/features/radio_player/controllers/player_controller.dart`: Reactive `ChangeNotifier` orchestrating playback and 3s periodic telemetry polling.
     - `mobile_app/lib/features/radio_player/widgets/`:
       * `header_banner.dart`: Station branding, tagline, and animated ON/OFF Air pill.
       * `telemetry_cards.dart`: 3-card grid (Broadcast status, Listeners, Bitrate) in 2px amber bordered cards.
       * `live_player_card.dart`: Energetic spectrum wave animation, track ticker, master play/pause button, stream reload, and volume slider.
       * `social_follow_card.dart`: Facebook (`#0E7A3D`) and YouTube (`#E53935`) action buttons.
       * `shoutbox_card.dart`: Warm yellow festive card with community chat placeholder and live greeting feed.
       * `radio_home_screen.dart`: Main scrollable view with pull-to-refresh.
     - `mobile_app/lib/features/rj_panel/rj_panel_screen.dart`: Placeholder for future mobile RJ quick controls.
  2. Quality Assurance & Testing:
     - `flutter analyze`: 0 issues found across all packages and components.
     - `flutter test`: 100% test pass rate.
- **Architectural Rationale**: Decoupling the mobile client from the server infrastructure allows independent releases, native audio session management (handling interruptions like phone calls or unplugged headphones), and an authentic Bangladeshi Folk Festive UI.

---

### [2026-10-03] - Phase 5: Broadcaster / RJ Admin Control Panel Suite
- **Branch**: `feature/04-rj-admin-panel`
- **Author**: Antigravity Assistant & Full-Stack Architect
- **Action Items Completed**:
  1. Built dedicated Broadcaster Control Dashboard in `admin/` (and mirrored to `web/admin/` for unified static hosting):
     - `admin/index.html`: Executive dashboard with passkey security gate, live status badge, metrics grid (listeners, peaks, bitrate, stream uptime), track title ticker, and server diagnostics.
     - `admin/css/admin.css`: Control room dark theme with glassmorphic cards, emerald status badges, and responsive layouts.
     - `admin/js/admin-config.js`: Centralized broadcast parameters (Host, Port, Mount `/live`, User, Source password) and admin passkey (`charuAdmin2026`).
     - `admin/js/admin.js`: Handles passkey authentication with session persistence, 1-click clipboard copy utility, password reveal/mask, and 3-second telemetry polling.
  2. Implemented Caster.fm parity setup guides:
     - Step-by-step connection instructions for BUTT, Mixxx, OBS, and mobile streaming encoders (Rocket Broadcaster, BroadcastMySelf).
  3. Integrated seamless cross-navigation between public Listener Web App (`/`) and RJ Panel (`/admin/`).
- **Architectural Rationale**: Providing an intuitive, self-hosted RJ control panel replaces commercial dependencies (such as Caster.fm) while keeping broadcast credentials securely guarded behind a passkey gate.

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
