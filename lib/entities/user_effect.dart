class UserEffect {
  int? user_id;
  String? kidney_effects;
  String? effects;
  DateTime? date_inserted;

  UserEffect(this.user_id, this.kidney_effects,this.effects,this.date_inserted);

  UserEffect.name(this.user_id, this.kidney_effects,this.effects);


  toJson(){
    return {
      "user_id" : user_id,
      "kidney_effects" : kidney_effects,
      "effects" : effects,
    };
  }

  factory UserEffect.fromJson(Map<String, dynamic> json) {
    return UserEffect(
        json['user_id'],
        json['kidney_effects'],
        json['effects'],
        json['date_inserted'],
    );
  }
}