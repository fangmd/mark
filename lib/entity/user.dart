class User {
  String name;
  int age;

  User(this.name, this.age);

  factory User.fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var age = json['age'];
    return User(name, age);
  }
}
