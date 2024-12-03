import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:alerta_uaz/presentation/widget/load_widget.dart';
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
          tabs: const [Tab(text: 'Recibidas'), Tab(text: 'Enviadas')],
        ),
      ),
      body: BlocListener<AlertBloc, AlertState>(
        listener: (context, state) {
          if (state is AlertError) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error en ${state.title}'),
                content: Text(state.message!),
                actions: [
                  TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<AlertBloc, AlertState>(
          builder: (context, state) {
            if (state is AlertLoaded) {
              // Seleccionar las alertas según la pestaña activa
              final history = _tabController.index == 0
                  ? state.contactAlertHistory
                  : state.myAlertHistory;

              // Si no hay ninguna alerta obtenida mostramos no disponible.
              if (history == null) {
                return const Center(
                  child: Text('No hay alertas registradas.'),
                );
              }

              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  if (_tabController.index == 0) {
                    // Caso: Alertas recibidas (AlertReceived)
                    final alert = history[index] as AlertReceived;
                    return ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: Text(alert.nameUser),
                      subtitle: Text(alert.dateReceived as String),
                    );
                  } else {
                    // Caso: Alertas enviadas (AlertSent)
                    final alert = history[index] as AlertSent;
                    return ListTile(
                      leading: const Icon(Icons.outbox),
                      title: Text(
                          "Latitud; ${alert.latitude} longitude: ${alert.longitude}"),
                    );
                  }
                },
              );
            } else if (state is AlertLoading) {
              return LoadWidget(message: state.message);
            } else if (state is AlertError) {
              return const Center(child: Text('Error al cargar el historial.'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
