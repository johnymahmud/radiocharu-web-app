# Radio Charu - Core Audio Server Engine

This directory contains the Dockerized **Icecast 2.4** media server for Radio Charu.

---

## Quick Start Guide

### 1. Environment Setup
The environment file `.env` is initialized with default streaming configurations. You can inspect or tweak variables in `server/.env`:

```bash
# View configuration
cat server/.env
```

### 2. Launch the Container
Start the Icecast media server in the background:

```powershell
docker compose -f server/docker-compose.yml up -d --build
```

### 3. Monitor Logs & Health
Follow live server logs:

```powershell
docker compose -f server/docker-compose.yml logs -f icecast_engine
```

Check container status:
```powershell
docker compose -f server/docker-compose.yml ps
```

### 4. Stop the Server
```powershell
docker compose -f server/docker-compose.yml down
```

---

## Live Broadcasting Setup (Mixxx / BUTT)

To broadcast live audio from your microphone, mixing console, or DJ software:

### Recommended Tool: BUTT (Broadcast Using This Tool)
1. Download & open [BUTT](https://danielnoethen.de/butt/).
2. Navigate to **Settings** -> **Main** -> **Server** -> Click **Add**:
   - **Name**: `Radio Charu Local`
   - **Type**: `Icecast`
   - **Server**: `localhost` (or LAN IP)
   - **Port**: `8000`
   - **Password**: `CharuLiveSource2026!`
   - **Icecast Mountpoint**: `/live`
   - **Icecast User**: `source`
3. Navigate to **Audio** settings:
   - **Audio Device**: Select your primary microphone / interface / stereo mix.
   - **Codec**: `MP3`
   - **Bitrate**: `192 kbps` (or `128 kbps` / `320 kbps`)
   - **Sample Rate**: `44100 Hz` (Stereo)
4. Click the **Play / Broadcast (▶)** button on the main BUTT window.

### Alternative Tool: Mixxx DJ
1. Open **Mixxx** -> **Options** -> **Preferences** -> **Live Broadcasting**.
2. Configure:
   - **Type**: `Icecast 2`
   - **Host**: `localhost`
   - **Port**: `8000`
   - **Mount**: `/live`
   - **Login**: `source`
   - **Password**: `CharuLiveSource2026!`
   - **Bitrate**: `192 kbps`, Format: `MP3`
3. Check **Enable live broadcasting** or press `Ctrl + L` to go live.

---

## Stream URLs & Verification Endpoints

Once connected and broadcasting:

| Resource | URL | Description |
| :--- | :--- | :--- |
| **Direct Audio Stream** | `http://localhost:8000/live` | Open in browser, VLC (`Media -> Open Network Stream`), or mobile player |
| **Web Admin Panel** | `http://localhost:8000/admin/` | Login with user `admin` / pass `CharuAdminSecure2026!` |
| **Real-time Status JSON** | `http://localhost:8000/status-json.xsl` | Public JSON telemetry for web visualizers & frontend stats |
| **Web Status Page** | `http://localhost:8000/status.xsl` | Default Icecast web status view |
