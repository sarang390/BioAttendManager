// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:staff_management/utils/appcolors.dart';
// import 'package:staff_management/widgets/apptext.dart';
//
// import 'homepage.dart';
// void main() {
//   runApp(const ViewAttendance());
// }
//
// class ViewAttendance extends StatelessWidget {
//   const ViewAttendance({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const ViewAttendancePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class ViewAttendancePage extends StatefulWidget {
//   const ViewAttendancePage({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<ViewAttendancePage> createState() => _ViewAttendanceState();
// }
//
// class _ViewAttendanceState extends State<ViewAttendancePage> {
//
//   _ViewAttendanceState() {
//     view_notification2();
//   }
//
//   List<String> id_ = <String>[];
//   List<String> Date_ = <String>[];
//   List<String> Attendance_ = <String>[];
//   // List<String> Type_ = <String>[];
//   List<String> Time_ = <String>[];
//
//    List<AttendanceRecord> records = [
//     AttendanceRecord(
//         date: '2024-04-23',
//         checkInAM: '09:00',
//         checkOutAM: '12:00',
//         checkInPM: '13:00',
//         checkOutPM: '18:00',
//         time: '8h'
//     ),
//     // Additional records can be added here
//   ];
//
//
//
//   Future<void> view_notification2() async {
//     List<String> id = <String>[];
//     List<String> Date = <String>[];
//     List<String> Attendance = <String>[];
//     // List<String> Type = <String>[];
//     List<String> Time = <String>[];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String url = sh.getString('url').toString();
//       String lid = sh.getString('lid').toString();
//       // String img_url = sh.getString('img_url').toString();
//       String urls = '$url/staff_attendance_history/';
//
//       var data = await http.post(Uri.parse(urls), body: {
//         'lid':lid
//
//         // 'search':sh.getString("date")
//       });
//       var jsondata = json.decode(data.body);
//       String statuss = jsondata['status'];
//
//       var arr = jsondata["data"];
//
//       print(arr.length);
//
//       final List<AttendanceRecord> records_ = [
//
//       ];
//       for (int i = 0; i < arr.length; i++) {
//         id.add(arr[i]['id'].toString());
//         Date.add(arr[i]['Date'].toString());
//         Attendance.add(arr[i]['Attendance'].toString());
//         // Type.add(arr[i]['Type'].toString());
//         Time.add(arr[i]['Time'].toString());
//         AttendanceRecord(
//             date: arr[i]['Date'].toString(),
//             checkInAM: arr[i]['Attendance'].toString(),
//             checkOutAM: arr[i]['Attendance'].toString(),
//             checkInPM: arr[i]['Attendance'].toString(),
//             checkOutPM: arr[i]['Attendance'].toString(),
//             time: arr[i]['Time'].toString()
//         );
//     // Additional records can be added here
//       }
//
//       setState(() {
//         id_ = id;
//         Date_ = Date;
//         Attendance_ = Attendance;
//         // Type_ = Type;
//         Time_ = Time;
//
//
//       });
//
//       print(statuss);
//     } catch (e) {
//       print("Error ------------------- " + e.toString());
//       //there is error during converting file image to base64 encoding.
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeNewPage(title: '')),
//               );
//             },
//           ),
//           backgroundColor: AppColors.primaryColor,
//           title: const AppText(
//             text: "View Attendance",
//             fontSize: 18.0,
//             color: AppColors.blackColor,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         body:
//         ListView.builder(
//           physics: BouncingScrollPhysics(),
//           // padding: EdgeInsets.all(5.0),
//           // shrinkWrap: true,
//           itemCount: id_.length,
//           itemBuilder: (BuildContext context, int index) {
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('Check-in AM')),
//                   DataColumn(label: Text('Check-out AM')),
//                   DataColumn(label: Text('Check-in PM')),
//                   DataColumn(label: Text('Check-out PM')),
//                   // DataColumn(label: Text('Total Time')),
//                 ],
//                 rows: records.map((AttendanceRecord record) => DataRow(cells: [
//                   DataCell(Text(record.date)),
//                   DataCell(Text(record.checkInAM)),
//                   DataCell(Text(record.checkOutAM)),
//                   DataCell(Text(record.checkInPM)),
//                   DataCell(Text(record.checkOutPM)),
//                   // DataCell(Text(record.time)),
//                 ])).toList(),
//               ),
//             );
//             //   SingleChildScrollView(
//             //   scrollDirection: Axis.horizontal,
//             //   child:                 Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start, // Align all children to the left side
//             //     children: [
//             //       Row(
//             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //         children: [
//             //           Text(
//             //             "Date :",
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //           Text(
//             //             Date_[index],
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //
//             //         ],
//             //       ),
//             //       Row(
//             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //         children: [
//             //           Text(
//             //             "Attendance :",
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //           Text(
//             //             Attendance_[index],
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //
//             //         ],
//             //       ),
//             //       Row(
//             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //         children: [
//             //           Text(
//             //             "Time :",
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //           Text(
//             //             Time_[index],
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //             ),
//             //           ),
//             //
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             //
//             //     // DataTable(
//             //   //   columns: const [
//             //   //     DataColumn(label: Text('Date')),
//             //   //     DataColumn(label: Text('Check-in AM')),
//             //   //     DataColumn(label: Text('Check-out AM')),
//             //   //     DataColumn(label: Text('Check-in PM')),
//             //   //     DataColumn(label: Text('Check-out PM')),
//             //   //     DataColumn(label: Text('Total Time')),
//             //   //   ],
//             //   //   rows: records.map((record) => DataRow(cells: [
//             //   //     DataCell(Text(Date_[index])),
//             //   //     // DataCell(Text(record.checkInAM)),
//             //   //     // DataCell(Text(record.checkOutAM)),
//             //   //     // DataCell(Text(record.checkInPM)),
//             //   //     // DataCell(Text(record.checkOutPM)),
//             //   //     // DataCell(Text(record.time)),
//             //   //   ])).toList(),
//             //   //
//             //   // ),
//             // );
//             //   Card(
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(8.0),
//             //     child:
//             //   ),
//             // );
//
//           },
//         )
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//
// }
// class AttendanceRecord {
//   final String date;
//   final String checkInAM;
//   final String checkOutAM;
//   final String checkInPM;
//   final String checkOutPM;
//   final String time;
//
//   AttendanceRecord({
//     required this.date,
//     required this.checkInAM,
//     required this.checkOutAM,
//     required this.checkInPM,
//     required this.checkOutPM,
//     required this.time,
//   });
// }