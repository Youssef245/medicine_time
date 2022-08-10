import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine_time/pages/image_view.dart';
import 'package:medicine_time/pages/static_view.dart';
import 'package:medicine_time/pages/test1.dart';
import 'package:medicine_time/pages/test2.dart';
import 'package:medicine_time/pages/test3.dart';

class ButtonsPage extends StatefulWidget {
  String page;

  ButtonsPage(this.page,{Key? key}) : super(key: key);

  @override
  State<ButtonsPage> createState() => _MyButtonsPageState();
}

class _MyButtonsPageState extends State<ButtonsPage> {
  bool isLoaded = false;
  _Butttons? buttonPage;

  getData() async {
    final String response = await rootBundle.loadString('assets/generated.json');
    final data = await json.decode(response);
    buttonPage = _Butttons.fromJson(data[widget.page]);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 40,left: 20,right: 20),
        child: SingleChildScrollView(
          child: isLoaded ? Column(
            children: [
              Center(child: Text(buttonPage!.title!,
              style: const TextStyle(color: Colors.black,fontSize: 20),)),
              if(buttonPage!.image!)
                Image.asset("images/${buttonPage!.path}.png",
                  width: 150,
                  height: 150,
                ),
              Text(buttonPage!.extra!),
              ...buttonPage!.buttons!.map((button)  {
                return Column(
                  children: [
                    ElevatedButton(onPressed: ()  {
                      if(button.redirect=="buttons")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ButtonsPage(button.name!),
                        ));
                      }
                      else if (button.redirect=="static")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StaticView(button.id!),
                        ));
                      }
                      else if (button.redirect=="image")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ImageView(),
                        ));
                      }
                      else if (button.redirect=="test1")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Test1(),
                        ));
                      }
                      else if (button.redirect=="test2")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Test2(),
                        ));
                      }
                      else if (button.redirect=="test3")
                      {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Test3(),
                        ));
                      }
                    }, child:  Text(button.name!,style: const TextStyle(color: Colors.white,fontSize: 20),),
                      style: ElevatedButton.styleFrom(primary: Colors.teal,
                          minimumSize: Size(MediaQuery.of(context).size.width, 50)),),
                    const SizedBox(height: 50,)
                  ],
                );
              }).toList()
            ],
          ) : const Center(child: CircularProgressIndicator(),)
        ),
      ),
    );
  }
}

class _Butttons {
  int? id;
  String? extra;
  String? path;
  bool? image;
  String? title;
  List<_ButtonDetails>? buttons;

  _Butttons(
      this.id, this.extra, this.path, this.image, this.title, this.buttons);

  factory _Butttons.fromJson(Map<String, dynamic> json) {
    return _Butttons(
      json['id'],
      json['extra'],
      json['path'],
      json['image'],
      json['title'],
      List<_ButtonDetails>.from(json['buttons'].map((x) => _ButtonDetails.fromJson(x))) ,
    );
  }
}

class _ButtonDetails
{
  String? name;
  String? redirect;
  int? id;

  _ButtonDetails(this.name, this.redirect, this.id);

  factory _ButtonDetails.fromJson(Map<String, dynamic> json) {
    return _ButtonDetails(
      json['name'],
      json['redirect'],
      json['id'],
    );
  }
}

