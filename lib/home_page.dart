import 'package:dio_imc/imc.dart';
import 'package:dio_imc/model/person_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersonModel person = PersonModel(name: '', height: 0, weight: 0);
  String imcStatus = '';

  final List<PersonModel> personList = [];
  late Box<PersonModel> personBox;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadHivePersonData();
  }

  Future<void> _loadHivePersonData() async {
    personBox = Hive.box<PersonModel>('personBox');

    setState(() {
      personList.clear();
      personList.addAll(personBox.values);
    });
  }

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

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
                      const SizedBox(height: 32),
                      Text(
                        imcStatus.isEmpty
                            ? 'Clique no botão para calcular o IMC'
                            : '${person.name}\nAltura: ${Imc.convertCmEmMetros(height: person.height)} - Peso: ${person.weight.toStringAsFixed(2)}\nIMC: ${Imc.calculateIMC(height: person.height, weight: person.weight).toStringAsFixed(2)}\nStatus: $imcStatus',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(personList[index].name),
                              subtitle: Text(
                                'Altura: ${Imc.convertCmEmMetros(height: personList[index].height)} m - Peso: ${personList[index].weight.toStringAsFixed(2)} kg\nIMC: ${Imc.calculateIMC(height: personList[index].height, weight: personList[index].weight).toStringAsFixed(2)}  -  Status: ${Imc.getIMCStatus(height: personList[index].height, weight: personList[index].weight)}',
                              ),
                            );
                          },
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
                              onPressed: () async {
                                if (person.name.isEmpty ||
                                    person.height <= 0 ||
                                    person.weight <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Por favor, preencha todos os campos corretamente.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final newPerson = PersonModel(
                                  name: person.name,
                                  height: person.height,
                                  weight: person.weight,
                                );

                                await personBox.add(newPerson);

                                setState(() {
                                  imcStatus = Imc.getIMCStatus(
                                    height: person.height,
                                    weight: person.weight,
                                  );
                                  personList.add(
                                    PersonModel(
                                      name: person.name,
                                      height: person.height,
                                      weight: person.weight,
                                    ),
                                  );
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
            );
          },
        ),
      ),
    );
  }
}
