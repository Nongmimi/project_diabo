import 'package:diabo/models/option_time.dart';
import 'package:diabo/screens/food_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FoodWidget extends StatelessWidget {
  final double totalCarbs;
  final double breakfastCarbs;
  final double lunchCarbs;
  final double dinnerCarbs;
  final double snackCarbs;
  final VoidCallback onNavigateToList;

  const FoodWidget({
    super.key,
    required this.totalCarbs,
    required this.breakfastCarbs,
    required this.lunchCarbs,
    required this.dinnerCarbs,
    required this.snackCarbs,
    required this.onNavigateToList,
  });

  @override
  Widget build(BuildContext context) {
    double maxCarbs = 10; // ค่าของคาร์บแต่ละคน
    double percent =
        (totalCarbs / maxCarbs).clamp(0.0, 1.0); // คำนวณค่าเปอร์เซ็นต์

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 15.0, right: 100),
          child: const Text(
            "วันนี้ทาน Carbs ไปทั้งหมด...",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 15), // เพิ่มระยะห่างจากขอบบน
          child: CircularPercentIndicator(
            radius: 95.0, // ขนาดของวงกลม
            lineWidth: 25.0, // ความหนาของเส้น
            percent: percent, // ค่าเปอร์เซ็นต์ (0.0 - 1.0)
            center: CustomPaint(
              painter: DividerPainter(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalCarbs.toInt().toString(), // ตัวเลขที่คำนวณ
                      style: const TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      maxCarbs.toInt().toString(), // ตัวเลขเต็ม
                      style: const TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            progressColor:
                const Color.fromARGB(255, 89, 150, 230), // สีของความคืบหน้า
            backgroundColor:
                const Color.fromARGB(255, 199, 213, 221), // สีพื้นหลังของวงกลม
            circularStrokeCap: CircularStrokeCap.round, // รูปร่างของขอบเส้น
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 107, 106, 106),
          thickness: 0.5,
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.free_breakfast),
                title: const Text(
                  'มื้อเช้า : ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                trailing: Text(
                  "Carbs : $breakfastCarbs",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 33, 54, 243), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                titleTextStyle: const TextStyle(fontSize: 23),
                leadingAndTrailingTextStyle: const TextStyle(fontSize: 16),
              ),
              const Divider(
                color: Color.fromARGB(255, 107, 106, 106),
                thickness: 0.5,
              ),
              ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: const Text(
                  'มื้อเที่ยง : ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                trailing: Text(
                  "Carbs : $lunchCarbs",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 33, 54, 243), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                titleTextStyle: const TextStyle(fontSize: 23),
                leadingAndTrailingTextStyle: const TextStyle(fontSize: 16),
              ),
              const Divider(
                color: Color.fromARGB(255, 107, 106, 106),
                thickness: 0.5,
              ),
              ListTile(
                leading: const Icon(Icons.cloud),
                title: const Text(
                  'มื้อเย็น : ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                trailing: Text(
                  "Carbs : $dinnerCarbs",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 33, 54, 243), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                titleTextStyle: const TextStyle(fontSize: 23),
                leadingAndTrailingTextStyle: const TextStyle(fontSize: 16),
              ),
              const Divider(
                color: Color.fromARGB(255, 107, 106, 106),
                thickness: 0.5,
              ),
              ListTile(
                leading: const Icon(Icons.bakery_dining_rounded),
                title: const Text(
                  'อาหารว่าง : ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 0, 0, 0), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                trailing: Text(
                  "Carbs : $snackCarbs",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(
                        255, 33, 54, 243), // ปรับเปลี่ยนสีตัวอักษรที่นี่
                  ),
                ),
                titleTextStyle: const TextStyle(fontSize: 23),
                leadingAndTrailingTextStyle: const TextStyle(fontSize: 16),
              ),
              const Divider(
                color: Color.fromARGB(255, 107, 106, 106),
                thickness: 0.5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black // สีของเส้นแบ่ง
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // ความหนาของเส้นแบ่ง

    //double radius = size.width / 2; // รัศมีของวงกลม
    double centerX = size.width / 2; // ตำแหน่ง X ของจุดศูนย์กลาง
    double centerY = size.height / 2; // ตำแหน่ง Y ของจุดศูนย์กลาง

    double lineLength = 60; // ความยาวของเส้นแบ่ง

    // วาดเส้นแบ่งครึ่ง
    canvas.drawLine(
      Offset(centerX - lineLength / 2, centerY), // จุดเริ่มต้นของเส้น
      Offset(centerX + lineLength / 2, centerY), // จุดสิ้นสุดของเส้น
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
