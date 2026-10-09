import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

// Raw Linen background with the petal corners (top left, bottom right).
// Every page gets this from the theme, so screens don't add it themselves.
class PetalBackground extends StatelessWidget {
  final Widget child;
  const PetalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cornerWidth = MediaQuery.sizeOf(context).width * 0.42;
    return ColoredBox(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.35,
                child: Image.asset('assets/images/petal_corner_top.png', width: cornerWidth),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.35,
                child: Image.asset('assets/images/petal_corner_bottom.png', width: cornerWidth),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

// Adds the background to every page route, then uses the normal Android animation.
class PetalPageTransitionsBuilder extends PageTransitionsBuilder {
  const PetalPageTransitionsBuilder();

  static const _inner = ZoomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _inner.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      PetalBackground(child: child),
    );
  }
}
