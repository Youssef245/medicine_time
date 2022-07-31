import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Question {
  int? user_id;
  String? question;
  String? towho;
  String? date;
  String? answer;

  Question(this.user_id, this.question, this.towho, this.date,this.answer);

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      json['user_id'],
      json['question'],
      json['towho'],
      json['date'],
      json['answers'],
    );
  }

  String getFormattedDate() {
    initializeDateFormatting();
    DateTime dateTime = DateFormat('MMMM d, y', 'en_US').parse("$date");
    var formatter = DateFormat.yMMMMd('ar_EG');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  toJson(){
    return {
      "user_id" : user_id,
      "question" : question,
      "towho" : towho,
      "date" : date,
    };
  }
}