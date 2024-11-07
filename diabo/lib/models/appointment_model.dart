class AppointmentModel {
  final String? id;
  final String hospital;
  final String date;
  final String appointmentDate;
  final String uid;

  AppointmentModel(
      {this.id,
      required this.hospital,
      required this.date,
      required this.appointmentDate,
      required this.uid});

  // แปลงข้อมูลจาก Firestore Document เป็น Product Object
  factory AppointmentModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return AppointmentModel(
        id: documentId,
        hospital: data['hospital'],
        date: data['date'],
        appointmentDate: data['appointmentDate'],
        uid: data['uid']);
  }

  // แปลง Product Object เป็น Map ก่อนส่งไปบันทึกใน Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'hospital': hospital,
      'date': date,
      'appointmentDate': appointmentDate,
      'uid': uid,
    };
  }
}
