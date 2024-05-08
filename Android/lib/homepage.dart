
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/send%20leave%20req.dart';
import 'package:staff_management/utils/appcolors.dart';
import 'package:staff_management/view%20attendance.dart';
import 'package:staff_management/view%20leave%20req%20status.dart';
import 'package:staff_management/view%20profile.dart';
import 'package:staff_management/view%20services.dart';
import 'package:staff_management/widgets/apptext.dart';


import 'add service.dart';
import 'addservicestemp.dart';
import 'changepswd.dart';
import 'login.dart';
import 'logintemp/logintemplate.dart';
import 'new_view_attendence.dart';
void main() {
  runApp(const HomeNew());
}

class HomeNew extends StatelessWidget {
  const HomeNew({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 82, 98)),
        useMaterial3: true,
      ),
      home: const HomeNewPage(title: 'Home'),
    );
  }
}

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({super.key, required this.title});

  final String title;

  @override
  State<HomeNewPage> createState() => _HomeNewPageState();
}

class _HomeNewPageState extends State<HomeNewPage> {

  String Name_="";
  String Age_="";
  String Gender_="";
  String Place_="";
  String Post_="";
  String District_="";
  String State_="";
  String Email_="";
  String Phone_="";
  String Photo_="";
  String DEPARTMENT_="";

  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url').toString();


    final urls = Uri.parse('$url/staff_view_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String Name=jsonDecode(response.body)['Name'].toString();
          String Age=jsonDecode(response.body)['Age'].toString();
          String Gender=jsonDecode(response.body)['Gender'].toString();
          String Place=jsonDecode(response.body)['Place'].toString();
          String Post=jsonDecode(response.body)['Post'].toString();
          String District=jsonDecode(response.body)['District'].toString();
          String State=jsonDecode(response.body)['State'].toString();
          String Email=jsonDecode(response.body)['Email'].toString();
          String Phone=jsonDecode(response.body)['Phone'].toString();
          String Photo=img_url+jsonDecode(response.body)['Photo'].toString();
          String DEPARTMENT=jsonDecode(response.body)['DEPARTMENT'].toString();

          setState(() {

            Name_= Name;
            Age_= Age;
            Gender_= Gender;
            Place_= Place;
            Post_= Post;
            District_= District;
            State_= State;
            Email_= Email;
            Phone_= Phone;
            Photo_= Photo;
            DEPARTMENT_ = DEPARTMENT;

          });





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





  String uname_="";
  // String uemail_="";
  String uphoto_="";


  _HomeNewPageState()
  {
    a();
    _send_data();
  }

  a()
  async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String name = sh.getString('name').toString();
    // String email = sh.getString('email').toString();
    String photo =sh.getString("imgurl").toString()+ sh.getString('photo').toString();


    setState(() {
      uname_=name;
      // uemail_=email;
      uphoto_=photo;

    });


  }


  TextEditingController unameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{ return true; },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const AppText(
            text: "Home Page",
            fontSize: 18.0,
            color: AppColors.blackColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body:
        SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.network(
                  Photo_,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 240.0, 16.0, 16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 110.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            Name_,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),

                                          // SizedBox(
                                          //   height: 40,
                                          // )
                                        ],
                                      ),
                                      Spacer(),
                                      // CircleAvatar(
                                      //   backgroundColor: Colors.blueAccent,
                                      //   child: IconButton(
                                      //       // onPressed: () {
                                      //       //   Navigator.push(context, MaterialPageRoute(builder: (context) =>MyeditPage(title: "Edit"),));
                                      //       //
                                      //       // },
                                      //       icon: Icon(
                                      //         Icons.edit_outlined,
                                      //         color: Colors.white,
                                      //         size: 18,
                                      //       )),
                                      // )
                                    ],
                                  )),
                              SizedBox(height: 30.0),
                              Row(
                                children: [
                                  // SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      children: [Text("Gender"), Text(Gender_) ],
                                    ),
                                  ),
                                  // SizedBox(width: 20,),
                                  Expanded(
                                    child: Column(
                                      children: [Text("Age"), Text(Age_) ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      Photo_),
                                  fit: BoxFit.cover)),
                          margin: EdgeInsets.only(left: 20.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Profile Information"),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Department"),
                            subtitle: Text(
                                '$DEPARTMENT_'),
                            leading: Icon(Icons.description),
                          ),
                          ListTile(
                            title: Text("Email"),
                            subtitle: Text(Email_),
                            leading: Icon(Icons.mail_outline),
                          ),
                          ListTile(
                            title: Text("Phone"),
                            subtitle: Text(Phone_),
                            leading: Icon(Icons.phone),
                          ),
                          ListTile(
                            title: Text("Address"),
                            subtitle: Text(
                                '$Place_, $Post_, $District_, $State_'),
                            leading: Icon(Icons.map),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // Positioned(
              //   top: 60,
              //   left: 20,
              //   child: MaterialButton(
              //     minWidth: 0.2,
              //     elevation: 0.2,
              //     color: Colors.white,
              //     child: const Icon(Icons.arrow_back_ios_outlined,
              //         color: Colors.indigo),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30.0),
              //     ),
              //     onPressed: () {},
              //   ),
              // ),
            ],
          ),
        ),





        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 224, 173, 41),
                ),
                child:
                Column(children: [

                  Text(
                    'BioAttendManager',
                    style: TextStyle(fontSize: 20,color: Colors.white),

                  ),
                  CircleAvatar(radius: 29,backgroundImage: NetworkImage(Photo_)),
                  Text(Name_,style: TextStyle(color: Colors.white)),



                ])


                ,
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeNew(),));
                },
              ),
              ListTile(
                leading: Icon(Icons.person_pin),
                title: const Text(' View Profile '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage(title: 'View Profile',),));
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.person_pin_outlined),
              //   title: const Text(' View Staff '),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => ViewStaffPage(title: "View Staff",),));
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.book_outlined),
                title: const Text(' Add Courses '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddServicesTemp(title: "Add Courses",),));
                },
              ),
              ListTile(
                leading: Icon(Icons.book_outlined),
                title: const Text(' View Courses '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewServicesPage(title: "View Courses",),));
                },
              ),
              ListTile(
                leading: Icon(Icons.book_outlined),
                title: const Text(' Send Leave Request '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SendLeavePage(title: "Send Leave Request",),));
                },
              ),
              ListTile(
                leading: Icon(Icons.note_alt_rounded),
                title: const Text(' Change Password '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyChangePasswordPage(title: "Change Password",),));
                },
              ),
              ListTile(
                leading: Icon(Icons.medical_services_outlined),
                title: const Text(' Leave Request Status '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveStatusPage(title: "View Leave Request Status",),));
                },
              ),


              ListTile(
                leading: Icon(Icons.local_pharmacy),
                title: const Text(' View Attendance History '),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAttendancePage(title: '',),));
                },

              ),


              ListTile(
                leading: Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreenPage(),));
                },
              ),

            ],
          ),
        ),





      ),
    );
  }




}
