import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/player_controller.dart';
import '../../widgets/header_banner.dart';
import '../../widgets/live_player_card.dart';
import '../../widgets/shoutbox_card.dart';
import '../../widgets/social_follow_card.dart';
import '../../widgets/telemetry_cards.dart';

class MobileLayout extends StatelessWidget {
  final PlayerController controller;

  const MobileLayout({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Top Folk Festive Header Banner
          HeaderBanner(
            isOnAir: controller.isOnAir,
            isServerOnline: controller.isServerOnline,
          ),

          // Error Toast Banner (if stream failed)
          if (controller.errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.crimsonRedLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.crimsonRed.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppTheme.crimsonRed, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: AppTheme.crimsonRed, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // Main Stack of Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                // Real-time Telemetry Metrics (3-Card Grid)
                TelemetryCards(
                  isOnAir: controller.isOnAir,
                  listeners: controller.telemetry.listeners,
                  bitrate: controller.telemetry.bitrate,
                ),
                const SizedBox(height: 16),

                // Master Live Audio Player Card
                LivePlayerCard(controller: controller),
                const SizedBox(height: 16),

                // Social Media Actions
                const SocialFollowCard(),
                const SizedBox(height: 16),

                // Festive Community Shoutbox Card
                const ShoutboxCard(),
                const SizedBox(height: 24),

                // Footer
                Column(
                  children: [
                    const Text(
                      AppStrings.footerCopyright,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.footerEngine,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
