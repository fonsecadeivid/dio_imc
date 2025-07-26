class PersonModel {
  String name;
  double height;
  double weight;

  PersonModel({required this.name, required this.height, required this.weight});

  Map<String, dynamic> toJson() => {
    'name': name,
    'height': height,
    'weight': weight,
  };

  static PersonModel fromJson(Map<String, dynamic> json) => PersonModel(
    name: json['name'],
    height: json['height'].toDouble(),
    weight: json['weight'].toDouble(),
  );
}
