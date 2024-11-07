import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/appointment_model.dart';
import 'package:diabo/models/food_model.dart';
import 'package:diabo/models/lab_model.dart';
import 'package:diabo/services/appointment_service.dart';
import 'package:diabo/services/food_service.dart';
import 'package:diabo/services/lab_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  Future<void> uploadImageAppointmentDay(File imageFile) async {
    // URL เซิร์ฟเวอร์ที่ต้องการอัปโหลด
    String uploadUrl = "${dotenv.env['API_URL']}/appointment-day";
    // สร้าง multipart request เพื่ออัปโหลดไฟล์
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    // แนบไฟล์รูป
    var file = await http.MultipartFile.fromPath("image", imageFile.path);
    print('File path: ${imageFile.path}');
    // เพิ่มไฟล์ไปที่ request
    request.files.add(file);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String uid = "";
      if (currentUser != null) {
        uid = currentUser.uid;
      }
      // ส่งคำขอไปที่เซิร์ฟเวอร์
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body); // แปลงเป็น JSON
        var hospital = jsonResponse['hospital'];
        var date = jsonResponse['date'];
        var appointmentDate = jsonResponse['appointmentDate'];
        final AppointmentService appointmentService = AppointmentService();
        AppointmentModel newAppointmentModel = AppointmentModel(
            hospital: hospital,
            date: date,
            appointmentDate: appointmentDate,
            uid: uid);
        await appointmentService.addAppointment(newAppointmentModel);
        print('Upload successful ${jsonResponse['hospital']}');
      } else {
        print(
            'Upload failed with status code: ${response.statusCode}-${uploadUrl}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> uploadImageLab(File imageFile) async {
    // URL เซิร์ฟเวอร์ที่ต้องการอัปโหลด
    String uploadUrl = "${dotenv.env['API_URL']}/health-certificate";
    // สร้าง multipart request เพื่ออัปโหลดไฟล์
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    // แนบไฟล์รูป
    var file = await http.MultipartFile.fromPath("image", imageFile.path);
    print('File path: ${imageFile.path}');
    // เพิ่มไฟล์ไปที่ request
    request.files.add(file);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String uid = "";
      if (currentUser != null) {
        uid = currentUser.uid;
      }
      // ส่งคำขอไปที่เซิร์ฟเวอร์
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body); // แปลงเป็น JSON
        var ldl = jsonResponse['ldl'];
        var sugar = jsonResponse['sugar'];
        final LabService labService = LabService();
        LabModel newLabModel =
            LabModel(ldl: ldl, sugar: sugar, uid: uid, date: Timestamp.now());
        await labService.addLab(newLabModel);
        print('Upload successful ${ldl}');
      } else {
        print(
            'Upload failed with status code: ${response.statusCode}-${uploadUrl}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> uploadImageFood(File imageFile, String optionTime) async {
    // URL เซิร์ฟเวอร์ที่ต้องการอัปโหลด
    String uploadUrl = "${dotenv.env['API_URL']}/food";
    // สร้าง multipart request เพื่ออัปโหลดไฟล์
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    // แนบไฟล์รูป
    var file = await http.MultipartFile.fromPath("image", imageFile.path);
    print('File path: ${imageFile.path}');
    // เพิ่มไฟล์ไปที่ request
    request.files.add(file);

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String uid = "";
      if (currentUser != null) {
        uid = currentUser.uid;
      }
      // ส่งคำขอไปที่เซิร์ฟเวอร์
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body); // แปลงเป็น JSON
        var foodName = jsonResponse['foodName'];
        var carb = jsonResponse['carb'];

        final FoodService foodService = FoodService();
        FoodModel newFoodModel = FoodModel(
            carb: carb.toDouble(),
            foodName: foodName,
            foodTime: int.parse(optionTime),
            uid: uid,
            date: Timestamp.now());
        await foodService.addFood(newFoodModel);
        print('Upload successful');
      } else {
        print(
            'Upload failed with status code: ${response.statusCode}-${uploadUrl}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
