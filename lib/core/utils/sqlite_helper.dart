import 'package:alerta_uaz/data/data_sources/local/contact_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/contacts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/my_alerts_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// <<<<<<< HEAD:lib/core/utils/sqlite_helper.dart
class SQLiteHelper {
// =======
// class DatabaseService {
//   // Instancia estática para el singleton
//   static final DatabaseService _instance = DatabaseService._internal();

//   // Constructor privado
//   DatabaseService._internal();

//   // Getter para obtener la instancia del singleton
//   static DatabaseService get instance => _instance;

// >>>>>>> development:lib/data/data_sources/remote/database_service.dart
  Database? _database;

  // Obtener la base de datos
  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    try {
      _database = await _initialize();
    } catch (e) {
      rethrow;
    }
    return _database!;
  }

  // Obtener la ruta completa de la base de datos
  Future<String> getFullPath() async {
    const name = 'alerta_uaz.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  // Crear las tablas iniciales
  Future<void> create(Database database, int version) async {
    await ContactosConfianza().createTable(database);
    await MyAlertsDB().createTable(database);
    await ContactAlertsDB().createTable(database);
  }

  // Inicializar la base de datos
  Future<Database> _initialize() async {
    final path = await getFullPath();
// <<<<<<< HEAD:lib/core/utils/sqlite_helper.dart
    Database database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }
// =======
//     return await openDatabase(
//       path,
//       version: 2,
//       onCreate: create,
//       singleInstance: true,
//     );
//   }

//   // Cerrar la base de datos
//   Future<void> closeDatabase() async {
//     if (_database != null) {
//       await _database!.close();
//       _database = null;
//     }
//   }

// Future<void> deleteDatabaseFile() async {
//   try {
//     // Obtener la ruta completa de la base de datos
//     final path = await getFullPath();

//     // Verificar si la base de datos existe
//     final exists = await databaseExists(path);

//     if (exists) {
//       // Cerrar la base de datos si está abierta
//       await closeDatabase();

//       // Eliminar el archivo de la base de datos
//       await deleteDatabase(path);
//       print('Base de datos eliminada exitosamente en la ruta: $path');
//     } else {
//       print('La base de datos no existe en la ruta: $path');
//     }
//   } catch (e) {
//     print('Error al eliminar la base de datos: $e');
//     rethrow; // Propagar el error si es necesario
//   }
// }

// >>>>>>> development:lib/data/data_sources/remote/database_service.dart
}
