import 'package:alerta_uaz/data/data_sources/remote/database_service.dart';
import 'package:alerta_uaz/domain/model/alerts_received_model.dart';
import 'package:sqflite/sqflite.dart';

class AlertsReceived {

  final tableName = 'alertas_recibidas';

  //Crear la tabla para las alertas recibidas de otros usuarios
  Future<void> createTable(Database database) async {
    await database.execute(
      """CREATE TABLE IF NOT EXISTS $tableName (
        "idAlertReceived" TEXT NOT NULL,
        "idAlerta" TEXT NOT NULL,
        "aliasContact" TEXT NOT NULL,
        "nameUser" TEXT NOT NULL,
        "dateReceived" DATE NOT NULL,
        PRIMARY KEY("idAlertReceived")
      );"""
    );
  }

  //Insertar nuevo registro de alerta recibidas
  Future<void> insertRecordAlertReceived(AlertReceived alert) async {
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

  // Obtener todas las alertas recibidas
  Future<List<AlertReceived>> getAlertsReceived() async {
    try {
    // Obtener referencia a la base de datos
      final db = await DatabaseService().getDatabase();

    // Query a todas las alertas generadas y enviadas
      final List<Map<String, Object?>> alertasEnviadasMap = await db.query(tableName);

    // Convertir la lista a objetos AlertReceived
      return [
        for (final {
        'idAlertReceived': idAlertReceived as String,
        'idAlerta': idAlerta as String,
        'aliasContact': aliasContact as String,
        'nameUser': nameUser as String,
        'dateReceived': dateReceived as DateTime,
        } in alertasEnviadasMap)
          AlertReceived(idAlertReceived: idAlertReceived, aliasContact: aliasContact, nameUser: nameUser, dateReceived: dateReceived, idAlerta: idAlerta),
      ];
    } catch (e) {
      rethrow;
    }
  }

}