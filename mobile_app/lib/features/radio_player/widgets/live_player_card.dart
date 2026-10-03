import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/player_controller.dart';

class LivePlayerCard extends StatefulWidget {
  final PlayerController controller;

  const LivePlayerCard({
    super.key,
    required this.controller,
  });

  @override
  State<LivePlayerCard> createState() => _LivePlayerCardState();
}

class _LivePlayerCardState extends State<LivePlayerCard> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isPlaying = controller.isPlaying;
    final isLoading = controller.isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.folkCardDecoration(
        backgroundColor: AppTheme.cardBackground,
        borderColor: AppTheme.festiveAmber,
        borderWidth: 2.0,
        borderRadius: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Track Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.canvasCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.festiveAmber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.equalizer_rounded,
                      color: AppTheme.festiveAmberDark,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.nowPlayingHeader,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.festiveAmberDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  controller.currentTrack,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Dynamic Spectrum Wave Visualizer Mock
          _buildSpectrumWave(isPlaying: isPlaying),
          const SizedBox(height: 16),

          // Quality Info Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.festiveGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              AppStrings.streamQualityTag,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.festiveGreen,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Controls Row (Reload + Play/Pause Master Button + Volume Button)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reload / Reconnect Stream Button
              Tooltip(
                message: AppStrings.reconnectStream,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => controller.reloadStream(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.festiveAmber.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.festiveAmber, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: AppTheme.festiveAmberDark,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Master Play / Pause Action Button
              GestureDetector(
                onTap: () => controller.togglePlay(),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.festiveGreenLight, AppTheme.festiveGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.festiveGreenDark.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Live Signal Indicator
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isPlaying ? AppTheme.festiveGreen : AppTheme.textMuted).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPlaying ? AppTheme.festiveGreen : AppTheme.textMuted,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isPlaying ? Icons.wifi_tethering_rounded : Icons.portable_wifi_off_rounded,
                  color: isPlaying ? AppTheme.festiveGreen : AppTheme.textMuted,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Volume Slider Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.volume_down_rounded,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.festiveAmber,
                      inactiveTrackColor: AppTheme.festiveAmber.withValues(alpha: 0.2),
                      thumbColor: AppTheme.festiveAmberDark,
                      overlayColor: AppTheme.festiveAmber.withValues(alpha: 0.2),
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    ),
                    child: Slider(
                      value: controller.volume,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (val) => controller.setVolume(val),
                    ),
                  ),
                ),
                const Icon(
                  Icons.volume_up_rounded,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpectrumWave({required bool isPlaying}) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(24, (index) {
              double height;
              if (isPlaying) {
                // Generate energetic dancing spectrum height
                final phase = (_waveController.value * 2 * pi) + (index * 0.4);
                final noise = sin(phase) * cos(index * 0.6);
                height = 8 + (noise.abs() * 26);
              } else {
                height = 4.0;
              }

              return Container(
                width: 3.5,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPlaying
                        ? [AppTheme.festiveGreen, AppTheme.festiveAmber]
                        : [AppTheme.borderSubtle, AppTheme.borderSubtle],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
