class User {
  int? userId;
  int? id;
  String? userName;
  String? password;
  String? name;

  User({
    this.userId,
    this.id,
    this.userName,
    this.password,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    id: json["id"],
    userName: json["userName"],
    password: json["password"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "userName": userName,
    "password": password,
    "name": name,
  };

}
