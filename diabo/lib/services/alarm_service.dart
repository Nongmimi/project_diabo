import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/alarm_model.dart';
import 'package:diabo/models/appointment_model.dart';

class AlarmService {
  final CollectionReference _alarmsCollection =
      FirebaseFirestore.instance.collection('alarms');

  //วันนัด
  Future<void> addAlarm(AlarmModel alarm) async {
    try {
      await _alarmsCollection.add(alarm.toFirestore());
    } catch (e) {
      throw Exception('Error adding appointment: $e');
    }
  }

  Future<List<AlarmModel>> getAlarmByUid(String uid) async {
    try {
      QuerySnapshot snapshot =
          await _alarmsCollection.where('uid', isEqualTo: uid).get();
      return snapshot.docs.map((doc) {
        return AlarmModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // ฟังก์ชันลบการนัดหมาย
  Future<void> deleteAlarmt(String id) async {
    try {
      await _alarmsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }

  Future<void> delAlarmByTimeKey(int timeKey) async {
    try {
      QuerySnapshot querySnapshot =
          await _alarmsCollection.where('timeKey', isEqualTo: timeKey).get();
      for (var doc in querySnapshot.docs) {
        await _alarmsCollection.doc(doc.id).delete();
        print('Deleted document: ${doc.id}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
