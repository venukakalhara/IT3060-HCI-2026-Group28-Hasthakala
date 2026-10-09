import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/account/presentation/screens/account_created_screen.dart';
import '../../features/account/presentation/screens/artisan_profile_created_screen.dart';
import '../../features/account/presentation/screens/artisan_profile_setup_screen.dart';
import '../../features/account/presentation/screens/checking_access_screen.dart';
import '../../features/account/presentation/screens/context_selection_screen.dart';
import '../../features/account/presentation/screens/language_selection_screen.dart';
import '../../features/account/presentation/screens/login_screen.dart';
import '../../features/account/presentation/screens/onboarding_screen.dart';
import '../../features/account/presentation/screens/purpose_confirmed_screen.dart';
import '../../features/account/presentation/screens/purpose_selection_screen.dart';
import '../../features/account/presentation/screens/splash_screen.dart';
import '../../features/account/presentation/screens/support_access_removed_screen.dart';
import '../../features/account/presentation/state/auth_provider.dart';
import '../../features/account/presentation/state/onboarding_provider.dart';
import '../localization/language_provider.dart';
import 'artisan_shell.dart';
import 'buyer_shell.dart';

// Decides the first screen from the signed-in state:
// checking -> signed out -> artisan setup -> "Continue as" -> shell.
// Screens never navigate to a home screen themselves;
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _splashDone = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // the splash animation is shown for about 2 seconds on every launch
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _splashDone = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final onboarding = context.watch<OnboardingProvider>();
    final language = context.watch<LanguageProvider>();

    if (!_splashDone || !language.loaded) return const SplashScreen();

    switch (auth.status) {
      case AuthStatus.checking:
        return const CheckingAccessScreen();
      case AuthStatus.signedOut:
        if (!onboarding.loaded) return const CheckingAccessScreen();
        if (!language.chosen) return const LanguageSelectionScreen();
        if (!onboarding.seen) return const OnboardingScreen();
        return const LoginScreen();
      case AuthStatus.signedIn:
        if (auth.needsPurpose) {
          return auth.justRegistered
              ? const AccountCreatedScreen()
              : const PurposeSelectionScreen();
        }
        if (auth.purposeJustChosen != null) return const PurposeConfirmedScreen();
        if (auth.needsArtisanSetup) return const ArtisanProfileSetupScreen();
        if (auth.supportAccessLost) return const SupportAccessRemovedScreen();
        if (auth.justCreatedArtisanProfile) return const ArtisanProfileCreatedScreen();
        if (auth.needsContextChoice) return const ContextSelectionScreen();
        switch (auth.activeContext) {
          case AppContextType.buyer:
            return const BuyerShell();
          case AppContextType.artisan:
          case AppContextType.supporter:
            return const ArtisanShell();
          case null:
            return const CheckingAccessScreen();
        }
    }
  }
}
