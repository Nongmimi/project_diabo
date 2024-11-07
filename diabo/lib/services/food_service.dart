import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabo/models/food_model.dart';
import 'package:diabo/models/lab_model.dart';

class FoodService {
  final CollectionReference _foodsCollection =
      FirebaseFirestore.instance.collection('foods');

  //อาหาร
  Future<void> addFood(FoodModel lab) async {
    try {
      await _foodsCollection.add(lab.toFirestore());
    } catch (e) {
      throw Exception('Error adding appointment: $e');
    }
  }

  Future<List<FoodModel>> getFoodByUid(String uid) async {
    try {
      QuerySnapshot snapshot =
          await _foodsCollection.where('uid', isEqualTo: uid).get();
      return snapshot.docs.map((doc) {
        return FoodModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // ฟังก์ชันลบการนัดหมาย
  Future<void> deleteFood(String id) async {
    try {
      await _foodsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }

  Future<List<FoodModel>> getFoodByDate(
      String uid, DateTime currentDate) async {
    try {
      DateTime startOfDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      DateTime endOfDay = DateTime(
          currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
      QuerySnapshot snapshot = await _foodsCollection
          .where('uid', isEqualTo: uid)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();
      return snapshot.docs.map((doc) {
        var foodModel =
            FoodModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);

        return foodModel;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products by date: $e');
    }
  }

  Future<List<FoodModel>> getFoodLast15Day(String uid) async {
    try {
      DateTime today = DateTime.now();
      DateTime startDate = today.subtract(const Duration(days: 15));
      QuerySnapshot snapshot = await _foodsCollection
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: today)
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) {
        var foodModel =
            FoodModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);

        return foodModel;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products by date: $e');
    }
  }

  Future<List<FoodModel>> getFoodLast30Day(String uid) async {
    try {
      DateTime today = DateTime.now();
      DateTime startDate = today.subtract(const Duration(days: 15));
      QuerySnapshot snapshot = await _foodsCollection
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: today)
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) {
        var foodModel =
            FoodModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);

        return foodModel;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products by date: $e');
    }
  }
}
