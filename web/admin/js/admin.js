/**
 * Radio Charu - Strict Ground-Truth Telemetry & Caster.fm Controller
 */
document.addEventListener('DOMContentLoaded', () => {
  // Elements: Auth & Modal
  const passkeyModal = document.getElementById('passkeyModal');
  const passkeyInput = document.getElementById('passkeyInput');
  const passkeySubmitBtn = document.getElementById('passkeySubmitBtn');
  const passkeyError = document.getElementById('passkeyError');
  const lockBtn = document.getElementById('lockBtn');
  const toast = document.getElementById('toast');

  // Dual Status Header Pills
  const serverPill = document.getElementById('serverPill');
  const serverPillText = document.getElementById('serverPillText');
  const broadcastPill = document.getElementById('broadcastPill');
  const broadcastPillText = document.getElementById('broadcastPillText');

  // Streaming Server Card Elements
  const serverCardStatus = document.getElementById('serverCardStatus');
  const serverIdEl = document.getElementById('serverId');
  const serverLocationEl = document.getElementById('serverLocation');
  const credHost = document.getElementById('credHost');
  const credPort = document.getElementById('credPort');
  const credMount = document.getElementById('credMount');
  const credUser = document.getElementById('credUser');
  const credPass = document.getElementById('credPass');
  const togglePassBtn = document.getElementById('togglePassBtn');

  // Live Broadcast Telemetry Card Elements
  const currentTrackEl = document.getElementById('currentTrack');
  const currentListenersEl = document.getElementById('currentListeners');
  const peakListenersEl = document.getElementById('peakListeners');
  const streamBitrateEl = document.getElementById('streamBitrate');
  const streamUptimeEl = document.getElementById('streamUptime');
  const streamAudioInfoEl = document.getElementById('streamAudioInfo');

  let streamStartTime = null;
  let uptimeTimer = null;
  let telemetryTimer = null;
  let isPasswordVisible = false;

  // -------------------------------------------------------------
  // 1. Passkey Gate Authentication
  // -------------------------------------------------------------
  function checkAuth() {
    const isUnlocked = sessionStorage.getItem('rc_admin_unlocked') === 'true';
    if (isUnlocked) {
      passkeyModal.classList.add('hidden');
      startDashboard();
    } else {
      passkeyModal.classList.remove('hidden');
      passkeyInput.focus();
    }
  }

  passkeySubmitBtn.addEventListener('click', handleAuth);
  passkeyInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') handleAuth();
  });

  function handleAuth() {
    const val = passkeyInput.value.trim();
    if (val === ADMIN_CONFIG.ADMIN_PASSKEY) {
      sessionStorage.setItem('rc_admin_unlocked', 'true');
      passkeyModal.classList.add('hidden');
      passkeyError.classList.add('hidden');
      passkeyInput.value = '';
      showToast('Login successful. Welcome to Broadcaster Control Panel.');
      startDashboard();
    } else {
      passkeyError.textContent = 'Invalid passkey. Please try again.';
      passkeyError.classList.remove('hidden');
      passkeyInput.focus();
    }
  }

  lockBtn.addEventListener('click', () => {
    sessionStorage.removeItem('rc_admin_unlocked');
    stopDashboard();
    passkeyModal.classList.remove('hidden');
    passkeyInput.value = '';
    passkeyInput.focus();
    showToast('Dashboard locked.');
  });

  // -------------------------------------------------------------
  // 2. Dashboard Lifecycle
  // -------------------------------------------------------------
  function startDashboard() {
    // Populate credentials
    if (credHost) credHost.textContent = ADMIN_CONFIG.DEFAULT_HOST;
    if (credPort) credPort.textContent = ADMIN_CONFIG.DEFAULT_PORT;
    if (credMount) credMount.textContent = ADMIN_CONFIG.DEFAULT_MOUNT;
    if (credUser) credUser.textContent = ADMIN_CONFIG.DEFAULT_SOURCE_USER;
    if (credPass) credPass.textContent = '••••••••••••••••';

    // Immediate poll followed by periodic intervals
    pollIcecastGroundTruth();
    if (telemetryTimer) clearInterval(telemetryTimer);
    telemetryTimer = setInterval(pollIcecastGroundTruth, ADMIN_CONFIG.POLL_INTERVAL_MS);
  }

  function stopDashboard() {
    if (telemetryTimer) clearInterval(telemetryTimer);
    if (uptimeTimer) clearInterval(uptimeTimer);
  }

  // -------------------------------------------------------------
  // 3. Strict Ground-Truth Telemetry Engine
  // -------------------------------------------------------------
  async function pollIcecastGroundTruth() {
    try {
      const response = await fetch(`${ADMIN_CONFIG.ICECAST_STATUS_URL}?_t=${Date.now()}`, {
        cache: 'no-store',
        headers: { 'Accept': 'application/json' }
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      applyGroundTruthState(data);
    } catch (networkErr) {
      applyServerOfflineState(networkErr);
    }
  }

  function applyGroundTruthState(data) {
    // 1. Server is Online (Icecast responded with valid HTTP 200 JSON)
    setServerPill(true);
    if (serverCardStatus) {
      serverCardStatus.textContent = 'Online';
      serverCardStatus.className = 'badge badge-success';
    }

    if (data && data.icestats) {
      if (serverIdEl) serverIdEl.textContent = data.icestats.server_id || 'Icecast 2.4';
      if (serverLocationEl) serverLocationEl.textContent = data.icestats.location || 'Dhaka, Bangladesh';

      let sources = data.icestats.source;
      let liveSource = null;

      if (sources) {
        if (!Array.isArray(sources)) {
          sources = [sources];
        }
        liveSource = sources.find(s => {
          const mount = s.mount || '';
          const listenUrl = s.listenurl || '';
          return mount === '/live' || mount.endsWith('/live') || listenUrl.endsWith('/live');
        }) || sources[0];
      }

      if (liveSource) {
        // 2. Broadcast is ON AIR (Mixxx / BUTT connected to Icecast)
        setBroadcastPill(true);

        // Track title
        let title = liveSource.title || '';
        if (liveSource.artist && liveSource.title) {
          title = `${liveSource.artist} - ${liveSource.title}`;
        } else if (!title && liveSource.server_name) {
          title = liveSource.server_name;
        }
        title = title.replace(/^[\s\-_~:|]+/, '').trim() || 'Live Stream Active';
        if (currentTrackEl) currentTrackEl.textContent = title;

        // Metrics
        const listeners = parseInt(liveSource.listeners || 0, 10);
        const peak = parseInt(liveSource.listener_peak || 0, 10);
        const bitrate = liveSource.bitrate ? `${liveSource.bitrate} kbps` : '192 kbps';

        if (currentListenersEl) currentListenersEl.textContent = listeners;
        if (peakListenersEl) peakListenersEl.textContent = peak;
        if (streamBitrateEl) streamBitrateEl.textContent = bitrate;
        if (streamAudioInfoEl) streamAudioInfoEl.textContent = liveSource.audio_info || `${bitrate} MP3`;

        // Uptime tracking
        if (liveSource.stream_start_iso8601 || liveSource.stream_start) {
          const start = new Date(liveSource.stream_start_iso8601 || liveSource.stream_start);
          if (!isNaN(start.getTime())) {
            streamStartTime = start;
            calcUptime();
            if (!uptimeTimer) {
              uptimeTimer = setInterval(calcUptime, 1000);
            }
          }
        }
      } else {
        // Broadcast is OFF AIR (Server online, but no DJ connected)
        applyBroadcastOffAirState();
      }
    } else {
      applyBroadcastOffAirState();
    }
  }

  function applyBroadcastOffAirState() {
    setBroadcastPill(false);
    if (currentTrackEl) currentTrackEl.textContent = 'No active broadcast (Mixxx / BUTT disconnected)';
    if (currentListenersEl) currentListenersEl.textContent = '0';
    if (peakListenersEl) peakListenersEl.textContent = '0';
    if (streamBitrateEl) streamBitrateEl.textContent = '--';
    if (streamUptimeEl) streamUptimeEl.textContent = '--';
    if (streamAudioInfoEl) streamAudioInfoEl.textContent = 'Waiting for source stream';

    if (uptimeTimer) {
      clearInterval(uptimeTimer);
      uptimeTimer = null;
    }
    streamStartTime = null;
  }

  function applyServerOfflineState(err) {
    setServerPill(false);
    setBroadcastPill(false);

    if (serverCardStatus) {
      serverCardStatus.textContent = 'Offline';
      serverCardStatus.className = 'badge badge-danger';
    }
    if (currentTrackEl) currentTrackEl.textContent = 'Streaming engine is offline. Start docker container to begin.';
    if (currentListenersEl) currentListenersEl.textContent = '0';
    if (peakListenersEl) peakListenersEl.textContent = '0';
    if (streamBitrateEl) streamBitrateEl.textContent = '--';
    if (streamUptimeEl) streamUptimeEl.textContent = '--';

    if (uptimeTimer) {
      clearInterval(uptimeTimer);
      uptimeTimer = null;
    }
    streamStartTime = null;
  }

  function setServerPill(isOnline) {
    if (!serverPill || !serverPillText) return;
    if (isOnline) {
      serverPill.className = 'status-pill pill-online';
      serverPillText.textContent = 'Online';
    } else {
      serverPill.className = 'status-pill pill-offline';
      serverPillText.textContent = 'Offline';
    }
  }

  function setBroadcastPill(isOnAir) {
    if (!broadcastPill || !broadcastPillText) return;
    if (isOnAir) {
      broadcastPill.className = 'status-pill pill-on-air';
      broadcastPillText.textContent = 'On Air';
    } else {
      broadcastPill.className = 'status-pill pill-off-air';
      broadcastPillText.textContent = 'Off Air';
    }
  }

  function calcUptime() {
    if (!streamStartTime || !streamUptimeEl) return;
    const now = new Date();
    const diff = Math.floor((now - streamStartTime) / 1000);
    if (diff < 0) return;

    const hrs = Math.floor(diff / 3600);
    const mins = Math.floor((diff % 3600) / 60);
    const secs = diff % 60;

    const pad = (n) => String(n).padStart(2, '0');
    streamUptimeEl.textContent = `${pad(hrs)}:${pad(mins)}:${pad(secs)}`;
  }

  // -------------------------------------------------------------
  // 4. Password Mask / Reveal
  // -------------------------------------------------------------
  if (togglePassBtn) {
    togglePassBtn.addEventListener('click', () => {
      isPasswordVisible = !isPasswordVisible;
      if (isPasswordVisible) {
        credPass.textContent = ADMIN_CONFIG.DEFAULT_SOURCE_PASS;
        togglePassBtn.textContent = 'Hide';
      } else {
        credPass.textContent = '••••••••••••••••';
        togglePassBtn.textContent = 'Show';
      }
    });
  }

  // -------------------------------------------------------------
  // 5. 1-Click Clipboard Copying
  // -------------------------------------------------------------
  document.querySelectorAll('.btn-copy').forEach((btn) => {
    btn.addEventListener('click', () => {
      const target = btn.dataset.copy;
      let text = '';

      switch (target) {
        case 'host': text = ADMIN_CONFIG.DEFAULT_HOST; break;
        case 'port': text = ADMIN_CONFIG.DEFAULT_PORT; break;
        case 'mount': text = ADMIN_CONFIG.DEFAULT_MOUNT; break;
        case 'user': text = ADMIN_CONFIG.DEFAULT_SOURCE_USER; break;
        case 'pass': text = ADMIN_CONFIG.DEFAULT_SOURCE_PASS; break;
        case 'all':
          text = `Server Type: Icecast 2\nHost: ${ADMIN_CONFIG.DEFAULT_HOST}\nPort: ${ADMIN_CONFIG.DEFAULT_PORT}\nMount: ${ADMIN_CONFIG.DEFAULT_MOUNT}\nUsername: ${ADMIN_CONFIG.DEFAULT_SOURCE_USER}\nPassword: ${ADMIN_CONFIG.DEFAULT_SOURCE_PASS}`;
          break;
        default:
          text = btn.previousElementSibling ? btn.previousElementSibling.textContent : '';
      }

      navigator.clipboard.writeText(text).then(() => {
        showToast('Copied to clipboard! ✓');
      }).catch(err => {
        console.error('Clipboard copy failed:', err);
      });
    });
  });

  // -------------------------------------------------------------
  // 6. Accordions
  // -------------------------------------------------------------
  document.querySelectorAll('.accordion-header').forEach((hdr) => {
    hdr.addEventListener('click', () => {
      const parent = hdr.parentElement;
      parent.classList.toggle('active');
    });
  });

  // -------------------------------------------------------------
  // 7. Toast Notification Utility
  // -------------------------------------------------------------
  function showToast(msg) {
    if (!toast) return;
    toast.textContent = msg;
    toast.classList.remove('hidden');
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.classList.add('hidden'), 250);
    }, 2200);
  }

  // Init
  checkAuth();
});
