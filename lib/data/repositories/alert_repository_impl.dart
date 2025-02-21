import 'dart:async';
import 'dart:io';

import 'package:alerta_uaz/core/device/audio.dart';
import 'package:alerta_uaz/core/device/button_service.dart';
// import 'package:alerta_uaz/core/device/shake_detector.dart';
import 'package:alerta_uaz/data/data_sources/local/contact_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/contact_db.dart';
import 'package:alerta_uaz/data/data_sources/local/my_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/socket_service.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

class AlertRepositoryImpl {
  Timer? _timer;
  final AlertApi _alertApi;
  final NotificationApi _notificationApi;

  final _user = User();
  final _audio = Audio();
  final _alertActivate = ButtonService();
  final _socket = SocketService();
  final _myAlertsDB = MyAlertsDB();
  final _contactAlertsDB = ContactAlertsDB();

  // Constructor
  AlertRepositoryImpl(this._notificationApi, this._alertApi);

  /// Crea un cuarto dónde solo usuarios específicos podrán entrar
  String get getRoom => '${DateTime.now()}:${_user.name}'.replaceAll(' ', '');

  void connectAlert() => _socket.connect();

  void disconnectAlert() => _socket.disconnect();

  void joinRoomAlert(String room) {
    _socket.emit('joinRoom', {'room': room, 'user': _user.name});
  }

  //
  // Ubicación /////////////////////////////////////////////////////////////////
  //

  void startReceivedLocation(Function(dynamic) handler) {
    _socket.on('newCoordinates', handler);
  }

  void startSendLocation(String room) {
    _socket.emit('createRoom', {'room': room, 'user': _user.name});

    LocationData locationData;

    // Envía constantemente la ubicación cada 5s
    try {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
        locationData = await Location().getLocation();

        _socket.emit('sendingCoordinates', {
          'room': room,
          'coordinates': {
            'latitude': locationData.latitude,
            'longitude': locationData.longitude
          },
        });
      });
    } catch (e) {
      _timer?.cancel();
      throw 'No se puede enviar datos de localización: ${e.toString()}';
    }
  }

  void stopSendLocation() {
    _timer!.cancel();
  }

  //
  // Audio /////////////////////////////////////////////////////////////////////
  //

  void startAudioCapture() async {
    try {
      DateTime now = DateTime.now();

      // Formato: yyyyMMddHHmmssSSS (sin espacios ni símbolos)
      final date = "${now.year}"
          "${now.month.toString().padLeft(2, '0')}"
          "${now.day.toString().padLeft(2, '0')}"
          "${now.hour.toString().padLeft(2, '0')}"
          "${now.minute.toString().padLeft(2, '0')}"
          "${now.second.toString().padLeft(2, '0')}"
          "${now.millisecond.toString().padLeft(3, '0')}";

      final username = _user.name!.toUpperCase().replaceAll(' ', '_');

      final filename = 'ALERTA_${username}_$date';
      await _audio.startAudioCapture(filename);
    } catch (e) {
      throw 'No se pudo iniciar la captura de audio: ${e.toString()}';
    }
  }

  Future<String?> stopAudioCapture() async {
    try {
      return await _audio.stopAudioCapture();
    } catch (e) {
      throw 'No se pudo detener la captura de alerta: ${e.toString()}';
    }
  }

  Future<File?> downloadAudio(String filename) async {
    final path = await _audio.getAudioPath();
    final bytes = await _alertApi.downloadAudio(filename);

    File audio = File('$path/$filename');

    return bytes != null ? await audio.writeAsBytes(bytes) : null;
  }

  Future<File?> checkAudio(String filename) => _audio.checkAudio(filename);

  //
  // Registro //////////////////////////////////////////////////////////////////
  //

  Future<Map<String, dynamic>> saveAlert(String? path) async {
    try {
      final locationData = await Location().getLocation();

      // Si los valores son nulos, se asignan ceros
      // para que la aplicacion almenos emita la alarma
      // y evitar excepciones
      double latitude = locationData.latitude ?? 0.0;
      double longitude = locationData.longitude ?? 0.0;

      Map<String, dynamic> data = {
        'date': DateTime.now(),
        'coordinates': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'media': path != null ? basename(path) : null,
      };

      return data;
    } catch (e) {
      throw 'No se pudo crear los datos para registrar la alerta: ${e.toString()}';
    }
  }

  void registerLocalMyAlert(Map<String, dynamic> data) async {
    try {
      final newAlert = MyAlert(
        uid: _user.id!,
        latitude: data['coordinates']['latitude'],
        longitude: data['coordinates']['longitude'],
        date: DateFormat('dd/MM/yyyy - HH:mm:ss').format(data['date']),
        audio: data['media'],
      );

      await _myAlertsDB.registerAlert(newAlert);
    } catch (e) {
      throw 'No se pudo registrar en local la alerta: ${e.toString()}';
    }
  }

  void registerServerMyAlert(Map<String, dynamic> data, String? path) async {
    try {
      String? alertListId = _user.idAlertList;

      if (alertListId == null) throw 'Lista de alerta del usuario no existe.';

      // Se registra la alerta en el servidor.
      await _alertApi.addAlert(alertListId, data);
      // Registramos el audio también en el servidor
      if (path != null) await _alertApi.uploadAudio(path);
    } catch (e) {
      throw 'No se pudo registrar en el servidor la alerta: ${e.toString()}';
    }
  }

  Future<void> registerLocalContactAlert(Map<String, dynamic> data) async {
    try {
      final newContactAlert = ContactAlert(
        uid: _user.id!,
        username: data['username'],
        avatar: data['avatar']?.toString(),
        latitude: double.parse(data['coordinates_latitude']),
        longitude: double.parse(data['coordinates_longitude']),
        date: data['date'].toString(),
        audio: data['media'],
      );

      await _contactAlertsDB.registerAlert(newContactAlert);
    } catch (e) {
      throw 'No se pudo registrar en local la alerta del contacto: ${e.toString()}';
    }
  }

  //
  // Notificación //////////////////////////////////////////////////////////////
  //

  /// Envía notificación de alerta a los contactos del usuario.
  /// Comparte datos a través del [room].
  Future<String> sendAlertActivated(String room) async {
    // Verificamos si tiene contactos para recibir la alerta.
    var contacts = await ContactDB().getContacts(_user.id!);
    if (contacts.isEmpty) return 'No tienes contactos que reciban la alerta.';

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
        'avatar': _user.avatar,
        'type': 'ALERT_ACTIVATED' // Hacemos referencia que es una alerta.
      }
    };
    try {
      final data = await _notificationApi.sendNotification(
        contactListId,
        message,
      );

      if (data["success"] > 0 && data['failure'] == 0) {
        return 'La alerta ha sido enviada a tus contactos.';
      } else if (data["success"] > 0 && data['failure'] > 0) {
        return 'La alerta no pudo ser recibida con algunos contactos.';
      } else {
        // Probablemente los contactos agregados no esten en sesión o se caducó el token.
        return 'La alerta no fue enviada porque ningún contacto esta conectado.';
      }
    } catch (e) {
      throw 'No se pudo enviar la notificación: ${e.toString()}';
    }
  }

  /// Envía una notificación a los contactos donde indique
  /// que la alerta fue desactivada.
  void sendAlertDesactivated(Map<String, dynamic> data) async {
    var contacts = await ContactDB().getContacts(_user.id!);
    if (contacts.isEmpty) return; // No hay contactos para enviar notificación.

    String contactListId = _user.idContactList!;

    Map<String, Object> message = {
      'notification': {
        'title': 'Alerta desactivada',
        'body':
            '${_user.name} ha desactivado la alerta. Puedes ver cuál fue su última ubicación.'
      },
      'data': {
        'username': _user.name,
        'avatar': _user.avatar?.toString(),
        'coordinates_latitude': data['coordinates']['latitude'].toString(),
        'coordinates_longitude': data['coordinates']['longitude'].toString(),
        'date': DateFormat('dd/MM/yyyy - HH:mm:ss').format(data['date']),
        'media': data['media']?.toString(),
        'type': 'ALERT_DESACTIVATED'
      },
    };

    try {
      await _notificationApi.sendNotification(
        contactListId,
        message,
      );
    } catch (e) {
      throw 'No se pudo enviar la notificación: ${e.toString()}';
    }
  }

  //
  // Historial /////////////////////////////////////////////////////////////////
  //

  /// Retorna una lista de alertas emitidas, si no hay ningun registro en local
  /// verifica si hay registros en el servidor.
  Future<List<MyAlert>> loadMyAlertHistory() async {
    try {
      final history = await _myAlertsDB.getAlerts(_user.id!);
      if (history.isNotEmpty) return history;

      final alertsRegistered = await _alertApi.getAlertList(_user.idAlertList!);

      // Almacenara uno por uno las alertas obtenidas del servidor.
      for (Map<String, dynamic> alert in alertsRegistered) {
        alert['date'] = DateTime.parse(alert['date'].toString());

        final getAlert = MyAlert(
          uid: _user.id!,
          latitude: double.parse(alert['coordinates']['latitude'].toString()),
          longitude: double.parse(alert['coordinates']['longitude'].toString()),
          date: DateFormat('dd/MM/yyyy - HH:mm:ss').format(alert['date']),
          audio: alert['media'],
        );

        await _myAlertsDB.registerAlert(getAlert);

        history.add(getAlert);
      }

      return history;
    } catch (e) {
      throw 'No se pudo cargar tu historial de alertas: ${e.toString()}';
    }
  }

  /// Retorna una lista de alertas recibidas.
  Future<List<ContactAlert>> loadContactsAlertHistory() async {
    try {
      final history = await _contactAlertsDB.getAlerts(_user.id!);

      return history;
    } catch (e) {
      throw 'No se pudo obtener el historial de alertas de los contactos: ${e.toString()}';
    }
  }

  //
  // Shake //////////////////////////////////////////////////////////////////
  //

  void startAlert(Function() handler) {
    _alertActivate.startListening(handler);
  }

  void stopAlert() {
    _alertActivate.stopListening();
  }

  void pauseAlert() {
    _alertActivate.pauseListening();
  }

  void resumeAlert() {
    _alertActivate.resumeListening();
  }
}
