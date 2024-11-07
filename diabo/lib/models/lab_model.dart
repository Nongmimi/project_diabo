import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  final String? id;
  final int ldl;
  final int sugar;
  final String uid;
  final Timestamp date;

  LabModel(
      {this.id,
      required this.ldl,
      required this.sugar,
      required this.uid,
      required this.date});

  // แปลงข้อมูลจาก Firestore Document เป็น Product Object
  factory LabModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return LabModel(
        id: documentId,
        ldl: data['ldl'],
        sugar: data['sugar'],
        date: data['date'],
        uid: data['uid']);
  }

  // แปลง Product Object เป็น Map ก่อนส่งไปบันทึกใน Firestore
  Map<String, dynamic> toFirestore() {
    return {'ldl': ldl, 'sugar': sugar, 'uid': uid, 'date': date};
  }
}
