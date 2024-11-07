import 'package:diabo/models/food_model.dart';
import 'package:diabo/models/option_time.dart';
import 'package:diabo/services/food_service.dart';
import 'package:diabo/widgets/food_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './../widgets/option_time_widget.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  double _breakfastCarbs = 0;
  double _lunchCarbs = 0;
  double _dinnerCarbs = 0;
  double _snackCarbs = 0;
  double _totalCarbs = 0;

  final FoodService _foodService = FoodService();
  OptionTime? selectedOption;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  void _showSelectedOption(OptionTime option) {
    setState(() {
      selectedOption = option;
    });

    Navigator.pushNamed(context, '/camera',
            arguments: {'actionType': "food", "openTime": option.id.toString()})
        .then((_) {
      setState(() {}); // โหลดข้อมูลใหม่เมื่อกลับมา
    });
  }

  void _navigateToList() {
    Navigator.pushNamed(context, '/food_list');
  }

  Future<void> _loadFoods() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    double getBreakfastCarbs = 0;
    double getLunchCarbs = 0;
    double getDinnerCarbs = 0;
    double getSnackCarbs = 0;

    if (currentUser != null) {
      String uid = currentUser.uid;
      DateTime today = DateTime.now();
      List<FoodModel> foodItems = await _foodService.getFoodByDate(uid, today);
      for (var food in foodItems) {
        var carbCal = food.carb / 15;
        switch (food.foodTime) {
          case 1: // เวลาอาหารเช้า
            getBreakfastCarbs += carbCal;
            break;
          case 2: // เวลาอาหารกลางวัน
            getLunchCarbs += carbCal;
            print("Food Item: ${food.id}, Date: ${food.foodTime}");
            break;
          case 3: // เวลาอาหารเย็น
            getDinnerCarbs += carbCal;
            break;
          case 4: // เวลาอาหารว่าง
            getSnackCarbs += carbCal;
            break;
          default:
            // ถ้า foodTime ไม่ตรงกับที่คาดหวัง
            print("Unknown food time for Food Item: ${food.id}");
            break;
        }
      }

      var total =
          getBreakfastCarbs + getLunchCarbs + getDinnerCarbs + getSnackCarbs;
      setState(() {
        _breakfastCarbs = getBreakfastCarbs;
        _lunchCarbs = getLunchCarbs;
        _dinnerCarbs = getDinnerCarbs;
        _snackCarbs = getSnackCarbs;
        _totalCarbs = total;
      });
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
      body: Center(
        child: FoodWidget(
          totalCarbs: _totalCarbs,
          breakfastCarbs: _breakfastCarbs,
          lunchCarbs: _lunchCarbs,
          dinnerCarbs: _dinnerCarbs,
          snackCarbs: _snackCarbs,
          onNavigateToList: _navigateToList,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.replay,
                size: 30,
              ),
              //tooltip: "ประวัติการกิน Carbs",
              onPressed: _navigateToList,
            ),
            const SizedBox(width: 50.0),
            IconButton(
              icon: const Icon(
                Icons.equalizer,
                size: 40,
              ),
              //tooltip: "กราฟประวัติการกิน Carbs",
              onPressed: () {
                Navigator.pushNamed(context, '/food_graph');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            onPressed: () => optionsTimeWidget(
              context: context,
              onSave: _showSelectedOption,
            ),
            child: const Icon(Icons.camera_alt, size: 30),
          ),
        ),
      ),
    );
  }
}
