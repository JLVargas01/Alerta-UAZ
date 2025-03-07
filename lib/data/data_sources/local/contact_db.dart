/*
/// ContactDB es una clase encargada de gestionar la base de datos de contactos de confianza en SQLite. 
/// Esta clase proporciona métodos para:
/// - Crear la tabla 'Contacts' si no existe.
/// - Insertar nuevos contactos.
/// - Obtener la lista de contactos de un usuario específico.
/// - Eliminar un contacto en base a su 'contactId'.
/// - Verificar si un contacto ya existe en la base de datos mediante su número de teléfono.
/// 
/// La información almacenada incluye el 'uid' del usuario, un 'contactId' único,
/// un 'alias' para el contacto y su número de teléfono.
*/

import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/my_contact_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactDB {
  final _tableName = 'Contacts';
  // Nombre de las columnas
  final _uid = 'uid'; // Columna que representa el usuario actual.
  final _contactId = 'contactId'; // Columna que será el id contacto a guardar.
  final _alias = 'alias'; // Columna que almacenara el alías del contacto.
  final _phone = 'phone'; // Columna que será el número del contacto.

  /// Crea la tabla 'Contacts' en la base de datos si no existe.
  /// [database] - Instancia de la base de datos SQLite donde se creará la tabla.
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $_tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        $_uid  TEXT NOT NULL,
        $_contactId TEXT NOT NULL,
        $_alias TEXT NOT NULL,
        $_phone TEXT NOT NULL
      );""");
  }

  /// Inserta un nuevo contacto en la base de datos.
  /// [myContact] - Objeto 'MyContact' que representa el contacto a insertar.
  Future<void> insertContact(MyContact myContact) async {
    try {
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();

      await db.insert(
        _tableName,
        myContact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Obtiene la lista de contactos de confianza de un usuario.
  /// [uid] - Identificador del usuario cuyos contactos se quieren obtener.
  /// Retorna una lista de objetos 'MyContact'.
  Future<List<MyContact>> getContacts(String uid) async {
    try {
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();
      // Query a todos los contactos de confianza.

      final List<Map<String, Object?>> contacts =
          await db.query(_tableName, where: 'uid = ?', whereArgs: [uid]);

      // Convertir la lista a objetos Contact
      return contacts.map((contact) => MyContact.fromMap(contact)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina un contacto específico de la base de datos.
  /// [contactId] - Identificador único del contacto a eliminar.
  Future<void> deleteContact(String contactId) async {
    try {
      final db = await SQLiteHelper().getDatabase();
      // Eliminar el contacto
      await db.delete(
        _tableName,
        where: '$_contactId = ?',
        whereArgs: [contactId],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Verifica si un contacto ya existe en la base de datos basándose en su número de teléfono.
  /// [phone] - Número de teléfono del contacto a verificar.
  /// Retorna 'true' si el contacto existe, 'false' en caso contrario.
  Future<bool> contactExists(String phone) async {
    try {
      final db = await SQLiteHelper().getDatabase();

      var contacts = await db.query(
        _tableName,
        where: '$_phone = ?',
        whereArgs: [phone],
      );
      return contacts.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
