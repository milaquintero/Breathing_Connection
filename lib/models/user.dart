class User{
  int userId;
  String username;
  User({this.userId, this.username});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      username: json['username'],
    );
  }
  @override
  String toString() {
    return 'UserID: $userId, Username: $username';
  }
}