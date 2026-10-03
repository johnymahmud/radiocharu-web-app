# Radio Charu: Next Actionable Steps

## Immediate Action Items (Phase 2 Validation)

1. **Local Container Launch & Health Verification**
   - Run: `docker compose -f server/docker-compose.yml up -d --build`
   - Check container status: `docker compose -f server/docker-compose.yml ps`
   - Verify health: `curl http://localhost:8000/status-json.xsl`

2. **Live Broadcast Ingestion Test (Mixxx / BUTT)**
   - Connect broadcaster with credentials:
     * **Host**: `localhost`
     * **Port**: `8000`
     * **Mount**: `/live`
     * **User**: `source`
     * **Password**: `CharuLiveSource2026!`
   - Play audio in BUTT/Mixxx and verify live output at `http://localhost:8000/live` in browser or VLC.

3. **Phase 3 Preview: Cloudflare Zero Trust Tunnel Setup**
   - Create `server/tunnel/Dockerfile` and `server/tunnel/config.yml`.
   - Update `server/docker-compose.yml` with `tunnel_gateway` service using Cloudflare Tunnel token.
   - Map `stream.radiocharu.com` -> `http://icecast_engine:8000` for public HTTPS streaming.
