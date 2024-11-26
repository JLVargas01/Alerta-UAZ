import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alerta_uaz/application/history_bloc.dart';

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

    // Escucha cambios en el TabController y reconstruye la UI
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
              // Seleccionar las alertas según la pestaña activa
              final alerts = _tabController.index == 0 
                  ? state.receivedAlerts 
                  : state.sentAlerts;

              if (alerts.isEmpty) {
                return const Center(
                  child: Text('No hay alertas disponibles.'),
                );
              }

              return ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  if (_tabController.index == 0) {
                    // Caso: Alertas recibidas (AlertReceived)
                    final alert = alerts[index] as AlertReceived;
                    return ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: Text(alert.nameUser),
                      subtitle: Text(alert.dateReceived as String),
                    );
                  } else {
                    // Caso: Alertas enviadas (AlertSent)
                    final alert = alerts[index] as AlertSent;
                    return ListTile(
                      leading: const Icon(Icons.outbox),
                      title: Text("Latitud; ${alert.latitude} longitude: ${alert.longitude}"),
                    );
                  }
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
