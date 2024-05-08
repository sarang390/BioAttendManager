

import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/appcolors.dart';
import '../widgets/apptext.dart';
import '../widgets/expanded_button_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddServicesTemp extends StatefulWidget {
  const AddServicesTemp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddServicesTemp> createState() => _AddServicesTempState();
}

class _AddServicesTempState extends State<AddServicesTemp> {
  final servicenamecontroller = TextEditingController();
  final fromdatecontroller = TextEditingController();
  final todatecontroller = TextEditingController();
  final durationcontroller = TextEditingController();

  final formkey=GlobalKey<FormState>();


  String name = '';
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  final DateFormat _dateFormatter1 = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fromdatecontroller.text = _dateFormatter.format(picked);
      });
    }
  }
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        todatecontroller.text = _dateFormatter1.format(picked);
      });
    }
  }

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
            text: "Add Courses",
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 5,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Service Name";
                    }
                    return null;
                  },
                  controller: servicenamecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    labelText: 'Service Name',
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
                const SizedBox(height: 5,),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please Enter From Date";
                        }
                        return null;
                      },
                      controller: fromdatecontroller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range_outlined),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: 'From Date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    // AppText(
                    //   text: "ToDate",
                    //   fontSize: 12.0,
                    //   color: AppColors.blackColor,
                    //   overflow: TextOverflow.ellipsis,
                    //   fontWeight: FontWeight.normal,
                    // ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 5,),
                GestureDetector(
                  onTap: () {
                    _selectDate1(context);
                  },
                  child: AbsorbPointer(
                    child:
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please Enter To Date";
                        }
                        return null;
                      },
                      controller: todatecontroller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: 'To Date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    // AppText(
                    //   text: "Duration",
                    //   fontSize: 12.0,
                    //   color: AppColors.blackColor,
                    //   overflow: TextOverflow.ellipsis,
                    //   fontWeight: FontWeight.normal,
                    // ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 5,),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Duration";
                    }
                    return null;
                  },
                  controller: durationcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    labelText: 'Duration',
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
    String serviceName = servicenamecontroller.text;
    String fromDate = fromdatecontroller.text;
    String toDate = todatecontroller.text;
    String duration = durationcontroller.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/add_services/');
    try {
      final response = await http.post(urls, body: {
        'servicename': serviceName,
        'fromdate': fromDate,
        'todate': toDate,
        'duration': duration,
        'certificate':photo,
        'lid': sh.getString('lid').toString(),
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeNewPage(title: "Home")),
          );
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
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
}
