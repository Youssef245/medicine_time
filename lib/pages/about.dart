import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';


class About extends StatelessWidget {
  About({Key? key}) : super(key: key);

  String text = "هو تطبيق هاتفي يهدف إلى مساعدة مرضي الكلى من خلال \n" +
      "• تسجيل أدويتهم وتذكيرهم بمواعيدها، \n" +
      "• تسجيل الأعراض والآثار الجانبية التي قد تظهر أثناء اليوم، \n" +
      "• إمكانية ارسال أسئلة إلى الطبيب والصيدلي ،\n" +
      "• توفير مواد تعليمية خاصة بأمراض الكلى والعناية بالكلى.\n" +
      "\n" +
      "المصادر\n" +
      "• منظمة تحسين النتائج العالمية لأمراض الكلى (KDIGO)" +"\n"+
      "•منظمة اليوم العالمي للكلى (world kidney day)\n" +
      "• المؤسسة الوطنية للكلى (National kidney foundation)\n" +
      "•المعهد الوطني للسكري وأمراض الجهاز الهضمي والكلى (NIDDK)\n" +
      "•الجمعية المصرية لأمراض وزراعة الكلى (ESNT)\n" +
      "Flaticon •" +"\n"+
      "Freepik •"+"\n"+"\n"+
      "اتفاق الاستخدام والخصوصية\n" +
      "•هذا التطبيق لمساعدة مرضى الكلى وليس بديل لزيارة الطبيب.\n" +
      "• سيتم في البداية تقييم الالتزام بالدواء، وظائف الكلى، مستوى الصوديوم والبوتاسيوم والفوسفات في الدم، مستوى الهيموجلوبين والهيموجلوبين السكري، وضغط الدم.\n" +
      "•ثم سوف يتم متابعة جميع المرضى شهريا لمدة ثلاثة أشهر من خلال:\n" +
      " - استكمال استبيان الالتزام بالدواء عند زيارة العيادة.\n" +
      " - متابعة قياس ضغط الدم وتسجيل قيم تحاليل وظائف الكلى، الصوديوم، البوتاسيوم، الفوسفات، الهيموجلوبين والهيموجلوبين السكري (عند الثلاثة أشهر فقط).\n" +
      " - استكمال استبيان سهولة استخدام والرضا عن التطبيق الهاتفي\n" +
      "•سيتم الحفاظ علي سرية المعلومات وحمايتها مع الحفاظ أيضا على خصوصية المرضى.\n" +
      "\n";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Image.asset("images/about2.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10,),
                Text(text,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

