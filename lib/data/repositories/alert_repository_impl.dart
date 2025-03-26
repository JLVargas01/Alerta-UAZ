/*
/// Implementación del repositorio de alertas.
/// 
/// Esta clase gestiona el flujo de datos y comunicación relacionada con las alertas,
/// incluyendo la conexión a sockets, envío de notificaciones, captura de audio y almacenamiento local.
/// También maneja la localización en tiempo real y el historial de alertas.
/// 
/// Dependencias:
/// - 'AlertApi': API para gestionar alertas en el servidor.
/// - 'NotificationApi': API para enviar notificaciones.
/// - 'SocketService': Servicio de sockets para la comunicación en tiempo real.
/// - 'Audio': Manejo de captura y reproducción de audio.
/// - 'Location': Servicio de geolocalización.
/// - 'MyAlertsDB': Base de datos local para alertas personales.
/// - 'ContactAlertsDB': Base de datos local para alertas de contactos.
*/

import 'dart:async';
import 'dart:io';

import 'package:alerta_uaz/core/device/audio.dart';
import 'package:alerta_uaz/core/device/button_service.dart';
import 'package:alerta_uaz/core/device/geolocator_device.dart';

import 'package:alerta_uaz/data/data_sources/local/contact_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/contact_db.dart';
import 'package:alerta_uaz/data/data_sources/local/my_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/remote/alert_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/notification_api.dart';
import 'package:alerta_uaz/data/data_sources/remote/socket_service.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class AlertRepositoryImpl {
  StreamSubscription<dynamic>? _stream;
  final AlertApi _alertApi;
  final NotificationApi _notificationApi;

  final _user = User();
  final _audio = Audio();
  final _alertActivate = ButtonService();
  final _socket = SocketService();
  final _myAlertsDB = MyAlertsDB();
  final _contactAlertsDB = ContactAlertsDB();

  /// Constructor de la clase.
  ///
  /// [notificationApi] API de notificaciones.
  /// [alertApi] API de alertas.
  AlertRepositoryImpl(this._notificationApi, this._alertApi);

  /// Genera un identificador único para una sala de alertas.
  ///
  /// Retorna una cadena que combina la fecha actual y el nombre del usuario.
  String get getRoom => '${DateTime.now()}:${_user.name}'.replaceAll(' ', '');

  /// Conecta al servicio de alertas por sockets.
  void connectAlert() => _socket.connect();

  /// Desconecta del servicio de alertas por sockets.
  void disconnectAlert() => _socket.disconnect();

  /// Une al usuario a una sala de alertas.
  ///
  /// [room] Nombre de la sala a la que se unirá el usuario.
  void joinRoomAlert(String room) {
    _socket.emit('joinRoom', {'room': room, 'user': _user.name});
  }

  /// Escucha eventos de ubicación de otros usuarios en una sala.
  ///
  /// [handler] Función que manejará los datos de ubicación recibidos.
  void startReceivedLocation(Function(dynamic) handler) {
    _socket.on('newCoordinates', handler);
  }

  /// Inicia el envío de la ubicación del usuario cada 5 segundos.
  ///
  /// [room] Nombre de la sala donde se enviarán las coordenadas.
  void startSendLocation(String room) {
    try {
      _socket.emit('createRoom', {'room': room, 'user': _user.name});

      _stream = GeolocatorDevice.getPositionStream((position) {
        _socket.emit('sendingCoordinates', {
          'room': room,
          'coordinates': {
            'latitude': position.latitude,
            'longitude': position.longitude
          },
        });
      });
    } catch (e) {
      _stream!.cancel();
      throw 'No se puede enviar datos de localización: ${e.toString()}';
    }
  }

  /// Detiene el envío de ubicación.
  void stopSendLocation() {
    _stream!.cancel();
  }

  /// Inicia la captura de audio para la alerta.
  void startAudioCapture() async {
    try {
      DateTime now = DateTime.now();
      final date = "${now.year}${now.month.toString().padLeft(2, '0')}"
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

  /// Detiene la captura de audio y retorna el archivo generado..
  Future<String?> stopAudioCapture() async {
    try {
      return await _audio.stopAudioCapture();
    } catch (e) {
      throw 'No se pudo detener la captura de alerta: ${e.toString()}';
    }
  }

  /// Descarga un archivo de audio.
  ///
  /// [filename] Nombre del archivo a descargar.
  Future<File?> downloadAudio(String filename) async {
    final path = await _audio.getAudioPath();
    final bytes = await _alertApi.downloadAudio(filename);

    File audio = File('$path/$filename');

    return bytes != null ? await audio.writeAsBytes(bytes) : null;
  }

  /// Verifica si un archivo de audio con el nombre [filename] existe en el almacenamiento.
  /// Retorna el archivo si existe o 'null' si no se encuentra.
  Future<File?> checkAudio(String filename) => _audio.checkAudio(filename);

  /// Genera los datos necesarios para registrar una alerta.
  /// Si 'path' no es nulo, se incluye el nombre del archivo en la alerta.
  /// Obtiene la ubicación actual y, en caso de error, usa valores por defecto (0.0).
  /// Retorna un 'Map<String, dynamic>' con la información de la alerta.
  Future<Map<String, dynamic>> saveAlert(String? path) async {
    try {
      final position = await Geolocator.getCurrentPosition();

      double latitude = position.latitude;
      double longitude = position.longitude;

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

  /// Registra una alerta en la base de datos local.
  /// [data] contiene la información de la alerta generada.
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

  /// Registra una alerta en el servidor.
  /// Si 'path' contiene un archivo de audio, también lo sube al servidor.
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

  /// Registra una alerta de contacto en la base de datos local.
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

  /// Envía una notificación de alerta a los contactos del usuario.
  /// [room] es la sala en la que se compartirá la localización del usuario.
  /// Retorna un mensaje indicando el resultado del envío.
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
        // 'avatar': _user.avatar, // ACTUALMENTE NO SE USA
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

  /// Envía una notificación a los contactos cuando la alerta es desactivada.
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

  /// Carga el historial de alertas emitidas desde la base de datos local o el servidor.
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

  /// Carga el historial de alertas recibidas.
  Future<List<ContactAlert>> loadContactsAlertHistory() async {
    try {
      final history = await _contactAlertsDB.getAlerts(_user.id!);

      return history;
    } catch (e) {
      throw 'No se pudo obtener el historial de alertas de los contactos: ${e.toString()}';
    }
  }

  //
  // Bottons //////////////////////////////////////////////////////////////////
  //

  /// Inicia la escucha de alertas, ejecutando [handler] cuando se detecta una activación.
  void startAlert(Function() handler) {
    _alertActivate.startListening(handler);
  }

  /// Detiene la escucha de alertas, deshabilitando cualquier detección de activación.
  void stopAlert() {
    _alertActivate.stopListening();
  }

  /// Pausa temporalmente la escucha de alertas.
  void pauseAlert() {
    _alertActivate.pauseListening();
  }

  /// Reanuda la escucha de alertas después de haber sido pausada.
  void resumeAlert() {
    _alertActivate.resumeListening();
  }
}
