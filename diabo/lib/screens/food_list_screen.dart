import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/food_date_model.dart';
import 'package:diabo/models/food_model.dart';
import 'package:diabo/services/food_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
  }

  Future<List<FoodDateModel>> getUniqueDatesAndCarbs() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DateTime today = DateTime.now();
        List<FoodModel> foodItems = await _foodService.getFoodByUid(uid);

        // ใช้ Map เพื่อรวบรวมวันที่และค่าคาร์โบไฮเดรตรวม
        Map<DateTime, double> dateCarbsMap = {};

        for (var food in foodItems) {
          // ตรวจสอบประเภทและแปลง food.date เป็น DateTime
          DateTime date;
          date =
              (food.date as Timestamp).toDate(); // แปลง Timestamp เป็น DateTime

          // กำหนดวันที่ (เฉพาะปี, เดือน, วัน)
          DateTime onlyDate = DateTime(date.year, date.month, date.day);
          var carbCal = food.carb / 15; // คำนวณคาร์โบไฮเดต

          // เพิ่มคาร์โบไฮเดรตลงในวันที่ที่เกี่ยวข้อง
          dateCarbsMap.update(
            onlyDate,
            (existingCarbs) => existingCarbs + carbCal,
            ifAbsent: () => carbCal,
          );
        }

        // แปลง Map เป็น List<DateAndCarbs>
        return dateCarbsMap.entries
            .map((entry) => FoodDateModel(entry.key, entry.value))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching unique dates and carbs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20, top: 20),
              child: Text(
                'ประวัติการรับประทาน Carbs',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 1)),
              ),
            ),
          ),
          Expanded(
              child: FutureBuilder<List<FoodDateModel>>(
            future: getUniqueDatesAndCarbs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(''); // แสดง loading
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data found.');
              } else {
                List<FoodDateModel> dateAndCarbsList = snapshot.data!;
                return ListView.builder(
                  itemCount: dateAndCarbsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(DateFormat('dd/MM/yyyy')
                          .format(dateAndCarbsList[index].date)),
                      subtitle: Text(
                          "Carbs: ${dateAndCarbsList[index].totalCarbs.toStringAsFixed(2)}"), // แสดงคาร์โบไฮเดรตรวม
                    );
                  },
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
