class UserFormModel{
  String email;
  String password;
  String username;
  UserFormModel({this.email, this.password, this.username});
  @override
  String toString() {
    return "Email: $email, Password: $password, Username: $username";
  }
}