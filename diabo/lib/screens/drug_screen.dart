import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/alarm_model.dart';
// import 'package:diabo/screens/alarm_screen.dart';
import 'package:diabo/services/alarm_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';

class DrugScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DrugScreen(this.flutterLocalNotificationsPlugin);

  @override
  _DrugScreenState createState() => _DrugScreenState();
}

class _DrugScreenState extends State<DrugScreen> {
  TimeOfDay? selectedTime;
  final AlarmService _alarmService = AlarmService();
  List<String> items = [];
  final TextEditingController noteController = TextEditingController();

  //List<AlarmSettings> alarms = [];
  List<AlarmModel> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarm();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
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
    //if (res != null && res == true) loadAlarms();
  }

  void _loadAlarm() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      List<AlarmModel> alarmItems = await _alarmService.getAlarmByUid(uid);
      alarmItems.sort((a, b) => a.date.compareTo(b.date));
      setState(() {
        alarms = alarmItems;
      });
    }
  }

  void _setAlarm(DateTime dateTime, String note) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      var random = Random();
      var timeKey =
          dateTime.millisecondsSinceEpoch % 10000 + random.nextInt(10000);
      final alarmSettings = AlarmSettings(
        id: timeKey,
        dateTime: dateTime,
        assetAudioPath: 'assets/alarm_sound.mp3', // ตั้งไฟล์เสียงปลุกใน assets
        loopAudio: true,
        vibrate: true,
        fadeDuration: 3.0,
        notificationSettings: NotificationSettings(
          title: 'แจ้งเตือนกินยา',
          body: 'เวลา:  ${dateTime.hour}:${dateTime.minute}',
          icon: 'notification_icon',
          stopButton: 'ปิดการแจ้งเตือน',
        ),
      );

      //Alarm.ringStream.stream.listen(navigateToAlarmScreen);
      await Alarm.set(alarmSettings: alarmSettings); // ตั้งปลุก

      AlarmModel newAlarmModel = AlarmModel(
        timeKey: timeKey,
        uid: uid,
        date: Timestamp.fromDate(dateTime),
        note: note,
      );
      await _alarmService.addAlarm(newAlarmModel);
      _loadAlarm();
/*
      setState(() {
        alarms.add(alarmSettings); // เพิ่มลงใน List ของนาฬิกาปลุก
      });*/

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("ตั้งเวลาทานยา ${dateTime.hour}:${dateTime.minute}")),
      );
    }
  }

  void _removeAlarm(int timeKey, String id) async {
    await Alarm.stop(timeKey); // หยุดปลุก
    await _alarmService.deleteAlarmt(id);
    _loadAlarm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("ลบเวลาทานยาแล้ว")),
    );
  }

  void _pickTime() async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  void _selectTime() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController noteController = TextEditingController();

        return AlertDialog(
          title: const Text("ตั้งเวลาและโน๊ต"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickTime, // Call _pickTime on tap,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    selectedTime != null
                        ? "เวลา: ${selectedTime!.format(context)}"
                        : "กดเพื่อเลือกเวลา",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'โน๊ต (ไม่บังคับ)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                if (selectedTime != null) {
                  final now = DateTime.now();
                  final selectedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  if (selectedDateTime.isAfter(now)) {
                    // Return selected time and note (note can be empty)
                    Navigator.of(context).pop({
                      'time': selectedDateTime,
                      'note': noteController.text
                          .trim(), // Trim to avoid unnecessary spaces
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("กรุณาเลือกเวลาในอนาคต")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("กรุณาเลือกเวลา")),
                  );
                }
              },
              child: const Text("ตกลง"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      // Set the alarm with the selected date and note
      _setAlarm(result['time'], "การตั้งปลุก " + result['note']);
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
          const Padding(
            padding: EdgeInsets.only(left: 50, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'เวลาการรับประทานยา',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                DateTime date = alarm.date.toDate();

                return Dismissible(
                  key: Key(alarm.id ?? ''),
                  direction: DismissDirection.endToStart, // เลื่อนจากขวาไปซ้าย
                  background: Container(
                    color: const Color.fromARGB(
                        255, 167, 63, 56), // สีพื้นหลังเมื่อเลื่อน
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  confirmDismiss: (DismissDirection direction) async {
                    // การยืนยันก่อนลบ
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("ยืนยันการลบ"),
                        content:
                            const Text("คุณต้องการลบการแจ้งเตือนนี้หรือไม่?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("ยกเลิก"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text("ยืนยัน"),
                            onPressed: () {
                              Navigator.of(context).pop(true); // ยืนยันการลบ
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    // เมื่อทำการเลื่อนแล้วให้ลบ
                    _removeAlarm(alarm.timeKey, alarm.id ?? '');
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    elevation: 20, // กำหนดความสูงและเงาของวัตถุ
                    color: const Color.fromARGB(
                        255, 157, 157, 221), // เปลี่ยนสีพื้นหลังของ Card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${DateFormat('HH:mm').format(date)}",
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 30, 27, 27),
                                ),
                              ),
                              Text(
                                alarm.note,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 254, 245, 245),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Switch(
                                value: alarm.isActive,
                                activeColor:
                                    const Color.fromARGB(255, 240, 162, 162),
                                activeTrackColor:
                                    const Color.fromARGB(255, 213, 63, 63),
                                inactiveThumbColor:
                                    const Color.fromARGB(255, 158, 158, 158),
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 67, 65, 65),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    alarm.isActive = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 70.0, // Width of the FAB
        height: 70.0, // Height of the FAB
        child: FloatingActionButton(
          onPressed: _selectTime,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 60, // Size of the icon
          ),
        ),
      ),
    );
  }
}
