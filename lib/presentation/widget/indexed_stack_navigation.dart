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
        children: const [
          ProfilePage(),
          ContactPage(),
          AlertHistoryPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Colores para íconos seleccionados
        unselectedItemColor: Colors.grey, // Colores para íconos no seleccionados
        backgroundColor: Colors.white, // Fondo
        selectedLabelStyle: const TextStyle(fontSize: 15),
        unselectedLabelStyle: const TextStyle(fontSize: 15),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 24), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts, size: 24), label: 'Contactos'),
          BottomNavigationBarItem(icon: Icon(Icons.history, size: 24), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.settings, size: 24), label: 'Configuración'),
        ],
      ),
    );
  }
}
