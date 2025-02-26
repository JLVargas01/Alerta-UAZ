/*
/// 'AlertApi' maneja las solicitudes HTTP para la gestión de alertas en el sistema.
///
/// Esta clase proporciona métodos para agregar alertas, obtener listas de alertas,
/// subir archivos de audio y descargar grabaciones desde el servidor.
///
/// Utiliza 'HttpHelper' para realizar las solicitudes HTTP y gestionar las respuestas.
*/

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class AlertApi {
  // Default: base url = http://localhost:3002/api/alert
  final _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portAlert, 'alert');

  /// Agrega una nueva alerta al servidor.
  /// [alertId] - Identificador único de la alerta.
  /// [data] - Mapa con la información de la alerta, que debe contener:
  ///   - 'date': Fecha y hora de la alerta en formato 'DateTime'.
  ///   - 'coordinates': Ubicación en formato de coordenadas (ej. latitud y longitud).
  ///   - 'media': Contenido multimedia asociado a la alerta.
  Future<void> addAlert(String alertId, Map<String, dynamic> data) async {
    final endpoint = '/add/$alertId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    // Se crea un nuevo objeto para evitar posibles errores en la conversión de datos.
    Map<String, dynamic> newAlert = {
      'date': (data['date'] as DateTime).toIso8601String(),
      'coordinates': data['coordinates'],
      'media': data['media']
    };

    try {
      final response = await HttpHelper.post(uri, newAlert);
      HttpHelper.handleResponse(response);
    } catch (_) {
      rethrow;
    }
  }

  /// Obtiene una lista de alertas desde el servidor.
  /// [alertListId] - Identificador de la lista de alertas a recuperar.
  /// Retorna una lista dinámica con los datos de las alertas almacenadas en formato JSON.
  Future<List<dynamic>> getAlertList(String alertListId) async {
    final endpoint = '/getList/$alertListId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      var response = await HttpHelper.get(uri);
      response = HttpHelper.handleResponse(response);
      return json.decode(response.body);
    } catch (_) {
      rethrow;
    }
  }

  /// Sube un archivo de audio al servidor.
  /// [audioPath] - Ruta del archivo de audio en el sistema de archivos local.
  Future<void> uploadAudio(String audioPath) async {
    const endpoint = '/upload/audio';
    final uri = Uri.parse('$_baseUrl$endpoint');

    File audio = File(audioPath);

    try {
      await HttpHelper.uploadFile(uri, 'audio', audio);
    } catch (_) {
      rethrow;
    }
  }

  /// Descarga un archivo de audio desde el servidor.
  /// [filename] - Nombre del archivo de audio a descargar.
  /// Retorna un 'Uint8List' con los bytes del archivo si la descarga es exitosa.
  /// Si el archivo no está disponible, retorna 'null'.
  Future<Uint8List?> downloadAudio(String filename) async {
    final endpoint = '/download/audio/$filename';
    final uri = Uri.parse('$_baseUrl$endpoint');

    final response = await HttpHelper.get(uri);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }
}
