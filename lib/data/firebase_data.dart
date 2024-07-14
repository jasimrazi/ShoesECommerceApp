import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/model/shoe_model.dart';

class ShoeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Shoe>> fetchShoes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('shoes').get();
      return querySnapshot.docs.map((doc) => Shoe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching shoes: $e');
      return [];
    }
  }

  Future<Shoe?> getShoeById(String shoeId) async {
    try {
      DocumentSnapshot shoeSnapshot =
          await _firestore.collection('shoes').doc(shoeId).get();

      if (shoeSnapshot.exists) {
        return Shoe.fromFirestore(shoeSnapshot);
      } else {
        return null; // Return null if shoe with given ID doesn't exist
      }
    } catch (e) {
      print('Error fetching shoe: $e');
      return null;
    }
  }
}
