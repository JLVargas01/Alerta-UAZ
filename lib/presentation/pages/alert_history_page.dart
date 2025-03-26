/*
/// Pantalla para mostrar el historial de alertas
*/
import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/alert/alert_state.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:alerta_uaz/presentation/pages/alert_details_page.dart';
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
            if (state is AlertLoadedHistory) {
              return _buildAlertList(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAlertList(BuildContext context, AlertLoadedHistory state) {
    final isReceivedTab = _tabController.index == 0;
    final history =
        isReceivedTab ? state.contactAlertHistory : state.myAlertHistory;

    if (history.isEmpty) {
      return const Center(
        child: Text(
          'No hay alertas registradas.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.separated(
        itemCount: history.length,
        separatorBuilder: (context, index) {
          if (history.length > 1) {
            return const Divider();
          }
          return const SizedBox.shrink();
        },
        itemBuilder: (context, index) {
          final alert = history[index];
          if (isReceivedTab && alert is ContactAlert) {
            return _buildReceivedAlertCard(alert);
          } else if (!isReceivedTab && alert is MyAlert) {
            return _buildSentAlertCard(context, alert);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReceivedAlertCard(ContactAlert alert) {
    return ListTile(
      title: Text(
        alert.username,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        alert.date,
        style: const TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      leading: CircleAvatar(
        backgroundImage:
            alert.avatar != null ? NetworkImage(alert.avatar!) : null,
        child: alert.avatar == null ? const Icon(Icons.person, size: 30) : null,
      ),
      onTap: () async {
        final data = alert.toJson();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AlertDetailsPage(
              alert: data,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentAlertCard(BuildContext context, MyAlert alert) {
    return ListTile(
      title: Text(
        User().name!,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        alert.date,
        style: const TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      leading: CircleAvatar(
        backgroundImage:
            User().avatar != null ? NetworkImage(User().avatar!) : null,
        child:
            User().avatar == null ? const Icon(Icons.person, size: 30) : null,
      ),
      onTap: () async {
        Map<String, dynamic> data = {
          'username': User().name,
          'avatar': User().avatar,
          'coordinates': {
            'latitude': alert.latitude,
            'longitude': alert.longitude,
          },
          'date': alert.date,
          'audio': alert.audio
        };

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AlertDetailsPage(
              alert: data,
            ),
          ),
        );
      },
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
