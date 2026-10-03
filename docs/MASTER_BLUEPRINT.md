# Radio Charu: Master Architecture Blueprint

## 1. Project Overview & Identity
- **Project Name**: Radio Charu
- **Tagline**: The Voice of Charukola & Beyond — High-fidelity 24/7 Community Radio
- **Core Vision**: A robust, zero-lag, self-hosted 24/7 internet radio station streaming live RJ shows, automated playlists, community voice notes, and real-time listener interactions.
- **Hosting Strategy**: Self-hosted on local server / dedicated machine, securely tunneled with SSL to the global internet via Cloudflare Zero Trust without requiring a public static IP or exposing router ports, paired with a cloud-hosted web frontend (Firebase Hosting).

---

## 2. Technical Stack & Infrastructure Topology

```
   [ RJ Studio / BUTT / Mixxx ] 
                 │ (Icecast Protocol / Port 8000 / Mount: /live)
                 ▼
 ┌────────────────────────────────────────────────────────┐
 │ Local Server Node (Docker Compose Environment)         │
 │                                                        │
 │   ┌────────────────────────────────────────────────┐   │
 │   │ Container 1: icecast_engine                    │   │
 │   │ - Port: 8000 (Internal & Local LAN)            │   │
 │   │ - Mounts: /live (MP3/AAC 128-320kbps), /autodj │   │
 │   │ - Stats: /status-json.xsl                      │   │
 │   └───────────────▲────────────────────────────────┘   │
 │                   │ Local Bridged Network              │
 │   ┌───────────────┴────────────────────────────────┐   │
 │   │ Container 2: tunnel_gateway (cloudflared)      │   │
 │   │ - Cloudflare Zero Trust Tunnel Daemon          │   │
 │   │ - Ingress: stream.radiocharu.com -> :8000      │   │
 │   │ - Outbound HTTPS tunnel (Bypasses CGNAT & NAT) │   │
 │   └───────────────┬────────────────────────────────┘   │
 │                   │                                    │
 │   ┌───────────────┴────────────────────────────────┐   │
 │   │ Container 3: radio_admin_api                   │   │
 │   │ - RJ live parameter relay & stats aggregator   │   │
 │   │ - Shoutbox / Song request webhook listener     │   │
 │   └────────────────────────────────────────────────┘   │
 └────────────────────────────────────────────────────────┘
                 │
                 ▼ Cloudflare Edge (SSL Termination / CDN / DDoS shield)
   https://stream.radiocharu.com/live
                 │
                 ▼
 ┌────────────────────────────────────────────────────────┐
 │ Frontend & Listener Ecosystem (Firebase Hosting & App) │
 │                                                        │
 │   • Listener Web App (Ultra-lightweight Stream Monitor)│
 │   • Signal-Driven Audio Pipeline (Direct HTML5 Audio)  │
 │   • Real-time Telemetry (ON AIR / OFF AIR, Track info) │
 │   • Flutter Mobile App (Rich UI, Controls & Caching)   │
 │   • Broadcaster Admin Panel (Caster.fm style control)  │
 └────────────────────────────────────────────────────────┘
```

---

## 3. Container Topology & Port Allocations

| Container Name | Service | Internal Port | Host Port | Role & Details |
| :--- | :--- | :--- | :--- | :--- |
| `icecast_engine` | Icecast2 Media Server | `8000` | `8000` | Ingests audio from BUTT/Mixxx and serves audio streams (`/live`) and telemetry (`/status-json.xsl`). |
| `tunnel_gateway` | Cloudflare `cloudflared` | N/A | None exposed | Outbound-only encrypted tunnel routing `stream.radiocharu.com` directly to `icecast_engine:8000`. |
| `radio_admin_api` | Fast Node.js / Go microservice | `3001` | `127.0.0.1:3001` | Manages live metadata sync, RJ authentication, shoutbox moderation, and listener analytics. |

---

## 4. Icecast Configuration & Stream Endpoint Specifications

- **Default Port**: `8000`
- **Stream Mountpoints**:
  - `/live`: High-Quality Primary Live Stream (MP3 192kbps / AAC 128kbps)
  - `/fallback`: AutoDJ / Ambient Loop backup stream when RJ is offline
- **Status & Metadata Endpoint**:
  - `http://localhost:8000/status-json.xsl` (or `https://stream.radiocharu.com/status-json.xsl`)
  - Provides JSON stats: `current_listeners`, `song_title`, `bitrate`, `stream_start`, `server_name`.
- **Security & Credential Layout (Configured via `.env`)**:
  - `ICECAST_SOURCE_PASSWORD`: Used by RJ broadcasting software (BUTT, Mixxx, OBS, Rocket Broadcaster).
  - `ICECAST_ADMIN_PASSWORD`: Used for server administration, kicking rogue sources, inspecting client logs.
  - `ICECAST_RELAY_PASSWORD`: Used for stream relaying and clustering.

---

## 5. Phase-by-Phase Implementation Roadmap

### Phase 1: Repo Setup & Memory Kit Scaffolding (Current)
- Initialize directory structure: `docs/`, `server/icecast/`, `server/tunnel/`, `web/`, `admin/`, `shared/`.
- Establish persistent AI Memory Kit (`AGENT_RULES.md`, `MASTER_BLUEPRINT.md`, `CURRENT_STATE.md`, `PROJECT_LOG.md`, `NEXT_STEPS.md`).
- Configure root `.gitignore` to prevent secret leaks and repository clutter.

### Phase 2: Dockerized Icecast & Local BUTT/Mixxx Broadcast Validation
- Construct `server/icecast/Dockerfile` and production-tuned `server/icecast/icecast.xml`.
- Build `server/docker-compose.yml` to launch and test `icecast_engine`.
- Validate local audio ingestion over `localhost:8000` using BUTT (Broadcast Using This Tool) or Mixxx.
- Verify status JSON feed on `http://localhost:8000/status-json.xsl`.

### Phase 3: Cloudflare Zero Trust Tunnel Integration
- Configure `server/tunnel/` with Cloudflare Tunnel service definition.
- Map public hostname `stream.radiocharu.com` to internal container `http://icecast_engine:8000`.
- Verify HTTPS audio streaming globally on desktop/mobile browsers with zero router port forwarding.

### Phase 4: Signal-Driven Listener Web App & Stream Receiver
- Build an ultra-lightweight, signal-driven Web App & PWA in `web/` using Vanilla CSS/JS.
- Direct native HTML5 Audio stream pipeline (`/live`) without Web Audio API graph overhead or aggressive retry loops.
- Real-time Icecast telemetry polling (`/status-json.xsl`) mapping ON AIR / OFF AIR states and track metadata.
- Delegate complex stateful UI controls, offline caches, and visualizers to the upcoming Flutter Mobile Client.
- Setup Firebase project hosting configuration (`firebase.json`, `.firebaserc`).

### Phase 5: Broadcaster Admin Control Panel
- Build Caster.fm-style broadcaster dashboard in `admin/` for RJs:
  - Live broadcast credentials display (Server address, Port, Mount, Source password).
  - Audio bitrate, listener peak graphs, and active connection logs.
  - Real-time shoutbox and audience request moderation panel.
  - Quick disconnect / kick source utility.

### Phase 6: 24/7 Production Deployment & Migration Plan
- Setup dedicated continuous runtime configuration for 24/7 hosting node (laptop/server) with automatic restart policies (`restart: unless-stopped`).
- Configure automated AutoDJ fallback for off-air hours (Liquidsoap or MPD fallback).
- Establish monitoring, health check alerts, and automated local log rotation.

---

## 6. Security, Resilience & Compliance
- **Zero Exposed Inbound Ports**: All external streaming is handled via Cloudflare Tunnel outbound sockets.
- **Failover & Graceful Recovery**: If an RJ disconnects abruptly, the player falls back seamlessly to the `/fallback` loop without dropping listeners.
- **CORS Handling**: Icecast headers configured with `Access-Control-Allow-Origin: *` for seamless status and audio fetching across web clients.
