import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';
import 'new register.dart';

void main() {
  runApp(const MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});

  

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final usernamecontroller=TextEditingController();
  final passwordcontroller=TextEditingController();
 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextFormField(
                 controller: usernamecontroller,
                 decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Username"))),
           ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Password"))),
            ),
            ElevatedButton(onPressed: (){_send_data();}, child: Text("Login")),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => NewRegisterPage(title: "Signup"),));
            }, child: Text("Signup"))
          ],
        ),
      ),
      
    );
  }
  void _send_data() async{


    String uname=usernamecontroller.text;
    String password=passwordcontroller.text;



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/staff_login/');
    try {
      final response = await http.post(urls, body: {
        'name':uname,
        'password':password,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {

          String lid=jsonDecode(response.body)['lid'];
          sh.setString("lid", lid);

          Navigator.push(context, MaterialPageRoute(
            builder: (context) => HomeNewPage(title: "Home"),));
        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }

}
