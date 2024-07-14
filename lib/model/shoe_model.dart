// shoe.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final String id;
  final String name;
  final String description;
  final String brand;
  final double price;
  final List<String> imageUrls;
  final String color;
  final List<String> sizes;
  final String tag;

  Shoe({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.price,
    required this.imageUrls,
    required this.color,
    required this.sizes,
    required this.tag,
  });

  factory Shoe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Shoe(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      brand: data['brand'],
      price: data['price'],
      imageUrls: List<String>.from(data['imageUrls']),
      color: data['color'],
      sizes: List<String>.from(data['sizes']),
      tag: data['tag'],
    );
  }
}
