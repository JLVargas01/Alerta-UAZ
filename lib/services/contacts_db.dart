
import 'package:alerta_uaz/services/database_service.dart';
import 'package:alerta_uaz/models/cont_confianza.dart';
import 'package:sqflite/sqflite.dart';

class ContactosConfianza {

  final tableName = 'contactos';

  //Crear la tabla para los contactos de confianza
  Future<void> createTable(Database database) async {
    await database.execute(
      """CREATE TABLE IF NOT EXISTS $tableName (
        "id"  INTEGER NOT NULL,
        "telephone" TEXT NOT NULL,
        "name" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );"""
    );
  }

  //Insertar nuevo contacto
  Future<void> insertContacto(ContactoConfianza contacto) async {
    
    // Obtener referencia a la base de datos
    final db = await DatabaseService().getDatabase();

    await db.insert(
      tableName,
      contacto.toMap(),

      // Remplazar registro si se repite
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    db.close();
  }

  // Obtener todos los contactos en la base de datos
  Future<List<ContactoConfianza>> contactos() async {

    // Obtener referencia a la base de datos
    final db = await DatabaseService().getDatabase();

    // Query a todos los contactos de confianza.
    final List<Map<String, Object?>> contactoMaps = await db.query(tableName);

    // Convertir la lista a objetos ContactoConfianza
    db.close();
    return [
      for (final {
            'id': id as int,
            'telephone': telephone as String,
            'name': name as String,
          } in contactoMaps)
        ContactoConfianza(id: id, name: name, telephone: telephone),
    ];
  }

}
