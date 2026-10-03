import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';

class TelemetryModel {
  final bool isServerOnline;
  final bool isOnAir;
  final String title;
  final String serverName;
  final String serverDescription;
  final int listeners;
  final int bitrate;
  final String streamUrl;
  final String mount;

  TelemetryModel({
    required this.isServerOnline,
    required this.isOnAir,
    required this.title,
    required this.serverName,
    required this.serverDescription,
    required this.listeners,
    required this.bitrate,
    required this.streamUrl,
    required this.mount,
  });

  factory TelemetryModel.offline() {
    return TelemetryModel(
      isServerOnline: false,
      isOnAir: false,
      title: '',
      serverName: 'Radio Charu',
      serverDescription: 'কথা, গান ও মানুষের সংযোগ',
      listeners: 0,
      bitrate: 0,
      streamUrl: '',
      mount: '',
    );
  }

  factory TelemetryModel.serverOnlineBroadcastOff() {
    return TelemetryModel(
      isServerOnline: true,
      isOnAir: false,
      title: '',
      serverName: 'Radio Charu',
      serverDescription: 'কথা, গান ও মানুষের সংযোগ',
      listeners: 0,
      bitrate: 0,
      streamUrl: '',
      mount: '',
    );
  }

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    try {
      final icestats = json['icestats'];
      if (icestats == null) {
        return TelemetryModel.serverOnlineBroadcastOff();
      }

      final dynamic sourceRaw = icestats['source'];
      if (sourceRaw == null) {
        return TelemetryModel.serverOnlineBroadcastOff();
      }

      Map<String, dynamic>? activeSource;

      if (sourceRaw is List) {
        if (sourceRaw.isEmpty) {
          return TelemetryModel.serverOnlineBroadcastOff();
        }
        // Find /live mount or fallback to first mount
        activeSource = sourceRaw.firstWhere(
          (s) => s is Map<String, dynamic> && s['listenurl']?.toString().contains('/live') == true,
          orElse: () => sourceRaw.first is Map<String, dynamic> ? sourceRaw.first : null,
        ) as Map<String, dynamic>?;
      } else if (sourceRaw is Map<String, dynamic>) {
        activeSource = sourceRaw;
      }

      if (activeSource == null) {
        return TelemetryModel.serverOnlineBroadcastOff();
      }

      final title = activeSource['title']?.toString() ?? 
                    activeSource['yp_currently_playing']?.toString() ?? '';
      final serverName = activeSource['server_name']?.toString() ?? 
                         icestats['server_id']?.toString() ?? 'Radio Charu';
      final serverDescription = activeSource['server_description']?.toString() ?? 
                                 'কথা, গান ও মানুষের সংযোগ';
      final listeners = int.tryParse(activeSource['listeners']?.toString() ?? '0') ?? 0;
      final bitrate = int.tryParse(activeSource['bitrate']?.toString() ?? '128') ?? 128;
      final listenUrl = activeSource['listenurl']?.toString() ?? '';
      final mount = activeSource['mount']?.toString() ?? '/live';

      return TelemetryModel(
        isServerOnline: true,
        isOnAir: true,
        title: title,
        serverName: serverName,
        serverDescription: serverDescription,
        listeners: listeners,
        bitrate: bitrate,
        streamUrl: listenUrl,
        mount: mount,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing telemetry JSON: $e');
      }
      return TelemetryModel.serverOnlineBroadcastOff();
    }
  }
}

class TelemetryService {
  final http.Client _client = http.Client();

  Future<TelemetryModel> fetchTelemetry() async {
    try {
      final uri = Uri.parse('${ApiEndpoints.telemetryUrl}?_t=${DateTime.now().millisecondsSinceEpoch}');
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return TelemetryModel.fromJson(decoded);
        }
      }
      return TelemetryModel.offline();
    } catch (e) {
      if (kDebugMode) {
        print('TelemetryService fetch error: $e');
      }
      return TelemetryModel.offline();
    }
  }

  void dispose() {
    _client.close();
  }
}
