import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/entities/user_effect.dart';
import 'package:medicine_time/services/effects_service.dart';
import 'package:medicine_time/services/questions_service.dart';
import '../entities/question.dart';
import 'package:medicine_time/globals.dart' as globals;


class PrevEffects extends StatefulWidget {
  PrevEffects();

  @override
  State<PrevEffects> createState() => _MyPrevEffectsState();
}

class _MyPrevEffectsState extends State<PrevEffects> {
  bool isLoaded = false;
  List<UserEffect> effects = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    String? id = await globals.user.read(key: "id");
    EffectsService service = EffectsService();
    effects = await service.getEffects(int.parse(id!));
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(child:  Text("الأعراض السابقة",style: TextStyle(color: Colors.white),)),
        ),
        body: isLoaded ? Padding(
          padding: const EdgeInsets.only(top: 15 , left: 15,right: 15),
          child: SingleChildScrollView(
              child:Column(
                children: [
                  ...effects.map((effect) {
                    return Column(
                      children: [
                        Text(effect.getFormattedDate(),style: const TextStyle(color :Colors.teal,fontSize: 23)),
                        const SizedBox(height: 7,),
                        Text(" أعراض مرض الكلى : ${effect.kidney_effects}",style: const TextStyle(color :Colors.black,fontSize: 18),),
                        const SizedBox(height: 5,),
                        Text(" الأعراض الجانبية : ${effect.effects}",style: const TextStyle(color :Colors.black,fontSize: 18),),
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
