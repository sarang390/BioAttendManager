import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/appcolors.dart';
import '../widgets/apptext.dart';
import '../widgets/expanded_button_widget.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'logintemp/logintemplate.dart';

class MyChangePasswordPage extends StatefulWidget {
  const MyChangePasswordPage({super.key, required this.title});

  final String title;

  @override
  State<MyChangePasswordPage> createState() => _MyChangePasswordPageState();
}

class _MyChangePasswordPageState extends State<MyChangePasswordPage> {
  final oldpasswordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final cnfmpasswordController = TextEditingController();

  final formkey=GlobalKey<FormState>();


  String name = '';
  // final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  // final DateFormat _dateFormatter1 = DateFormat('yyyy-MM-dd');

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       fromdatecontroller.text = _dateFormatter.format(picked);
  //     });
  //   }
  // }
  // Future<void> _selectDate1(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       todatecontroller.text = _dateFormatter1.format(picked);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
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
            text: "Change Password",
            fontSize: 18.0,
            color: AppColors.blackColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child:
          Form(
            key: formkey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 20),
                const Row(
                  children: [
                    // AppText(
                    //   text: "ServiceName",
                    //   fontSize: 12.0,
                    //   color: AppColors.blackColor,
                    //   overflow: TextOverflow.ellipsis,
                    //   fontWeight: FontWeight.normal,
                    // ),
                    Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Current Password";
                    }
                    return null;
                  },
                  controller: oldpasswordController,
                  obscureText:true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Current Password',
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    // AppText(
                    //   text: "FromDate",
                    //   fontSize: 12.0,
                    //   color: AppColors.blackColor,
                    //   overflow: TextOverflow.ellipsis,
                    //   fontWeight: FontWeight.normal,
                    // ),
                    Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter New Password";
                    }
                    return null;
                  },
                  controller: newpasswordController,
                  obscureText:true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'New Password',
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    // AppText(
                    //   text: "FromDate",
                    //   fontSize: 12.0,
                    //   color: AppColors.blackColor,
                    //   overflow: TextOverflow.ellipsis,
                    //   fontWeight: FontWeight.normal,
                    // ),
                    Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter New Password again";
                    }
                    return null;
                  },
                  controller: cnfmpasswordController,
                  obscureText:true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Confirm Password',
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 20),
                ExpandedButton(
                  buttonColor: AppColors.primaryColor.withOpacity(1),
                  onPressed: () async {
                    if(formkey.currentState!.validate()) {
                      _sendData();
                    }
                  },
                  child: const AppText(
                    text: "Submit",
                    fontSize: 18.0,
                    color: AppColors.blackColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendData() async {
    String oldp = oldpasswordController.text;
    String newp = newpasswordController.text;
    String cnfmp = cnfmpasswordController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/staff_change_pswd/');
    try {
      final response = await http.post(urls, body: {
        'oldpassword': oldp,
        'newpassword': newp,
        'cnfmpassword': cnfmp,
        'lid': sh.getString('lid').toString(),
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreenPage()),
          );
        }
        else if(status=='no'){
          Fluttertoast.showToast(msg: 'Invalid password');
        }
        else if(status=='ano'){
          Fluttertoast.showToast(msg: 'Password do not match');
        }
        else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
