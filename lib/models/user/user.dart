class User {
  int? id;
  String userName;
  String password;
  String? firstName;
  String? lastName;
  String? phoneNumber;

  static var instance;

  User(
      {this.id,
      required this.userName,
      required this.password,
      this.firstName,
      this.lastName,
      this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userName: json["username"],
        password: json["password"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "username": userName,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
      };
}
