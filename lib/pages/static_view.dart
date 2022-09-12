import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StaticView extends StatelessWidget {
 int id;
 StaticView(this.id, {Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return MaterialApp(title: 'StaticView', home: MyStaticView(id));
}
}

class MyStaticView extends StatefulWidget {
  int id;
  MyStaticView(this.id,{Key? key}) : super(key: key);

  @override
  State<MyStaticView> createState() => _MyStaticViewState();
}

class _MyStaticViewState extends State<MyStaticView> {
  String? title;
  String? image;
  String? content;
  bool isLoaded = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    final String response = await rootBundle.loadString('assets/statics.json');
    final data = await json.decode(response);

    image = data['images'][widget.id-1];
     //= images;

     title = data['titles'][widget.id-1];
    // = titles;

    final String response2 = await rootBundle.loadString('assets/content.json');
    final data2 = await json.decode(response2);

    content = data2['contents'][widget.id-1];
    // = contents;

    setState(() {
      isLoaded = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded ? Padding(
        padding: const EdgeInsets.only(top : 40,left: 20,right: 20),
        child:  SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: Text("صحة الكلى",
                style: TextStyle(color: Colors.black,fontSize: 20),)),
              Center(
                child: Image.asset("images/$image.png",
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 10,),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  color: Colors.teal,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      title!,
                      style: const TextStyle(color: Colors.white,fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(content! ,
              style: const TextStyle(color: Colors.teal , fontSize: 15,fontWeight: FontWeight.bold),
                  locale: const Locale('ar'),
              textDirection: TextDirection.rtl,)
            ],
          ),
        )
      ): const Center(child: CircularProgressIndicator(),),
    );
  }
}