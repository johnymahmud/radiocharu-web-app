/**
 * Radio Charu - Central Runtime Configuration
 * Supports Dynamic Hostname Detection, Cloudflare Zero Trust Edge Tunnel, and Localhost Fallback
 */
function detectBaseStreamUrl() {
  const hostname = window.location.hostname;
  
  // If running on custom domain or public web host (e.g. *.web.app, *.firebaseapp.com, radio.charu.fm)
  if (hostname && hostname !== 'localhost' && hostname !== '127.0.0.1') {
    // If running on a dedicated stream subdomain, use origin
    if (hostname.startsWith('stream.')) {
      return window.location.origin;
    }
    // Default production Cloudflare edge stream fallback (or configured custom stream domain)
    const storedDomain = localStorage.getItem('rc_stream_domain');
    if (storedDomain) {
      return storedDomain;
    }
  }
  
  // Default Local Development Engine
  return 'http://localhost:8000';
}

const BASE_EDGE_URL = detectBaseStreamUrl();

const CONFIG = {
  STATION_NAME: 'রেডিও চারু',
  STATION_TAGLINE: 'কথা, গান ও মানুষের সংযোগ',
  STATION_LOCATION: 'Dhaka, Bangladesh',

  // Audio Stream Endpoint (Localhost or Cloudflare Edge Tunnel)
  DEFAULT_STREAM_URL: `${BASE_EDGE_URL}/live`,

  // Real-time Telemetry JSON Endpoint
  DEFAULT_STATUS_URL: `${BASE_EDGE_URL}/status-json.xsl`,

  // Polling interval for Icecast telemetry (milliseconds)
  POLL_INTERVAL_MS: 3000,

  // Stream reconnect backoff (milliseconds)
  RECONNECT_INTERVAL_MS: 3000,
  MAX_RECONNECT_ATTEMPTS: 5
};

// Allow runtime overrides via URL query params or localStorage
(function initRuntimeConfig() {
  const urlParams = new URLSearchParams(window.location.search);
  
  if (urlParams.has('stream')) {
    CONFIG.DEFAULT_STREAM_URL = urlParams.get('stream');
  } else if (localStorage.getItem('rc_stream_url')) {
    CONFIG.DEFAULT_STREAM_URL = localStorage.getItem('rc_stream_url');
  }

  if (urlParams.has('status')) {
    CONFIG.DEFAULT_STATUS_URL = urlParams.get('status');
  } else if (localStorage.getItem('rc_status_url')) {
    CONFIG.DEFAULT_STATUS_URL = localStorage.getItem('rc_status_url');
  }
})();
