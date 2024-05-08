import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: unused_import
import 'package:staff_management/components/my_button.dart';
import 'package:staff_management/controller/flow_controller.dart';
import 'package:staff_management/controller/sign_up_controller.dart';
import 'package:staff_management/logintemp/logintemplate.dart';

import '../../login/login.dart';

List<String> list = <String>['Pembaca', 'Penulis'];

class SignUpOne extends StatefulWidget {
  const SignUpOne({super.key});

  @override
  State<SignUpOne> createState() => _SignUpOneState();
}

class _SignUpOneState extends State<SignUpOne> {
  _SignUpOneState(){
    getdata();
  }
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namecontroller = TextEditingController();
  final agecontroller=TextEditingController();
  final placecontroller=TextEditingController();
  final postcontroller=TextEditingController();
  final districtcontroller=TextEditingController();
  // final gendercontroller=TextEditingController();
  final statecontroller=TextEditingController();
  final phonecontroller=TextEditingController();
  final photocontroller=TextEditingController();
  final departmentcontroller=TextEditingController();
  final cnfrmpasswordpasswordcontroller=TextEditingController();

  final formkey=GlobalKey<FormState>();

  // SignUpController signUpController = Get.put(SignUpController());
  // FlowController flowController = Get.put(FlowController());

  String dropdownValue = list.first;
  String _errorMessage = "";
  String gender = "";
  File? uploadimage;

  @override
  Widget build(BuildContext context) {
    // debugPrint(signUpController.userType);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.offAll(() => const LoginScreen());
                    //   },
                    //   child: const Icon(
                    //     Icons.arrow_back,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    const SizedBox(
                      width: 27,
                    ),
                    Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#4f4f4f"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Type Dropdown
                      // Text(
                      //   "User Type",
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 16,
                      //     color: HexColor("#8d8d8d"),
                      //   ),
                      // ),
                      // DropdownButton<String>(
                      //   value: dropdownValue,
                      //   icon: const Icon(Icons.arrow_drop_down),
                      //   elevation: 16,
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 15,
                      //     color: HexColor("#8d8d8d"),
                      //   ),
                      //   isExpanded: true,
                      //   underline: Container(
                      //     height: 2,
                      //     color: HexColor("#ffffff"),
                      //   ),
                      //   iconSize: 30,
                      //   borderRadius: BorderRadius.circular(20),
                      //   onChanged: (String? value) {
                      //     setState(() {
                      //       dropdownValue = value!;
                      //       signUpController.setUserType(value);
                      //     });
                      //   },
                      //   items: list.map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                      // const SizedBox(
                      //   height: 1,
                      // ),
                      // Email Input
                      Text(
                        "Name",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                        controller: namecontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Age",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Age";
                          }
                          return null;
                        },
                        controller: agecontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      Text(
                        "Photo",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      if (_selectedImage != null) ...{
                        InkWell(
                          child:
                          Image.file(_selectedImage!, height: 400,),
                          radius: 399,
                          onTap: _checkPermissionAndChooseImage,
                          // borderRadius: BorderRadius.all(Radius.circular(200)),
                        ),
                      } else ...{
                        // Image(image: NetworkImage(),height: 100, width: 70,fit: BoxFit.cover,),
                        InkWell(
                          onTap: _checkPermissionAndChooseImage,
                          child:Column(
                            children: [
                              Image(image: NetworkImage('https://cdn.pixabay.com/photo/2017/11/10/05/24/select-2935439_1280.png'),height: 200,width: 200,),
                              Text('Select Image',style: TextStyle(color: Colors.cyan))
                            ],
                          ),
                        ),
                      },
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Gender",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RadioListTile(value: "Male", groupValue: gender, onChanged: (value) { setState(() {gender="Male";}); },title: Text("Male"),),
                      RadioListTile(value: "Female", groupValue: gender, onChanged: (value) { setState(() {gender="Female";}); },title: Text("Female"),),
                      RadioListTile(value: "Other", groupValue: gender, onChanged: (value) { setState(() {gender="Other";}); },title: Text("Other"),),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Place",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Place";
                          }
                          return null;
                        },
                        controller: placecontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Post",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Post";
                          }
                          return null;
                        },
                        controller: postcontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "District",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your District";
                          }
                          return null;
                        },
                        controller: districtcontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "State",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your State";
                          }
                          return null;
                        },
                        controller: statecontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Phone",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Phone Number";
                          }
                          RegExp regex = RegExp(r'^[0-9]{10}$');
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                        controller: phonecontroller,
                        onChanged: (value) {
                          // validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Department",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // TextField(
                      //   controller: departmentcontroller.value,
                      //   onChanged: (value) {
                      //     // validateEmail(value);
                      //     // signUpController.setEmail(value);
                      //   },
                      //   onSubmitted: (value) {
                      //     signUpController.setEmail(value);
                      //   },
                      //   cursorColor: HexColor("#4f4f4f"),
                      //   decoration: InputDecoration(
                      //     fillColor: HexColor("#f0f3f1"),
                      //     contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      //     hintStyle: GoogleFonts.poppins(
                      //       fontSize: 15,
                      //       color: HexColor("#8d8d8d"),
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //     filled: true,
                      //   ),
                      // ),
                      Center(
                        child: DropdownButton<String>(
                        isExpanded: true,
                          value: dropdownValue1,
                          onChanged: (String? value) {
                            print(dropdownValue1);
                            print("Hiiii");
                            setState(() {
                              dropdownValue1 = value!;
                            });
                          },
                          items: department_name_.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                        // backgroundColor: Colors.brown,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: Text(
                      //     _errorMessage,
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 12,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Email id";
                          }
                          return null;
                        },
                        controller: emailController,
                        onChanged: (value) {
                          validateEmail(value);
                          // signUpController.setEmail(value);
                        },
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          hintText: "hello@gmail.com",
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          _errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Password Input
                      Text(
                        "Password",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // signUpController.setPassword(value);
                        },
                        obscureText: true,
                        controller: passwordController,
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          // hintText: "*************",
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          focusColor: HexColor("#44564a"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Confirm Password",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: HexColor("#8d8d8d"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Password again";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // signUpController.setPassword(value);
                        },
                        obscureText: true,
                        controller: cnfrmpasswordpasswordcontroller,
                        cursorColor: HexColor("#4f4f4f"),
                        decoration: InputDecoration(
                          // hintText: "*************",
                          fillColor: HexColor("#f0f3f1"),
                          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          focusColor: HexColor("#44564a"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Proceed Button
                      MyButton(
                        buttonText: 'Submit',
                        onPressed: () async {
                          if(formkey.currentState!.validate()) {
                            _send_data();
                          }


                          String name=namecontroller.text;
                          String age=agecontroller.text;
                          // String gender=gendercontroller.text;
                          String place=placecontroller.text;
                          String post=postcontroller.text;
                          String district=districtcontroller.text;
                          String state=statecontroller.text;
                          String email=emailController.text;
                          String phone=phonecontroller.text;
                          // String photo=photocontroller.toString();
                          String department=departmentcontroller.text;
                          String password=passwordController.text;
                          String confirmpassword=cnfrmpasswordpasswordcontroller.text;




                          SharedPreferences sh = await SharedPreferences.getInstance();
                          String url = sh.getString('url').toString();

                          final urls = Uri.parse('$url/new_register/');
                          try {
                            final response = await http.post(urls, body: {
                              'name':name,
                              'age':age,
                              'gender':gender,
                              'place':place,
                              'post':post,
                              'district':district,
                              'state':state,
                              'email':email,
                              'phone':phone,
                              'photo':photo,
                              'password':password,
                              'cnfrmpassword':confirmpassword,
                              'lid':sh.getString('lid').toString(),
                              'department': department_id_[department_name_.indexOf(dropdownValue1)].toString()



                            });
                            if (response.statusCode == 200) {
                              String status = jsonDecode(response.body)['status'];
                              if (status=='ok') {

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LoginScreenPage(),));
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
                        },
                      ),
                      // Login Navigation
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              "Already have an account?",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: HexColor("#8d8d8d"),
                              ),
                            ),
                            TextButton(
                              child: Text(
                                "Log In",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: HexColor("#44564a"),
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  LoginScreenPage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _send_data() async{



  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
  String photo="";
  File? _selectedImage;
  String? _encodedImage;
  Future<void> _chooseAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _encodedImage = base64Encode(_selectedImage!.readAsBytesSync());
        photo = _encodedImage.toString();
      });
    }
  }

  Future<void> _checkPermissionAndChooseImage() async {
    final PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      _chooseAndUploadImage();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Please go to app settings and grant permission to choose an image.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<int> department_id_ = <int>[];
  List<String> department_name_ = <String>[];
  String dropdownValue1 = "";

  void getdata() async {
    List<int> department_id = <int>[];
    List<String> department_name = <String>[];

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    final urls = Uri.parse('$url/View_stud_dep/');

    var data = await http.post(urls, body: {});
    var jsondata = json.decode(data.body);
    String status = jsondata['status'];

    var arr = jsondata["data"];

    for (int i = 0; i < arr.length; i++) {
      department_id_.add(arr[i]['id']);
      department_name_.add(arr[i]['dep_name']);
    }
    setState(() {
      department_id_ = department_id_;
      department_name_ = department_name_;
      dropdownValue1 = department_name_.first;
    });
  }

}
