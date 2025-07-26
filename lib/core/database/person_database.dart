// ignore_for_file: avoid_print

import 'package:dio_imc/model/person_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PersonDatabase {
  static final PersonDatabase instance = PersonDatabase._init();
  static Database? _database;
  static const _dbName = 'person.db';

  PersonDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<void> initializeDatabase() async {
    debugPrint('Inicializando banco de dados...');
    await database;
    debugPrint('Banco de dados inicializado com sucesso!');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint('Criando banco de dados em: $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    debugPrint('Criando tabela person...');
    await db.execute('''
      CREATE TABLE person(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        height REAL NOT NULL,
        weight REAL NOT NULL
      )
    ''');
    debugPrint('Tabela person criada com sucesso!');
  }

  Future<int> create(PersonModel person) async {
    try {
      final db = await instance.database;
      debugPrint('Tentando salvar pessoa: ${person.toJson()}');
      final result = await db.insert('person', person.toJson());
      debugPrint('Pessoa salva com sucesso! ID: $result');
      return result;
    } catch (e) {
      debugPrint('Erro ao salvar pessoa: $e');
      rethrow;
    }
  }

  Future<List<PersonModel>> readAll() async {
    try {
      final db = await instance.database;
      debugPrint('Tentando carregar todas as pessoas...');
      final result = await db.query('person');
      debugPrint('Dados carregados do banco: $result');
      final persons = result.map((json) => PersonModel.fromJson(json)).toList();
      debugPrint('Pessoas convertidas: ${persons.length}');
      return persons;
    } catch (e) {
      debugPrint('Erro ao ler dados do banco: $e');
      return [];
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
  }
}
