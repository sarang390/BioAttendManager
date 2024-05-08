import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:staff_management/utils/appcolors.dart';
import 'package:staff_management/view%20profile.dart';
import 'package:staff_management/widgets/apptext.dart';

import 'homepage.dart';
import 'login.dart';


void main() {
  runApp(const EditProfile());
}

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EditProfilePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.title});



  final String title;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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


  String upic='';
  _EditProfilePageState(){
    getdata();
    senddata1();

  }

  void senddata1() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String img_url = sh.getString('img_url').toString();
    String lid = sh.getString('lid').toString();

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
          String genders=jsonDecode(response.body)['Gender'].toString();
          String Place=jsonDecode(response.body)['Place'].toString();
          String Post=jsonDecode(response.body)['Post'].toString();
          String District=jsonDecode(response.body)['District'].toString();
          String State=jsonDecode(response.body)['State'].toString();
          String Email=jsonDecode(response.body)['Email'].toString();
          String Phone=jsonDecode(response.body)['Phone'].toString();
          String Photo=img_url+jsonDecode(response.body)['Photo'].toString();
          String DEPARTMENT=jsonDecode(response.body)['DEPARTMENT'].toString();

          setState(() {

            namecontroller.text= Name;
            agecontroller.text= Age;
            gender= genders;
            placecontroller.text= Place;
            postcontroller.text= Post;
            districtcontroller.text= District;
            statecontroller.text= State;
            emailcontroller.text= Email;
            phonecontroller.text= Phone;
            upic= Photo;
            dropdownValue1 = DEPARTMENT;
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const AppText(
          text: "Edit Profile",
          fontSize: 18.0,
          color: AppColors.blackColor,
          overflow: TextOverflow.ellipsis,
        ),
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
                      Image(image: NetworkImage(upic),height: 200,width: 200,),
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
              ),RadioListTile(value: "Male", groupValue: gender, onChanged: (value) { setState(() {gender="Male";}); },title: Text("Male"),),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Enter Your Phone Number";
                      }
                      return null;
                    },
                    controller: phonecontroller,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),label: Text("Phone"))),
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

                }, child: Text("Submit"))
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




    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();


    final urls = Uri.parse('$url/staff_edit_profile/');
    try {
      final response = await http.post(urls, body: {
        'lid':lid,
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
        // 'lid':sh.getString('lid').toString(),
        'department': department_id_[department_name_.indexOf(dropdownValue1)].toString()



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          Fluttertoast.showToast(msg: 'updated');

          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfilePage(title: 'view profile',)));

          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => MyLoginPage(title: "Home"),));
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
