class Medicine{
  String? _name;
  String? _category;

  Medicine();

  Medicine.name(this._name, this._category);

  String get category => _category!;

  set category(String value) {
    _category = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine.name(
      json['medicine_name'],
      json['cat_name']
    );
  }
  
}