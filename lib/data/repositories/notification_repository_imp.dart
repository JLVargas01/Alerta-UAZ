import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/domain/repositories/notification_repository.dart';

class NotificationRepositoryImp implements NotificationRepository {
  final _notificationApi = NotificationApi();

  @override
  Future<void> sendAlert(String contacts, Map<String, dynamic> data) async {
    // Contruyendo estructura de una notificación
    Map<String, Object> message = {
      'notification': {
        'title': '¡Alerta de emergencia!',
        'body':
            '${data['name']} necesita ayuda urgente. Se encuentra en una situación de peligro.'
      },
      'data': data
    };

    await _notificationApi.sendAlert(contacts, message);
  }
}
