import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'ImageView', home: MyImageView());
  }
}

class MyImageView extends StatefulWidget {
  const MyImageView({Key? key}) : super(key: key);

  @override
  State<MyImageView> createState() => _MyImageViewState();
}

class _MyImageViewState extends State<MyImageView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top : 40,left: 20,right: 20),
          child:  SingleChildScrollView(
            child: Column(
              children: [
                const Center(child: Text("مراحل مرض الكلى المزمن",
                  style: TextStyle(color: Colors.black,fontSize: 20),)),
                Center(
                  child: Image.asset("images/stages.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                  child: Image.asset("images/kidney_stages.png",
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}