import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/audio_handler.dart';
import '../../../core/services/telemetry_service.dart';

enum StreamPlaybackStatus {
  idle,
  connecting,
  buffering,
  playing,
  paused,
  error,
}

class PlayerController extends ChangeNotifier {
  final AudioStreamHandler _audioHandler = AudioStreamHandler();
  final TelemetryService _telemetryService = TelemetryService();

  TelemetryModel _telemetry = TelemetryModel.offline();
  StreamPlaybackStatus _playbackStatus = StreamPlaybackStatus.idle;
  double _volume = 1.0;
  String? _errorMessage;
  Timer? _telemetryTimer;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _volumeSubscription;

  // Getters
  TelemetryModel get telemetry => _telemetry;
  StreamPlaybackStatus get playbackStatus => _playbackStatus;
  double get volume => _volume;
  String? get errorMessage => _errorMessage;
  bool get isPlaying => _playbackStatus == StreamPlaybackStatus.playing;
  bool get isLoading => _playbackStatus == StreamPlaybackStatus.connecting || 
                        _playbackStatus == StreamPlaybackStatus.buffering;
  bool get isOnAir => _telemetry.isOnAir;
  bool get isServerOnline => _telemetry.isServerOnline;
  String get currentTrack => _telemetry.title.isNotEmpty 
      ? _telemetry.title 
      : (_telemetry.isOnAir ? 'সরাসরি লাইভ অনুষ্ঠান চলছে' : 'গান বা অনুষ্ঠানের নাম শীঘ্রই আসছে...');

  PlayerController() {
    _init();
  }

  Future<void> _init() async {
    await _audioHandler.init();

    // Listen to player state
    _playerStateSubscription = _audioHandler.playerStateStream.listen((state) {
      if (state.playing) {
        switch (state.processingState) {
          case ProcessingState.idle:
            _playbackStatus = StreamPlaybackStatus.idle;
            break;
          case ProcessingState.loading:
            _playbackStatus = StreamPlaybackStatus.connecting;
            break;
          case ProcessingState.buffering:
            _playbackStatus = StreamPlaybackStatus.buffering;
            break;
          case ProcessingState.ready:
            _playbackStatus = StreamPlaybackStatus.playing;
            break;
          case ProcessingState.completed:
            _playbackStatus = StreamPlaybackStatus.idle;
            break;
        }
      } else {
        if (state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering) {
          _playbackStatus = StreamPlaybackStatus.buffering;
        } else {
          _playbackStatus = StreamPlaybackStatus.paused;
        }
      }
      notifyListeners();
    });

    // Listen to volume
    _volumeSubscription = _audioHandler.volumeStream.listen((vol) {
      _volume = vol;
      notifyListeners();
    });

    // Initial Telemetry Fetch & Start Periodic Polling (every 3 seconds)
    await refreshTelemetry();
    _telemetryTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      refreshTelemetry();
    });
  }

  /// Poll Icecast JSON status
  Future<void> refreshTelemetry() async {
    final result = await _telemetryService.fetchTelemetry();
    _telemetry = result;
    notifyListeners();
  }

  /// Toggle Live Playback
  Future<void> togglePlay() async {
    _errorMessage = null;
    try {
      if (_playbackStatus == StreamPlaybackStatus.playing) {
        await _audioHandler.pause();
      } else {
        _playbackStatus = StreamPlaybackStatus.connecting;
        notifyListeners();
        await _audioHandler.playLiveStream();
      }
    } catch (e) {
      _playbackStatus = StreamPlaybackStatus.error;
      _errorMessage = 'স্ট্রিম চালু করতে সমস্যা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
      notifyListeners();
    }
  }

  /// Force reload live stream
  Future<void> reloadStream() async {
    _errorMessage = null;
    _playbackStatus = StreamPlaybackStatus.connecting;
    notifyListeners();
    try {
      await _audioHandler.reloadStream();
    } catch (e) {
      _playbackStatus = StreamPlaybackStatus.error;
      _errorMessage = 'স্ট্রিম রিলোড করতে সমস্যা হয়েছে।';
      notifyListeners();
    }
  }

  /// Adjust Volume
  Future<void> setVolume(double value) async {
    _volume = value;
    await _audioHandler.setVolume(value);
    notifyListeners();
  }

  /// Update Base Host dynamically (e.g. for custom IP/domain switch)
  void updateHost(String newHost) {
    ApiEndpoints.baseUrl = newHost;
    refreshTelemetry();
    if (isPlaying) {
      reloadStream();
    }
  }

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _playerStateSubscription?.cancel();
    _volumeSubscription?.cancel();
    _audioHandler.dispose();
    _telemetryService.dispose();
    super.dispose();
  }
}
