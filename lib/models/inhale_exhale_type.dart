class InhaleExhaleType{
  int inhaleExhaleTypeID;
  String description;
  InhaleExhaleType({this.inhaleExhaleTypeID, this.description});
  factory InhaleExhaleType.fromJson(Map<String, dynamic> json){
    return InhaleExhaleType(
      inhaleExhaleTypeID: json['inhaleExhaleTypeID'],
      description: json['description']
    );
  }
}