import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_builder.dart';
import '../controllers/player_controller.dart';
import 'layouts/desktop_web_layout.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class RadioHomeScreen extends StatelessWidget {
  const RadioHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppTheme.canvasCream,
          body: RefreshIndicator(
            color: AppTheme.festiveGreen,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await controller.refreshTelemetry();
            },
            child: ResponsiveBuilder(
              mobile: (context, constraints) => MobileLayout(controller: controller),
              tablet: (context, constraints) => TabletLayout(controller: controller),
              desktop: (context, constraints) => DesktopWebLayout(controller: controller),
            ),
          ),
        );
      },
    );
  }
}
