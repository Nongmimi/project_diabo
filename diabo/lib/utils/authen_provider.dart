import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  // ฟังก์ชั่นดึงสถานะการล็อกอิน จากข้อมูล SharedPreferences
  Future<bool> getLoginStatus() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('loginSuccess') ?? false;
  }

  // ฟังก์ชั่นกำหนดสถานะการล็อกอิน ไว้ใน SharedPreferences
  Future<bool> setLoginStatus(status) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setBool('loginSuccess', status);
  }

  // ส่วนของการล็อกเอาท์
  Future<bool> logout() async {
    final SharedPreferences prefs = await _prefs;
    await FirebaseAuth.instance.signOut();
    return await prefs.clear();
  }

  // ส่วนของการล็อกอินผ่าน firebase
  Future<String> authen(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    var result;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await prefs.setBool("loginSuccess", true);
      result = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        result = 'Wrong password provided.';
      } else {
        result = 'กรุณากรอก email และ password ให้ถูกต้อง';
      }
    }
    return result;
  }

  // ส่วนของการสมัครสมาชิกผ่าน firebase
  Future<Map<String, dynamic>> create(String email, String password) async {
    var result;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      result = json.decode('{"success": "Create new user successful"}');
    } on FirebaseAuthException catch (e) {
      String err = '';
      if (e.code == 'weak-password') {
        err = '{"error": "The password provided is too weak."}';
        result = json.decode(err);
      } else if (e.code == 'email-already-in-use') {
        err = '{"error": "The account already exists for that email."}';
        result = json.decode(err);
      } else if (e.code == 'unknown') {
        err = '{"error": "Email and Password are required."}';
        result = json.decode(err);
      } else if (e.code == 'invalid-email') {
        err = '{"error": "The email address is badly formatted."}';
        result = json.decode(err);
      } else {
        err = '{"error": "$e"}';
        result = json.decode(err);
      }
    } catch (e) {
      String err = '{"error": "$e"}';
      result = json.decode(err);
    }
    return result;
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
