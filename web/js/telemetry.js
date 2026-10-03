/**
 * Radio Charu - Icecast Telemetry Engine
 * Fetches real-time server statistics, mount point metadata, and listener counts.
 */
class RadioTelemetry {
  constructor(statusUrl, pollInterval = 5000) {
    this.statusUrl = statusUrl;
    this.pollInterval = pollInterval;
    this.pollTimer = null;
    this.listeners = [];
    this.isAudioPlaying = false;
    this.lastState = {
      isOnAir: false,
      listeners: 0,
      bitrate: 'Offline',
      title: 'Off Air (রেডিও চারু স্টুডিও নীরব)',
      serverName: 'Radio Charu Broadcast Engine',
      mount: '/live'
    };
  }

  setAudioPlaying(playing) {
    this.isAudioPlaying = !!playing;
    // If audio is playing but telemetry previously indicated offline, update state immediately
    if (this.isAudioPlaying && !this.lastState.isOnAir) {
      this.lastState = {
        ...this.lastState,
        isOnAir: true,
        bitrate: this.lastState.bitrate === 'Offline' ? '192 kbps' : this.lastState.bitrate,
        title: this.lastState.title.includes('নীরব') || this.lastState.title.includes('অফলাইন') 
          ? 'রেডিও চারু লাইভ সম্প্রচার (সরাসরি শুনছেন)' 
          : this.lastState.title
      };
      this.notify(this.lastState);
    }
  }

  onStateChange(callback) {
    if (typeof callback === 'function') {
      this.listeners.push(callback);
    }
  }

  notify(state) {
    this.listeners.forEach((cb) => {
      try {
        cb(state);
      } catch (err) {
        console.error('[Telemetry] Callback error:', err);
      }
    });
  }

  async fetchStatus() {
    try {
      const response = await fetch(`${this.statusUrl}?_t=${Date.now()}`, {
        method: 'GET',
        cache: 'no-store',
        mode: 'cors',
        headers: { 'Accept': 'application/json' }
      });

      if (!response.ok) {
        throw new Error(`HTTP Error ${response.status}`);
      }

      const data = await response.json();
      const state = this.parseIcecastJson(data);
      this.lastState = state;
      this.notify(state);
      return state;
    } catch (err) {
      console.warn('[Telemetry] Telemetry fetch notice:', err.message);

      // If audio is actively playing, keep UI in ON AIR mode despite telemetry fetch blips
      const fallbackState = {
        isOnAir: this.isAudioPlaying,
        listeners: this.lastState.listeners || (this.isAudioPlaying ? 1 : 0),
        bitrate: this.isAudioPlaying ? (this.lastState.bitrate !== 'Offline' ? this.lastState.bitrate : '192 kbps') : 'Offline',
        title: this.isAudioPlaying 
          ? (this.lastState.title && !this.lastState.title.includes('নীরব') ? this.lastState.title : 'রেডিও চারু লাইভ স্ট্রিমিং')
          : 'Off Air (রেডিও চারু স্টুডিও নীরব)',
        serverName: 'Radio Charu Engine',
        mount: '/live',
        error: err.message
      };

      this.lastState = fallbackState;
      this.notify(fallbackState);
      return fallbackState;
    }
  }

  parseIcecastJson(data) {
    if (!data || !data.icestats) {
      return {
        isOnAir: this.isAudioPlaying,
        listeners: this.isAudioPlaying ? 1 : 0,
        bitrate: this.isAudioPlaying ? '192 kbps' : 'Offline',
        title: this.isAudioPlaying ? 'রেডিও চারু লাইভ স্ট্রিমিং' : 'Off Air',
        serverName: 'Radio Charu',
        mount: '/live'
      };
    }

    const icestats = data.icestats;
    let sources = icestats.source;

    if (!sources) {
      return {
        isOnAir: this.isAudioPlaying,
        listeners: this.isAudioPlaying ? 1 : 0,
        bitrate: this.isAudioPlaying ? '192 kbps' : 'Offline',
        title: this.isAudioPlaying ? 'রেডিও চারু লাইভ ব্রডকাস্ট' : 'Off Air (RJ স্টুডিও সংযোগের অপেক্ষায়)',
        serverName: icestats.server_id || 'Radio Charu Engine',
        mount: '/live'
      };
    }

    // Normalize source into an Array
    if (!Array.isArray(sources)) {
      sources = [sources];
    }

    // Find active /live mount or first available mount
    const liveSource = sources.find(s => {
      const mount = s.mount || '';
      const listenUrl = s.listenurl || '';
      return mount === '/live' || mount.endsWith('/live') || listenUrl.endsWith('/live');
    }) || sources[0];

    if (!liveSource) {
      return {
        isOnAir: this.isAudioPlaying,
        listeners: this.isAudioPlaying ? 1 : 0,
        bitrate: this.isAudioPlaying ? '192 kbps' : 'Offline',
        title: this.isAudioPlaying ? 'রেডিও চারু লাইভ স্ট্রিমিং' : 'Off Air',
        serverName: icestats.server_id || 'Radio Charu Engine',
        mount: '/live'
      };
    }

    // Extract Listeners
    const rawListeners = liveSource.listeners !== undefined ? liveSource.listeners : liveSource.connected || 0;
    const listeners = parseInt(rawListeners, 10) || (this.isAudioPlaying ? 1 : 0);

    // Extract Bitrate
    let bitrate = '192 kbps';
    if (liveSource.bitrate) {
      bitrate = `${liveSource.bitrate} kbps`;
    } else if (liveSource.audio_bitrate) {
      bitrate = `${Math.round(liveSource.audio_bitrate / 1000)} kbps`;
    }

    // Extract Title / Artist
    let title = '';
    if (liveSource.artist && liveSource.title) {
      title = `${liveSource.artist} - ${liveSource.title}`;
    } else if (liveSource.title) {
      title = liveSource.title;
    } else if (liveSource.server_name) {
      title = liveSource.server_name;
    } else if (liveSource.stream_name) {
      title = liveSource.stream_name;
    } else {
      title = 'রেডিও চারু লাইভ ব্রডকাস্ট';
    }

    // Clean up leading hyphen/separators if artist was omitted by DJ software
    title = title.replace(/^[\s\-_~:|]+/, '').trim() || 'রেডিও চারু লাইভ ব্রডকাস্ট';

    return {
      isOnAir: true,
      listeners: listeners,
      bitrate: bitrate,
      title: title,
      serverName: liveSource.server_name || icestats.server_id || 'Radio Charu Engine',
      mount: liveSource.mount || '/live',
      genre: liveSource.genre || 'Eclectic'
    };
  }

  start() {
    this.stop();
    this.fetchStatus();
    this.pollTimer = setInterval(() => this.fetchStatus(), this.pollInterval);
  }

  stop() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer);
      this.pollTimer = null;
    }
  }
}
