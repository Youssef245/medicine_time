class Question {
  int? user_id;
  String? question;
  String? towho;
  String? date;

  Question(this.user_id, this.question, this.towho, this.date);

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      json['user_id'],
      json['question'],
      json['towho'],
      json['date'],
    );
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