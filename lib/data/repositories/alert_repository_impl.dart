import 'package:alerta_uaz/data/data_sources/local/alerts_sent_db.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:location/location.dart';

class AlertRepositoryImpl {
  final NotificationApi _notificationApi;
  final AlertApi _alertApi;
  final AlertsSent lertasDB = AlertsSent();

  final User _user = User();

  AlertRepositoryImpl(this._notificationApi, this._alertApi);

  Future<void> registerAlert() async {
    // id temporal
    final String alertId = _user.idAlertList!;

    final locationData = await Location().getLocation();

    Map<String, dynamic> data = {
      'coordinates': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      },
      'media': 'https://mx.pinterest.com/pin/351912465120658/'
    };

    AlertSent nuevaAlerta = AlertSent(
      latitude: locationData.latitude as String,
      longitude: locationData.longitude  as String
    );
    await lertasDB.insertRecordAlertSent(nuevaAlerta);

    await _alertApi.addAlert(alertId, data);
  }

  Future<void> sendAlert(String room, User user) async {
    String contactListId = user.idContactList!;

    // Estructura para compartir la ubicación actual del emisor
    Map<String, dynamic> data = {
      'room': room, // Cuarto dónde se compartira la localización.
      'name': user.name, // Nombre del emisor que envía la alerta
      'avatar': user.avatar
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
