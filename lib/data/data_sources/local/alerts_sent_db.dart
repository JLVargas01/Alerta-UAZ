import 'package:alerta_uaz/data/data_sources/remote/database_service.dart';
import 'package:alerta_uaz/domain/model/alerts_sent_model.dart';
import 'package:sqflite/sqflite.dart';

class AlertsSent {

  final tableName = 'alertas_enviadas';

  //Crear la tabla para las alertas mandadas a otros usuarios
  Future<void> createTable(Database database) async {
    await database.execute(
      """CREATE TABLE IF NOT EXISTS $tableName (
        "idAlertSent" TEXT NOT NULL,
        "dateSended" DATE NOT NULL,
        PRIMARY KEY("idAlertSent")
      );"""
    );
  }

  //Insertar nuevo registro de alerta enviada
  Future<void> insertRecordAlertSent(AlertSent alert) async {
    try {
    // Obtener referencia a la base de datos
      final db = await DatabaseService().getDatabase();

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
  Future<List<AlertSent>> getAlertsSent() async {
    try {
    // Obtener referencia a la base de datos
      final db = await DatabaseService().getDatabase();

    // Query a todas las alertas generadas y enviadas
      final List<Map<String, Object?>> alertasEnviadasMap = await db.query(tableName);

    // Convertir la lista a objetos AlertSent
      return [
        for (final {
        'idAlertSent': idAlertSent as String,
        'dateSended': dateSended as DateTime,
        } in alertasEnviadasMap)
          AlertSent(idAlertSent: idAlertSent, dateSended: dateSended ),
      ];
    } catch (e) {
      rethrow;
    }
  }

}