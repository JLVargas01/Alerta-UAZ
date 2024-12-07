import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/cont-confianza_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactosConfianza {
  final tableName = 'contactos_confianza';
  // final dbService = DatabaseService.instance;

  //Crear la tabla para los contactos de confianza
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id_confianza"  TEXT NOT NULL,
        "alias" TEXT NOT NULL,
        "telephone" TEXT NOT NULL,
        "relacion" TEXT,
        PRIMARY KEY("id_confianza")
      );""");
  }

  //Insertar nuevo contacto
  Future<void> insertContacto(ContactoConfianza contacto) async {
    try {
// <<<<<<< HEAD
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();
// =======
//     // Obtener referencia a la base de datos
//       final db = await dbService.getDatabase();

// >>>>>>> development
      await db.insert(
        tableName,
        contacto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtener todos los contactos en la base de datos
  Future<List<ContactoConfianza>> contactos() async {
    try {
// <<<<<<< HEAD
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();
      // Query a todos los contactos de confianza.
// =======
//     // Obtener referencia a la base de datos
//       final db = await dbService.getDatabase();

//     // Query a todos los contactos de confianza.
// >>>>>>> development
      final List<Map<String, Object?>> contactoMap = await db.query(tableName);

      // Convertir la lista a objetos ContactoConfianza
      return [
        for (final {
              'id_confianza': id_confianza as String,
              'telephone': telephone as String,
              'alias': alias as String,
              'relacion': relacion as String,
            } in contactoMap)
          ContactoConfianza(
              id_confianza: id_confianza,
              alias: alias,
              telephone: telephone,
              relacion: relacion),
      ];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> eliminarContacto(String id) async {
    try {
// <<<<<<< HEAD
      final db = await SQLiteHelper().getDatabase();
      // Eliminar el contacto
// =======
//       final db = await dbService.getDatabase();

//     // Eliminar el contacto
// >>>>>>> development
      await db.delete(
        tableName,
        where: 'id_confianza = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> eliminarTodosContacto() async {
  //   try {
  //     // Obtener la instancia de la base de datos
  //     final db = await dbService.getDatabase();
  //     // Eliminar todos los registros de la tabla
  //      await db.delete(tableName);
  //   } catch (e) {
  //     throw Exception('Error al intentar eliminar todos los contactos');
  //   }
  // }

  Future<bool> existContact(String telephone) async {
    try {
// <<<<<<< HEAD
      final db = await SQLiteHelper().getDatabase();
// =======
//       final db = await dbService.getDatabase();
// >>>>>>> development
      var retorno = await db.query(
        tableName,
        where: 'telephone = ?',
        whereArgs: [telephone],
      );
      return retorno.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
