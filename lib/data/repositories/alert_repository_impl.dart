import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:location/location.dart';

class AlertRepositoryImpl {
  final NotificationApi _notificationApi;
  final AlertApi _alertApi;

  AlertRepositoryImpl(this._notificationApi, this._alertApi);

  Future<void> registerAlert() async {
    // id temporal
    const alertId = '6742db2bb98ef71d14ec7afc';

    final locationData = await Location().getLocation();

    Map<String, dynamic> data = {
      'coordinates': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      },
      'media': 'https://mx.pinterest.com/pin/351912465120658/'
    };

    await _alertApi.addAlert(alertId, data);
  }

  Future<void> sendAlert(room, user) async {
    String contactListId = user!.idContacts;

    // Estructura para compartir la ubicación actual del emisor
    Map<String, dynamic> data = {
      'room': room, // Cuarto dónde se compartira la localización.
      'name': user!.name, // Nombre del emisor que envía la alerta
      'avatar': user!.avatar
    };

    // Contruyendo estructura de una notificación
    Map<String, Object> message = {
      'notification': {
        'title': '¡Alerta de emergencia!',
        'body':
            '${data['name']} necesita ayuda urgente. Se encuentra en una situación de peligro.'
      },
      'data': data
    };

    await _notificationApi.sendAlert(contactListId, message);
  }
}
