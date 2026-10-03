# Radio Charu: Next Actionable Steps

## Phase 4 Status: VERIFIED & STABLE ✅
- Signal-driven native streaming pipeline is active and verified.
- Real-time Icecast telemetry sync (`● ON AIR` / `○ OFF AIR`, track title, bitrate, listeners) is fully operational.
- Single global CORS header configured and confirmed.
- PWA icons generated and manifest validated without console errors.

---

## Immediate Next Actions (Transition to Phase 5)

1. **Commit & Branch Transition**:
   - Commit all Phase 4 refinements on `feature/03-listener-web-app`:
     ```powershell
     git add .
     git commit -m "feat(web): finalize signal-driven audio pipeline and telemetry (Phase 4 complete)"
     git push origin feature/03-listener-web-app
     ```
   - Switch to `main` and branch out to `feature/04-rj-admin-panel`:
     ```powershell
     git checkout main
     git checkout -b feature/04-rj-admin-panel
     ```

2. **Phase 5: Broadcaster Admin Control Panel (Caster.fm-style RJ Suite)**:
   - Scaffold `admin/index.html`, `admin/css/admin.css`, and `admin/js/admin.js`.
   - Build RJ Live Connection Dashboard:
     * Server Host, Ingestion Port (8000), Mount (`/live`), Bitrate, Source Password display with copy-to-clipboard buttons.
     * Direct one-click links to launch or configure BUTT and Mixxx.
   - Build Stream Diagnostics & RJ Telemetry:
     * Active broadcast uptime counter, peak listener graph, and client connection table.
     * Kick source utility and server restart/reload trigger.
   - Build Audience Shoutbox Moderation Panel:
     * Message approval queue and live request feed.

3. **Mobile Client Preparation (Flutter App)**:
   - Structure API schemas in `shared/` for native Flutter client integration (consuming raw `/live` stream and status endpoints).
