import 'dart:collection';

class InhaleExhaleType{
  int inhaleExhaleTypeID;
  String description;
  InhaleExhaleType({this.inhaleExhaleTypeID, this.description});
  factory InhaleExhaleType.fromSnapshot(LinkedHashMap json){
    return InhaleExhaleType(
      inhaleExhaleTypeID: json['id'],
      description: json['description']
    );
  }
  @override
  String toString() {
    return 'ID: ${this.inhaleExhaleTypeID}, Description: ${this.description}';
  }
}