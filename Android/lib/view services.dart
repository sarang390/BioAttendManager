import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/utils/appcolors.dart';
import 'package:staff_management/widgets/apptext.dart';

import 'homepage.dart';
void main() {
  runApp(const ViewServices());
}

class ViewServices extends StatelessWidget {
  const ViewServices({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewServicesPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ViewServicesPage extends StatefulWidget {
  const ViewServicesPage({super.key, required this.title});


  final String title;

  @override
  State<ViewServicesPage> createState() => _viewservicesState();
}

class _viewservicesState extends State<ViewServicesPage> {

  _viewservicesState() {
    view_notification2();
  }

  List<String> id_ = <String>[];
  List<String> servicename_ = <String>[];
  List<String> fromdate_ = <String>[];
  List<String> todate_ = <String>[];
  List<String> duration_ = <String>[];
  List<String> certificate_ = <String>[];




  Future<void> view_notification2() async {
    List<String> id = <String>[];
    List<String> servicename = <String>[];
    List<String> fromdate = <String>[];
    List<String> todate = <String>[];
    List<String> duration = <String>[];
    List<String> certificate = <String>[];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();
      // String img_url = sh.getString('img_url').toString();
      String urls = '$url/staff_view_services/';

      var data = await http.post(Uri.parse(urls), body: {
        'lid':lid

        // 'search':sh.getString("date")
      });
      var jsondata = json.decode(data.body);
      String statuss = jsondata['status'];

      var arr = jsondata["data"];

      print(arr.length);

      for (int i = 0; i < arr.length; i++) {
        id.add(arr[i]['id'].toString());
        servicename.add(arr[i]['servicename'].toString());
        fromdate.add(arr[i]['fromdate'].toString());
        todate.add(arr[i]['todate'].toString());
        duration.add(arr[i]['duration'].toString());
        certificate.add(sh.getString('img_url').toString()+arr[i]['certificate'].toString());

      }

      setState(() {
        id_ = id;
        servicename_ = servicename;
        fromdate_ = fromdate;
        todate_ = todate;
        duration_ = duration;
        certificate_ = certificate;


      });

      print(statuss);
    } catch (e) {
      print("Error ------------------- " + e.toString());
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            text: "View Courses",
            fontSize: 18.0,
            color: AppColors.blackColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          // padding: EdgeInsets.all(5.0),
          // shrinkWrap: true,
          itemCount: id_.length,
          itemBuilder: (BuildContext context, int index) {
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
                          "Service Name :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          servicename_[index],
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
                          "From Date :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          fromdate_[index],
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
                          "To Date :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          todate_[index],
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
                          "Duration :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          duration_[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
        )



      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}