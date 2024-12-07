import 'package:alerta_uaz/core/utils/sqlite_helper.dart';
import 'package:alerta_uaz/domain/model/my_alert_model.dart';
import 'package:sqflite/sqflite.dart';

// <<<<<<< HEAD:lib/data/data_sources/local/my_alerts_db.dart
class MyAlertsDB {
  final tableName = 'MyAlerts';
// =======
// class AlertsSent {

//   final tableName = 'alertas_enviadas';
//   final dbService = DatabaseService.instance;
// >>>>>>> development:lib/data/data_sources/local/alerts_sent_db.dart

  //Crear la tabla para las alertas mandadas a otros usuarios
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "userId" TEXT NOT NULL,
        "latitude" REAL NOT NULL,
        "longitude" REAL NOT NULL
      );""");
  }

  //Insertar nuevo registro de alerta enviada
  Future<void> registerAlert(MyAlert alert) async {
    try {
      // Obtener referencia a la base de datos
// <<<<<<< HEAD:lib/data/data_sources/local/my_alerts_db.dart
      final db = await SQLiteHelper().getDatabase();
// =======
//       final db = await dbService.getDatabase();
// >>>>>>> development:lib/data/data_sources/local/alerts_sent_db.dart

      await db.insert(
        tableName,
        alert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtener todas las alertas enviadas del usuario.
  Future<List<MyAlert>> getAlerts(String userId) async {
    try {
      // Obtener referencia a la base de datos
// <<<<<<< HEAD:lib/data/data_sources/local/my_alerts_db.dart
      final db = await SQLiteHelper().getDatabase();
// =======
//       final db = await dbService.getDatabase();
// >>>>>>> development:lib/data/data_sources/local/alerts_sent_db.dart

      // Query a todas las alertas generadas y enviadas
      final alerts =
          await db.query(tableName, where: 'userId = ?', whereArgs: [userId]);

      return alerts
          .map((alert) => MyAlert(
              alert['userId'].toString(),
              double.parse(alert['latitude'].toString()),
              double.parse(alert['latitude'].toString())))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
