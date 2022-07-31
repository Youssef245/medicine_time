class SideEffect{
  String? _name;
  String? _category;

  SideEffect();

  SideEffect.name(this._name, this._category);

  String get category => _category!;

  set category(String value) {
    _category = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  factory SideEffect.fromJson(Map<String, dynamic> json) {
    return SideEffect.name(
        json['effect'],
        json['cat_name']
    );
  }

}