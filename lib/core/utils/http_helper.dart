/*
//  Clase auxiliar para realizar peticiones HTTP en la aplicación.
//  La clase 'HttpHelper' proporciona métodos estáticos para realizar solicitudes 
//  HTTP ('GET', 'POST', 'DELETE', 'PATCH') de manera sencilla y manejando errores 
//  comunes como falta de conexión, tiempos de espera o respuestas incorrectas del 
//  servidor. También incluye un método para subir archivos mediante 'MultipartRequest'.
//  Funcionalidades principales:
// -Define encabezados predeterminados para las solicitudes.
// -Maneja errores comunes de conexión y tiempo de espera.
// -Ofrece métodos 'post', 'get', 'delete' y 'patch' para interactuar con una API.
// -Proporciona un método 'uploadFile' para subir archivos al servidor.
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static const int _timeout = 10;

  static const String _errorInServer = 'Error al comunicarse con el servidor.';

  static const String _errorConection = 'No hay conexión a internet.';

  static const String _errorTimeout =
      'La solicitud tardó demasiado. Por favor, intentelo más tarde.';

  /// Retorna los encabezados predeterminados para las solicitudes HTTP.
  static Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': ApiConfig.headerKey,
    };
  }

  /// Maneja las respuestas del servidor y lanza excepciones en caso de error.
  /// Retorna la respuesta si el estado es exitoso (código 2XX).
  /// Lanza una excepción con un mensaje de error si hay un código de estado no esperado.
  static http.Response handleResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) return response;

    final messageError = json.decode(response.body)['message'];

    switch (status) {
      case 400:
        throw 'Solicitud incorrecta: $messageError';
      case 401:
        throw 'No autorizad: $messageError';
      case 404:
        throw 'Recurso no encontrado: $messageError';
      case 500:
        throw 'Error interno del servidor: $messageError';
      default:
        throw 'Error desconocido: $status - $messageError';
    }
  }

  /// Realiza una solicitud HTTP 'POST'.
  /// - [url] : Dirección del endpoint.
  /// - [data] : Datos que se enviarán en el cuerpo de la solicitud.
  /// Retorna la respuesta del servidor o lanza una excepción en caso de error.
  static Future<http.Response> post(Uri url, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            url,
            headers: _defaultHeaders(),
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: _timeout));

      return response;
    } on SocketException {
      throw _errorConection;
    } on HttpException {
      throw _errorInServer;
    } on TimeoutException {
      throw _errorTimeout;
    } catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }

  /// Realiza una solicitud HTTP 'GET'.
  /// - [url] : Dirección del endpoint.
  /// Retorna la respuesta del servidor o lanza una excepción en caso de error.
  static Future<http.Response> get(Uri url) async {
    try {
      final response = await http
          .get(
            url,
            headers: _defaultHeaders(),
          )
          .timeout(const Duration(seconds: _timeout));

      return response;
    } on SocketException {
      throw _errorConection;
    } on HttpException {
      throw _errorInServer;
    } on TimeoutException {
      throw _errorTimeout;
    } catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }

  /// Realiza una solicitud HTTP 'DELETE'.
  /// - [url] : Dirección del endpoint.
  /// Retorna la respuesta del servidor o lanza una excepción en caso de error.
  static Future<http.Response> delete(Uri url) async {
    try {
      final response = await http
          .delete(
            url,
            headers: _defaultHeaders(),
          )
          .timeout(const Duration(seconds: _timeout));

      return response;
    } on SocketException {
      throw _errorConection;
    } on HttpException {
      throw _errorInServer;
    } on TimeoutException {
      throw _errorTimeout;
    } catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }

  /// Realiza una solicitud HTTP 'PATCH'.
  /// - [url] : Dirección del endpoint.
  /// Retorna la respuesta del servidor o lanza una excepción en caso de error.
  static Future<http.Response> patch(Uri url) async {
    try {
      final response =
          await http.patch(url).timeout(const Duration(seconds: _timeout));

      return response;
    } on SocketException {
      throw _errorConection;
    } on HttpException {
      throw _errorInServer;
    } on TimeoutException {
      throw _errorTimeout;
    } catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }

  /// Sube un archivo al servidor mediante una solicitud 'MultipartRequest'.
  /// - [url] : Dirección del endpoint.
  /// - [type] : Tipo de archivo que se está enviando (ej. "image", "audio").
  /// - [file] : Archivo a subir.
  static Future<http.StreamedResponse> uploadFile(
      Uri url, String type, File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        url,
      )..files.add(await http.MultipartFile.fromPath(
          type,
          file.path,
        ).timeout(const Duration(seconds: _timeout)));

      return await request.send();
    } on SocketException {
      throw _errorConection;
    } on HttpException {
      throw _errorInServer;
    } on TimeoutException {
      throw _errorTimeout;
    } catch (e) {
      throw 'Ocurrió un error inesperado: ${e.toString()}';
    }
  }
}
