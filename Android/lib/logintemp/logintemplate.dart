// import 'package:flutter/material.dart';
//
// import 'components/login_body.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: LoginScreenPage(),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/new%20register.dart';

import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../../homepage.dart';
import '../forgotpswd.dart';
import '../signup/sign_up.dart';



class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  // final emailController = TextEditingController();

  final formkey=GlobalKey<FormState>();


  // void signUserIn() async {
  //   try {
  //     // Masuk menggunakan email dan password
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordcontroller.text);
  //   } on FirebaseAuthException catch (e) {
  //     showErrorMessage(e.code);
  //   }
  // }

  // void showErrorMessage(String message) {
  //   // Tampilkan dialog dengan pesan error
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(message),
  //         );
  //       });
  // }

  String _errorMessage = "";

  // void validateEmail(String val) {
  //   if (val.isEmpty) {
  //     // Validasi jika email kosong
  //     setState(() {
  //       _errorMessage = "Enter email";
  //     });
  //   } else if (!EmailValidator.validate(val, true)) {
  //     // Validasi jika email tidak valid
  //     setState(() {
  //       _errorMessage = "Email is incorrect";
  //     });
  //   } else {
  //     setState(() {
  //       _errorMessage = "";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 535,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: HexColor("#ffffff"),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Log In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#4f4f4f"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: HexColor("#8d8d8d"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    TextFormField(
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Please Enter Username";
                                        }
                                        return null;
                                      },
                                      controller: usernamecontroller,
                                      cursorColor: HexColor("#4f4f4f"),
                                      decoration: InputDecoration(
                                        hintText: "email",
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
                                        prefixIcon: Icon(Icons.mail),
                                        prefixIconColor: HexColor("#4f4f4f"),
                                        filled: true,
                                      ),
                                    ),

                                    Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                        child: Text(
                                          _errorMessage,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Password",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: HexColor("#8d8d8d"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        validator: (value){
                                          if(value!.isEmpty){
                                            return "Please Enter Password";
                                          }
                                          return null;
                                        },
                                        controller: passwordcontroller,
                                        obscureText: true,
                                        cursorColor: HexColor("#4f4f4f"),
                                        decoration: InputDecoration(
                                          hintText: "password",
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
                                          prefixIcon: Icon(Icons.lock),
                                          prefixIconColor: HexColor("#4f4f4f"),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    GestureDetector(
                                      onTap: () async {
                                        if(formkey.currentState!.validate()) {
                                          String uname = usernamecontroller
                                              .text;
                                          String password = passwordcontroller
                                              .text;

                                          SharedPreferences sh = await SharedPreferences
                                              .getInstance();
                                          String url = sh.getString('url')
                                              .toString();

                                          final urls = Uri.parse(
                                              '$url/staff_login/');
                                          try {
                                            final response = await http.post(
                                                urls, body: {
                                              'name': uname,
                                              'password': password,


                                            });
                                            if (response.statusCode == 200) {
                                              String status = jsonDecode(
                                                  response.body)['status'];
                                              if (status == 'ok') {
                                                String lid = jsonDecode(
                                                    response.body)['lid'];
                                                sh.setString("lid", lid);

                                                Navigator.push(
                                                    context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeNewPage(
                                                          title: "Home"),));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'Not Found');
                                              }
                                            }
                                            else {
                                              Fluttertoast.showToast(
                                                  msg: 'Network Error');
                                            }
                                          }
                                          catch (e) {
                                            Fluttertoast.showToast(
                                                msg: e.toString());
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                                          height: 55,
                                          width: 275,
                                          decoration: BoxDecoration(
                                            color: HexColor('#44564a'),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            "Login",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                        child: Row(
                                          children: [
                                            Text("Can't sign in ?",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: HexColor("#8d8d8d"),
                                                )),
                                            TextButton(
                                              child: Text(
                                                "Register",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: HexColor("#44564a"),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                      const SignUpBodyScreen(),
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                        child: Row(
                                          children: [
                                            Text("Forgot password ?",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: HexColor("#8d8d8d"),
                                                )),
                                            TextButton(
                                              child: Text(
                                                "Click to Reset",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: HexColor("#44564a"),
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ForgotPassword(title: '',),
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
                      Transform.translate(
                        offset: const Offset(0, -253),
                        child: Image.asset(
                          'assets/plants2.png',
                          scale: 1.5,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
