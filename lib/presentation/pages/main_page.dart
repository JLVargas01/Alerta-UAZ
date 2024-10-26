import 'package:alerta_uaz/application/notification_bloc.dart';
import 'package:alerta_uaz/domain/model/notification_model.dart';
import 'package:alerta_uaz/presentation/widget/indexed_stack_navigation.dart';
import 'package:alerta_uaz/presentation/widget/notification_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationReceived) {
          _showNotificationAlert(context, state.notificationModel);
        }
      },
      child: const IndexedStackNavigation(),
    );
  }

  void _showNotificationAlert(
      BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationAlert(notificationModel: notification);
      },
    );
  }
}
