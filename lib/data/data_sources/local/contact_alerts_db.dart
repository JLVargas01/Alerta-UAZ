import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactAlertsDB {
  final tableName = 'ContactAlert';

  // Nombre de las columnas
  final _uid = 'uid'; // Columna que representa el usuario actual.
  // Columna que representa el nombre de usuario quien envío la alerta.
  final _username = 'username';
  final _avatar = 'avatar';
  // Columna almacenado coordenada.
  final _latitude = 'latitude';
  final _longitude = 'longitude';
  final _date = 'date'; // Columna que representa la fecha de la alerta enviada.
  final _audio = 'audio';

  //Crear la tabla para las alertas recibidas de otros usuarios
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

  //Insertar nuevo registro de alerta recibidas
  Future<void> registerAlert(ContactAlert alert) async {
    try {
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();

      await db.insert(
        tableName,
        alert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtener todas las alertas recibidas
  Future<List<ContactAlert>> getAlerts(String userId) async {
    try {
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();
      // Query a a las alertas notificadas por el contacto.
      final alerts =
          await db.query(tableName, where: 'uid = ?', whereArgs: [userId]);

      // Convertir la lista a objetos AlertReceived
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
      rethrow;
    }
  }
}
