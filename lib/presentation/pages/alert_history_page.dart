import 'package:flutter/material.dart';
import 'package:alerta_uaz/application/history_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertHistoryPage extends StatefulWidget {
  const AlertHistoryPage({super.key});

  @override
  State<AlertHistoryPage> createState() => _AlertHistoryPageState();
}

class _AlertHistoryPageState extends State<AlertHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Alertas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recibidas'),
            Tab(text: 'Enviadas'),
          ],
        ),
      ),
      body: BlocListener<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryInitialState || state is HistoryLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoadedState) {
              // Filtra las alertas según la pestaña seleccionada
              final alerts = _tabController.index == 0
                  ? state.receivedAlerts // Mostrar alertas recibidas
                  : state.sentAlerts;    // Mostrar alertas enviadas

              if (alerts.isEmpty) {
                return const Center(
                  child: Text('No hay alertas disponibles.'),
                );
              }

              return ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return ListTile(
                    title: Text(alert), // Cambiar según tus datos
                    subtitle: Text("date"), // Cambiar según tus datos
                  );
                },
              );
            } else if (state is HistoryErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
