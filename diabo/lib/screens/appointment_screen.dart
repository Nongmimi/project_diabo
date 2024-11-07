import 'package:diabo/models/appointment_model.dart';
import 'package:diabo/services/appointment_service.dart';
import 'package:diabo/widgets/appointment_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  late Future<List<AppointmentModel>> _appointmentsFuture;
  List<String> items = [];

  void _addNewItem() {
    setState(() {
      items.insert(0, "New Item ${items.length + 1}");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<AppointmentModel>> _loadAppointments() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      return await _appointmentService.getAppointmentByUid(uid);
    } else {
      return [];
    }
  }

  // ฟังก์ชันลบการนัดหมาย
  Future<void> _deleteAppointment(String id) async {
    try {
      await _appointmentService.deleteAppointment(id);
      // หลังจากลบให้ทำการรีเฟรชข้อมูล
      setState(() {
        _appointmentsFuture = _appointmentService
            .getAppointmentByUid(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      // แสดงข้อความแสดงข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting appointment: $e')));
    }
  }

  void _confirmDeleteAppointment(String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: const Text('คุณแน่ใจหรือว่าต้องการลบการนัดหมายนี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                _deleteAppointment(appointmentId); // เรียกใช้ฟังก์ชันลบ
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
              },
            ),
          ],
        );
      },
    );
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
        body: FutureBuilder<List<AppointmentModel>>(
          future: _loadAppointments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No appointments found.'));
            }
            List<AppointmentModel> appointments = snapshot.data!;

            return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  AppointmentModel appointment = appointments[index];
                  Color cardColor =
                      index.isEven ? Colors.blue[100]! : Colors.green[100]!;
                  return AppointmentCardWidget(
                      appointment: appointment,
                      color: cardColor,
                      onDelete: () {
                        if (appointment.id != null) {
                          _confirmDeleteAppointment(
                              appointment.id!); // ใช้ ! เพื่อตัด `null`
                        } else {
                          // คุณสามารถแสดงข้อความหรือจัดการกรณีนี้ตามต้องการ
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Appointment ID is null.')));
                        }
                      });
                });
          },
        ),
        floatingActionButton: SizedBox(
          width: 70.0, // Width of the FAB
          height: 70.0, // Height of the FAB
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/camera', arguments: {
                'actionType': "appointment",
              }).then((_) {
                setState(() {}); // โหลดข้อมูลใหม่เมื่อกลับมา
              });
            },
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.camera_alt,
              size: 35, // Size of the icon
            ),
          ),
        ),
      ),
    );
  }
}
