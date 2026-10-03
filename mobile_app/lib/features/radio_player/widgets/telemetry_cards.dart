import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class TelemetryCards extends StatelessWidget {
  final bool isOnAir;
  final int listeners;
  final int bitrate;

  const TelemetryCards({
    super.key,
    required this.isOnAir,
    required this.listeners,
    required this.bitrate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Broadcast Status Card
        Expanded(
          child: _buildMetricCard(
            context: context,
            icon: Icons.sensors_rounded,
            iconColor: isOnAir ? AppTheme.festiveGreen : AppTheme.crimsonRed,
            title: AppStrings.broadcastStatus,
            value: isOnAir ? AppStrings.liveNow : AppStrings.broadcastOff,
            valueColor: isOnAir ? AppTheme.festiveGreen : AppTheme.crimsonRed,
          ),
        ),
        const SizedBox(width: 10),

        // Listeners Card
        Expanded(
          child: _buildMetricCard(
            context: context,
            icon: Icons.people_alt_rounded,
            iconColor: AppTheme.festiveAmber,
            title: AppStrings.listeners,
            value: '$listeners জন',
            valueColor: AppTheme.festiveAmberDark,
          ),
        ),
        const SizedBox(width: 10),

        // Bitrate Card
        Expanded(
          child: _buildMetricCard(
            context: context,
            icon: Icons.speed_rounded,
            iconColor: AppTheme.festiveGreen,
            title: AppStrings.bitrate,
            value: '$bitrate kbps',
            valueColor: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: AppTheme.folkCardDecoration(
        backgroundColor: AppTheme.cardBackground,
        borderColor: AppTheme.festiveAmber,
        borderWidth: 2.0,
        borderRadius: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
