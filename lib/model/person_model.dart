class PersonModel {
  String name;
  double height;
  double weight;

  PersonModel({required this.name, required this.height, required this.weight});

  double calculateIMC() {
    return weight / ((height / 100) * (height / 100));
  }

  String getIMCStatus() {
    double imc = calculateIMC();
    if (imc < 16) {
      return 'Magreza grave';
    } else if (imc >= 16 && imc < 17) {
      return 'Magreza moderada';
    } else if (imc >= 17 && imc < 18.5) {
      return 'Magreza leve';
    } else if (imc >= 18.5 && imc < 25) {
      return 'Peso normal, saudável';
    } else if (imc >= 25 && imc < 30) {
      return 'Sobrepeso';
    } else if (imc >= 30 && imc < 35) {
      return 'Obesidade grau 1';
    } else if (imc >= 35 && imc < 40) {
      return 'Obesidade grau 2 (severa)';
    } else if (imc >= 40) {
      return 'Obesidade grau 3 (morbida)';
    } else {
      return 'Sem classificação';
    }
  }

  String convertCmEmMetros() {
    return (height / 100).toStringAsFixed(2);
  }
}
