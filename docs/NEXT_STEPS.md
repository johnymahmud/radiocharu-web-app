# Radio Charu: Next Actionable Steps

## Phase 7 Status: INTEGRATED & READY FOR TOKEN / TESTING ✅
- Multi-container architecture (`icecast` and `cloudflared`) configured with dynamic `TUNNEL_TOKEN` injection on `radio_net` bridge.
- Central configurations (`web/js/config.js`, `admin/js/admin-config.js`, `mobile_app/lib/core/constants/api_endpoints.dart`) updated with dynamic host detection and production edge URL support.
- Ephemeral Quick Tunnel test utilities (`tunnel/quick-tunnel.bat` and `tunnel/quick-tunnel.sh`) configured for instant `trycloudflare.com` testing.
- Static analysis & tests: `flutter analyze` 0 issues, `flutter test` 100% passing.

---

## Testing & Public Launch Options

### Option A: Quick Ephemeral Test (Free, Zero Domain Required)
Test live audio streaming from your local machine over cellular data or remote devices:
1. Ensure the Icecast container is running:
   ```powershell
   cd server
   docker compose up -d icecast
   ```
2. Start the ephemeral quick tunnel:
   ```powershell
   # Windows:
   .\tunnel\quick-tunnel.bat

   # Linux / macOS:
   chmod +x ./tunnel/quick-tunnel.sh && ./tunnel/quick-tunnel.sh
   ```
3. Copy the output URL (e.g., `https://random-words.trycloudflare.com`).
4. Test live stream playback on any phone or browser:
   `https://random-words.trycloudflare.com/live`
   `https://random-words.trycloudflare.com/status-json.xsl`

---

### Option B: Production Cloudflare Zero Trust Named Tunnel (Custom Domain)
For permanent 24/7 public broadcasting with custom domain (e.g. `stream.yourdomain.com`):
1. Navigate to **Cloudflare Dashboard** -> **Zero Trust** -> **Networks** -> **Tunnels**.
2. Click **Create a Tunnel** (select **Cloudflared**), name it `radiocharu-broadcast-tunnel`.
3. Copy the Tunnel Token from the setup command (e.g. `eyJh...`).
4. Set the token in `server/.env`:
   ```env
   CLOUDFLARE_TUNNEL_TOKEN=eyJhIjoi...
   ```
5. In Cloudflare Tunnel Public Hostname configuration, add:
   - **Subdomain**: `stream`
   - **Domain**: `yourdomain.com`
   - **Type**: `HTTP`
   - **URL**: `icecast:8000`
6. Launch both containers:
   ```powershell
   cd server
   docker compose up -d
   ```
7. Verify public stream and status endpoints:
   - `https://stream.yourdomain.com/live`
   - `https://stream.yourdomain.com/status-json.xsl`

---

## Next Steps (Phase 8: 24/7 Dedicated Server Shift)
1. Commit branch `feature/06-cloudflare-tunnel`:
   ```powershell
   git add .
   git commit -m "feat(tunnel): integrate Cloudflare Zero Trust tunnel service and dynamic edge endpoints (Phase 7 complete)"
   git push origin feature/06-cloudflare-tunnel
   ```
2. Merge into `main` and deploy web client to Firebase Hosting (`firebase deploy --only hosting`).
3. Deploy 24/7 Icecast + Cloudflare container stack on the dedicated broadcast machine.
