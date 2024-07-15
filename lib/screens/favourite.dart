import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:shoesapp/utils/theme.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/model/shoe_model.dart';
import 'details.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late Future<List<Shoe>> _favouriteShoesFuture;

  @override
  void initState() {
    super.initState();
    _favouriteShoesFuture = fetchFavouriteShoes();
  }

  Future<List<Shoe>> fetchFavouriteShoes() async {
    try {
      User? user = FirebaseAuth
          .instance.currentUser; // Get current user from FirebaseAuth
      if (user == null) {
        throw Exception('User not logged in');
      }

      final favouriteShoesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourite')
          .get();

      List<String> favouriteShoeIds =
          favouriteShoesSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch details of favourite shoes using their IDs
      List<Shoe> favouriteShoes = [];
      for (String shoeId in favouriteShoeIds) {
        DocumentSnapshot shoeSnapshot = await FirebaseFirestore.instance
            .collection('shoes')
            .doc(shoeId)
            .get();

        if (shoeSnapshot.exists) {
          favouriteShoes.add(Shoe.fromFirestore(shoeSnapshot));
        }
      }

      return favouriteShoes;
    } catch (e) {
      print('Error fetching favourite shoes: $e');
      return [];
    }
  }

  void _navigateToDetails(String shoeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(shoeId: shoeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        
        title: 'Favourite',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Shoe>>(
          future: _favouriteShoesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favourite shoes found'));
            }

            final shoes = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 21,
                mainAxisSpacing: 20,
                childAspectRatio: 0.7, // Adjusted aspect ratio
              ),
              itemCount: shoes.length,
              itemBuilder: (context, index) {
                final shoe = shoes[index];
                return GestureDetector(
                  onTap: () => _navigateToDetails(shoe.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.network(
                                shoe.imageUrls[0], // Use first image for now
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150, // Adjusted height
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xffF8F9FA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                size: 18,
                                color: Colors.red, // Red heart for favourite
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shoe.tag.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: kPrimary,
                                  ),
                                ),
                                Text(
                                  shoe.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '\$${shoe.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
