import 'package:flutter/material.dart';

import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/discovery/presentation/screens/home_screen.dart';
import '../../features/discovery/presentation/screens/search_screen.dart';
import '../widgets/placeholder_tab.dart';

/// Buyer navigation - LOCKED by the Milestone 02 contract:
/// Home | Search | Orders | Profile. Cart is a contextual action, not a tab.
/// Owners replace their tab's screen here when it is ready.
class BuyerShell extends StatefulWidget {
  const BuyerShell({super.key});

  @override
  State<BuyerShell> createState() => _BuyerShellState();
}

class _BuyerShellState extends State<BuyerShell> {
  int _index = 0;

  static const List<Widget> _tabs = [
    HomeScreen(), // I02 - Member 1
    SearchScreen(), // I03 - Member 1
    PlaceholderTab(title: 'My Orders', interfaceId: 'I08', owner: 'Member 2'),
    ProfileScreen(), // buyer profile - Member 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
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
