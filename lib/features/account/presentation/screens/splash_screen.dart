import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';

// I01 animated splash - logo grows and fades in, then the tagline appears.
// AuthGate decides when to move on (about 2 seconds).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final Animation<double> _logoScale = Tween(begin: 0.6, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: const Interval(0, 0.7, curve: Curves.easeOutBack)),
  );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.5, curve: Curves.easeOut),
  );
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.55, 1, curve: Curves.easeOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset('assets/images/hasthakala_logo.png', width: 170),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  const Text('HASTHAKALA',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                          color: AppColors.primaryDark)),
                  const SizedBox(height: 6),
                  Text(context.tr('app_tagline'),
                      style: const TextStyle(color: AppColors.textSecondary, letterSpacing: 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
