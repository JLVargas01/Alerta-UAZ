import 'package:alerta_uaz/presentation/pages/alert_history_page.dart';
import 'package:alerta_uaz/presentation/pages/contact_page.dart';
import 'package:alerta_uaz/presentation/pages/profile_page.dart';
import 'package:alerta_uaz/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';

class IndexedStackNavigation extends StatefulWidget {
  const IndexedStackNavigation({super.key});

  @override
  State<IndexedStackNavigation> createState() => _IndexedStackNavigationState();
}

class _IndexedStackNavigationState extends State<IndexedStackNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ProfilePage(),
    ContactPage(),
    AlertHistoryPage(),
    SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        indicatorColor: Colors.amber, // Personalización del color del indicador
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.contacts),
            icon: Icon(Icons.contacts_outlined),
            label: 'Contactos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history),
            icon: Icon(Icons.history_outlined),
            label: 'Historial',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
