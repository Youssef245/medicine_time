class User {
  String? _name;
  int? _id;

  User(this._name, this._id);

  int get id => _id!;

  set id(int value) {
    _id = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'],
      json['id'],
    );
  }
}