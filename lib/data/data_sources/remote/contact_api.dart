/*
/// 'ContactApi' maneja las solicitudes HTTP relacionadas con la gestión de contactos.
///
/// Proporciona métodos para obtener listas de contactos, crear nuevos contactos,
/// buscar contactos por número de teléfono y eliminar contactos desde el servidor.
*/

import 'dart:convert';
import 'package:alerta_uaz/core/constants/api_config.dart';
import 'package:alerta_uaz/core/utils/http_helper.dart';

class ContactApi {
  /// URL base para acceder a los endpoints de contactos.
  final String _baseUrl = ApiConfig.getBaseUrl(ApiConfig.portUser, 'contact');

  /// Obtiene la lista de contactos desde el servidor.
  /// [contactListId] - Identificador de la lista de contactos del usuario.
  /// Retorna una lista de contactos en formato JSON si la solicitud es exitosa.
  /// Si la lista no existe, retorna 'null'.
  Future<List<dynamic>?> getContactList(String contactListId) async {
    String endpoint = '/list/byId/$contactListId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['contactList'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw data['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Crea un nuevo contacto en el servidor.
  /// [name] - Nombre o alias del contacto.
  /// [phone] - Número de teléfono del contacto.
  /// [contactListId] - Identificador de la lista de contactos donde se agregará el nuevo contacto.
  /// Retorna el 'contact_id' del nuevo contacto si la operación es exitosa.
  /// Si no se encuentra la lista de contactos, retorna 'null'.
  /// En caso de error, lanza una excepción.
  Future<String?> sendDataNewContact(
      String name, String phone, String contactListId) async {
    String endpoint = '/create/$contactListId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    Map<String, dynamic> data = {
      'alias': name,
      'phone': phone,
    };

    try {
      final response = await HttpHelper.post(uri, data);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['contact_id'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Error al crear el contacto, por favor intente más tarde');
      }
    } catch (e) {
      throw Exception('Error al crear contacto: $e');
    }
  }

  /// Obtiene un contacto específico desde el servidor usando su número de teléfono.
  /// [contactListId] - Identificador de la lista de contactos del usuario.
  /// [phone] - Número de teléfono del contacto a buscar.
  /// Retorna un mapa con la información del contacto si se encuentra.
  /// Si el contacto no existe, retorna 'null'.
  Future<Map<String, dynamic>?> getContactByPhone(
      String contactListId, String phone) async {
    String endpoint = '/byPhone/$contactListId/$phone';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.get(uri);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw 'Hubo un error en el servidor: ${data['message']}';
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina un contacto de la lista en el servidor.
  /// [contactListId] - Identificador de la lista de contactos del usuario.
  /// [contactId] - Identificador del contacto a eliminar.
  /// Si la eliminación no es exitosa, lanza una excepción con el mensaje de error.
  Future<void> sendIdsDeleteContact(
      String contactListId, String contactId) async {
    String endpoint = '/delete/$contactListId/$contactId';
    Uri uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await HttpHelper.delete(uri);

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        throw errorResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
