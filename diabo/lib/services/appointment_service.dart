import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/appointment_model.dart';

class AppointmentService {
  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  //วันนัด
  Future<void> addAppointment(AppointmentModel appointment) async {
    try {
      await _appointmentsCollection.add(appointment.toFirestore());
    } catch (e) {
      throw Exception('Error adding appointment: $e');
    }
  }

  Future<List<AppointmentModel>> getAppointmentByUid(String uid) async {
    try {
      QuerySnapshot snapshot =
          await _appointmentsCollection.where('uid', isEqualTo: uid).get();
      return snapshot.docs.map((doc) {
        return AppointmentModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // ฟังก์ชันลบการนัดหมาย
  Future<void> deleteAppointment(String id) async {
    try {
      await _appointmentsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }
}
