import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';
import 'login.dart';


void main() {
  runApp(const NewRegister());
}

class NewRegister extends StatelessWidget {
  const NewRegister({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NewRegisterPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class NewRegisterPage extends StatefulWidget {
  const NewRegisterPage({super.key, required this.title});



  final String title;

  @override
  State<NewRegisterPage> createState() => _NewRegisterPageState();
}

class _NewRegisterPageState extends State<NewRegisterPage> {
  File? uploadimage;
  String gender = "Male";

  final namecontroller=TextEditingController();
  final agecontroller=TextEditingController();
  // final gendercontroller=TextEditingController();
  final placecontroller=TextEditingController();
  final postcontroller=TextEditingController();
  final districtcontroller=TextEditingController();
  final statecontroller=TextEditingController();
  final emailcontroller=TextEditingController();
  final phonecontroller=TextEditingController();
  final photocontroller=TextEditingController();
  final departmentcontroller=TextEditingController();
  final passwordcontroller=TextEditingController();
  final cnfrmpasswordpasswordcontroller=TextEditingController();

  final formkey=GlobalKey<FormState>();

  _NewRegisterPageState(){
    getdata();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(

        child: Form(
          key: formkey,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Name";
                      }
                      return null;
                    },
                    controller: namecontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Name"))),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Age";
                      }
                      return null;
                    },
                    controller: agecontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Age"))),
              ),
              RadioListTile(value: "Male", groupValue: gender, onChanged: (value) { setState(() {gender="Male";}); },title: Text("Male"),),
              RadioListTile(value: "Female", groupValue: gender, onChanged: (value) { setState(() {gender="Female";}); },title: Text("Female"),),
              RadioListTile(value: "Other", groupValue: gender, onChanged: (value) { setState(() {gender="Other";}); },title: Text("Other"),), Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Place";
                      }
                      return null;
                    },
                    controller: placecontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Place"))),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Post";
                      }
                      return null;
                    },
                    controller: postcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Post"))),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your District";
                      }
                      return null;
                    },
                    controller: districtcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("District"))),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your State";
                      }
                      return null;
                    },
                    controller: statecontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("State"))),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Email id";
                      }
                      return null;
                    },
                    controller: emailcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Email"))),
              ), Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Please Enter Your Phone Number";
                  }
                  // Regular expression to match exactly 10 digits
                  RegExp regex = RegExp(r'^[6-9][0-9]{9}$');
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
                controller: phonecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    label: Text("Phone")
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //       validator: (value){
              //         if(value!.isEmpty){
              //           return "Please Enter Your Phone Number";
              //         }
              //         return null;
              //       },
              //       controller: phonecontroller,
              //       decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Phone"))),
              // ),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Password";
                      }
                      return null;
                    },
                    controller: passwordcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Password"))),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Confirm Password";
                      }
                      return null;
                    },
                    controller: cnfrmpasswordpasswordcontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Confirm Password"))),
              ),
              DropdownButton<String>(
          // isExpanded: true,
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
              ElevatedButton(onPressed: (){
                if(formkey.currentState!.validate()) {
                  _send_data();
                }

                }, child: Text("Submitt"))
            ],
          ),
        ),
      ),

    );
  }
  void _send_data() async{


    String name=namecontroller.text;
    String age=agecontroller.text;
    // String gender=gendercontroller.text;
    String place=placecontroller.text;
    String post=postcontroller.text;
    String district=districtcontroller.text;
    String state=statecontroller.text;
    String email=emailcontroller.text;
    String phone=phonecontroller.text;
    String photo=photocontroller.text;
    String department=departmentcontroller.text;
    String password=passwordcontroller.text;
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
            builder: (context) => MyLoginPage(title: "Home"),));
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

  String photo = '';
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
