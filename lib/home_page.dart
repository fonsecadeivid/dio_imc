import 'package:dio_imc/model/person_model.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersonModel person = PersonModel(name: '', height: 0, weight: 0);
  String imcStatus = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void clearData() {
    setState(() {
      nameController.text = '';
      heightController.text = '';
      weightController.text = '';
      nameFocusNode.requestFocus();
      person = PersonModel(name: '', height: 0, weight: 0);
      imcStatus = '';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    formKey.currentState?.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Informe os dados solicitados',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Divider(height: 4, color: Colors.grey),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: nameController,
                    focusNode: nameFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => setState(() {
                      person.name = value;
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: heightController,
                    decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {
                      person.height = double.tryParse(value) ?? 0;
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {
                      person.weight = double.tryParse(value) ?? 0;
                    }),
                  ),
                  const SizedBox(height: 64),
                  Expanded(
                    child: Text(
                      imcStatus.isEmpty
                          ? 'Clique no botão para calcular o IMC'
                          : '${person.name}\nAltura: ${person.convertCmEmMetros()} - Peso: ${person.weight.toStringAsFixed(2)}\nIMC: ${person.calculateIMC().toStringAsFixed(2)}\nStatus: $imcStatus',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 32,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              clearData();
                            });
                          },
                          child: const Text('Limpar Dados'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              imcStatus = person.getIMCStatus();
                            });
                          },
                          child: const Text('Calcular IMC'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
