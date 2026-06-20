class SkillModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String type;



  SkillModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.type
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'].toString(),
      name: json['name'], 
      description: json['description'],
      image: json['image'] as String,  
      type: json['type']
      );
  }
}
