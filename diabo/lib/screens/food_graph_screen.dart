import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/food_model.dart';
import 'package:diabo/services/food_service.dart';
import 'package:diabo/widgets/reusable_line_chart_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FoodGraphScreen extends StatefulWidget {
  const FoodGraphScreen({super.key});

  @override
  _FoodGraphScreenState createState() => _FoodGraphScreenState();
}

class _FoodGraphScreenState extends State<FoodGraphScreen> {
  final FoodService _foodService = FoodService();
  List<FlSpot> food15Spots = [];
  List<FlSpot> food30Spots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFood15Day();
    _loadFood30Day();
  }

  Future<void> _loadFood15Day() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DateTime today = DateTime.now();
        DateTime startDate = today.subtract(const Duration(days: 15));
        String uid = currentUser.uid;
        List<FlSpot> spots = [];
        List<FoodModel> foodItems = await _foodService.getFoodLast15Day(uid);
        Map<DateTime, double> carbsData = {};
        for (var food in foodItems) {
          DateTime date = (food.date as Timestamp).toDate();
          double carbs = food.carb ?? 0;
          carbsData[DateTime(date.year, date.month, date.day)] = carbs;
        }

        for (int i = 0; i <= 14; i++) {
          DateTime targetDate = startDate.add(Duration(days: i));
          double carbs = carbsData[DateTime(
                  targetDate.year, targetDate.month, targetDate.day)] ??
              0; // ถ้าไม่มีข้อมูลให้ใส่ 0
          spots.add(FlSpot(i.toDouble(), carbs));
        }

        setState(() {
          food30Spots = spots;
          //isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching food data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadFood30Day() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DateTime today = DateTime.now();
        DateTime startDate = today.subtract(const Duration(days: 15));
        String uid = currentUser.uid;
        List<FlSpot> spots = [];
        List<FoodModel> foodItems = await _foodService.getFoodLast15Day(uid);
        Map<DateTime, double> carbsData = {};
        for (var food in foodItems) {
          DateTime date = (food.date as Timestamp).toDate();
          double carbs = food.carb ?? 0;
          carbsData[DateTime(date.year, date.month, date.day)] = carbs;
        }

        for (int i = 0; i <= 14; i++) {
          DateTime targetDate = startDate.add(Duration(days: i));
          double carbs = carbsData[DateTime(
                  targetDate.year, targetDate.month, targetDate.day)] ??
              0; // ถ้าไม่มีข้อมูลให้ใส่ 0
          spots.add(FlSpot(i.toDouble(), carbs));
        }

        setState(() {
          food15Spots = spots;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching food data: $e');
      setState(() {
        isLoading = false;
      });
    }
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 25, right: 40),
                    child: const Text(
                        'กราฟแสดงข้อมูลการรับประทานCarbs 14 วันที่ผ่านมา',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 2, 66, 119),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 30),
                    width: 800, // กำหนดความกว้างของกราฟ
                    height: 250, // กำหนดความสูงของกราฟ
                    child: ReusableLineChartWidget(
                      spots: food15Spots,
                      lineColor: Colors.blue,
                      lineWidth: 3.0,
                      borderColor: Colors.black,
                      borderWidth: 2.0,
                      minX: 0,
                      maxX: 15,
                      minY: 0,
                      maxY: 10,
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 25),
                    child: const Text(
                        'กราฟแสดงข้อมูลเฉลี่ยการรับประทานCarbs 1 เดือนที่ผ่านมา',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 2, 66, 119),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  const Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 30),
                    width: 1000, // กำหนดความกว้างของกราฟ
                    height: 250, // กำหนดความสูงของกราฟ
                    child: ReusableLineChartWidget(
                      spots: food15Spots,
                      lineColor: Colors.blue,
                      lineWidth: 3.0,
                      borderColor: Colors.black,
                      borderWidth: 2.0,
                      minX: 0,
                      maxX: 30,
                      minY: 0,
                      maxY: 10,
                    ),
                  ),
                ]),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: Container(
          height: 90.0,
          width: 90.0,
          padding: const EdgeInsets.only(bottom: 30),
          child: FittedBox(
            child: FloatingActionButton(
                tooltip: "พิมพ์กราฟทั้งหมด",
                backgroundColor: const Color.fromARGB(255, 2, 66, 119),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)), //ความกลมของปุ่ม
                onPressed: () {},
                child: const Icon(
                  Icons.print,
                  size: 30,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
          ),
        ),
      ),
    );
  }
}

//void setState(Null Function() param0) {}

class LineChartSample1 extends StatelessWidget {
  const LineChartSample1({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
            drawHorizontalLine: true, drawVerticalLine: false), //กริด
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(drawBelowEverything: false),
          topTitles: AxisTitles(drawBelowEverything: false),
        ), //ข้อความรอบกรอบ
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
            left: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
            //top: BorderSide(
            //  color: Color.fromARGB(255, 0, 0, 0),
            //  width: 2,
            //),
            //right: BorderSide(
            //  color: Color.fromARGB(255, 0, 0, 0),
            //  width: 2,
            //),
          ),
        ), //เส้นกรอบ
        minX: 0,
        maxX: 14,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1, 1),
              const FlSpot(2, 4),
              const FlSpot(3, 2),
              const FlSpot(4, 5),
              const FlSpot(5, 3),
              const FlSpot(6, 4),
              const FlSpot(7, 6),
              const FlSpot(8, 3),
              const FlSpot(9, 1),
              const FlSpot(10, 4),
              const FlSpot(11, 3),
              const FlSpot(12, 4),
              const FlSpot(13, 2),
              const FlSpot(14, 5),
            ],

            //colors: [const Color.fromARGB(255, 97, 131, 216)], //สีเส้นกราฟ
            barWidth: 2, //ความหนาเส้นกราฟ
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), //จุดบนกราฟ
            belowBarData: BarAreaData(show: false), //สีใต้กราฟ
          ),
        ],
      ),
    );
  }
}

class LineChartSample2 extends StatelessWidget {
  const LineChartSample2({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
            drawHorizontalLine: true, drawVerticalLine: false), //กริด
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(drawBelowEverything: false),
          topTitles: AxisTitles(drawBelowEverything: false),
        ), //ข้อความรอบกรอบ
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
            left: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
          ),
        ), //เส้นกรอบ
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1, 1),
              const FlSpot(2, 4),
              const FlSpot(3, 2),
              const FlSpot(4, 5),
            ],

            //colors: [const Color.fromARGB(255, 97, 131, 216)], //สีเส้นกราฟ
            barWidth: 2, //ความหนาเส้นกราฟ
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), //จุดบนกราฟ
            belowBarData: BarAreaData(show: false), //สีใต้กราฟ
          ),
        ],
      ),
    );
  }
}
