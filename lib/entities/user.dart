class User {
  String? _name;
  int? _id;
  String? password;
  String? mobile;
  String? email;
  int? height;
  String? gendar;
  String? education_level;
  String? birth_date;
  bool? pressure;
  bool? glucose;
  bool? chl;
  bool? heart;
  bool? liver;
  bool? hemoglobin;
  bool? cancer;
  bool? manaya;
  String? glucose_stage;
  String? heart_type;
  String? cancer_type;
  String? manaya_type;
  String? kidney_period;
  String? kidney_stage;
  String? kidney_transplant;
  String? transplant;
  String? liver_type;


  User(
      this._name,
      this.password,
      this.mobile,
      this.email,
      this.height,
      this.gendar,
      this.education_level,
      this.birth_date,
      this.pressure,
      this.glucose,
      this.chl,
      this.heart,
      this.liver,
      this.hemoglobin,
      this.cancer,
      this.manaya,
      this.glucose_stage,
      this.heart_type,
      this.cancer_type,
      this.manaya_type,
      this.kidney_period,
      this.kidney_stage,
      this.kidney_transplant,
      this.transplant,
      this.liver_type);


  User.name(this._name, this._id);

  int get id => _id!;

  set id(int value) {
    _id = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  factory User.fromJson2(Map<String, dynamic> json) {
    return User.name(
      json['name'],
      json['id'],
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'],
      json['password'],
      json['mobile'],
      json['email'],
      json['height'],
      json['gendar'],
      json['education_level'],
      json['birth_date'],
      json['pressure'],
      json['glucose'],
      json['chl'],
      json['heart'],
      json['liver'],
      json['hemoglobin'],
      json['cancer'],
      json['manaya'],
      json['glucose_stage'],
      json['heart_type'],
      json['cancer_type'],
      json['manaya_type'],
      json['kidney_period'],
      json['kidney_stage'],
      json['kidney_transplant'],
      json['transplant'],
      json['liver_type'],
    );
  }

  toJson(){
    return {
      "name" : _name,
      "password" : password,
      "mobile" : mobile,
      "email" : email,
      "height" : height,
      "gendar" : gendar,
      "education_level" : education_level,
      "birth_date" : birth_date,
      "pressure" : pressure!? 1: 0,
      "glucose" : glucose!? 1: 0,
      "chl" : chl!? 1: 0,
      "heart" : heart!? 1: 0,
      "liver" : liver!? 1: 0,
      "hemoglobin" : hemoglobin!? 1: 0,
      "cancer" : cancer!? 1: 0,
      "manaya" : manaya!? 1: 0,
      "glucose_stage" : glucose_stage ,
      "heart_type" : heart_type,
      "cancer_type" : cancer_type,
      "manaya_type" : manaya_type,
      "liver_type" : liver_type,
      "kidney_period" : kidney_period,
      "kidney_stage" : kidney_stage,
      "kidney_transplant" : kidney_transplant,
      "transplant" : transplant,
    };

  }
}