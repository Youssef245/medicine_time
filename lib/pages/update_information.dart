import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/services/user_service.dart';
import 'package:medicine_time/globals.dart' as globals;
import '../entities/user.dart';
import 'home_page.dart';

class UpdateInformation extends StatelessWidget {
  const UpdateInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'UpdateInformation', home: MyUpdateInformation());
  }
}

class MyUpdateInformation extends StatefulWidget {
  MyUpdateInformation({Key? key}) : super(key: key);

  @override
  State<MyUpdateInformation> createState() => _MyUpdateInformationState();
}

enum gender {male, female}
enum options {no , yes}

class _MyUpdateInformationState extends State<MyUpdateInformation> {
  User? user;
  bool isLoaded = false;
  TextEditingController? nameController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  TextEditingController? heightController;
  TextEditingController? passwordController;

  TextEditingController? heartController;
  TextEditingController? liverController;
  TextEditingController? cancerController;
  TextEditingController? manayaController;

  TextEditingController? kidneyPeriod;
  TextEditingController? kidneyTransplant;

  bool? pressure ,
      glucose ,
      col ,
      heart ,
      liver ,
      hemoglobin ,
      cancer ,
      manaya ;

  bool showPassword = false;
  List <String> educationLevel = [
    "...اختار مستوى التعليم...",
    "متوسط أو أقل",
    "ثانوي او ما يعادله",
    "جامعي أو أعلى"
  ];
  List <String> glucoseLevels = [
    "...الرجاء اختيار النوع...",
    "النوع الأول",
    "النوع الثاني",
  ];
  List<String> kidneyStages = [
    "...الرجاء اختيار مرحلة المرض...",
    "1",
    "2",
    "3أ",
    "3ب",
    "4",
    "5",
  ];
  String? educationLevelValue;
  String? glucoseStage;
  String? kidneyStage;
  gender? userGender;
  options? option;
  static DateTime now =  DateTime.now();
  DateTime date =  DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData () async {
    glucoseStage = glucoseLevels.first;
    educationLevelValue = educationLevel.first;
    kidneyStage = kidneyStages.first;

    String? id = await globals.user.read(key: "id");
    UserSerivce service = UserSerivce();
    user = await service.getUserInfo(int.parse(id!));

    nameController = TextEditingController(text: user!.name);
    phoneController = TextEditingController(text: user!.mobile);
    emailController = TextEditingController(text: user!.email);
    heightController = TextEditingController(text: user!.height.toString());
    passwordController = TextEditingController(text: user!.password);

    heartController = TextEditingController(text: user!.heart_type);
    liverController = TextEditingController(text: user!.liver_type);
    cancerController = TextEditingController(text: user!.cancer_type);
    manayaController = TextEditingController(text: user!.manaya_type);

    kidneyPeriod = TextEditingController(text: user!.kidney_period);
    kidneyTransplant = TextEditingController(text: user!.kidney_transplant);

    userGender = setGender(user!.gendar!);
    option = setOption(user!.transplant!);

    pressure = user!.pressure!;
    glucose = user!.glucose!;
    col = user!.chl!;
    heart = user!.heart!;
    liver = user!.liver!;
    hemoglobin = user!.hemoglobin!;
    cancer = user!.cancer!;
    manaya = user!.manaya!;

    setState(() {
      isLoaded = true;
    });
  }

  updateUser () async {

    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(date);

    int newHeight=0;
    if(heightController!.text!="") {
      newHeight = int.parse(heightController!.text);
    }

    User newUser = User(
        nameController!.text,
        passwordController!.text,
        phoneController!.text,
        emailController!.text,
        newHeight,
        getValueGender(userGender),
        educationLevelValue,
        formattedDate,
        pressure,
        glucose,
        col,
        heart,
        liver,
        hemoglobin,
        cancer,
        manaya,
        glucoseStage,
        heartController!.text,
        cancerController!.text,
        manayaController!.text,
        kidneyPeriod!.text,
        kidneyStage,
        kidneyTransplant!.text,
        getValueOption(option),
        liverController!.text,
    );

    String? id = await globals.user.read(key: "id");
    UserSerivce service = UserSerivce();
    await service.updateUserInfo(newUser.toJson(), int.parse(id!));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80,right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              firstPart(),
              const SizedBox(height: 5,),
              Container(
                color: Colors.teal,
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: const Center(
                  child:  Text(
                    "أمراض أخرى",
                    style: TextStyle(color: Colors.white,fontSize: 23),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              secondPart(),
              Container(
                color: Colors.teal,
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: const Center(
                  child:  Text(
                    "الكلى",
                    style: TextStyle(color: Colors.white,fontSize: 23),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              thirdPart(),
              const SizedBox(height: 5,),
              ElevatedButton(onPressed: () async {
                //registerMeasure();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    Homepage()));
              }, child: Text("تسجيل",style: const TextStyle(color: Colors.teal),),
                style: ElevatedButton.styleFrom(primary: Colors.white70),),
              const SizedBox(height: 5,),
            ],
          )
        ),
      ),
    );
  }

  Widget firstPart () {
    return Column(
      children: [
        inputField("اسم المستخدم",nameController!,false),
        inputField("رقم الهاتف",phoneController!,false),
        inputField("البريد الإلكتروني",emailController!,false),
        inputField("الطول",heightController!,true),
        genderRadio(),
        passwordField(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${date.year}/${date.month}/${date.day}'),
            IconButton(
              icon: const Icon(Icons.date_range , color: Colors.teal,size: 20),
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: date);

                if(newDate == null) return;

                setState(() {
                  date = newDate;
                });
              },
            )
          ],
        )
      ],
    );
  }

  Widget inputField(String field , TextEditingController controller , bool numbers)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width,height:30,
            padding: EdgeInsets.only(left: 10),
            child: TextFormField(decoration:const  InputDecoration(
              border:  OutlineInputBorder(
              borderSide:  BorderSide(width: 2.0),),),
              keyboardType: numbers ? TextInputType.number : null,
              controller: controller ,),
          ),
        ),
        Flexible(child: Text(" : $field",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
      ],
    );
  }

  Widget passwordField () {
    return Row(
      children: [
        TextFormField(style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border:  const OutlineInputBorder(
              borderSide:  BorderSide(width: 2.0),),
              labelStyle: const TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: showPassword ? const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ) : const Icon(
                  Icons.visibility_off,
                  color: Colors.white,
                ),
              )
          ),
          controller: passwordController,
          obscureText: showPassword ? true : false,
          cursorColor: Colors.white,
        ),
        const Flexible(child: Text(" : كلمة السر",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),

      ],
    );
  }

  Widget dropDownInput (String field , String value , List<String> values)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
            items: values
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: value,
            onChanged: (String? newValue) {
              setState(() {
                value = newValue!;
              });
            }),
        Flexible(child: Text(" : $field",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
      ],
    );
  }

 Widget genderRadio ()
 {
   return Row(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
       ListTile(
         title: const Text('ذكر'),
         leading: Radio<gender>(
           value: gender.male,
           groupValue: userGender,
           onChanged: (gender? value) {
             setState(() {
               userGender = value;
             });
           },
         ),
       ),
       ListTile(
         title: const Text('أنثى'),
         leading: Radio<gender>(
           value: gender.female,
           groupValue: userGender,
           onChanged: (gender? value) {
             setState(() {
               userGender = value;
             });
           },
         ),
       ),
       const Flexible(child: Text(" : الجنس",style:  TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
     ],
   );
 }

  Widget transplantRadio ()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          title: const Text('لا'),
          leading: Radio<options>(
            value: options.no,
            groupValue: option,
            onChanged: (options? value) {
              setState(() {
                option = value;
              });
            },
          ),
        ),
        Row(
          children: [
            ListTile(
              title: const Text('نعم'),
              leading: Radio<options>(
                value: options.yes,
                groupValue: option,
                onChanged: (options? value) {
                  setState(() {
                    option = value;
                  });
                },
              ),
            ),
            if(option==options.yes)
              inputField("", kidneyTransplant!, false),
          ],
        ),
        const Flexible(child: Text(" : هل تم زراعة الكلى",style:  TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify)),
      ],
    );
  }

 Widget secondPart (){
    return Column(
      children: [
        checkBoxes(false,false,"ارتفاع ضغط الدم",pressure!,TextEditingController()),
        checkBoxes(false,true,"السكري",glucose!,TextEditingController()),
        checkBoxes(false,false,"ارتفاع الكوليسترول والدهون في الدم",pressure!,TextEditingController()),
        checkBoxes(true,false,"أمراض القلب",heart!,heartController!),
        checkBoxes(true,false,"أمراض الكبد",liver!,liverController!),
        checkBoxes(false,false,"انيميا",hemoglobin!,TextEditingController()),
        checkBoxes(true,false,"سرطان",cancer!,cancerController!),
        checkBoxes(true,false,"أمراض مناعية أو روماتيزمية",manaya!,manayaController!),
      ],
    );
 }

 Widget checkBoxes(bool textField ,bool dropDown,  String field,  bool checkValue,TextEditingController controller) {
    return Row(
      children: [
        if(dropDown) dropDownInput("", glucoseStage!, glucoseLevels),
        if(textField) inputField("", controller, false),
        ListTile(
          title: Text(field,style: const TextStyle(color: Colors.teal),),
          leading: Checkbox(value: false,onChanged: (value) {
            setState(() {
              checkValue = value!;
            });
          },),
        )
      ],
    );

 }

 Widget thirdPart() {
    return Column(
      children: [
        inputField("فترة المرض بالكلى", kidneyPeriod!, false),
        dropDownInput("مرحلة مرض الكلى", kidneyStage!, kidneyStages),
        transplantRadio(),
      ],
    );
 }

 getValueGender(gender? g)
 {
   if(g==gender.male)
     return "ذكر";
   else if (g==gender.female)
     return "أنثى";
   else
     return "";
 }

 getValueOption (options? o)
 {
   if(o==options.yes)
     return "نعم";
   else if (o==options.no)
     return "لا";
   else
     return "";
 }

 setOption(String? o)
 {
   if(o=="نعم")
     return options.yes;
   else
     return options.no;
 }

 setGender(String? g)
 {
   if(g=="ذكر")
     return gender.male;
   else
     return gender.female;
 }
}

