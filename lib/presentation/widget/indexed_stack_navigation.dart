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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfilePage(),
          ContactPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: 'Contactos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Configuración')
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
