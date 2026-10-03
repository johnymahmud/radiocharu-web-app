/**
 * Radio Charu - Bulletproof Native HTML5 Audio Streaming Engine
 * Lightweight, zero Web Audio API overhead, direct unhindered MP3/AAC live streaming.
 */
class RadioPlayer {
  constructor(streamUrl, options = {}) {
    this.streamUrl = streamUrl;
    this.options = Object.assign({
      onStateChange: null,
      onVolumeChange: null
    }, options);

    // Standard native HTML5 Audio element
    this.audio = new Audio();
    this.audio.preload = 'none';

    this.isPlaying = false;
    this.isBuffering = false;
    this.reconnectAttempts = 0;

    this.initAudioEvents();
  }

  initAudioEvents() {
    this.audio.addEventListener('playing', () => {
      console.log('[Audio Player] Live stream playing.');
      this.isPlaying = true;
      this.isBuffering = false;
      this.reconnectAttempts = 0;
      this.emitState('playing');
    });

    this.audio.addEventListener('waiting', () => {
      console.log('[Audio Player] Buffering stream chunks...');
      this.isBuffering = true;
      this.emitState('buffering');
    });

    this.audio.addEventListener('pause', () => {
      console.log('[Audio Player] Live stream paused/stopped.');
      this.isPlaying = false;
      this.isBuffering = false;
      this.emitState('paused');
    });

    this.audio.addEventListener('error', (e) => {
      console.error('[Audio Player] Stream error:', e);
      this.isBuffering = false;
      this.isPlaying = false;
      this.emitState('error');
      this.handleReconnect();
    });

    this.audio.addEventListener('stalled', () => {
      if (this.isPlaying) {
        console.warn('[Audio Player] Stream stalled.');
        this.isBuffering = true;
        this.emitState('buffering');
      }
    });
  }

  /**
   * Connect and start playing live stream with cache-busting
   */
  play() {
    this.isBuffering = true;
    this.emitState('loading');

    // Attach unique timestamp to avoid playing stale browser buffer
    const timestamp = `t=${Date.now()}`;
    const targetUrl = this.streamUrl.includes('?') 
      ? `${this.streamUrl}&${timestamp}` 
      : `${this.streamUrl}?${timestamp}`;

    console.log('[Audio Player] Connecting to live stream:', targetUrl);
    this.audio.src = targetUrl;
    this.audio.load();

    const playPromise = this.audio.play();

    if (playPromise !== undefined) {
      playPromise
        .then(() => {
          console.log('[Audio Player] Playback started successfully');
          this.isPlaying = true;
          this.isBuffering = false;
          this.reconnectAttempts = 0;
          this.emitState('playing');
        })
        .catch((err) => {
          console.error('[Audio Player] Playback error:', err);
          this.isPlaying = false;
          this.isBuffering = false;
          this.emitState('error');
        });
    }
  }

  /**
   * Stop stream and immediately release HTTP connection
   */
  pause() {
    this.audio.pause();
    this.audio.src = '';
    this.isPlaying = false;
    this.isBuffering = false;
    this.emitState('paused');
  }

  toggle() {
    if (this.isPlaying || this.isBuffering) {
      this.pause();
    } else {
      this.play();
    }
  }

  reload() {
    console.log('[Audio Player] Reloading live stream...');
    this.pause();
    setTimeout(() => this.play(), 200);
  }

  setVolume(val) {
    const clamped = Math.max(0, Math.min(1, parseFloat(val)));
    this.audio.volume = clamped;
    if (this.options.onVolumeChange) {
      this.options.onVolumeChange(clamped);
    }
  }

  getVolume() {
    return this.audio.volume;
  }

  setMute(mute) {
    this.audio.muted = !!mute;
    if (this.options.onVolumeChange) {
      this.options.onVolumeChange(this.audio.muted ? 0 : this.audio.volume);
    }
  }

  handleReconnect() {
    console.log('[Audio Player] Stream connection ended or unavailable.');
    this.isPlaying = false;
    this.isBuffering = false;
    this.emitState('offline');
  }

  emitState(state) {
    if (typeof this.options.onStateChange === 'function') {
      this.options.onStateChange(state, {
        isPlaying: this.isPlaying,
        isBuffering: this.isBuffering,
        attempts: this.reconnectAttempts
      });
    }
  }
}
