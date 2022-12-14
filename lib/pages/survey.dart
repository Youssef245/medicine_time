import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/globals.dart' as globals;
import 'package:medicine_time/services/survey_service.dart';
import 'home_page.dart';

enum answer {agree , strongAgree , neutral, refuse, strongRefuse, noChoice}

class Survey extends StatefulWidget {
  Survey({Key? key}) : super(key: key);

  @override
  State<Survey> createState() => _MySurveyState();
}

class _MySurveyState extends State<Survey> {
  List <answer> answers = List.filled(10, answer.noChoice);

  String text = "هذا الاستبيان مكون من عشرة اسئلة يقيس قابلية و سهولة استخدام التطبيق بشكل عام. الرجاء اختيار الإجابة التي تعبر عن ردّك الفوري على"
      " كل عبارة بعد استخدام هذا التطبيق. لا تفكر طويلا في اجابتك و تأكد من الإجابة على جميع العبارات.";

  List<String> questions = [
    "أعتقد أنني قد أرغب في استخدام هذا التطبيق بشكل متكرر.",
    "وجدت أن هذا التطبيق معقدا بشكل غير ضروري.",
    "رأيت أن هذا التطبيق سهل الاستخدام.",
    "أعتقد أنني أحتاج مساعدة شخص تقني حتى أتمكن من استخدام هذا التطبيق.",
    "وجدت الوظائف المتعددة في هذا التطبيق مدمجة بشكل جيد.",
    "أعتقد أن هناك الكثير من عدم الانسجام في هذا التطبيق.",
    "أتصور أن معظم الناس سوف يتعلمون استخدام هذا التطبيق بسرعة كبيرة.",
    "وجدت هذا التطبيق غريب الاستخدام.",
    "شعرت بثقة تامة عند استخدام هذا التطبيق.",
    "كنت بحاجة إلى تعلم الكثير من الأمور قبل أن أتمكن من استخدام هذا التطبيق.",
  ];

  @override
  void initState() {
    // TODO: implement initState
    Homepage().sendOffline();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 40,left: 5,right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Image.asset("images/newbie.png",
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                ),
              ),
            ),
            Table(
              border: TableBorder.all(width: 2),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(40),
                1: FixedColumnWidth(40),
                2: FixedColumnWidth(40),
                3: FixedColumnWidth(40),
                4: FixedColumnWidth(40),
              },
              children: const [
                TableRow(
                    children:[
                      TableCell(child: Center(child: Text("أوافق\nبشدة",
                        style: TextStyle(fontWeight: FontWeight.bold),))),
                      TableCell(child: Center(child: Text("أوافق",
                        style: TextStyle(fontWeight: FontWeight.bold),))),
                      TableCell(child: Center(child: Text("محايد",
                        style: TextStyle(fontWeight: FontWeight.bold),))),
                      TableCell(child: Center(child: Text("أعارض",
                        style: TextStyle(fontWeight: FontWeight.bold),))),
                      TableCell(child: Center(child: Text("أعارض\nبشدة",
                        style: TextStyle(fontWeight: FontWeight.bold),))),
                      TableCell(child: Center(child: Text("السؤال",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)))),
                    ]
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(width: 2),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(40),
                        1: FixedColumnWidth(40),
                        2: FixedColumnWidth(40),
                        3: FixedColumnWidth(40),
                        4: FixedColumnWidth(40),
                      },
                      children:  [
                        for(int i = 0;i<10;i++)
                          TableRow(
                            children: [
                              TableCell(child: Radio<answer>(
                                value: answer.strongAgree,
                                groupValue: answers[i],
                                onChanged: (answer? value) {
                                  setState(() {
                                    answers[i] = value!;
                                  });
                                },
                              ),),
                              TableCell(child: Radio<answer>(
                                value: answer.agree,
                                groupValue: answers[i],
                                onChanged: (answer? value) {
                                  setState(() {
                                    answers[i] = value!;
                                  });
                                },
                              ),),
                              TableCell(child: Radio<answer>(
                                value: answer.neutral,
                                groupValue: answers[i],
                                onChanged: (answer? value) {
                                  setState(() {
                                    answers[i] = value!;
                                  });
                                },
                              ),),
                              TableCell(child: Radio<answer>(
                                value: answer.refuse,
                                groupValue: answers[i],
                                onChanged: (answer? value) {
                                  setState(() {
                                    answers[i] = value!;
                                  });
                                },
                              ),),
                              TableCell(child: Radio<answer>(
                                value: answer.strongRefuse,
                                groupValue: answers[i],
                                onChanged: (answer? value) {
                                  setState(() {
                                    answers[i] = value!;
                                  });
                                },
                              ),),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child : Text(questions[i]
                                  ,style: const TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),
                                  textDirection: TextDirection.rtl,)),
                                ),
                              )
                            ]
                          )
                      ],
                    ),
                    const SizedBox(height: 15,),
                    ElevatedButton(onPressed: () async{
                      sendSurvey();
                    },child: Text("تسجيل",style: const TextStyle(color: Colors.teal),),
                      style: ElevatedButton.styleFrom(primary: Colors.white70),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// Navigator.of(context).pop();
  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
  //   Homepage()));
  getAnswer (answer a) {
    if(a==answer.strongAgree) {
      return "أوافق بشدة";
    } else if(a==answer.agree) {
      return "أوافق";
    } else if(a==answer.neutral) {
      return "محايد";
    } else if(a==answer.refuse) {
      return "أعارض";
    } else if(a==answer.strongRefuse) {
      return "أعارض بشدة";
    } else {
      return "";
    }
  }

  sendSurvey() async {
    String? id = await globals.user.read(key: "id");
    String formattedDate = globals.getDateNow();

    bool nochoice = false;
    answers.forEach((e) {if(e==answer.noChoice) nochoice=true; });

    if(nochoice)
    {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              text: "يجب إجابة جميع الأسئلة لإتمام الاستبيان."
          )
      );
    }
    else
    {
      SurveyService service = SurveyService();
      await service.postSurvey({
        "q1" : getAnswer(answers[0]),
        "q2" : getAnswer(answers[1]),
        "q3" : getAnswer(answers[2]),
        "q4" : getAnswer(answers[3]),
        "q5" : getAnswer(answers[4]),
        "q6" : getAnswer(answers[5]),
        "q7" : getAnswer(answers[6]),
        "q8" : getAnswer(answers[7]),
        "q9" : getAnswer(answers[8]),
        "q10" : getAnswer(answers[9]),
        "user_id" : int.parse(id!),
        "date" : formattedDate,
      });
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          Homepage()));
    }
  }
}

