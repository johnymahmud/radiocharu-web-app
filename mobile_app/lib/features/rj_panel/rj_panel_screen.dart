import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Future expansion module for RJ tools (Quick Stream Kick, Live Mic Routing, Stream Passkey Gate)
class RjPanelScreen extends StatelessWidget {
  const RjPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RJ কন্ট্রোল প্যানেল'),
        backgroundColor: AppTheme.festiveGreen,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.folkCardDecoration(),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mic_external_on_rounded, size: 48, color: AppTheme.festiveAmber),
              SizedBox(height: 16),
              Text(
                'RJ দ্রুত নিয়ন্ত্রণ প্যানেল',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'এই ফিচারটি পরবর্তী আপডেটে সংযুক্ত করা হবে।',
                style: TextStyle(color: AppTheme.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
