import 'package:alerta_uaz/services/contacts_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  Database? _database;

  //getter para obtener el objeto Database
  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  //getter para obtener la ruta de la database
  Future<String> getFullPath() async {
    const name ='alerta_uaz.db';
    final path = await getDatabasesPath();
    return join(path,name);
  }

  //Crear las tablas de la base de datos
  Future<void> create(Database database, int version) async {
    await ContactosConfianza().createTable(database);
  }

  //Iniciar la base de datos
  Future<Database> _initialize() async {
    final path = await getFullPath();
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true
    );
    return database;
  }

}