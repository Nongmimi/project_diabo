import 'package:alarm/alarm.dart';
import 'package:diabo/screens/appointment_screen.dart';
import 'package:diabo/screens/camera_screen.dart';
import 'package:diabo/screens/drug_screen.dart';
import 'package:diabo/screens/first_page.dart';
import 'package:diabo/screens/food_graph_screen.dart';
import 'package:diabo/screens/food_list_screen.dart';
import 'package:diabo/screens/food_screen.dart';
import 'package:diabo/screens/home_screen.dart';
import 'package:diabo/screens/login_screen.dart';
import 'package:diabo/screens/profile_edit.dart';
import 'package:diabo/screens/test_results_screen.dart';
import 'package:diabo/utils/authen_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['GOOGLE_API_KEY'].toString(),
      appId: dotenv.env['GOOGLE_APP_ID'].toString(),
      messagingSenderId: dotenv.env['GOOGLE_SENDER_ID'].toString(),
      projectId: dotenv.env['GOOGLE_PROJECT_ID'].toString(),
    ),
  ); // เชื่อมต่อ firebase กับ app

  // สร้าง instance ของ FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ตั้งค่าการแจ้งเตือนสำหรับ Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // ตั้งค่าการแจ้งเตือนทั้งหมด
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // เริ่มการแจ้งเตือน
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(MyApp(flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyApp(this.flutterLocalNotificationsPlugin);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthenProvider()),
          //ChangeNotifierProvider(create: (context) => UserProvider()),
          //ChangeNotifierProvider(create: (context) => Counter()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Diabo',
          initialRoute: '/',
          routes: {
            //เดียวค่อยเพิ่มหน้า
            // '/': (context) => FirstPage(),
            '/': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/edit': (context) => ProfileEditPage(),
            '/appointment': (context) => const AppointmentScreen(),
            '/camera': (context) => const CameraScreen(),
            '/test_results': (context) => const TestResultsScreen(),
            '/food': (context) => const FoodScreen(),
            '/food_list': (context) => const FoodListScreen(),
            '/food_graph': (context) => const FoodGraphScreen(),
            '/drug': (context) => DrugScreen(flutterLocalNotificationsPlugin)
          },
        ));
  }
}
