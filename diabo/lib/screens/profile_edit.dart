import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String userId;

  // Controllers for the input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  List<String> gender = ["ชาย", "หญิง"];
  String? selectedValue;
  List<String> images = [
    'assets/images/pi1.jpg',
    'assets/images/pi2.jpg',
    'assets/images/pi3.jpg',
    'assets/images/pi4.jpg',
    'assets/images/pi5.jpg',
    'assets/images/pi6.jpg',
    'assets/images/pi7.jpg',
    'assets/images/pi8.jpg',
    'assets/images/pi9.jpg',
  ];
  String? _selectedImage;

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกรูป profile ของคุณ'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                    setState(() {
                      _selectedImage = images[index];
                    });
                  },
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      setState(() {
        _fullNameController.text = userDoc['fullName'];
        _usernameController.text = userDoc['username'];
        _emailController.text = userDoc['email'];
        _weightController.text = userDoc['weight'];
        _heightController.text = userDoc['height'];
        _selectedImage = userDoc['profileImage'];
        selectedValue = userDoc['gender'];
      });
    }
  }

  Future<void> _saveChanges() async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fullName': _fullNameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'weight': _weightController.text,
        'height': _heightController.text,
        'gender': selectedValue,
        'profileImage': _selectedImage,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("แก้ไขข้อมูลสำเร็จ")),
      );
    } catch (e) {
      print("Error updating profile: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("แก้ไขข้อมูลไม่สำเร็จ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขข้อมูลส่วนตัว"),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          color: const Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 49, 42, 107),
      ),
      backgroundColor: const Color.fromARGB(255, 75, 110, 192),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                child: Stack(
                  children: [
                    _selectedImage == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              _selectedImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 4, bottom: 4),
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 208, 180, 180),
                          radius: 15.0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 16, color: Colors.white),
                            onPressed: _showImagePickerDialog,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.transparent),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(
                      controller: _fullNameController,
                      label: "ชื่อ - นามสกุล",
                      icon: Icons.person),
                  const Divider(color: Colors.transparent),
                  _buildTextField(
                      controller: _usernameController,
                      label: "Username",
                      icon: Icons.assignment_ind),
                  const Divider(color: Colors.transparent),
                  _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email),
                  const Divider(color: Colors.transparent),
                  _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      hint: "รหัสผ่านต้องมีอย่างน้อย 6 ตัว"),
                  const Divider(color: Colors.transparent),
                  //_buildTextField(controller: _dobController, label: "วันเกิด", icon: Icons.cake, hint: "วัน / เดือน / ปี พ.ศ."),
                  //const Divider(color: Colors.transparent),
                ],
              ),
              //const Divider(color: Colors.transparent),
              _buildTextField(
                  controller: _weightController,
                  label: "น้ำหนัก",
                  icon: Icons.monitor_weight,
                  hint: ".kg"),
              const Divider(color: Colors.transparent),
              _buildTextField(
                  controller: _heightController,
                  label: "ส่วนสูง",
                  icon: Icons.emoji_people,
                  hint: ".cm"),
              const Divider(color: Colors.transparent),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  labelText: "เพศ",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 58, 57, 57),
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(65, 255, 255, 255),
                  icon: Icon(Icons.wc),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                value: selectedValue,
                items: gender.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
              const Divider(color: Colors.transparent),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: _saveChanges,
                        backgroundColor: const Color.fromARGB(255, 28, 49, 82),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Save Changes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 58, 57, 57),
          fontSize: 15,
        ),
        hintText: hint,
        filled: true,
        fillColor: const Color.fromARGB(65, 255, 255, 255),
        icon: Icon(icon),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
