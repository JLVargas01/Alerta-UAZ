/*
//  Clase de acceso a datos para la tabla de alertas de contacto en SQLite.
//  Esta clase maneja la creación, inserción y recuperación de registros
//  en la tabla 'ContactAlert', donde se almacenan las alertas enviadas por otros
//  usuarios.
//  Funcionalidades principales:
//- Crea la tabla 'ContactAlert' si no existe.
//- Inserta nuevas alertas de contacto en la base de datos.
//- Recupera todas las alertas recibidas para un usuario específico.
*/

import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactAlertsDB {
  final tableName = 'ContactAlert';

  final _uid = 'uid'; // ID del usuario actual
  final _username = 'username'; // Nombre de usuario que envió la alerta
  final _avatar = 'avatar'; // URL o ruta del avatar del usuario
  final _latitude = 'latitude'; // Coordenada de latitud
  final _longitude = 'longitude'; // Coordenada de longitud
  final _date = 'date'; // Fecha de la alerta
  final _audio = 'audio'; // Ruta o URL del archivo de audio (si existe)

  /// Crea la tabla 'ContactAlert' en la base de datos si no existe.
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        $_uid TEXT NOT NULL,
        $_username TEXT NOT NULL,
        $_avatar TEXT NULL,
        $_latitude REAL NOT NULL,
        $_longitude REAL NOT NULL,
        $_date TEXT NOT NULL,
        $_audio TEXT NULL
      );""");
  }

  /// Inserta un nuevo registro de alerta en la base de datos.
  ///
  /// Si ya existe un registro con los mismos datos, lo reemplaza.
  Future<void> registerAlert(ContactAlert alert) async {
    try {
      final db = await SQLiteHelper().getDatabase();
      await db.insert(
        tableName,
        alert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow; // Propaga el error en caso de fallo
    }
  }

  /// Obtiene todas las alertas recibidas para un usuario específico.
  ///
  /// Retorna una lista de objetos 'ContactAlert' asociados al 'userId'.
  Future<List<ContactAlert>> getAlerts(String userId) async {
    try {
      final db = await SQLiteHelper().getDatabase();
      final alerts =
          await db.query(tableName, where: 'uid = ?', whereArgs: [userId]);

      return alerts
          .map((alert) => ContactAlert(
                uid: alert['uid'].toString(),
                username: alert['username'].toString(),
                avatar: alert['avatar']?.toString(),
                latitude: double.parse(alert['latitude'].toString()),
                longitude: double.parse(alert['longitude'].toString()),
                date: alert['date'].toString(),
                audio: alert['audio']?.toString(),
              ))
          .toList();
    } catch (e) {
      rethrow; // Propaga el error en caso de fallo
    }
  }
}
