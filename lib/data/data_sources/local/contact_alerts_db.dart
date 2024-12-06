import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/contact_alert_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactAlertsDB {
  final tableName = 'ContactAlert';

  //Crear la tabla para las alertas recibidas de otros usuarios
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "userId" TEXT NOT NULL,
        "username" TEXT NOT NULL,
        "latitude" REAL NOT NULL,
        "longitude" REAL NOT NULL
      );""");
  }

  //Insertar nuevo registro de alerta recibidas
  Future<void> insertAlert(ContactAlert alert) async {
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
          await db.query(tableName, where: 'userId = ?', whereArgs: [userId]);

      // Convertir la lista a objetos AlertReceived
      return alerts
          .map((alert) => ContactAlert(
              alert['userId'].toString(),
              alert['username'].toString(),
              double.parse(alert['latitude'].toString()),
              double.parse(alert['latitude'].toString())))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
