import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine_time/globals.dart' as globals;
import 'package:medicine_time/pages/LoginPage.dart';

import 'home_page.dart';


class Agreement extends StatelessWidget {
  Agreement({Key? key}) : super(key: key);

  String text = "يأخذ مرضى الكلى العديد من الأدوية والالتزام بهذه الأدوية له تأثير كبير على حالة الكلى ومضاعفات أمراض الكلى المزمنة. استخدام التكنولوجيا قد يساعد المريض على الالتزام بدوائه وتحسين معرفته بمرضه وعلاجاته ومتابعة حالته بمساعدة برامج مثل تطبيقات الهاتف الذكي.\n"
  " هذا التطبيق مقدم من قبل د. شذا جمال عبد الفتاح وهو خاص بموضوع البحث بعنوان (تأثير تطبيق هاتفي يقوده الصيدلي على الالتزام بالأدوية وفعاليتها في مرضى الكلى المزمنة.) الهدف من هذا التطبيق هو تقييم تقبل المرضى للتطبيق الهاتفي وتأثيره على الالتزام بالدواء وفعاليتها في مرضى الكلى المزمنة.\n"

"  الفائدة للمريض هي تحسين الالتزام بالدواء وحالة الكلى مع تقليل المشاكل المترتبة على عدم الالتزام بالدواء لدى مرضى الكلى المزمنة.\n"

  "*سيتم متابعة المعلومات التي يدخلها مريض على التطبيق مع الحفاظ على السرية التامة للمعلومات وخصوصية المرضى.\n"

 " * لا يوجد اعراض جانبية محتملة من استخدام هذا التطبيق الهاتفي.\n"
 "\n * في حالة رفضك استخدام هذا التطبيق ستتلقى علاجك المعتاد."
  "\n*من حق المشارك الانسحاب في أي وقت دون أي عواقب سلبية.";

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
                const SizedBox(height: 10,),
                Text(text,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(child : const Text("أوافق",style: TextStyle(color :Colors.black,fontSize: 18),)
                      ,onPressed : () async {
                      await globals.user.write(key: "agreed", value: "true");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.teal),),
                    ElevatedButton(child : const Text("لا أوافق",style: TextStyle(color :Colors.black,fontSize: 18),)
                      ,onPressed : (){
                       SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.teal),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

