import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/account/presentation/state/auth_provider.dart';
import '../../features/artisan/presentation/screens/artisan_dashboard_screen.dart';
import '../../features/artisan/presentation/screens/artisan_orders_screen.dart';
import '../../features/artisan/presentation/screens/manage_products_screen.dart';
import '../widgets/placeholder_tab.dart';
import '../widgets/restricted_access_view.dart';
import '../widgets/support_context_banner.dart';

/// Artisan navigation - LOCKED by the Milestone 02 contract:
/// Home | Products | Orders | Profile.
/// Also reused by an authorised supporter (I13): same structure, persistent
/// "Supporting <artisan>" banner, and only permitted areas available.
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
      // I10 (Member 3). Supporter home is part of I13 (Member 4).
      isSupporter
          ? const PlaceholderTab(
              title: 'Supporter Home', interfaceId: 'I13', owner: 'Member 4')
          : ArtisanDashboardScreen(artisanId: artisanId),
      // I11 (Member 3)
      auth.canManageProducts
          ? ManageProductsScreen(artisanId: artisanId)
          : RestrictedAccessView(featureName: 'Manage products', artisanName: artisanName),
      // I12 (Member 3)
      auth.canManageOrders
          ? const ArtisanOrdersScreen()
          : RestrictedAccessView(featureName: 'Manage orders', artisanName: artisanName),
      // Profile: I05 Manage + I13 entry (Member 4)
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
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: 'Products'),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Orders'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
