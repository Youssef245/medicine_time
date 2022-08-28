
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_time/services/user_service.dart';
import 'package:medicine_time/globals.dart' as globals;
import '../entities/user.dart';
import 'home_page.dart';

class UpdateInformation extends StatefulWidget {
  UpdateInformation({Key? key}) : super(key: key);

  @override
  State<UpdateInformation> createState() => _MyUpdateInformationState();
}

enum gender {male, female}
enum options {no , yes}

class _MyUpdateInformationState extends State<UpdateInformation> {
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

  List<_checkBox> boxes = [ _checkBox("pressure", false),
    _checkBox("glucose", false) ,
    _checkBox("col", false)  ,
    _checkBox("heart", false)  ,
    _checkBox("liver", false)   ,
    _checkBox("hemoglobin", false)  ,
    _checkBox("cancer", false) ,
    _checkBox("manaya", false) ];

  bool showPassword = false;
  List <String> educationLevel = [
    "...اختار مستوى التعليم...",
    "متوسط او أقل",
    "ثانوى او ما يعادله",
    "جامعى او أعلى"
  ];
  List <String> glucoseLevels = [
    "...الرجاء اختيار النوع...",
    "النوع الاول",
    "النوع الثانى",
  ];
  List<String> kidneyStages = [
    "الرجاء اختيار مرحلة المرض",
    "1",
    "2",
    "3ا",
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
    Homepage().sendOffline();
    getData();
  }

  getData () async {

    String? id = await globals.user.read(key: "id");
    String? userName = await globals.user.read(key: "name");
    UserSerivce service = UserSerivce();
    user = await service.getUserInfo(int.parse(id!));

    nameController = TextEditingController(text: userName);
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

    if(user!.glucose_stage!="") {
      glucoseStage = glucoseLevels.firstWhere((element) => element==user!.glucose_stage);
    } else {
      glucoseStage = glucoseLevels.first;
    }

    if(user!.education_level!="") {
      print(user!.education_level);
      print(educationLevel);
      educationLevelValue = educationLevel.firstWhere((element) => element==user!.education_level);
    } else {
      educationLevelValue = educationLevel.first;
    }

    if(user!.kidney_stage!="") {
      kidneyStage = kidneyStages.firstWhere((element) => element==user!.kidney_stage);
    } else {
      kidneyStage = kidneyStages.first;
    }

    boxes.firstWhere((element) => element.name=="pressure").value = user!.pressure!;
    boxes.firstWhere((element) => element.name=="glucose").value = user!.glucose!;
    boxes.firstWhere((element) => element.name=="col").value = user!.chl!;
    boxes.firstWhere((element) => element.name=="heart").value = user!.heart!;
    boxes.firstWhere((element) => element.name=="liver").value = user!.liver!;
    boxes.firstWhere((element) => element.name=="hemoglobin").value = user!.hemoglobin!;
    boxes.firstWhere((element) => element.name=="cancer").value = user!.cancer!;
    boxes.firstWhere((element) => element.name=="manaya").value= user!.manaya!;

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
        educationLevelValue==educationLevel.first ? "" : educationLevelValue,
        formattedDate,
        boxes.firstWhere((element) => element.name=="pressure").value,
        boxes.firstWhere((element) => element.name=="glucose").value,
        boxes.firstWhere((element) => element.name=="col").value,
        boxes.firstWhere((element) => element.name=="heart").value,
        boxes.firstWhere((element) => element.name=="liver").value,
        boxes.firstWhere((element) => element.name=="hemoglobin").value,
        boxes.firstWhere((element) => element.name=="cancer").value,
        boxes.firstWhere((element) => element.name=="manaya").value,
        glucoseStage==glucoseLevels.first ? "" : glucoseStage,
        heartController!.text,
        cancerController!.text,
        manayaController!.text,
        kidneyPeriod!.text,
        kidneyStage==kidneyStages.first ? "" :kidneyStage,
        kidneyTransplant!.text,
        getValueOption(option),
        liverController!.text,
    );

    String? id = await globals.user.read(key: "id");
    UserSerivce service = UserSerivce();
    print(newUser.toJson());
    await service.updateUserInfo(newUser.toJson(), int.parse(id!));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded ? Padding(
        padding: const EdgeInsets.only(right: 8.0,left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.teal,
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Image.asset("images/user4.png",
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              inputField(field: " : اسم المستخدم",controller: nameController!),
              const SizedBox(height: 10,),
              inputField(field: " : رقم الهاتف",controller: phoneController!,numbers: true),
              const SizedBox(height: 10,),
              inputField(field: " : البريد الإلكتروني",controller: emailController!),
              const SizedBox(height: 10,),
              inputField(field: " : الطول",controller: heightController!,numbers: true),
              const SizedBox(height: 10,),
              genderRadio(),
              const SizedBox(height: 10,),
              passwordField(),
              const SizedBox(height: 10,),
              datePicker(),
              const SizedBox(height: 10,),
              dropDownInput(field: " : المستوى التعليمي",values: educationLevel,edu: true),
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
              checkBoxes(false,false,"ارتفاع ضغط الدم","pressure",TextEditingController()),
              const SizedBox(height: 5,),
              checkBoxes(false,true,"السكري","glucose",TextEditingController()),
              const SizedBox(height: 5,),
              checkBoxes(false,false,"ارتفاع الكوليسترول والدهون في الدم","col",TextEditingController()),
              const SizedBox(height: 5,),
              checkBoxes(true,false,"أمراض القلب","heart",heartController!),
              const SizedBox(height: 5,),
              checkBoxes(true,false,"أمراض الكبد","liver",liverController!),
              const SizedBox(height: 5,),
              checkBoxes(false,false,"انيميا","hemoglobin",TextEditingController()),
              const SizedBox(height: 5,),
              checkBoxes(true,false,"سرطان","cancer",cancerController!),
              const SizedBox(height: 5,),
              checkBoxes(true,false,"أمراض مناعية أو روماتيزمية","manaya",manayaController!),
              const SizedBox(height: 5,),
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
              inputField(field: " : فترة المرض بالكلى", controller: kidneyPeriod!),
              const SizedBox(height: 10,),
              dropDownInput(field: " : مرحلة مرض الكلى",values: kidneyStages,kidney: true),
              const SizedBox(height: 5,),
              transplantRadio(),
              const SizedBox(height: 5,),
              ElevatedButton(onPressed: () async {
                updateUser();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    Homepage()));
              }, child: Text("تسجيل",style: const TextStyle(color: Colors.teal),),
                style: ElevatedButton.styleFrom(primary: Colors.white70),),
              const SizedBox(height: 5,),
            ],
          )
        ),
      ) : const Center(child: CircularProgressIndicator(),)
    );
  }

  Widget datePicker ()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.date_range , color: Colors.teal,size: 30),
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
        ),
        Text('${date.year}/${date.month}/${date.day}',
        style: TextStyle(color: Colors.black , fontSize: 20),),
        Text(" : تاريخ الميلاد",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify),
      ],
    );
  }

  Widget inputField({String field = "" , required TextEditingController controller
    ,bool numbers = false ,bool checkbox = false})
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: checkbox ? MediaQuery.of(context).size.width/3 : MediaQuery.of(context).size.width/2,
          //height:30,
          child: AutoSizeTextField(
            controller: controller,
            style: TextStyle(fontSize: 15,color: Colors.black),
            decoration: InputDecoration(
              hintText: checkbox ? "برجاء ادخال المرض" : "",
              contentPadding: EdgeInsets.only(top: 0.0,bottom: 0.0,left: 3),
              border:  OutlineInputBorder(borderSide:  BorderSide(width: 2.0),),),
            maxLines: 1,
            ),
        ),
        Text(field,style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify),
      ],
    );
  }

  Widget passwordField () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width/2,height:30,
          padding: EdgeInsets.only(left: 10),
          child: TextFormField(style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border:  const OutlineInputBorder(
                borderSide:  BorderSide(width: 2.0),),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: showPassword ? const Icon(
                    Icons.remove_red_eye,
                    color: Colors.black,
                  ) : const Icon(
                    Icons.visibility_off,
                    color: Colors.black,
                  ),
                )
            ),
            controller: passwordController,
            obscureText: showPassword ? true : false,
            cursorColor: Colors.black,
          ),
        ),
        Text(" : كلمة السر",style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify),

      ],
    );
  }

  Widget dropDownInput ({String field = "", required List<String> values , bool kidney = false,bool edu =false})
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
            value:  edu ? educationLevelValue : kidney ?  kidneyStage : glucoseStage ,
            onChanged: (String? newValue) {
              setState(() {
                if(edu){
                  educationLevelValue = newValue!;
                }
                else {
                  if(kidney) {
                    kidneyStage = newValue!;
                  } else {
                    glucoseStage = newValue!;
                  }
                }

              });
            }),
        Text(field,style: const TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify),
      ],
    );
  }

 Widget genderRadio ()
 {
   return Row(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
       Flexible(
         child: ListTile(
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
       ),
       Flexible(
         child: ListTile(
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
       ),
       Text(" : الجنس",style:  TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify),
     ],
   );
 }

  Widget transplantRadio ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(" : هل تم زراعة الكلى",style:  TextStyle(color: Colors.teal, fontSize: 20),textAlign: TextAlign.justify),
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
          Center(child: inputField(controller: kidneyTransplant!,field: " : فترة زراعة الكلى")),
      ],
    );
  }

 Widget checkBoxes(bool textField ,bool dropDown,  String field,  String checkName,
     TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(dropDown&&boxes.firstWhere((element) => element.name==checkName).value!)
          dropDownInput(values: glucoseLevels),
        if(textField&&boxes.firstWhere((element) => element.name==checkName).value!)
          inputField(controller:  controller,checkbox: true),
         Checkbox(value: boxes.firstWhere((element) => element.name==checkName).value!,onChanged: (value) {
              setState(() {
                boxes.firstWhere((element) => element.name==checkName).value = value!;
              });
            },),
        Text(field,style: const TextStyle(color: Colors.teal),),
      ],
    );

 }

 getValueGender(gender? g)
 {
   if(g==gender.male) {
     return "ذكر";
   } else if (g==gender.female) {
     return "أنثى";
   } else {
     return "";
   }
 }

 getValueOption (options? o)
 {
   if(o==options.yes) {
     return "نعم";
   } else if (o==options.no) {
     return "لا";
   } else {
     return "";
   }
 }

 setOption(String? o)
 {
   if(o=="نعم") {
     return options.yes;
   } else {
     return options.no;
   }
 }

 setGender(String? g)
 {
   if(g=="ذكر") {
     return gender.male;
   } else {
     return gender.female;
   }
 }


}

class _checkBox {
  String? name;
  bool? value;

  _checkBox(this.name,this.value);
}

