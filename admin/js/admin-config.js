/**
 * Radio Charu - Caster.fm Style Broadcaster Admin Configuration
 */
const ADMIN_CONFIG = {
  STATION_NAME: 'Radio Charu (রেডিও চারু)',
  PANEL_TITLE: 'Broadcaster Control Panel',

  // Ground-Truth Endpoints
  ICECAST_STATUS_URL: 'http://localhost:8000/status-json.xsl',
  ICECAST_ADMIN_URL: 'http://localhost:8000/admin/',

  // Connection Credentials
  SERVER_TYPE: 'Icecast 2',
  DEFAULT_HOST: 'localhost',
  DEFAULT_PORT: '8000',
  DEFAULT_MOUNT: '/live',
  DEFAULT_SOURCE_USER: 'source',
  DEFAULT_SOURCE_PASS: 'CharuLiveSource2026!',
  DEFAULT_FORMAT: 'MP3 192kbps Stereo',

  // Authentication Passkey
  ADMIN_PASSKEY: 'charuAdmin2026',

  // Strict ground-truth polling interval (2500ms)
  POLL_INTERVAL_MS: 2500
};

// Allow runtime URL query param overrides
(function initAdminConfig() {
  const params = new URLSearchParams(window.location.search);
  if (params.has('host')) {
    ADMIN_CONFIG.DEFAULT_HOST = params.get('host');
  }
  if (params.has('status')) {
    ADMIN_CONFIG.ICECAST_STATUS_URL = params.get('status');
  }
})();
