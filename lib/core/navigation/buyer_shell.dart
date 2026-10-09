import 'package:flutter/material.dart';

import '../localization/tr.dart';

import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/discovery/presentation/screens/home_screen.dart';
import '../../features/discovery/presentation/screens/search_screen.dart';
import '../../features/purchase/presentation/screens/my_orders_screen.dart';

// Buyer bottom navigation.
// Home | Search | Orders | Profile. Cart is a contextual action, not a tab.
// Owners replace their tab's screen here when it is ready.
class BuyerShell extends StatefulWidget {
  const BuyerShell({super.key});

  @override
  State<BuyerShell> createState() => _BuyerShellState();
}

class _BuyerShellState extends State<BuyerShell> {
  int _index = 0;

  static const List<Widget> _tabs = [
    HomeScreen(), // I02 
    SearchScreen(), // I03 
    MyOrdersScreen(), // I08
    ProfileScreen(), // buyer profile 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: context.tr('nav_home')),
          NavigationDestination(icon: const Icon(Icons.search), label: context.tr('nav_search')),
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
