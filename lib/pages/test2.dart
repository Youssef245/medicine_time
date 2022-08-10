import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Test2 extends StatefulWidget {
  Test2({Key? key}) : super(key: key);

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  List <bool> answers = List.filled(12, false);

  String text = "\n"+"الإجابات الصحيحة\n" +"\n"+
      "1.ممارسة الرياضة\n" +"\n"+
      "3.حافظ على الفحص المنتظم لنسبة السكر في دمك\n" +"\n"+
      "4.اعتن بمراقبة ضغط دمك\n" +"\n"+
      "6.احرص على التغذية السليمة وراقب وزنك بانتظام\n" +"\n"+
      "8.الاكثار من شرب الماء والسوائل الصحية\n" +"\n"+
      "9.الامتناع عن التدخين\n" +"\n"+
      "11.لا تفرط في أخذ الأدوية بدون وصفة طبية بصفة منتظمة\n" +"\n"+
      "12.راقب حالة كليتك إذا كان لديك عاملا او أكثر من عوامل الخطر المرتفع التالية/الفحص الدوري للكلى: إذا كنت مصابا بداء السكري، إذا كان ضغط دمك مرتفعا، إذا كنت تعاني من زيادة الوزن، إذا كان أحد أفراد عائلتك يعاني من مرض الكلى\n" +
      "\n";

  bool answered = false;

  List<String> questions = [
        "1.ممارسة الرياضة",
        "2.تناول الأطعمة عالية الصوديوم والفوسفور",
        "3.حافظ على الفحص المنتظم لنسبة السكر في دمك",
        "4.اعتن بمراقبة ضغط دمك",
        "5.تناول الأدوية دون الرجوع إلى الطبيب أو الصيدلي",
        "6.احرص على التغذية السليمة وراقب وزنك بانتظام",
        "7.عدم الحفاظ على مواعيد أخذ الدواء",
        "8.الاكثار من شرب الماء والسوائل الصحية",
        "9.الامتناع عن التدخين",
        "10.ارتفاع الضغط والسكر لا علاقة لهم بأمراض الكلى",
        "11.لا تفرط في أخذ الأدوية بدون وصفة طبية بصفة منتظمة",
        "12.راقب حالة كليتك إذا كان لديك عاملا او أكثر من عوامل الخطر المرتفع التالية/الفحص الدوري للكلى: إذا كنت مصابا بداء السكري، إذا كان ضغط دمك مرتفعا، إذا كنت تعاني من زيادة الوزن، إذا كان أحد أفراد عائلتك يعاني من مرض الكلى",

  ];

  int score = 0 ;

  List <bool> rightAnswers = [
    true,
    false,
    true,
    true,
    false,
    true,
    false,
    true,
    true,
    false,
    true,
    true,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 9,left: 9,top: 40),
          child: Column(
            children: [
              const Center(child: Text("الاختبار الثاني",style:
              TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),),
              Center(
                child: Container(
                  color: Colors.teal,
                  width: MediaQuery.of(context).size.width,
                  height: 25,
                  child: const Text("اختر مما يلي القواعد الذهبية الثمانية للحفاظ على صحة الكلى.",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for(int i=0; i < questions.length;i++)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(child: Text(questions[i],textDirection: TextDirection.rtl,
                              style: const TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 17),)),
                            Checkbox(value: answers[i],onChanged: (value) {
                              setState(() {
                                answers[i] = value!;
                              });
                            },),
                          ],
                        ),
                        const SizedBox(height: 15,)
                      ],
                    ),
                  const SizedBox(height: 10,),
                  Center(
                    child: ElevatedButton(child : const Text("نتيجة الاختبار",style: TextStyle(color :Colors.white,fontSize: 18),)
                      ,onPressed : (){
                        int newScore = correctTest();
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
                        Text("نتيجة الاختبارات الصحيحة $score من 12",
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

