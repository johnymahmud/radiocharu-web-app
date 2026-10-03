import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/player_controller.dart';
import '../../widgets/header_banner.dart';
import '../../widgets/live_player_card.dart';
import '../../widgets/shoutbox_card.dart';
import '../../widgets/social_follow_card.dart';
import '../../widgets/telemetry_cards.dart';

class TabletLayout extends StatelessWidget {
  final PlayerController controller;

  const TabletLayout({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              // Header Banner with rounded edges suitable for tablet
              HeaderBanner(
                isOnAir: controller.isOnAir,
                isServerOnline: controller.isServerOnline,
              ),

              // Error Toast Banner (if stream failed)
              if (controller.errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          style: const TextStyle(color: AppTheme.crimsonRed, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              // Dual-Column Balanced Studio Grid
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Live Audio Player & Telemetry Cards & Social
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          TelemetryCards(
                            isOnAir: controller.isOnAir,
                            listeners: controller.telemetry.listeners,
                            bitrate: controller.telemetry.bitrate,
                          ),
                          const SizedBox(height: 16),
                          LivePlayerCard(controller: controller),
                          const SizedBox(height: 16),
                          const SocialFollowCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Right Column: Festive Shoutbox & Station Info
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
