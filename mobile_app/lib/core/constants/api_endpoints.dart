import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  // Determine default base host based on platform (10.0.2.2 for Android Emulator, localhost for others)
  static String get defaultHost {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) {
      // 10.0.2.2 points to host machine from standard Android Emulator
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  // Active base URL (can be customized dynamically if remote domain is provided)
  static String baseUrl = defaultHost;

  // Icecast Live Audio Stream URL
  static String get streamUrl => '$baseUrl/live';

  // Icecast JSON Telemetry Endpoint
  static String get telemetryUrl => '$baseUrl/status-json.xsl';

  // Fallback public stream URLs if deployed
  static const String publicStreamUrl = 'https://radio.example.com/live';
  static const String publicTelemetryUrl = 'https://radio.example.com/status-json.xsl';

  // Social & Community Links
  static const String facebookPageUrl = 'https://facebook.com';
  static const String youtubeChannelUrl = 'https://youtube.com';
}
