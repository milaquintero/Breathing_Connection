class EmailFormModel{
  String name;
  String email;
  String birthDate;
  EmailFormModel({this.name, this.email, this.birthDate});
  @override
  String toString() {
    return 'Name: ${this.name}, Email: ${this.email}, Birth Date: ${this.birthDate}';
  }
}