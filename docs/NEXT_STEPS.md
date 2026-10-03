# Radio Charu: Next Actionable Steps

## Phase 3: Cloudflare Tunnel Gateway (Deferred Status)
- [~] **DEFERRED TO PRE-LAUNCH / CUSTOM DOMAIN HOOKUP**
  - **Prerequisites to Resume**:
    1. Register custom domain (e.g. `radiocharu.com` or subdomains) on Cloudflare.
    2. Create Named Tunnel `radiocharu-tunnel` in Zero Trust dashboard.
    3. Input secret token into `server/.env` (`CLOUDFLARE_TUNNEL_TOKEN=...`).
    4. Map public hostname `stream.yourdomain.com` to `http://icecast_engine:8000`.
    5. Run `docker compose -f server/docker-compose.yml up -d`.

---

## Immediate Next Steps (Transitioning to Phase 4)

1. **Git Commit & Branch Switch**:
   - Stage and commit Phase 3 scaffolding on `feature/02-cloudflare-tunnel`:
     ```powershell
     git add .
     git commit -m "feat(server): add cloudflared tunnel container and documentation (Phase 3 deferred)"
     git push origin feature/02-cloudflare-tunnel
     ```
   - Switch to `main` and branch out to `feature/03-listener-web-app`:
     ```powershell
     git checkout main
     git pull origin main
     git checkout -b feature/03-listener-web-app
     ```

2. **Phase 4: Listener Web App & PWA Architecture**:
   - Initialize the `web/` application directory.
   - Design and build the modern dark-themed, glassmorphic UI layout for Radio Charu.
   - Implement low-latency HTML5 audio streaming element targeting `http://localhost:8000/live` (with fallback configurable via environment).
   - Build real-time Canvas Audio Spectrum Visualizer using the Web Audio API.
   - Implement real-time status telemetry polling against `http://localhost:8000/status-json.xsl` (Now Playing, Stream Title, Bitrate, Listeners Count).
   - Configure Firebase hosting deployment scaffolding (`firebase.json`).
