import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/services/questions_service.dart';
import '../entities/question.dart';
import 'package:medicine_time/globals.dart' as globals;


class PrevQuestions extends StatelessWidget {
  const PrevQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'PrevQuestions', home: MyPrevQuestions());
  }
}

class MyPrevQuestions extends StatefulWidget {
   MyPrevQuestions();

  @override
  State<MyPrevQuestions> createState() => _MyPrevQuestionsState();
}

class _MyPrevQuestionsState extends State<MyPrevQuestions> {
  bool isLoaded = false;
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    String? id = await globals.user.read(key: "id");
    QuestionsService service = QuestionsService();
    questions = await service.getQuestions(int.parse(id!));
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(child:  Text("الأسئلة السابقة",style: TextStyle(color: Colors.white),)),
        ),
        body: isLoaded ? Padding(
          padding: const EdgeInsets.only(top: 15 , left: 15,right: 15),
          child: SingleChildScrollView(
              child:Column(
                children: [
                  ...questions.map((question) {
                    print(question.date);
                    return Column(
                      children: [
                        Text(question.date!,style: const TextStyle(color :Colors.teal,fontSize: 23)),
                        const SizedBox(height: 7,),
                        Text("${question.question}  : السؤال ",style: const TextStyle(color :Colors.black,fontSize: 18),),
                        if(question.answer!=null)
                        Column(
                          children: [
                            Text(" الإجابة : ${question.answer}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                            const SizedBox(height: 5,),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        const Divider(color: Colors.teal,thickness: 3,),
                      ],
                    );
                  }).toList()
                ],
              )
          ),
        ): const Center(child: CircularProgressIndicator(),)
    );
  }
}
