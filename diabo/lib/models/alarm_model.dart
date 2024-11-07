import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  final String? id;
  final int timeKey;
  final Timestamp date;
  final String uid;
  final String note;
  bool isActive; // เปลี่ยนให้เป็น field ที่สามารถตั้งค่าได้

  AlarmModel({
    this.id,
    required this.timeKey,
    required this.date,
    required this.uid,
    required this.note,
    this.isActive = true, // ตั้งค่าปริยายให้เป็น true
  });

  // Convert Firestore Document to AlarmModel Object
  factory AlarmModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return AlarmModel(
      id: documentId,
      timeKey: data['timeKey'],
      date: data['date'],
      uid: data['uid'],
      note:
          data['note'] ?? '', // Default to empty string if note is not provided
      isActive: data['isActive'] ?? true, // อ่านค่าของ isActive จาก Firestore
    );
  }

  // Check if the alarm is active (you may adjust this logic as needed)
  bool checkIsActive() {
    // Check if the alarm date is in the future
    return date.toDate().isAfter(DateTime.now());
  }

  // Convert AlarmModel Object to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'timeKey': timeKey,
      'date': date,
      'uid': uid,
      'note': note, // Include note in the data sent to Firestore
      'isActive': isActive, // Include isActive in Firestore data
    };
  }
}
