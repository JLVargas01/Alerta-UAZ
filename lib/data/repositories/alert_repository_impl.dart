import 'dart:async';

import 'package:alerta_uaz/core/device/audio.dart';
import 'package:alerta_uaz/core/device/shake_detector.dart';
import 'package:alerta_uaz/data/data_sources/local/contact_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/my_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/socket_service.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AlertRepositoryImpl {
  Timer? _timer;
  final AlertApi _alertApi;
  final NotificationApi _notificationApi;

  final _user = User();
  final _audio = Audio();
  final _shake = ShakeDetector();
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

  ///
  ///
  ///----------------------------------------------# UBICACIÓN
  ///
  ///

  void startReceivedLocation(Function(dynamic) handler) {
    _socket.on('newCoordinates', handler);
  }

  void startSendLocation(String room) {
    _socket.emit('createRoom', {'room': room, 'user': _user.name});

    LocationData locationData;

    // Envía constantemente la ubicación cada 5s
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
  }

  void stopSendLocation() {
    _timer!.cancel();
  }

  ///
  ///
  ///----------------------------------------------# AUDIO
  ///
  ///

  void startSendAudio(String room) async {
    await _audio.startAudioCapture();
    final stream = _audio.streamAudio;

    stream.listen((food) {
      if (food.data != null) {
        _socket.emit('sendingAudioCapture', {'room': room, 'data': food.data});
      }
    });
  }

  void startPlayAudio() async {
    await _audio.startPlayAudioCapture();
    _socket.on('audioCapture', (data) {
      if (data != null) _audio.playAudioCapture(data);
    });
  }

  void stopSendAudio() async => await _audio.stopAudioCapture();

  void stopPlayAudio() async => await _audio.stopPlayAudioCapture();

  ///
  ///
  ///----------------------------------------------# REGISTRO DE ALERTA
  ///
  ///

  Future<Map<String, dynamic>> saveAlert() async {
    final locationData = await Location().getLocation();

    // Si los valores son nulos, se asignan ceros
    // para que la aplicacion almenos emita la alarma
    // y evitar excepciones
    double latitude = locationData.latitude ?? 0.0;
    double longitude = locationData.longitude ?? 0.0;

    Map<String, dynamic> data = {
      'date': DateTime.now().toIso8601String(),
      'coordinates': {'latitude': latitude, 'longitude': longitude},
      // 'media':
      //     'https://i.pinimg.com/736x/80/72/f9/8072f92472418239a3ff1a3d07e96bdd.jpg'
    };

    return data;
  }

  void registerLocalMyAlert(Map<String, dynamic> data) async {
    final newAlert = MyAlert(
      uid: _user.id!,
      latitude: data['coordinates']['latitude'],
      longitude: data['coordinates']['longitude'],
      date: DateFormat('dd-MM-yyyy HH:mm:ss').format(data['date']),
    );

    await _myAlertsDB.registerAlert(newAlert);
  }

  void registerServerMyAlert(Map<String, dynamic> data) async {
    String? alertListId = _user.idAlertList;

    if (alertListId == null) throw 'Lista de alerta del usuario no existe.';

    // Se registra la alerta en el servidor.
    await _alertApi.addAlert(alertListId, data);
  }

  Future<void> registerLocalContactAlert(Map<String, dynamic> data) async {
    try {
      final newContactAlert = ContactAlert(
        uid: _user.id!,
        username: data['username'],
        latitude: double.parse(data['coordinates_latitude']),
        longitude: double.parse(data['coordinates_longitude']),
        date: data['date'].toString(),
      );

      await _contactAlertsDB.insertAlert(newContactAlert);
    } catch (e) {
      throw 'Ocurrió un error al registrar la alerta del contacto: ${e.toString()}';
    }
  }

  ///
  ///
  ///----------------------------------------------# ENVÍO DE NOTIFICACIONES
  ///
  ///

  /// Función que enviara una notificación de alerta a los contactos del usuario.
  /// Estructura especifica para que los contactos se enteren y obtengan
  /// datos del emisor.
  void sendAlertActivated(String room) async {
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
      await _notificationApi.sendNotification(contactListId, message);
    } catch (e) {
      throw 'Ocurrió un error al enviar la notificación: ${e.toString()}';
    }
  }

  /// Función que envía notificación a contactos de que el usuario a
  /// desactivado la alerta, dejando de emitir datos y enviando cuál
  /// fue la última ubicación del hecho.
  Future<void> sendAlertDesactivated(Map<String, dynamic> data) async {
    String contactListId = _user.idContactList!;

    // Se realiza otra data para evitar fallos al enviar notificación.
    final newData = {
      'username': _user.name,
      'coordinates_latitude': data['coordinates']['latitude'].toString(),
      'coordinates_longitude': data['coordinates']['longitude'].toString(),
      'date': DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()),
      // 'avatar': _user.avatar,
      'type': 'ALERT_DESACTIVATED'
    };

    Map<String, Object> message = {
      'notification': {
        'title': 'Alerta desactivada',
        'body':
            '${_user.name} ha desactivado la alerta. Puedes ver cuál fue su última ubicación.'
      },
      'data': newData,
    };

    try {
      await _notificationApi.sendNotification(contactListId, message);
    } catch (e) {
      throw 'Ocurrió un error al enviar la notificación: ${e.toString()}';
    }
  }

  ///
  ///
  ///----------------------------------------------# historial de alertas
  ///
  ///

  /// Función que busca si hay registro de alertas del usuario. Primero busca
  /// de manera local, en caso de no tener registro buscara en el servidor,
  /// en caso de que tampoco haya registro entonces retornara null.
  Future<List<MyAlert>> loadMyAlertHistory() async {
    try {
      final history = await _myAlertsDB.getAlerts(_user.id!);
      if (history.isNotEmpty) return history;

      final alertsRegistered = await _alertApi.getAlertList(_user.idAlertList!);

      if (alertsRegistered.isNotEmpty) {
        // Almacenara uno por uno las alertas obtenidas del servidor.
        for (Map<String, dynamic> alert in alertsRegistered) {
          final alertCast = MyAlert(
            uid: _user.id!,
            latitude: double.parse(alert['coordinates']['latitude'].toString()),
            longitude:
                double.parse(alert['coordinates']['longitude'].toString()),
            date: alert['date'].toString(),
          );

          await _myAlertsDB.registerAlert(alertCast);
          history.add(alertCast);
        }
      }

      return history;
    } catch (e) {
      throw 'Ocurrió un error al cargar el historial del usuario: ${e.toString()}';
    }
  }

  /// Función que busca si hay registro de alertas de los contactos. Estos
  /// solo están disponibles de manera local, por lo que si no hay registro...
  /// entonces se retornara null.
  Future<List<ContactAlert>> loadContactsAlertHistory() async {
    try {
      final history = await _contactAlertsDB.getAlerts(_user.id!);

      return history;
    } catch (e) {
      throw 'Ocurrió un error al cargar el historial de los contactos: ${e.toString()}';
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
}
