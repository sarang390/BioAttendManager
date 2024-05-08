import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:staff_management/logintemp/logintemplate.dart';

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
      home: const ForgotPassword(title: 'Flutter Demo Home Page'),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required this.title});



  final String title;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                      label: Text("Email"))),
            ),
           
            ElevatedButton(onPressed: () {
              _send_data();
            }, child: Text("Reset")),
            
          ],
        ),
      ),

    );
  }


  void _send_data() async {
    String uname = emailController.text;


    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/forget_password_post/');
    try {
      final response = await http.post(urls, body: {
        'em_add': uname,


      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String lid = jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);

          Navigator.push(context as BuildContext, MaterialPageRoute(
            builder: (context) => LoginScreenPage(),));
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}