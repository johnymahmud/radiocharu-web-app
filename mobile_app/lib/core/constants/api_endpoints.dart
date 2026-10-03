import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  // Toggle between Local Development vs Cloudflare Zero Trust Production Edge
  static bool useProductionEdge = false;

  // Cloudflare Zero Trust Production Custom Edge Domain
  static const String productionBaseUrl = 'https://stream.yourdomain.com';

  // Determine default base host based on environment and platform
  static String get defaultHost {
    if (useProductionEdge) {
      return productionBaseUrl;
    }
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) {
      // 10.0.2.2 points to host machine from standard Android Emulator
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  // Active base URL (can be customized dynamically at runtime)
  static String baseUrl = defaultHost;

  // Icecast Live Audio Stream URL (/live)
  static String get streamUrl => '$baseUrl/live';

  // Icecast JSON Telemetry Endpoint (/status-json.xsl)
  static String get telemetryUrl => '$baseUrl/status-json.xsl';

  // Fallback public stream URLs
  static const String publicStreamUrl = 'https://stream.yourdomain.com/live';
  static const String publicTelemetryUrl = 'https://stream.yourdomain.com/status-json.xsl';

  // Social & Community Links
  static const String facebookPageUrl = 'https://facebook.com';
  static const String youtubeChannelUrl = 'https://youtube.com';
}
