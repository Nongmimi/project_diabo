import 'package:camera/camera.dart';
import 'package:diabo/services/upload_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  XFile? image; // ไฟล์รูปที่ถ่าย

  UploadService? uploadService;

  @override
  void initState() {
    super.initState();
    initializeCamera(); // เรียกใช้กล้องเมื่อเข้า screen
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras(); // ดึงกล้องที่ใช้งานได้
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.high);

      // เริ่มต้นการควบคุมกล้อง
      await controller?.initialize();
      if (!mounted) return;
      setState(() {}); // อัปเดต UI หลังจากกล้องพร้อม
    }
  }

  @override
  void dispose() {
    controller?.dispose(); // ปิดกล้องเมื่อออกจากหน้า
    super.dispose();
  }

  Future<void> takePicture() async {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var actionType = args['actionType'];
    if (controller != null && controller!.value.isInitialized) {
      try {
        image = await controller!.takePicture(); // ถ่ายภาพ
        setState(() {}); // อัปเดต UI เพื่อแสดงรูป
        if (image != null) {
          uploadService = UploadService();
          if (actionType == "appointment") {
            await uploadService?.uploadImageAppointmentDay(
                File(image!.path)); // อัปโหลดรูปไปที่เซิร์ฟเวอร์
            Navigator.pop(context);
          } else if (actionType == "lab") {
            await uploadService?.uploadImageLab(
                File(image!.path)); // อัปโหลดรูปไปที่เซิร์ฟเวอร์
            Navigator.pop(context);
          } else if (actionType == "food") {
            var openTime = args['openTime'];
            await uploadService?.uploadImageFood(
                File(image!.path), openTime); // อัปโหลดรูปไปที่เซิร์ฟเวอร์
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40),
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('ถ่ายภาพ', style: TextStyle(fontFamily: 'Prompt')),
        backgroundColor: const Color.fromARGB(255, 30, 30, 124),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          // ใช้ LayoutBuilder เพื่อทำให้ CameraPreview มีความสูงเต็มจอ
          if (controller != null && controller!.value.isInitialized)
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight, // ตั้งค่าให้เต็มความสูง
                  width: double.infinity, // เต็มความกว้าง
                  child: CameraPreview(controller!),
                );
              },
            )
          else
            Center(child: const Text('Loading camera...')),

          // แสดงภาพที่ถ่ายเต็มจอ (ถ้ามี)
          if (image != null)
            Positioned.fill(
              child: Image.file(
                File(image!.path),
                fit: BoxFit.cover, // แสดงรูปเต็มจอ
              ),
            ),

          // ปุ่มสำหรับถ่ายภาพ
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: takePicture,
                child: const Text('ถ่ายภาพ',
                    style: TextStyle(fontFamily: 'Prompt')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
