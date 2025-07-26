class PersonModel {
  final int? id;
  String name;
  double height;
  double weight;

  PersonModel({
    this.id,
    required this.name,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'height': height,
    'weight': weight,
  };

  static PersonModel fromJson(Map<String, dynamic> json) => PersonModel(
    id: json['id'] != null ? json['id'] as int : null,
    name: json['name']?.toString() ?? '',
    height: (json['height'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
  );

  PersonModel copyWith({
    int? id,
    String? name,
    double? height,
    double? weight,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          height == other.height &&
          weight == other.weight;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ height.hashCode ^ weight.hashCode;
}
