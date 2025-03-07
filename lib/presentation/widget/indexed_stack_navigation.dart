import 'package:alerta_uaz/presentation/pages/alert_history_page.dart';
import 'package:alerta_uaz/presentation/pages/contact_page.dart';
import 'package:alerta_uaz/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

class IndexedStackNavigation extends StatefulWidget {
  const IndexedStackNavigation({super.key});

  @override
  State<IndexedStackNavigation> createState() => _IndexedStackNavigationState();
}

class _IndexedStackNavigationState extends State<IndexedStackNavigation> {
  /// [_selectedIndex] Índice de la página actualmente seleccionada.
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ProfilePage(), // Página de perfil del usuario.
    ContactPage(), // Página de contactos.
    AlertHistoryPage(), // Página de historial de alertas.
  ];

  /// Función que actualiza el índice de la página seleccionada.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el estado con el nuevo índice.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Muestra la página correspondiente al índice seleccionado.
        children: _pages, // Lista de páginas disponibles en la navegación.
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped, // Maneja la selección de ítems en la barra de navegación.
        selectedIndex: _selectedIndex, // Índice del ítem actualmente seleccionado.
        indicatorColor: Colors.amber, // Color del indicador de selección.
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.person), // Ícono cuando está seleccionado.
            icon: Icon(Icons.person_outline), // Ícono cuando no está seleccionado.
            label: 'Perfil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.contacts),
            icon: Icon(Icons.contacts_outlined),
            label: 'Contactos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history_toggle_off_rounded),
            icon: Icon(Icons.history_outlined),
            label: 'Historial',
          ),
        ],
      ),
    );
  }
}
