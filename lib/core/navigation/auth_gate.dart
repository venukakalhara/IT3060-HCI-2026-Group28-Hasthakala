import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/account/presentation/screens/artisan_profile_setup_screen.dart';
import '../../features/account/presentation/screens/checking_access_screen.dart';
import '../../features/account/presentation/screens/context_selection_screen.dart';
import '../../features/account/presentation/screens/login_screen.dart';
import '../../features/account/presentation/state/auth_provider.dart';
import 'artisan_shell.dart';
import 'buyer_shell.dart';

/// Decides the first screen from the signed-in state (I01, decision D1):
/// checking -> signed out -> artisan setup -> "Continue as" -> shell.
/// Screens never navigate to a home screen themselves; they change the
/// AuthProvider state and this gate shows the right place.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.checking:
        return const CheckingAccessScreen();
      case AuthStatus.signedOut:
        return const LoginScreen();
      case AuthStatus.signedIn:
        if (auth.needsArtisanSetup) return const ArtisanProfileSetupScreen();
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
