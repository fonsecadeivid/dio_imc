import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 0)
class PersonModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double height;

  @HiveField(2)
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
