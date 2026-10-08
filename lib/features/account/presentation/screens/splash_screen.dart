import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'login_screen.dart';

/// Assigned to: WANIGATHUNGA Y. J.
/// Branch: feature/account-support
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.brush, size: 54, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'HASTHAKALA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sri Lankan Artisan Marketplace',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
