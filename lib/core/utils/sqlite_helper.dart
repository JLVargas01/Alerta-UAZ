/*
  Clase auxiliar para manejar la base de datos SQLite en la aplicación.

  La clase 'SQLiteHelper' proporciona métodos para inicializar, obtener y cerrar 
  la base de datos SQLite, así como para eliminar su archivo si es necesario.

  Funcionalidades principales:
  - Obtiene una instancia única de la base de datos SQLite.
  - Proporciona la ruta completa del archivo de la base de datos.
  - Crea las tablas necesarias para la aplicación.
  - Cierra la base de datos cuando ya no se necesita.
  - Elimina el archivo de la base de datos si es necesario.
*/

import 'package:alerta_uaz/data/data_sources/local/contact_alerts_db.dart';
import 'package:alerta_uaz/data/data_sources/local/contact_db.dart';
import 'package:alerta_uaz/data/data_sources/local/my_alerts_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  Database? _database;

  /// Obtiene la instancia única de la base de datos.
  /// Si la base de datos ya está inicializada, la retorna directamente.
  /// En caso contrario, la inicializa antes de retornarla.
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

  /// Obtiene la ruta completa del archivo de la base de datos.
  /// Retorna la ruta donde se almacena el archivo SQLite.
  Future<String> getFullPath() async {
    const name = 'alerta_uaz.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  /// Crea las tablas necesarias en la base de datos.
  /// Se llama automáticamente cuando la base de datos es creada por primera vez.
  Future<void> create(Database database, int version) async {
    await ContactDB().createTable(database);
    await MyAlertsDB().createTable(database);
    await ContactAlertsDB().createTable(database);
  }

  /// Inicializa la base de datos y la abre.
  /// Configura la versión de la base de datos y define el método 'onCreate'
  /// para crear las tablas necesarias.
  Future<Database> _initialize() async {
    final path = await getFullPath();

    return await openDatabase(
      path,
      version: 2,
      onCreate: create,
      singleInstance: true,
    );
  }

  /// Cierra la conexión con la base de datos.
  /// Se recomienda llamarlo cuando la base de datos ya no sea necesaria
  /// para liberar recursos.
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Elimina el archivo de la base de datos.
  /// - Verifica si el archivo existe antes de intentar eliminarlo.
  /// - Cierra la base de datos antes de eliminar el archivo para evitar errores.
  Future<void> deleteDatabaseFile() async {
    try {
      // Obtener la ruta completa de la base de datos
      final path = await getFullPath();

      // Verificar si la base de datos existe
      final exists = await databaseExists(path);

      if (exists) {
        // Cerrar la base de datos si está abierta
        await closeDatabase();

        // Eliminar el archivo de la base de datos
        await deleteDatabase(path);
      } else {
      }
    } catch (e) {
      rethrow; // Propagar el error si es necesario
    }
  }
}
