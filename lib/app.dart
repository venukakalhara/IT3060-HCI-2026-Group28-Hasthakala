import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/localization/language_provider.dart';
import 'core/navigation/auth_gate.dart';
import 'config/routes/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'features/account/presentation/state/artisan_profile_provider.dart';
import 'features/account/presentation/state/auth_provider.dart';
import 'features/account/presentation/state/family_support_provider.dart';
import 'features/account/presentation/state/onboarding_provider.dart';
import 'features/artisan/presentation/state/artisan_dashboard_provider.dart';
import 'features/artisan/presentation/state/artisan_orders_provider.dart';
import 'features/discovery/presentation/state/discovery_provider.dart';
import 'features/discovery/presentation/state/favorites_provider.dart';
import 'features/purchase/presentation/state/cart_provider.dart';

class HasthakalaApp extends StatelessWidget {
  const HasthakalaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
          create: (_) => FavoritesProvider(),
          update: (_, auth, favorites) {
            favorites!.setAccount(auth.currentUser?.uid);
            return favorites;
          },
        ),
        ChangeNotifierProvider(create: (_) => FamilySupportProvider()), // I13
        ChangeNotifierProvider(create: (_) => ArtisanProfileProvider()), // I05
        ChangeNotifierProvider(create: (_) => DiscoveryProvider()),
        // I06 cart follows the signed-in account (saved in users/{uid}/cart)
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) {
            cart!.setAccount(auth.currentUser?.uid);
            return cart;
          },
        ),
        ChangeNotifierProvider(create: (_) => ArtisanDashboardProvider()),
        ChangeNotifierProvider(create: (_) => ArtisanOrdersProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, language, _) => MaterialApp(
          title: 'Hasthakala',
          locale: language.locale,
          supportedLocales: const [Locale('en'), Locale('si'), Locale('ta')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          // AuthGate picks the first screen from the sign-in state.
          home: const AuthGate(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
