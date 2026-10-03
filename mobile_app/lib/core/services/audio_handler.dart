import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/api_endpoints.dart';

class AudioStreamHandler {
  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  // Stream getters for UI reactivity
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;
  Stream<ProcessingState> get processingStateStream => _player.processingStateStream;
  Stream<double> get volumeStream => _player.volumeStream;

  bool get isPlaying => _player.playing;
  ProcessingState get processingState => _player.processingState;
  double get volume => _player.volume;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // Listen for audio session interruptions (e.g., phone calls, headphones unplugged)
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _player.setVolume(0.3);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              _player.pause();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              _player.setVolume(1.0);
              break;
            case AudioInterruptionType.pause:
              _player.play();
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });

      session.becomingNoisyEventStream.listen((_) {
        // Pauses playback when headphones are disconnected
        _player.pause();
      });

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('AudioStreamHandler session configuration error: $e');
      }
    }
  }

  /// Start or resume live audio stream with fresh cache-busting parameter
  Future<void> playLiveStream({String? customUrl}) async {
    await init();
    try {
      final targetUrl = customUrl ?? ApiEndpoints.streamUrl;
      final uri = '$targetUrl?nocache=${DateTime.now().millisecondsSinceEpoch}';

      if (kDebugMode) {
        print('Connecting live audio stream: $uri');
      }

      await _player.setUrl(uri);
      await _player.play();
    } catch (e) {
      if (kDebugMode) {
        print('Error playing live audio stream: $e');
      }
      rethrow;
    }
  }

  /// Pause current audio stream
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      if (kDebugMode) {
        print('Error pausing stream: $e');
      }
    }
  }

  /// Stop current audio stream and release buffer
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping stream: $e');
      }
    }
  }

  /// Reconnect / reload live audio stream immediately
  Future<void> reloadStream({String? customUrl}) async {
    await stop();
    await playLiveStream(customUrl: customUrl);
  }

  /// Set volume level (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      if (kDebugMode) {
        print('Error setting volume: $e');
      }
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
