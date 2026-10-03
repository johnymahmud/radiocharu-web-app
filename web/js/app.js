/**
 * Radio Charu - Main Application UI Orchestrator
 */
document.addEventListener('DOMContentLoaded', () => {
  // DOM Element References
  const playBtn = document.getElementById('playBtn');
  const playIcon = document.getElementById('playIcon');
  const pauseIcon = document.getElementById('pauseIcon');
  const spinner = document.getElementById('spinner');
  const reloadBtn = document.getElementById('reloadBtn');
  const muteBtn = document.getElementById('muteBtn');
  const volumeSlider = document.getElementById('volumeSlider');
  const statusPill = document.getElementById('statusPill');
  const statusDot = document.getElementById('statusDot');
  const statusText = document.getElementById('statusText');
  const listenersCountEl = document.getElementById('listenersCount');
  const bitrateEl = document.getElementById('bitrate');
  const broadcastStateEl = document.getElementById('broadcastState');
  const trackTitleEl = document.getElementById('trackTitle');
  const pwaInstallBanner = document.getElementById('pwaInstallBanner');
  const pwaInstallBtn = document.getElementById('pwaInstallBtn');

  let deferredPrompt = null;

  // Initialize Native Audio Player
  const player = new RadioPlayer(CONFIG.DEFAULT_STREAM_URL, {
    onStateChange: (state, meta) => {
      updatePlayerUI(state, meta);
    },
    onVolumeChange: (vol) => {
      volumeSlider.value = Math.round(vol * 100);
      updateMuteIcon(vol === 0);
    }
  });

  // Initialize Telemetry Poller
  const telemetry = new RadioTelemetry(CONFIG.DEFAULT_STATUS_URL, CONFIG.POLL_INTERVAL_MS);

  telemetry.onStateChange((state) => {
    updateTelemetryUI(state);
  });

  // Start Background Telemetry
  telemetry.start();

  // -------------------------------------------------------------
  // Event Listeners
  // -------------------------------------------------------------
  playBtn.addEventListener('click', () => {
    player.toggle();
  });

  reloadBtn.addEventListener('click', () => {
    player.reload();
  });

  volumeSlider.addEventListener('input', (e) => {
    const val = e.target.value / 100;
    player.setVolume(val);
  });

  muteBtn.addEventListener('click', () => {
    const currentVol = player.getVolume();
    if (currentVol > 0) {
      player.audio.dataset.prevVol = currentVol;
      player.setVolume(0);
    } else {
      const prev = parseFloat(player.audio.dataset.prevVol) || 0.8;
      player.setVolume(prev);
    }
  });

  // Keyboard Shortcuts
  window.addEventListener('keydown', (e) => {
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
    
    if (e.code === 'Space') {
      e.preventDefault();
      player.toggle();
    } else if (e.code === 'KeyM') {
      muteBtn.click();
    } else if (e.code === 'ArrowUp') {
      e.preventDefault();
      const newVol = Math.min(1, player.getVolume() + 0.05);
      player.setVolume(newVol);
    } else if (e.code === 'ArrowDown') {
      e.preventDefault();
      const newVol = Math.max(0, player.getVolume() - 0.05);
      player.setVolume(newVol);
    }
  });

  // -------------------------------------------------------------
  // UI State Updaters
  // -------------------------------------------------------------
  function updatePlayerUI(state, meta) {
    if (state === 'loading' || state === 'buffering') {
      playIcon.classList.add('hidden');
      pauseIcon.classList.add('hidden');
      spinner.classList.remove('hidden');
      playBtn.setAttribute('aria-label', 'বাফারিং হচ্ছে...');
      playBtn.classList.add('is-loading');
    } else if (state === 'playing') {
      telemetry.setAudioPlaying(true);
      spinner.classList.add('hidden');
      playIcon.classList.add('hidden');
      pauseIcon.classList.remove('hidden');
      playBtn.setAttribute('aria-label', 'পজ করুন');
      playBtn.classList.remove('is-loading');
      playBtn.classList.add('is-playing');
      document.title = `▶ ${trackTitleEl.textContent} | রেডিও চারু`;
    } else {
      telemetry.setAudioPlaying(false);
      spinner.classList.add('hidden');
      pauseIcon.classList.add('hidden');
      playIcon.classList.remove('hidden');
      playBtn.setAttribute('aria-label', 'প্লে করুন');
      playBtn.classList.remove('is-loading', 'is-playing');
      document.title = 'রেডিও চারু - কথা, গান ও মানুষের সংযোগ';
    }
  }

  function updateTelemetryUI(state) {
    if (state.isOnAir) {
      statusPill.className = 'status-pill on-air';
      statusDot.className = 'status-dot dot-live';
      statusText.textContent = 'ON AIR';
      broadcastStateEl.textContent = 'সরাসরি সম্প্রচারিত';
      broadcastStateEl.className = 'metric-value text-success';
      listenersCountEl.textContent = state.listeners;
      bitrateEl.textContent = state.bitrate;
      trackTitleEl.textContent = state.title || 'রেডিও চারু লাইভ ব্রডকাস্ট';
    } else {
      statusPill.className = 'status-pill off-air';
      statusDot.className = 'status-dot dot-offline';
      statusText.textContent = 'OFF AIR';
      broadcastStateEl.textContent = 'অফলাইন';
      broadcastStateEl.className = 'metric-value text-muted';
      listenersCountEl.textContent = '০';
      bitrateEl.textContent = '--';
      trackTitleEl.textContent = state.title || 'রেডিও চারু স্টুডিও নীরব';
    }
  }

  function updateMuteIcon(isMuted) {
    const volSvg = muteBtn.querySelector('.icon-volume');
    const muteSvg = muteBtn.querySelector('.icon-muted');
    if (isMuted) {
      volSvg.classList.add('hidden');
      muteSvg.classList.remove('hidden');
    } else {
      volSvg.classList.remove('hidden');
      muteSvg.classList.add('hidden');
    }
  }

  // -------------------------------------------------------------
  // PWA Service Worker & Install Prompt Handling
  // -------------------------------------------------------------
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('./sw.js')
      .then(() => console.log('[PWA] Service Worker Registered successfully.'))
      .catch(err => console.warn('[PWA] Service Worker registration failed:', err));
  }

  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferredPrompt = e;
    if (pwaInstallBanner) {
      pwaInstallBanner.classList.remove('hidden');
    }
  });

  if (pwaInstallBtn) {
    pwaInstallBtn.addEventListener('click', async () => {
      if (deferredPrompt) {
        deferredPrompt.prompt();
        const choice = await deferredPrompt.userChoice;
        if (choice.outcome === 'accepted') {
          console.log('[PWA] User accepted the install prompt');
        }
        deferredPrompt = null;
        pwaInstallBanner.classList.add('hidden');
      }
    });
  }
});
