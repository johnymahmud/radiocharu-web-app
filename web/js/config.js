/**
 * Radio Charu - Central Runtime Configuration
 */
const CONFIG = {
  STATION_NAME: 'রেডিও চারু',
  STATION_TAGLINE: 'কথা, গান ও মানুষের সংযোগ',
  STATION_LOCATION: 'Dhaka, Bangladesh',

  // Audio Stream Endpoint (Fallback to localhost Icecast or Cloudflare Tunnel)
  DEFAULT_STREAM_URL: 'http://localhost:8000/live',

  // Real-time Telemetry JSON Endpoint
  DEFAULT_STATUS_URL: 'http://localhost:8000/status-json.xsl',

  // Polling interval for Icecast telemetry (milliseconds)
  POLL_INTERVAL_MS: 5000,

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
