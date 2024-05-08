import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:staff_management/utils/appcolors.dart';
import 'package:staff_management/widgets/apptext.dart';

import 'homepage.dart';


void main() {
  runApp(const LeaveStatus());
}

class LeaveStatus extends StatelessWidget {
  const LeaveStatus({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LeaveStatusPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class LeaveStatusPage extends StatefulWidget {
  const LeaveStatusPage({super.key, required this.title});

  

  final String title;

  @override
  State<LeaveStatusPage> createState() => _LeaveStatusPageState();
}

class _LeaveStatusPageState extends State<LeaveStatusPage> {
  _LeaveStatusPageState(){
    _getdata();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeNewPage(title: '')),
            );
          },
        ),
        backgroundColor: AppColors.primaryColor,
        title: const AppText(
          text: "View Leave Request Status",
          fontSize: 18.0,
          color: AppColors.blackColor,
          overflow: TextOverflow.ellipsis,
        ),

      ),
      body: ListView.builder(
        itemCount: id_.length,
        itemBuilder: (context, index) {
          return  Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align all children to the left side
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        Date_[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        Status_[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-120,
                        child: Text(
                          Description_[index],
                          textAlign: TextAlign.end,
                          style: TextStyle(

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Text(
                    "Certificate :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image(image: NetworkImage(certificate_[index]),height: 200,width: 200,),
                ],
              ),
            ),
          );
        },

      ),

    );
  }

  List<String> id_=<String>[];
  List<String> Date_=<String>[];
  List<String> Status_=<String>[];
  List<String> Description_=<String>[];
  List<String> certificate_=<String>[];


  Future<void> _getdata() async {
    List<String> id=<String>[];
    List<String> Date=<String>[];
    List<String> Status=<String>[];
    List<String> Description=<String>[];
    List<String> certificate=<String>[];
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String url = '$urls/staff_view_leave_req_status/';

      var data = await http.post(Uri.parse(url), body: {
        'lid':sh.getString('lid')
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        Date.add(arr[i]['Date']);
        Status.add(arr[i]['Status']);
        Description.add(arr[i]['Description']);
        certificate.add(sh.getString('img_url').toString()+arr[i]['certificate'].toString());


      }

      setState(() {
        id_ = id;
        Date_ = Date;
        Status_ = Status;
        Description_ = Description;
        certificate_ = certificate;

      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }
}

