import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/lab_model.dart';
import 'package:diabo/services/lab_service.dart';
import 'package:diabo/widgets/line_chart_lab_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({super.key});

  @override
  _TestResultsScreenState createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  // ตัวแปรที่เก็บ index ของแท็บที่เลือก
  final LabService _labService = LabService();
  late Future<List<LabModel>> _labsFuture;
  List<FlSpot> spots1 = [];
  List<FlSpot> spots2 = [];

  @override
  void initState() {
    super.initState();
    fetchSpotsFromFirebase();
  }

  // ฟังก์ชันดึงข้อมูลจาก Firebase
  Future<void> fetchSpotsFromFirebase() async {
    final snapshot1 = await FirebaseFirestore.instance
        .collection('labs') // สมมติว่ามี collection ชื่อ lineChartData1
        .orderBy('date', descending: false)
        .get();

    setState(() {
      spots1 = snapshot1.docs.asMap().entries.map((entry) {
        int index = entry.key; // ใช้ index จากเอกสาร Firebase
        final doc = entry.value;
        final data = doc.data();
        return FlSpot(
          index.toDouble(), // ใช้ index เป็นค่า x
          (data['ldl'] as num).toDouble(), // ค่า y ยังคงดึงจาก Firebase
        );
      }).toList();

      spots2 = snapshot1.docs.asMap().entries.map((entry) {
        int index = entry.key; // ใช้ index จากเอกสาร Firebase
        final doc = entry.value;
        final data = doc.data();
        return FlSpot(
          index.toDouble(), // ใช้ index เป็นค่า x
          (data['sugar'] as num).toDouble(), // ค่า y ยังคงดึงจาก Firebase
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 60, 101),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 40),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'DiaBo',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 3,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 25),
              child: const Text('กราฟแสดงข้อมูลจากใบผลตรวจ',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 2, 66, 119),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start),
            ),
            Container(
              padding: const EdgeInsets.only(left: 300),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Icon(Icons.square,
                          color: Color.fromARGB(255, 97, 131, 216)),
                      Text("ค่าน้ำตาล"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.square,
                          color: Color.fromARGB(255, 223, 87, 87)),
                      Text("ค่าLDL"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 30),
              width: 500, // กำหนดความกว้างของกราฟ
              height: 350, // กำหนดความสูงของกราฟ
              child: LineChartLab(spots1: spots1, spots2: spots2),
            ),
            const Divider(
              color: Colors.transparent,
            ),
            const Divider(
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.only(right: 250),
              child: SizedBox(
                //width: 300, // กำหนดความกว้างของปุ่ม
                //height: 50, // กำหนดความสูงของปุ่ม
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 2, 66, 119),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.print,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  label: const Text(
                    "PRINT",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: Container(
          height: 100.0,
          width: 100.0,
          padding: const EdgeInsets.only(bottom: 30),
          child: FittedBox(
            child: FloatingActionButton(
                tooltip: "สแกนใบตรวจ",
                backgroundColor: const Color.fromARGB(255, 2, 66, 119),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)), //ความกลมของปุ่ม
                onPressed: () {
                  Navigator.pushNamed(context, '/camera', arguments: {
                    'actionType': "lab",
                  }).then((_) {
                    setState(() {}); // โหลดข้อมูลใหม่เมื่อกลับมา
                  });
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
          ),
        ),
      ),
    );
  }
}
