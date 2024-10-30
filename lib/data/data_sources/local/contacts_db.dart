import 'package:alerta_uaz/data/data_sources/remote/database_service.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactosConfianza {

  final tableName = 'contactos_confianza';

  //Crear la tabla para los contactos de confianza
  Future<void> createTable(Database database) async {
    await database.execute(
      """CREATE TABLE IF NOT EXISTS $tableName (
        "id_confianza"  TEXT NOT NULL,
        "alias" TEXT NOT NULL,
        "telephone" TEXT NOT NULL,
        "relacion" TEXT,
        PRIMARY KEY("id_confianza")
      );"""
    );
  }

  //Insertar nuevo contacto
  Future<void> insertContacto(ContactoConfianza contacto) async {
    try {
    // Obtener referencia a la base de datos
      final db = await DatabaseService().getDatabase();

      await db.insert(
        tableName,
        contacto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar contacto: $e');
      rethrow;
    }
  }

  // Obtener todos los contactos en la base de datos
  Future<List<ContactoConfianza>> contactos() async {
    try {
    // Obtener referencia a la base de datos
      final db = await DatabaseService().getDatabase();

    // Query a todos los contactos de confianza.
      final List<Map<String, Object?>> contactoMaps = await db.query(tableName);

    // Convertir la lista a objetos ContactoConfianza
      return [
        for (final {
        'id_confianza': id_confianza as String,
        'telephone': telephone as String,
        'alias': alias as String,
        'relacion': relacion as String,
        } in contactoMaps)
          ContactoConfianza(id_confianza: id_confianza, alias: alias, telephone: telephone, relacion: relacion),
      ];
    } catch (e) {
      print('Error al obtener contactos: $e');
      return [];
    }
  }

  Future<void> eliminarContacto(String id) async {
    try {
      final db = await DatabaseService().getDatabase();

    // Eliminar el contacto
      await db.delete(
        tableName,
        where: 'id_confianza = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error al eliminar contacto: $e');
      rethrow;
    }
  }

  Future<bool> existContact(String telephone) async {
    try {
      final db = await DatabaseService().getDatabase();
      var retorno = await db.query(
        tableName,
        where: 'telephone = ?',
        whereArgs: [telephone],
      );
      return retorno.isNotEmpty;
    } catch (e) {
      print('Error al buscar el contacto: $e');
      rethrow;
    }
  }
}
