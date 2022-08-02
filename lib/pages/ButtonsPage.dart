import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonsPage extends StatelessWidget {
  String page;

  ButtonsPage(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ButtonsPage', home: MyButtonsPage(page));
  }
}

class MyButtonsPage extends StatefulWidget {
  String page;

  MyButtonsPage(this.page,{Key? key}) : super(key: key);

  @override
  State<MyButtonsPage> createState() => _MyButtonsPageState();
}

class _MyButtonsPageState extends State<MyButtonsPage> {
  bool isLoaded = false;
  _Butttons? buttonPage;

  getData() async {
    final String response = await rootBundle.loadString('assets/generated.json');
    final data = await json.decode(response);

    print(data[widget.page]);
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
          child: Column(
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
                    ElevatedButton(onPressed: ()  {}, child:  Text(button,style: const TextStyle(color: Colors.white,fontSize: 20),),
                      style: ElevatedButton.styleFrom(primary: Colors.teal,
                          fixedSize: Size(MediaQuery.of(context).size.width, 50)),),
                    const SizedBox(height: 50,)
                  ],
                );
              }).toList()
            ],
          )
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
  List<dynamic>? buttons;

  _Butttons(
      this.id, this.extra, this.path, this.image, this.title, this.buttons);

  factory _Butttons.fromJson(Map<String, dynamic> json) {
    return _Butttons(
      json['id'],
      json['extra'],
      json['path'],
      json['image'],
      json['title'],
      json['buttons'],
    );
  }
}

