import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  final String? id;
  final String foodName;
  final double carb;
  final int foodTime;
  final Timestamp date;
  final String uid;

  FoodModel(
      {this.id,
      required this.carb,
      required this.foodName,
      required this.foodTime,
      required this.uid,
      required this.date});

  // แปลงข้อมูลจาก Firestore Document เป็น Product Object
  factory FoodModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return FoodModel(
        id: documentId,
        foodName: data['foodName'],
        foodTime: data['foodTime'],
        carb: data['carb'],
        date: data['date'],
        uid: data['uid']);
  }

  // แปลง Product Object เป็น Map ก่อนส่งไปบันทึกใน Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'foodName': foodName,
      'foodTime': foodTime,
      'uid': uid,
      'date': date,
      'carb': carb
    };
  }
}
