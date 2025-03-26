import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:sqflite/sqflite.dart';

class MyAlertsDB {
  final tableName = 'MyAlerts';
  // Nombre de las columnas
  final _uid = 'uid'; // Columna que representa el usuario actual.
  final _latitude = 'latitude'; // Columna almacenando coordenada latitude.
  final _longitude = 'longitude'; // Columna almacenando coordenada longitude.
  final _date = 'date'; // Columna que representa la fecha de la alerta enviada.
  final _audio = 'audio'; // Columna que almacena el archivo de audio opcional.

  /// Crea la tabla 'MyAlerts' en la base de datos si no existe.
  /// [database] - Instancia de la base de datos SQLite donde se creará la tabla.
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        $_uid TEXT NOT NULL,
        $_latitude REAL NOT NULL,
        $_longitude REAL NOT NULL,
        $_date TEXT NOT NULL,
        $_audio TEXT NULL
      );""");
  }

  /// Inserta un nuevo registro de alerta enviada en la base de datos.
  /// [alert] - Objeto 'MyAlert' que representa la alerta a insertar.
  Future<void> registerAlert(MyAlert alert) async {
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

  /// Obtiene la lista de alertas enviadas por un usuario específico.
  /// [userId] - Identificador único del usuario cuyas alertas se quieren obtener.
  /// Retorna una lista de objetos 'MyAlert'.
  Future<List<MyAlert>> getAlerts(String userId) async {
    try {
      // Obtener referencia a la base de datos
      final db = await SQLiteHelper().getDatabase();

      // Query a todas las alertas generadas y enviadas por el usuario
      final alerts =
          await db.query(tableName, where: 'uid = ?', whereArgs: [userId]);

      return alerts
          .map((alert) => MyAlert(
                uid: alert['uid'].toString(),
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
