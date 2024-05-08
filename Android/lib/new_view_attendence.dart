import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ViewAttendance());
}

class ViewAttendance extends StatelessWidget {
  const ViewAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewAttendancePage(title: 'View Attendance'),
    );
  }
}

class ViewAttendancePage extends StatefulWidget {
  const ViewAttendancePage({super.key, required this.title});
  final String title;

  @override
  State<ViewAttendancePage> createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  List<AttendanceRecord> records = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }
  // Future<void> fetchAttendanceData() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String url = prefs.getString('url') ?? '';
  //     String lid = prefs.getString('lid') ?? '';
  //     var response = await http.post(Uri.parse('$url/staff_attendance_history/'), body: {'lid': lid});
  //
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = jsonDecode(response.body);
  //       print(data);
  //       List<AttendanceRecord> tempRecords = [];
  //
  //       for (var item in data) {
  //         for (var record in item) {
  //           tempRecords.add(AttendanceRecord.fromList(record));
  //         }
  //       }
  //
  //       setState(() {
  //         records = tempRecords;
  //       });
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print("Error: ${e.toString()}");
  //   }
  // }

  Future<void> fetchAttendanceData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String url = prefs.getString('url') ?? '';
      String lid = prefs.getString('lid') ?? '';
      var response = await http.post(Uri.parse('$url/staff_attendance_history/'), body: {'lid': lid});

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        print("abcd");
        print(data);
        for (var item in data) {
          for (var record in item) {
            setState(() {
              records.add(AttendanceRecord.fromList(record));
            });
          }
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Check-in AM')),
            DataColumn(label: Text('Check-out AM')),
            DataColumn(label: Text('Check-in PM')),
            DataColumn(label: Text('Check-out PM')),
            // DataColumn(label: Text('Total Time')),
          ],
          rows: records.map((record) => DataRow(cells: [
            DataCell(Text(record.date)),
            DataCell(Text(record.checkInAM)),
            DataCell(Text(record.checkOutAM)),
            DataCell(Text(record.checkInPM)),
            DataCell(Text(record.checkOutPM)),
            // DataCell(Text(record.time)),
          ])).toList(),
        ),
      ),
    );
  }
}

class AttendanceRecord {
  final String date;
  final String checkInAM;
  final String checkOutAM;
  final String checkInPM;
  final String checkOutPM;
  final String time;

  AttendanceRecord({
    required this.date,
    required this.checkInAM,
    required this.checkOutAM,
    required this.checkInPM,
    required this.checkOutPM,
    required this.time,
  });

  factory AttendanceRecord.fromList(List<dynamic> data) {
    // Ensure there's enough data in the list to avoid index errors
    return AttendanceRecord(
      date: data[0] ?? 'NA',
      checkInAM: data[1] ?? 'NA',
      checkOutAM: data.length > 2 ? data[2] : 'NA',
      checkInPM: data.length > 3 ? data[3] : 'NA',
      checkOutPM: data.length > 4 ? data[4] : 'NA',
      time: 'NA', // Assign 'NA' if there's no field for time in this dataset
    );
  }
}
