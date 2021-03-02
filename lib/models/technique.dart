class Technique{
  int techniqueID;
  String title;
  String description;
  Technique({this.techniqueID, this.title, this.description});
  factory Technique.fromJson(Map<String, dynamic> json){
    return Technique(
      techniqueID: json['id'],
      title: json['title'],
      description: json['description']
    );
  }
}