import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/appointment_model.dart';
import 'package:diabo/models/lab_model.dart';

class LabService {
  final CollectionReference _labsCollection =
      FirebaseFirestore.instance.collection('labs');

  //วันนัด
  Future<void> addLab(LabModel lab) async {
    try {
      await _labsCollection.add(lab.toFirestore());
    } catch (e) {
      throw Exception('Error adding appointment: $e');
    }
  }

  Future<List<LabModel>> getLabByUid(String uid) async {
    try {
      QuerySnapshot snapshot =
          await _labsCollection.where('uid', isEqualTo: uid).get();
      return snapshot.docs.map((doc) {
        return LabModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // ฟังก์ชันลบการนัดหมาย
  Future<void> deleteLab(String id) async {
    try {
      await _labsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }
}
