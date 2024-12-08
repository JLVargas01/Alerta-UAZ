import 'package:alerta_uaz/data/data_sources/local/alerts_received_db.dart';
import 'package:alerta_uaz/data/data_sources/local/alerts_sent_db.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/shake_detector_service.dart';
import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:location/location.dart';

class AlertRepositoryImpl {
  final NotificationApi _notificationApi;
  final AlertApi _alertApi;
  final _myAlertHistory = AlertsSent();
  final _user = User();
  final _shake = ShakeDetector();

  AlertRepositoryImpl(this._notificationApi, this._alertApi);

  Future<void> registerAlert() async {
    final String alertId = _user.idAlertList!;

    // última ubicación a registrar.
    final locationData = await Location().getLocation();

    Map<String, dynamic> data = {
      'coordinates': {
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      },
      'media':
          'https://i.pinimg.com/736x/80/72/f9/8072f92472418239a3ff1a3d07e96bdd.jpg'
    };

    // Al final se registra la alerta en el servidor.
    await _alertApi.addAlert(alertId, data);

    // También se registra de manera local.
    final newAlert = AlertSent(
        userId: _user.id!,
        latitude: locationData.latitude!,
        longitude: locationData.longitude!);

    await _myAlertHistory.registerAlert(newAlert);
  }

  Future<void> sendAlert(String room) async {
    String contactListId = _user.idContactList!;

    Map<String, Object> message = {
      'notification': {
        'title': '¡Alerta de emergencia!',
        'body':
            '${_user.name} necesita ayuda urgente. Se encuentra en una situación de peligro.'
      },
      'data': {
        'room': room, // Cuarto dónde se compartira la localización.
        'name': _user.name, // Nombre del emisor que envía la alerta
        'avatar': _user.avatar
      }
    };

    await _notificationApi.sendAlert(contactListId, message);
  }

  Future<List<AlertSent>> loadMyAlertHistory() async {
    try {
    // OBtenemos el  historial de alerta enviadas
      AlertsSent myAlertsDB = AlertsSent();
      return await myAlertsDB.getAlerts();
    } catch(e) {
        throw 'Error con mi lista de alertas enviadas';
    }
  }

  Future<List<AlertReceived>> loadContactsAlertHistory() async {
    try {
    AlertsReceived contactsAlertsDB = AlertsReceived();
    return await contactsAlertsDB.getAlertsReceived();
    } catch(e) {
        throw 'Error con mi lista de alertas recividas';
    }
  }

  ///
  /// Funcionalidades con Shake
  ///
  void startAlert(Function() handler) {
    _shake.startListening(handler);
  }

  void stopAlert() {
    _shake.stopListening();
  }

  void pauseAlert() {
    _shake.pauseListening();
  }

  void resumeAlert() {
    _shake.resumeListening();
  }

  //  PARA DEBUG
  // BORRAR CUANDO NO SE NECESITEN
  Future<void> insertAlertsDebug() async {
    AlertSent newAlertSent = AlertSent(
      userId: _user.id!,
      latitude: 00,
      longitude: 00
    );
    await _myAlertHistory.registerAlert(newAlertSent);

    AlertReceived newAlertRecived = AlertReceived(
        idAlertReceived: '00000',
        idAlerta: '00000',
        aliasContact: 'ALIAS',
        nameUser: 'USER', 
        dateReceived: DateTime. now().toIso8601String(),
    );
    AlertReceived newAlertRecived2 = AlertReceived(
        idAlertReceived: '11111',
        idAlerta: '11111',
        aliasContact: 'ALIAS2',
        nameUser: 'USER2', 
        dateReceived: DateTime.now().toIso8601String()
    );
    final myAlertRecived = AlertsReceived();
    await myAlertRecived.insertRecordAlertReceived(newAlertRecived);
    await myAlertRecived.insertRecordAlertReceived(newAlertRecived2);

  }
}
