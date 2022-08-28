import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/entities/question.dart';
import 'package:medicine_time/pages/prev_questions.dart';
import 'package:medicine_time/services/questions_service.dart';
import 'package:medicine_time/globals.dart' as globals;


import 'home_page.dart';


class AskDoctor extends StatefulWidget {
  AskDoctor({Key? key}) : super(key: key);

  @override
  State<AskDoctor> createState() => _MyAskDoctorState();
}

class _MyAskDoctorState extends State<AskDoctor> {

  TextEditingController questionController = TextEditingController();
  List<String> options = ["","الطبيب","الصيدلي"];
  String chosenvalue = "";

  sendQuestion () async{
    if(questionController.text!=""&&chosenvalue!="")
    {
      var now = DateTime.now();
      var formatter = DateFormat.yMMMMd('en_US');
      String formattedDate = formatter.format(now);
      String? id = await globals.user.read(key: "id");
      QuestionsService questionsService = QuestionsService();
      Question question = Question(int.parse(id!), questionController.text, chosenvalue, formattedDate, "");
      await questionsService.postQuestion(question.toJson());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Homepage().sendOffline();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80,right: 15,left: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Image.asset("images/ask1.png",
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 5,),
              Container(width: MediaQuery.of(context).size.width,
                  child: TextFormField(decoration: const InputDecoration(
                    hintText: "أدخل السؤال",),controller: questionController,)),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                      items: options
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: chosenvalue,
                      onChanged: (String? newValue) {
                        setState(() {
                          chosenvalue = newValue!;
                        });
                      }),
                  const Flexible(child: Text(" : اختر المختص",style:  TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
                ],
              ),
              const SizedBox(height: 10,),
              Center(
                child: ElevatedButton(onPressed: () async {
                  sendQuestion();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      Homepage()));
                }, child: const Text("إرسال",style: TextStyle(color: Colors.teal,fontSize: 20),),
                  style: ElevatedButton.styleFrom(primary: Colors.white70,fixedSize: Size(90, 50)),),
              ),
              const SizedBox(height: 15,),
              Align(
                alignment: FractionalOffset.bottomLeft,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      PrevQuestions()));
                }, child: const Text("الأسئلة السابقة",style:  TextStyle(color: Colors.teal),),
                  style: ElevatedButton.styleFrom(primary: Colors.white70),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

