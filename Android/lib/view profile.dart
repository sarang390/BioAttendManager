

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'edit profile.dart';
import 'homepage.dart';




void main() {
  runApp(const MyProfile());
}

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:  (title: 'Sent Complaint'),
    );
  }
}


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title});


  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}
class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    senddata();
  }



  String Name_="Name";
  String Age_="Age";
  String Gender_="Gender";
  String Place_="Place";
  String Post_="Post";
  String District_="District";
  String State_="State";
  String Email_="Email";
  String Phone_="Phone";
  String Photo_="Photo";
  String DEPARTMENT_="DEPARTMENT";




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeNewPage (title: 'Home',),));

        return false;

      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
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
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            ' $Name_',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          // Text(
                                          //   '$email',
                                          //   style: Theme.of(context)
                                          //       .textTheme
                                          //       .bodyText1,
                                          // ),
                                          SizedBox(
                                            height: 40,
                                          )
                                        ],
                                      ),
                                      Spacer(),

                                      CircleAvatar(
                                        backgroundColor: Colors.blueAccent,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(title: 'Edit Profile',),));
                                            },
                                            icon: Icon(
                                              Icons.edit_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(height: 10.0),
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
                              image:  DecorationImage(
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
                        children:  [


                          ListTile(
                            title: Text('Department'),
                            subtitle: Text(DEPARTMENT_),
                            leading: Icon(Icons.description),
                          ),
                          ListTile(
                            title: Text('Email'),
                            subtitle: Text(Email_),
                            leading: Icon(Icons.mail_outline),
                          ),
                          ListTile(
                            title: Text("Phone"),
                            subtitle: Text(Phone_),
                            leading: Icon(Icons.phone),
                          ),
                          ListTile(
                            title: Text('Adress'),
                            subtitle: Text( '${Place_}, ${Post_}, ${District_}, ${State_}  '),
                            leading: Icon(Icons.location_city),
                          ),





                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 60,
                left: 20,
                child: MaterialButton(
                  minWidth: 0.2,
                  elevation: 0.2,
                  color: Colors.white,
                  child: const Icon(Icons.arrow_back_ios_outlined,
                      color: Colors.indigo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeNewPage (title: '',),));



                  },
                ),
              ),

            ],

          ),

        ),

      ),
    );
  }


  void senddata()async{



    SharedPreferences sh=await SharedPreferences.getInstance();
    String url=sh.getString('url').toString();
    String lid=sh.getString('lid').toString();
    final urls=Uri.parse(url+"/staff_view_profile/");
    try{
      final response=await http.post(urls,body:{
        'lid':lid,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {


          setState(() {
            Name_=jsonDecode(response.body)['Name'].toString();
            Age_=jsonDecode(response.body)['Age'].toString();
            Gender_=jsonDecode(response.body)['Gender'].toString();
            Email_=jsonDecode(response.body)['Email'].toString();
            Phone_=jsonDecode(response.body)['Phone'].toString();
            Post_=jsonDecode(response.body)['Post'].toString();
            Place_=jsonDecode(response.body)['Place'].toString();
            District_=jsonDecode(response.body)['District'].toString();
            State_=jsonDecode(response.body)['State'].toString();
            DEPARTMENT_=jsonDecode(response.body)['DEPARTMENT'].toString();
            Photo_=sh.getString('img_url').toString()+jsonDecode(response.body)['Photo'];







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

}