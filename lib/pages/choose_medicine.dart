import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicine_time/entities/medicine.dart';
import 'package:medicine_time/pages/add_medicine.dart';
import 'package:medicine_time/services/medicine_service.dart';

class ChooseMedicine extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:MyChooseMedicine()
    );
  }
}



class MyChooseMedicine extends StatefulWidget {

  MyChooseMedicine();
  @override
  State<MyChooseMedicine> createState() => _MyChooseMedicineState();
}

class _MyChooseMedicineState extends State<MyChooseMedicine> {

  List<Medicine> allmedicines = [];
  List<MedCategory> allcategories = [];
  List<Medicine> filteredMedicines = [];
  List<MedCategory> filteredCategories = [];
  String? chosenCategory;
  String? chosenMedicine;
  bool isLoaded=false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final MedicineService service = MedicineService();
    allmedicines = await service.getMedicines();
    allcategories = await service.getCategories();
    chosenCategory = allcategories[0].name;
    chosenMedicine = allmedicines[0].name;
    filteredMedicines = allmedicines;
    filteredCategories = allcategories;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: isLoaded ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: OutlinedButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setStateForDialog) {
                          return SimpleDialog(
                            children: [
                              TextField(
                                decoration: const InputDecoration(hintText: 'Search'),
                                onChanged: (String value) {
                                  setStateForDialog(() {
                                    if(value=="")
                                      filteredCategories=allcategories;
                                    else
                                      filteredCategories=allcategories.where((element) => element.name!.startsWith(value)).toList();
                                  });
                                },
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...filteredCategories.map((category) {
                                      return SimpleDialogOption(
                                        onPressed: (){
                                          Navigator.pop(context, true);
                                          setState(() {
                                            chosenMedicine = allmedicines[0].name;
                                            chosenCategory = category.name;
                                            if(chosenCategory==allcategories[0].name)
                                              filteredMedicines = allmedicines;
                                            else
                                              filteredMedicines = allmedicines.where((element) => element.category==chosenCategory).toList();

                                            filteredCategories = allcategories;
                                          });
                                        },
                                        child: Text(category.name!),
                                      );
                                    }).toList()
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        );
                      });
                    }, child: Text(chosenCategory!, style: const TextStyle(color: Colors.black,fontSize: 20),)),
                  ),
                  const SizedBox(width: 30,),
                  const Text("نوع الدواء",style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: OutlinedButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setStateForDialog) {
                          return SimpleDialog(
                            children: [
                              TextField(
                                decoration: const InputDecoration(hintText: 'Search'),
                                onChanged: (String value) {
                                  setStateForDialog(() {
                                    if(value=="")
                                      filteredMedicines=allmedicines.where((element) => element.category==chosenCategory).toList();
                                    else
                                      if(chosenCategory==allcategories[0].name)
                                        filteredMedicines=allmedicines.where((element) => element.name.startsWith(value)).toList();
                                      else
                                        filteredMedicines=allmedicines.where((element) => element.category==chosenCategory&&element.name.startsWith(value)).toList();
                                  });
                                },
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...filteredMedicines.map((medicine) {
                                      return SimpleDialogOption(
                                        onPressed: (){
                                          Navigator.pop(context, true);
                                          setState(() {
                                            chosenMedicine = medicine.name;
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => AddMedicine(chosenMedicine)));
                                          });
                                        },
                                        child: Text(medicine.name),
                                      );
                                    }).toList()
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        );
                      });
                    }, child: Text(chosenMedicine!, style: const TextStyle(color: Colors.black,fontSize: 20),)),
                  ),
                  const SizedBox(width: 30,),
                  const Text("اسم الدواء",style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )),
                ],
              )
            ],
          ) : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}