import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/radio_player/controllers/player_controller.dart';
import 'features/radio_player/views/radio_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive status bar color matching folk festive theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.canvasCream,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const RadioCharuApp());
}

class RadioCharuApp extends StatelessWidget {
  const RadioCharuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerController()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RadioHomeScreen(),
      ),
    );
  }
}
