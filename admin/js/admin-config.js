/**
 * Radio Charu - Caster.fm Style Broadcaster Admin Configuration
 * Supports Dynamic Hostname Detection and Cloudflare Zero Trust Edge Tunnel
 */
function detectAdminBaseUrl() {
  const hostname = window.location.hostname;
  if (hostname && hostname !== 'localhost' && hostname !== '127.0.0.1') {
    if (hostname.startsWith('stream.')) {
      return window.location.origin;
    }
    const storedDomain = localStorage.getItem('rc_stream_domain');
    if (storedDomain) {
      return storedDomain;
    }
  }
  return 'http://localhost:8000';
}

const BASE_SERVER_URL = detectAdminBaseUrl();

const ADMIN_CONFIG = {
  STATION_NAME: 'Radio Charu (রেডিও চারু)',
  PANEL_TITLE: 'Broadcaster Control Panel',

  // Ground-Truth Endpoints
  ICECAST_STATUS_URL: `${BASE_SERVER_URL}/status-json.xsl`,
  ICECAST_ADMIN_URL: `${BASE_SERVER_URL}/admin/`,

  // Connection Credentials
  SERVER_TYPE: 'Icecast 2',
  DEFAULT_HOST: window.location.hostname && window.location.hostname !== 'localhost' && window.location.hostname !== '127.0.0.1' 
    ? window.location.hostname 
    : 'localhost',
  DEFAULT_PORT: window.location.port || '8000',
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
  if (params.has('port')) {
    ADMIN_CONFIG.DEFAULT_PORT = params.get('port');
  }
  if (params.has('status')) {
    ADMIN_CONFIG.ICECAST_STATUS_URL = params.get('status');
  }
})();
