import 'package:alerta_uaz/data/data_sources/remote/database_service.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:sqflite/sqflite.dart';

class AlertsSent {

  final tableName = 'alertas_enviadas';
  final dbService = DatabaseService.instance;

  //Crear la tabla para las alertas mandadas a otros usuarios
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "dateSended" TEXT NOT NULL,
        "latitude" REAL NOT NULL,
        "longitude" REAL NOT NULL
      );""");
  }

  //Insertar nuevo registro de alerta enviada
  Future<void> registerAlert(AlertSent alert) async {
    try {
      // Obtener referencia a la base de datos
      final db = await dbService.getDatabase();

      await db.insert(
        tableName,
        alert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtener todas las alertas enviadas
  Future<List<AlertSent>> getAlerts() async {
    try {
      // Obtener referencia a la base de datos
      final db = await dbService.getDatabase();

      // Query a todas las alertas generadas y enviadas
      final List<Map<String, Object?>> alertasEnviadasMap = await db.query(tableName);

      return alertasEnviadasMap.map((map) => AlertSent.fromMap(map)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
