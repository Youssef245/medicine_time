import 'package:flutter/material.dart';
import 'package:medicine_time/entities/user_effect.dart';
import 'package:medicine_time/pages/prev_effects.dart';
import 'package:medicine_time/services/effects_service.dart';
import 'package:darq/darq.dart';
import '../entities/side_effect.dart';
import 'home_page.dart';
import 'package:medicine_time/globals.dart' as globals;


class AddSideEffects extends StatelessWidget {

  const AddSideEffects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return MaterialApp(home: MyAddSideEffects());
  }
}

class MyAddSideEffects extends StatefulWidget {
  @override
  State<MyAddSideEffects> createState() => _MyAddSideEffectsState();
}

class _MyAddSideEffectsState extends State<MyAddSideEffects> {

  List<String> kidneyEffects = [
    "لا يوجد",
    "تورم في القدم/تجمع مياه في الجسم",
    "حكة في الجلد",
    "تشنج/شد في العضلات",
    " فقدان للشهية",
    " غثيان",
    " ارهاق",
    " أرق",
    " ضيق في التنفس",
    "زيادة في البول",
    "نقص في البول",
    "أخرى"
  ];

  String? kidneyEffectsValue;
  String? sideEffectsValue;
  String? sideCategoriesValue;

  List <SideEffect>? sideEffects;
  List <SideEffect>? filteredEffects;
  List <String> sideCategories = [];
  TextEditingController kidneyController = TextEditingController();
  TextEditingController sideController = TextEditingController();
  bool isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    EffectsService service = EffectsService();
    sideEffects = await service.getSideEffects();
    sideEffects!.distinct((d) => d.category).toList().forEach((element) {sideCategories.add(element.category);});
    print(sideCategories);
    filteredEffects = sideEffects;
    kidneyEffectsValue = kidneyEffects.first;
    sideCategoriesValue = sideCategories.where((element) => element=="الكل").first;
    setState(() {
      isLoaded = true;
    });
  }

  addEffect () async {
    String? kidneyEffect;
    String? sideEffect;
    if(kidneyController.text=="") {
      kidneyEffect = kidneyEffectsValue;
    } else {
      kidneyEffect = kidneyController.text;
    }
    if(sideController.text=="") {
      sideEffect = sideEffectsValue;
    } else {
      sideEffect = sideController.text;
    }

    String? id = await globals.user.read(key: "id");
    UserEffect userEffect = UserEffect.name(int.parse(id!), kidneyEffect, sideEffect);
    EffectsService service = EffectsService();
    await service.postEffect(userEffect.toJson());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80,right: 15),
        child: isLoaded ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Image.asset("images/symptoms1.png",
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 10,),
              firstPart(),
              const SizedBox(height: 10),
              secondPart(),
              const SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                addEffect();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    Homepage()));
              }, child: const Text("حفظ",style: TextStyle(color: Colors.teal),),
                style: ElevatedButton.styleFrom(primary: Colors.white70),),
              const SizedBox(height: 15,),
              Align(
                alignment: FractionalOffset.bottomLeft,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      PrevEffects()));
                }, child: const Text("الأعراض السابقة",style:  TextStyle(color: Colors.teal),),
                  style: ElevatedButton.styleFrom(primary: Colors.white70),),
              )

            ],
          ),
        ) : const Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  Widget firstPart ()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Center(
          child: Container(
            color: Colors.teal,
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: const Center(
              child:  Text(
                "أعراض مرض الكلى",
                style: TextStyle(color: Colors.white,fontSize: 23),
              ),
            ),
          ),
        ),
        DropdownButton<String>(
            items: kidneyEffects
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: kidneyEffectsValue,
            onChanged: (String? newValue) {
              setState(() {
                kidneyEffectsValue = newValue!;
              });
            }),
        const SizedBox(height: 5,),
        if(kidneyEffectsValue==kidneyEffects.last)
          Container(width: MediaQuery.of(context).size.width,
              child: TextFormField(
                  decoration:  const InputDecoration(hintText: "أعراض أخرى" ,
                    border:  OutlineInputBorder(borderSide:  BorderSide(width: 2.0),),),
                  controller: kidneyController ,
                  textAlignVertical: TextAlignVertical.center)),
      ],
    );
  }

  Widget secondPart () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          color: Colors.teal,
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: const Center(
            child: Text(
              "الأعراض الجانبية",
              style: TextStyle(color: Colors.white,fontSize: 23),
            ),
          ),
        ),
        DropdownButton<String>(
            items: sideCategories
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: sideCategoriesValue,
            onChanged: (String? newValue) {
              setState(() {
                sideCategoriesValue = newValue!;
                if(sideCategoriesValue=="الكل") {
                  filteredEffects = sideEffects;
                } else {
                  filteredEffects = sideEffects!.where((element) => element.category==sideCategoriesValue).toList();
                }
              });
            }),
        DropdownButton<String>(
            items: filteredEffects!.map((effect) => effect.name).toList()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: sideEffectsValue,
            onChanged: (String? newValue) {
              setState(() {
                sideEffectsValue = newValue!;
              });
            }),
        if(sideEffectsValue=="لا يوجد")
          Container(width: MediaQuery.of(context).size.width*0.6,
              child: TextFormField(
                  decoration:  const InputDecoration(hintText: "أعراض أخرى" ,
                    border:  OutlineInputBorder(borderSide:  BorderSide(width: 2.0),),),
                  controller: sideController ,
                  textAlignVertical: TextAlignVertical.center)),

      ],
    );
  }
}