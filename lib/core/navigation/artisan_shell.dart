import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/account/presentation/screens/supporter_home_screen.dart';
import '../../features/account/presentation/state/auth_provider.dart';
import '../../features/artisan/presentation/screens/artisan_dashboard_screen.dart';
import '../../features/artisan/presentation/screens/artisan_orders_screen.dart';
import '../../features/artisan/presentation/screens/manage_products_screen.dart';
import '../localization/tr.dart';
import '../widgets/restricted_access_view.dart';
import '../widgets/support_context_banner.dart';

// Artisan bottom navigation.
// Home | Products | Orders | Profile.
// Also reused by an authorised supporter: same structure, persistent
// "Supporting <artisan>" banner, and only permitted areas available.
class ArtisanShell extends StatefulWidget {
  const ArtisanShell({super.key});

  @override
  State<ArtisanShell> createState() => _ArtisanShellState();
}

class _ArtisanShellState extends State<ArtisanShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final artisanId = auth.actingArtisanId ?? '';
    final artisanName = auth.activeGrant?.artisanName ?? '';
    final isSupporter = auth.isSupporterContext;

    final tabs = <Widget>[
      // I10  Supporter home is part of I13.
      isSupporter
          ? SupporterHomeScreen(onOpenTab: (i) => setState(() => _index = i))
          : ArtisanDashboardScreen(artisanId: artisanId),
      // I11
      auth.canManageProducts
          ? ManageProductsScreen(artisanId: artisanId)
          : RestrictedAccessView(featureName: 'Manage products', artisanName: artisanName),
      // I12
      auth.canManageOrders
          ? const ArtisanOrdersScreen()
          : RestrictedAccessView(featureName: 'Manage orders', artisanName: artisanName),
      // Profile: I05 Manage + I13 entry
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          if (isSupporter)
            SupportContextBanner(
              artisanName: artisanName,
              supporterName: auth.currentUser?.displayName ?? '',
            ),
          Expanded(child: IndexedStack(index: _index, children: tabs)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: context.tr('nav_home')),
          NavigationDestination(
              icon: const Icon(Icons.inventory_2_outlined),
              selectedIcon: const Icon(Icons.inventory_2),
              label: context.tr('nav_products')),
          NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: context.tr('nav_orders')),
          NavigationDestination(
              icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: context.tr('nav_profile')),
        ],
      ),
    );
  }
}
