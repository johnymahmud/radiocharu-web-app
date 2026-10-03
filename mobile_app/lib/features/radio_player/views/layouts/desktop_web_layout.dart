import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/player_controller.dart';
import '../../widgets/header_banner.dart';
import '../../widgets/live_player_card.dart';
import '../../widgets/shoutbox_card.dart';
import '../../widgets/social_follow_card.dart';
import '../../widgets/telemetry_cards.dart';

class DesktopWebLayout extends StatelessWidget {
  final PlayerController controller;

  const DesktopWebLayout({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.canvasCream,
        image: DecorationImage(
          image: const AssetImage('assets/images/pattern.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppTheme.canvasCream.withValues(alpha: 0.95),
            BlendMode.srcOver,
          ),
          onError: (error, stackTrace) {},
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: Column(
              children: [
                // Top Header with desktop-grade shadow and padding
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  child: HeaderBanner(
                    isOnAir: controller.isOnAir,
                    isServerOnline: controller.isServerOnline,
                  ),
                ),

                // Error Toast Banner (if stream failed)
                if (controller.errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.crimsonRedLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.crimsonRed.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppTheme.crimsonRed, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.errorMessage!,
                            style: const TextStyle(color: AppTheme.crimsonRed, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                // 2-Column Balanced Studio Layout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Live Audio Player, Telemetry Metrics, Social Media
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            TelemetryCards(
                              isOnAir: controller.isOnAir,
                              listeners: controller.telemetry.listeners,
                              bitrate: controller.telemetry.bitrate,
                            ),
                            const SizedBox(height: 20),
                            LivePlayerCard(controller: controller),
                            const SizedBox(height: 20),
                            const SocialFollowCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Right Column: Festive Community Shoutbox & Station Metadata Card
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            const ShoutboxCard(),
                            const SizedBox(height: 20),
                            _buildDesktopStudioInfoCard(),
                            const SizedBox(height: 24),
                            // Footer
                            Column(
                              children: [
                                const Text(
                                  AppStrings.footerCopyright,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppStrings.footerEngine,
                                  style: TextStyle(
                                    fontSize: 12,
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
      ),
    );
  }

  Widget _buildDesktopStudioInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.folkCardDecoration(
        backgroundColor: AppTheme.cardBackground,
        borderColor: AppTheme.festiveAmber,
        borderWidth: 2.0,
        borderRadius: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.festiveGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.podcasts_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'অনলাইন স্টুডিও সংযোগ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'রেডিও চারুর সকল লাইভ শো সরাসরি ঢাকা স্টুডিও থেকে সম্প্রচারিত হয়। আপনার যেকোনো অনুষ্ঠান বা গানের অনুরোধ আমাদের ফেসবুক পেজ অথবা শাউটবক্সে পাঠাতে পারেন।',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
