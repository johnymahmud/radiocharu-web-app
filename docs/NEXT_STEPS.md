# Radio Charu: Next Actionable Steps & Roadmap

## Phase 8 Status: UNIFIED 3-SERVICE DOCKER ECOSYSTEM OPERATIONAL ✅
- **`radiocharu_icecast`**: Core streaming engine on port `8000`.
- **`radiocharu_web_admin`**: Lightweight Nginx container serving listener player (`:3000`), RJ control panel (`:3000/admin/`), and reverse-proxying `/status-json.xsl` & `/live`.
- **`radiocharu_tunnel`**: Zero-trust edge container (`cloudflare/cloudflared:latest`) on custom bridge network `radio_net`.
- **Verification**: All endpoints verified 200 OK locally, mobile cellular streaming tested, and `flutter test` 100% passing.

---

## Day-2 / Next Session Action Roadmap

### 1. Dedicated 24/7 Server Deployment
- **Git Clone & Setup**:
  ```bash
  git clone https://github.com/your-org/radiocharu-web-app.git
  cd radiocharu-web-app
  cp server/.env.example server/.env
  ```
- **Auto-Restart & Background Boot**:
  - All services configured with `restart: unless-stopped` in `docker-compose.yml`.
  - Configure Docker Desktop to launch on Windows system startup.
- **1-Click Stack Launch**:
  ```bash
  docker compose up -d
  ```

### 2. Custom Domain Pointing (Cloudflare Zero Trust)
- In the Cloudflare Zero Trust Dashboard (`Networks` -> `Tunnels`):
  1. Add a Public Hostname pointing to your custom domain (e.g. `stream.yourdomain.com`).
  2. Set Service URL to `http://icecast:8000` (or `http://web_admin:80` for reverse-proxied web access).
  3. Export the Tunnel Token and save it to `server/.env`:
     ```env
     CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoi...
     ```
  4. Restart tunnel container: `docker compose restart cloudflared`.

### 3. Client Applications & Live Distribution
- **Flutter Mobile Client (`mobile_app/`)**:
  - Build Android APK / App Bundle and iOS IPA connected to the live stream endpoint.
  - Test background audio playback with lock-screen notification media controls.
- **Web App Distribution**:
  - Serve directly via Nginx container on port `3000` (or reverse proxied via Cloudflare at `radio.yourdomain.com`).
  - Deploy static PWA to Firebase Hosting / Cloudflare Pages if CDN edge hosting is preferred.

---

## Quick Reference: Local Verification Endpoints
- **Listener Web Player**: `http://localhost:3000`
- **RJ Broadcaster Control Room**: `http://localhost:3000/admin/` (Passkey: `charuAdmin2026`)
- **Icecast Direct Stream**: `http://localhost:8000/live`
- **Icecast JSON Telemetry**: `http://localhost:3000/status-json.xsl`
- **Icecast Web Admin**: `http://localhost:8000/admin/` (User: `admin`, Pass: in `server/.env`)
