import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/services/test_service.dart';
import 'package:medicine_time/globals.dart' as globals;

enum answer {yes , no , noChoice}


class Test1 extends StatefulWidget {
  Test1({Key? key}) : super(key: key);

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  List <answer> answers = List.filled(6, answer.noChoice);

  String text = "الاجابات الصحيحة\n" +
      "1.لا يحسن وظائف الكلى.\n" +"\n"+
      "2.لا، لكن شرب الماء بشكل مبالغ فيه ربما يؤدي إلى تجمع السوائل في الأقدام والرئتين، كما أنه من الممكن أن يؤثر في مستوى ملح الصوديوم في الدم.\n" +"\n"+
      "3.لا، في الغالب هذه الأعراض تكون نتيجة أسباب عضلية، وليست دليل على مشكلة في الكلى، لكن في حال استمرارها أو تزامنها مع أعراض أخرى (مثل: وجود دم أو ألم أثناء التبول) فينصح بزيارة الطبيب.\n" +"\n"+
      "4.نعم، للمحافظة على تروية جيدة للكلية المزروعة.\n" +"\n"+
      "5.نعم، ينصح مريض الفشل الكلوي بتجنب الأغذية التي تحتوي على بوتاسيوم عالٍ والموز أحد هذه الأغذية.\n" +"\n"+
      "6.لا توجد كمية تناسب الجميع، ولكن ينصح بشرب لترين إلى ثلاث لترات في اليوم الواحد، كما يمكن مراقبة كمية البول وتركيزه" +
      " كمؤشر على كمية السوائل في الجسم، وأيضًا ارتفاع الوزن السريع وانتفاخ الأرجل دليل على احتباس السوائل.\n";

  bool answered = false;

  List<String> questions = [
    "1.هل شرب منقوع البقدونس يفيد الكلى؟",
    "2.هل الإفراط في شرب الماء يؤثر في عمل الكلى بشكل سلبي لدى الشخص السليم؟",
    "3.هل ألم الكلى المفاجئ (النغزات) دليل على قلة شرب الماء أو التهاب الكلى؟ وهل تحتاج إلى رؤية الطبيب؟",
    "4.يكثر المتبرع بالكلى من شرب الماء؟",
    "5.يمتنع المصاب بالفشل الكلوي عن أكل الموز؟",
    "6.يحتاج الجميع نفس كمية الماء يوميا؟"
  ];

  int score = 0 ;

  List <answer> rightAnswers = [
    answer.no,
    answer.no,
    answer.no,
    answer.yes,
    answer.yes,
    answer.no,
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
    await testService.postTest1({
      "user_id" : int.parse(id!),
      "date" : formattedDate,
      "score" : nScore,
      "base" : 6
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
              const Center(child: Text("الاختبار الأول",style:
                TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),),
              Center(
                child: Container(
                  color: Colors.teal,
                  width: MediaQuery.of(context).size.width,
                  height: 25,
                  child: const Text("أجب عما يلي بنعم أو لا",
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
                            TableCell(child: Center(child: Text("لا",
                              style: TextStyle(fontWeight: FontWeight.bold),))),
                            TableCell(child: Center(child: Text("نعم",
                              style: TextStyle(fontWeight: FontWeight.bold),))),
                            TableCell(child: Center(child: Text("السؤال",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)))),
                          ]
                      ),
                      for(int i = 0 ; i < questions.length ; i++)
                        TableRow(
                          children: [
                            TableCell(child: Radio<answer>(
                              value: answer.no,
                              groupValue: answers[i],
                              onChanged: (answer? value) {
                                setState(() {
                                  answers[i] = value!;
                                });
                              },
                            ),),
                            TableCell(child: Radio<answer>(
                              value: answer.yes,
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
                        Text("نتيجة الاختبارات الصحيحة $score من 6",
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

