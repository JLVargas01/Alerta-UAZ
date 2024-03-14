import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:alerta_uaz/models/receptor.dart';

void conexion() async {

  WidgetsFlutterBinding.ensureInitialized();

  final TheDatabase = openDatabase(
    join(
      await getDatabasesPath(), 'alerta_uaz.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE ContactosConfianza(id INTEGER PRIMARY KEY, telephone TEXT, name TEXT)',
        );
      },
      version: 1,
    );

  // Insertar contacto en la base de datos
  Future<void> insertContacto(ContactoConfianza contacto) async {
    // Obtener referencia a la base de datos
    final db = await TheDatabase;

    await db.insert(
      'ContactosConfianza',
      contacto.toMap(),

      // Remplazar registro si se repite
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los contactos en la base de datos
  Future<List<ContactoConfianza>> contactos() async {
    // Obtener referencia a la base de datos
    final db = await TheDatabase;

    // Query a todos los contactos de confianza.
    final List<Map<String, Object?>> contactoMaps = await db.query('ContactosConfianza');

    // Convertir la lista a objetos ContactoConfianza
    return [
      for (final {
            'id': id as int,
            'name': telephone as String,
            'age': name as String,
          } in contactoMaps)
        ContactoConfianza(id: id, name: name, telephone: telephone),
    ];
  }

}
