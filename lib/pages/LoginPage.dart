import 'package:flutter/material.dart';
import 'package:medicine_time/pages/home_page.dart';
import 'package:medicine_time/services/user_service.dart';

import '../entities/user.dart';
import 'package:medicine_time/globals.dart' as globals;

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:MyLoginPage()
    );

  }
}


class MyLoginPage extends StatefulWidget{

  @override
  State<MyLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MyLoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? user;
  bool save = false;
  bool showPassword = true;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  initializeControllers() async {
    String? name = await globals.credintials.read(key: "name");
    String? password = await globals.credintials.read(key: "password");
    nameController = TextEditingController(text: name);
    passwordController = TextEditingController(text: password);
    setState(() {
      if(nameController.text!=null)
        save=true;
      isLoaded = true;
    });
  }

  login (String name,String password) async {
    UserSerivce service = UserSerivce();
    user = await service.login({
      'name' : name,
      'password' : password,
    });

    if(user != null)
    {
       globals.user.write(key: "name", value: user!.name);
       globals.user.write(key: "id", value: user!.id.toString());
       globals.user.write(key: "logged", value: "true");
      if(save)
         globals.user.write(key: "remember", value: "true");
      else
         globals.user.write(key: "remember", value: "false");
      return "true";
    }

  }

  saveCredentials(String name,String password) async {
    globals.credintials.write(key: "name", value: name);
    globals.credintials.write(key: "password", value: password);
  }
  
  
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.teal,
          resizeToAvoidBottomInset: false,
          body: isLoaded ? Padding(
            padding: const EdgeInsets.only(top : 150),
            child: Center(
              child: Column (
                children: [
                  Image.asset("images/logo2.png",
                  width: 100, height: 100,),
                  const SizedBox(height: 10,),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      TextFormField( style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                         labelText: "اسم المستخدم",labelStyle: TextStyle(color: Colors.white)),
                        controller: nameController,
                        cursorColor: Colors.white,),
                      const SizedBox(height: 15,),
                      TextFormField(style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                         labelText: "كلمة السر", labelStyle: const TextStyle(color: Colors.white),
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
                    ],
                  )
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 200,
                  child: CheckboxListTile(side: const BorderSide(color: Colors.white),
                    checkColor: Colors.teal,
                    activeColor: Colors.white,
                    value: save, onChanged: (bool? value) {setState(() {save = value!;});},
                    title: const Text("تذكر كلمة المرور",style:
                      TextStyle(color: Colors.white),),),
                ),
                  const SizedBox(height: 10,),
                 ElevatedButton(onPressed: () async {
                   String status = await login(nameController.text, passwordController.text);
                   if(status=="true")
                   {
                     if(save) saveCredentials(nameController.text, passwordController.text);
                     Navigator.of(context).pop();
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                         Homepage()));
                   }
                 }, child: Text("تسجيل الدخول",style: const TextStyle(color: Colors.teal),),
                   style: ElevatedButton.styleFrom(primary: Colors.white70),)
                ],
              ),
            ),
          ) : const Center(child: CircularProgressIndicator(),),
        );
  }
}