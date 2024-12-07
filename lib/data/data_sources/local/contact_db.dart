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

  //Crear la tabla para los contactos de confianza
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $_tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        $_uid  TEXT NOT NULL,
        $_contactId TEXT NOT NULL,
        $_alias TEXT NOT NULL,
        $_phone TEXT NOT NULL
      );""");
  }

  //Insertar nuevo contacto
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

  // Obtener todos los contactos del usuario en la base de datos
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

  // Elimina un contacto específico
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

  /// TODO: Buscar la manera de agregar al argumento el código del país.
  /// Ya que al filtrar no encuentra coincidencias. Ejemplo del error:
  /// String phone = 492 102 8987
  /// QUERY - +524921028987 = 492 102 8987 / Como es diferente devuelve una lista vacía.
  /// Qué causa este error: Agregar más de una vez al contacto tanto en local como en el servidor.
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
