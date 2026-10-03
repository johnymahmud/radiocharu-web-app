# Radio Charu: Next Actionable Steps

## Phase 6 Status: COMPLETED & VERIFIED ✅
- Production-ready, decoupled Flutter mobile client scaffolded in `mobile_app/`.
- Authentic Bangladeshi Folk Festive Design System (`#0E7A3D`, `#FF7A00`, `#FFC107`, `#FFFDEE`, `#FFFFFF` with 2px amber border and 16px radius, `#E53935`).
- Audio Streaming Handler with `just_audio` + `audio_session` background audio, interruptions management, and cache-busting timestamping.
- Resilient Icecast JSON telemetry poller (`/status-json.xsl`) with live ON/OFF Air detection.
- Complete responsive UI components: `HeaderBanner`, `TelemetryCards`, `LivePlayerCard` (animated spectrum wave, track info ticker, reload), `SocialFollowCard`, `ShoutboxCard`.
- Quality Assurance: `flutter analyze` 0 issues, `flutter test` 100% passing.

---

## Immediate Next Actions (Phase 7: Cloudflare Edge Custom Domain & Production Shift)

1. **Test Flutter App on Physical Device / Emulator**:
   - Run on Android emulator or connected device:
     ```powershell
     cd mobile_app
     flutter run
     ```
   - For Android Emulator, `10.0.2.2:8000` is pre-configured in `ApiEndpoints`.

2. **Commit Phase 6 Feature Branch**:
   ```powershell
   git add .
   git commit -m "feat(mobile): scaffold production decoupled Flutter client with folk festive UI (Phase 6 complete)"
   git push origin feature/05-flutter-client
   ```

3. **Phase 7 Roadmap: Cloudflare Edge Custom Domain & 24/7 Shift**:
   - Provision Cloudflare named tunnel with dedicated custom domain token (`stream.yourdomain.com`).
   - Connect web app (`radioname.web.app`) and mobile client to production edge URL.
   - Configure 24/7 dedicated laptop auto-restart services for Docker & Mixxx/Icecast pipeline.
