# Radio Charu: Next Actionable Steps

## Immediate Action Items

1. **Commit & Push Phase 1 Scaffolding**
   - Stage all newly created directories and memory kit documents.
   - Commit message: `chore: initialize repository scaffolding and AI memory kit (Phase 1)`
   - Push to `origin/main`.

2. **Branch Creation for Phase 2**
   - Create feature branch: `feature/01-docker-icecast`
   - Switch to the feature branch before creating container configurations.

3. **Phase 2 Implementation: Dockerized Icecast Media Server**
   - Create `server/icecast/Dockerfile` utilizing alpine-based Icecast2 with CORS and JSON status support.
   - Create `server/icecast/icecast.xml` with:
     - Configurable passwords via environment substitution or defaults.
     - Mount points `/live` and `/fallback`.
     - JSON stats enabled (`status-json.xsl`).
     - Proper buffer limits and burst sizes for instant web playback.
   - Create `server/docker-compose.yml` exposing port `8000:8000`.
   - Create `server/.env.example` defining `ICECAST_SOURCE_PASSWORD`, `ICECAST_ADMIN_PASSWORD`, and `ICECAST_RELAY_PASSWORD`.

4. **Phase 2 Validation & Smoke Testing**
   - Launch container via `docker compose up -d` in `server/`.
   - Connect BUTT (Broadcast Using This Tool) or Mixxx to `localhost:8000/live`.
   - Test audio playback directly in VLC or browser at `http://localhost:8000/live`.
   - Verify `http://localhost:8000/status-json.xsl` returns valid real-time JSON statistics.
