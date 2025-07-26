import 'package:dio_imc/core/database/person_database.dart';
import 'package:dio_imc/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Deletar o banco antigo para forçar recriação
  //await PersonDatabase.instance.deleteDatabaseFile();

  // Inicializar o banco de dados
  await PersonDatabase.instance.initializeDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculadora de IMC'),
    );
  }
}
