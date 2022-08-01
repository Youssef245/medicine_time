import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class UserEffect {
  int? user_id;
  String? kidney_effects;
  String? effects;
  String? date;

  UserEffect(this.user_id, this.kidney_effects,this.effects,this.date);

  UserEffect.name(this.user_id, this.kidney_effects,this.effects);


  toJson(){
    return {
      "user_id" : user_id,
      "kidney_effects" : kidney_effects,
      "effects" : effects,
    };
  }

  String getFormattedDate() {
    initializeDateFormatting();
    String part = date!.split("T")[0];
    DateTime dateTime = DateFormat('yyyy-MM-dd', 'en_US').parse("$part");
    var formatter = DateFormat.yMMMMd('ar_EG');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  factory UserEffect.fromJson(Map<String, dynamic> json) {
    return UserEffect(
        json['user_id'],
        json['kidney_effects'],
        json['effects'],
        json['date'],
    );
  }
}