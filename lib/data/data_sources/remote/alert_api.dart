import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';
import 'package:http/http.dart' as http;

class AlertApi {
  // Default: base url = http://localhost:3002/api/alert
  final _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portAlert, 'alert');

  Future<String> addAlert(String alertId, Map<String, dynamic> data) async {
    final endpoint = '/add/$alertId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    // Se creo otro objeto para evitar errores
    Map<String, dynamic> newAlert = {
      'date': (data['date'] as DateTime).toIso8601String(),
      'coordinates': data['coordinates'],
      'media': data['media']
    };

    try {
      http.Response response = await HttpHelper.post(uri, newAlert);

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String dateNewAlert = responseData['dateNewAlert'];
        // Retornar la fecha de la nueva alerta
        return dateNewAlert;
      } else if (response.statusCode == 404) {
        // 'Error al registrar la alerta: La lista de alertas no existe
        return '';
      } else {
        throw HttpHelper.errorInServer;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAlertList(String alertListId) async {
    final endpoint = '/getList/$alertListId';
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      http.Response response = await HttpHelper.get(uri);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadAudio(String audioPath) async {
    const endpoint = '/upload/audio';
    final uri = Uri.parse('$_baseUrl$endpoint');

    File audio = File(audioPath);

    try {
      final response = await HttpHelper.uploadFile(uri, 'audio', audio);

      print('CÓDIGO DE ESTATUS AL ENVIAR EL AUDIO: ${response.statusCode}');

      // if (response.statusCode != 200) {
      //   throw 'No se pudo subir el archivo audio.';
      // }
    } catch (e) {
      rethrow;
    }
  }

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
