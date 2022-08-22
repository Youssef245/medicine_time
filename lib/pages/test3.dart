import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/globals.dart' as globals;
import '../services/test_service.dart';

enum answer {truth , myth , noChoice}


class Test3 extends StatefulWidget {
  Test3({Key? key}) : super(key: key);

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  List <answer> answers = List.filled(15, answer.noChoice);

  String text = "جميع ما سبق حقيقة فيما عدا الاتى خرافة"+"\n"+"1.أمراض الكلى نادرة\n" +
      "2.لا يمكن الوقاية من أمراض الكلى\n" +
      "3.يمكنك معرفة اصابتك بأمراض الكلى مبكرا بدون تحاليل\n" +
      "4.الغسيل الكلوي هو علاج شافي للفشل الكلوي\n" +
      "5.حصوات الكلى تسبب أمراض الكلى المزمنة\n";

  bool answered = false;

  List<String> questions = [
        "1.أمراض الكلى نادرة",
        "2.لا يمكن الوقاية من أمراض الكلى",
        "3.يمكنك معرفة اصابتك بأمراض الكلى مبكرا بدون تحاليل",
        "4.الغسيل الكلوي هو علاج شافي للفشل الكلوي",
        "5.حصوات الكلى تسبب أمراض الكلى المزمنة",
        "6.تعد أمراض الكلى السبب في الوفاة رقم 12 عالميا",
        "7.معظم أمراض الكلى من الممكن الوقاية منها",
        "8.يتسبب ارتفاع مستوى السكر في الدم وارتفاع ضغط الدم في ثلاثة أرباع حالات أمراض الكلى مما يعني أمكانية منعها والوقاية منها",
        "9.لا تظهر أعراض لأمراض الكلى إلا في المراحل المتأخرة من المرض",
        "10. 96% من المصابين بأمراض الكلى في المراحل المبكرة لا يعلمون بإصابتهم",
        "11.يؤثر مرض الكلى المزمن على الكلى ببطء، ولكن من الممكن اكتشافه من خلال تحاليل للدم والبول بسيطة",
        "12.يقوم الغسيل الكلوي ببعض وظائف الكلى السليمة، ولكن ليس جميعها",
        "13.من النادر أن تتسبب حصوات الكلى في ضرر دائم للكلى",
        "14.فقط 1 من كل 10 أشخاص يصابون بحصوات الكلى ويتم علاجها سريعا بسبب ما تسببه من ألم شديد",
        "15.من الممكن الوقاية من حصوات الكلى من خلال الحفاظ على شرب الماء بكميات مناسبة ",

  ];

  int score = 0 ;

  List <answer> rightAnswers = [
    answer.myth,
    answer.myth,
    answer.myth,
    answer.myth,
    answer.myth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
    answer.truth,
  ];

  correctTest()
  {
    int newScore = 0;
    for(int i = 0 ; i<questions.length;i++)
    {
      if(answers[i]==rightAnswers[i]) {
        newScore++;
      }
    }
    return newScore;
  }

  sendAnswer(int nScore) async
  {
    String? id = await globals.user.read(key: "id");
    String formattedDate = globals.getDateNow();

    TestService testService = TestService();
    await testService.postTest3({
      "user_id" : int.parse(id!),
      "date" : formattedDate,
      "score" : nScore,
      "base" : 15
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 15,left: 15,top: 40),
          child: Column(
            children: [
              const Center(child: Text("الاختبار الثالث",style:
              TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),),
              Center(
                child: Container(
                  color: Colors.teal,
                  width: MediaQuery.of(context).size.width,
                  height: 25,
                  child: const Text("أختر مما يلي ما الذي تراه حقيقة وما الذي تراه خرافة.",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Table(
                    border: TableBorder.all(width: 2),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(70),
                      1: FixedColumnWidth(70),
                    },
                    children: [
                      const TableRow(
                          children:[
                            TableCell(child: Center(child: Text("خرافة",
                              style: TextStyle(fontWeight: FontWeight.bold),))),
                            TableCell(child: Center(child: Text("حقيقة",
                              style: TextStyle(fontWeight: FontWeight.bold),))),
                            TableCell(child: Center(child: Text("السؤال",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)))),
                          ]
                      ),
                      for(int i = 0 ; i < questions.length ; i++)
                        TableRow(
                            children: [
                              TableCell(child: Radio<answer>(
                                value: answer.myth,
                                groupValue: answers[i],
                                onChanged: (answer? value) {
                                  setState(() {
                                    answers[i] = value!;
                                  });
                                },
                              ),),
                              TableCell(child: Radio<answer>(
                                value: answer.truth,
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
                                  child: Center(child : Text(questions[i],
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),)),
                                ),
                              )
                            ]
                        )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  if(!answered)
                    Center(
                      child: ElevatedButton(child : const Text("نتيجة الاختبار",style: TextStyle(color :Colors.white,fontSize: 18),)
                        ,onPressed : (){
                          int newScore = correctTest();
                          sendAnswer(newScore);
                          setState(() {
                            score = newScore;
                            answered = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.teal),),
                    ),
                  if(answered)
                    Column(
                      children: [
                        Text("نتيجة الاختبارات الصحيحة $score من 15",
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(color :Colors.red,fontSize: 18),),
                        const SizedBox(height: 10,),
                        Text(text,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15
                          ),
                        )
                      ],
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

