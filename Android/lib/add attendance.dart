import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';


void main() {
  runApp(const AddAttendance());
}

class AddAttendance extends StatelessWidget {
  const AddAttendance({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddAttendancePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AddAttendancePage extends StatefulWidget {
  const AddAttendancePage({super.key, required this.title});



  final String title;

  @override
  State<AddAttendancePage> createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  final attendancecontroller=TextEditingController();

  final formkey=GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Form(
          key: formkey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: attendancecontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Description"))),
              ),
              ElevatedButton(onPressed: (){
                if(formkey.currentState!.validate()) {
                  _send_data();
                }
                }, child: Text("Send"))
            ],
          ),
        ),
      ),

    );
  }
  void _send_data() async{


    String attendance=attendancecontroller.text;




    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/staff_send_leave_req/');
    try {
      final response = await http.post(urls, body: {
        'leavereq':attendance,
        'lid':sh.getString('lid').toString()



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {

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
