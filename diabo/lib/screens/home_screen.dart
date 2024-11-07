import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/screens/alarm_screen.dart';
import 'package:diabo/screens/first_page.dart';
import 'package:diabo/screens/login_screen.dart';
import 'package:diabo/screens/popup.dart';
import 'package:diabo/screens/profile_edit.dart';
import 'package:diabo/utils/authen_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabo/screens/signup_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late FirebaseAuth auth; // สำหรับ authen
  late AuthenProvider authProvider; // สำหรับ provider
  late bool _loginSuccess;

  String email = "";
  String username = "";
  String profileImage = ""; // สำหรับเก็บ URL ของภาพโปรไฟล์

  var height, width;

  List imgData = [
    "assets/images/meet-med.png",
    "assets/images/report.png",
    "assets/images/food.png",
    "assets/images/drug.png",
  ];

  List titles = [
    "แจ้งเตือนการพบแพทย์",
    "ผล Lab",
    "อาหาร",
    "แจ้งเตือนการรับประทานยา",
  ];

  @override
  void initState() {
    super.initState();
    loadSettings(); // เรียกใช้งานตั้งค่าเมื่อเริ่มต้นเป็นฟังก์ชั่น ให้รองรับ async
    callAlarm();
  }

  // ตั้งค่าเริ่มต้น
  void loadSettings() async {
    try {
      authProvider = context.read<AuthenProvider>();
      auth = authProvider.auth;
      _loginSuccess = await authProvider.getLoginStatus();

      if (!mounted) return;

      if (_loginSuccess == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // ดึงข้อมูลจาก Firestore
        await fetchUserData();
      }
    } catch (e) {
      _loginSuccess = false;
    }
  }

  Future<void> fetchUserData() async {
    try {
      final uid = auth.currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? 'Unknown Name';
          profileImage = userDoc['profileImage'] ?? ''; // รับ URL ของโปรไฟล์
        });
      } else {
        // หากไม่มีข้อมูลใน Firestore
        print("No user data found");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void callAlarm() async {
    Alarm.ringStream.stream.listen(toAlarmScreen);
  }

  Future<void> toAlarmScreen(AlarmSettings? settings) async {
    /*
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: AlarmScreen(alarmSettings: settings),
        );
      },
      */
    //await Alarm.stop(settings!.id);
    //Navigator.pushNamed(context, '/test_results');
/*
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AlarmScreen(alarmSettings: settings)),
    );
    */
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AlarmScreen(alarmSettings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final user = Provider.of<AuthenProvider>(context).getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text("DiaBo"),
        automaticallyImplyLeading: false, // This removes the back arrow
        backgroundColor: const Color.fromARGB(255, 30, 30, 124),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FirstPage()),
              );
            },
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 30, 30, 124),
          width: width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: height * 0.25,
                width: width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 100, left: 20, right: 15),
                        ),
                        CircleAvatar(
                          radius: 45, // Adjust the radius as needed
                          backgroundColor: Colors.white,
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(profileImage)
                              : const AssetImage(
                                      'assets/images/placeholder.png')
                                  as ImageProvider,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username ?? "Unknown name",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 254, 254),
                                fontFamily: 'Prompt',
                              ),
                            ),
                            Text(
                              user?.email ?? "Unknown email",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 254, 254, 254),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // ระยะห่างระหว่างปุ่ม
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEditPage()),
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 3),
                                Text(
                                  'แก้ไขข้อมูลส่วนตัว',
                                  style: TextStyle(fontFamily: 'Prompt'),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              DialogHelper.showLongTextDialog(context);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bookmark),
                                SizedBox(width: 3),
                                Text(
                                  'คู่มือการใช้งาน',
                                  style: TextStyle(fontFamily: 'Prompt'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: width,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.pushNamed(context, '/appointment');
                          } else if (index == 1) {
                            Navigator.pushNamed(context, '/test_results');
                          } else if (index == 2) {
                            Navigator.pushNamed(context, '/food');
                          } else if (index == 3) {
                            Navigator.pushNamed(context, '/drug');
                          }
                        },
                        child: Container(
                          //margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(imgData[index],
                                  width: width / 2 - 20,
                                  height: width / 2 - 20,
                                  fit: BoxFit.cover),
                              Text(
                                titles[index],
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Prompt'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
