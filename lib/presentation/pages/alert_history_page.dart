import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:flutter/material.dart';
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

    // Obtenemos las alertas registradas.
    context.read<AlertBloc>().add(LoadAlertHistory());

    // Escucha cambios en el TabController y reconstruye la UI
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
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
      body: BlocListener<AlertBloc, AlertState>(
        listener: (context, state) {
          if (state is AlertError) {
            _showErrorDialog(context, state.title, state.message!);
          }
        },
        child: BlocBuilder<AlertBloc, AlertState>(
          builder: (context, state) {
            if (state is AlertLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AlertError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            if (state is AlertLoaded) {
              return _buildAlertList(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAlertList(AlertLoaded state) {
    final isReceivedTab = _tabController.index == 0;
    final history = isReceivedTab
        ? state.contactAlertHistory
        : state.myAlertHistory;

    if (history.isEmpty) {
      return const Center(
        child: Text(
          'No hay alertas registradas.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final alert = history[index];
        if (isReceivedTab && alert is AlertReceived) {
          return _buildReceivedAlertCard(alert);
        } else if (!isReceivedTab && alert is AlertSent) {
          return _buildSentAlertCard(alert);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReceivedAlertCard(AlertReceived alert) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: const Icon(Icons.notifications_active, color: Colors.black),
        title: Text(
          alert.nameUser,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text('Fecha: ${alert.dateReceived}'),
      ),
    );
  }

  Widget _buildSentAlertCard(AlertSent alert) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: const Icon(Icons.outbox, color: Colors.black),
        title: const Text(
          "Ubicación y Fecha",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text(
          "Latitud: ${alert.latitude}\nLongitud: ${alert.longitude}\nFecha: ${alert.dateSended}"
        )
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error en $title'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
