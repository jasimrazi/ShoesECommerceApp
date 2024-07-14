import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/utils/theme.dart';
import 'package:shoesapp/widget/appbar.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true; // Initially set to true to show loading indicator

  Future<void> _removeFromCart(String productId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc('items')
            .collection('items')
            .doc(productId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item removed from cart')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> _getShoeDetails(String shoeId) async {
    try {
      final userCartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('cart')
          .doc('items')
          .collection('items')
          .doc(shoeId);

      final docSnapshot = await userCartRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        String selectedSize = data['size'] ?? 'Size not specified';

        // Now fetch the shoe details from the 'shoes' collection
        DocumentSnapshot shoeSnapshot = await FirebaseFirestore.instance
            .collection('shoes')
            .doc(shoeId)
            .get();
        if (shoeSnapshot.exists) {
          Map<String, dynamic> shoeData =
              shoeSnapshot.data() as Map<String, dynamic>;
          return {
            ...shoeData,
            'selectedSize': selectedSize,
          };
        } else {
          throw 'Shoe not found';
        }
      } else {
        throw 'Item not found in cart';
      }
    } catch (e) {
      throw 'Failed to fetch shoe details: $e';
    }
  }

  Future<void> _increaseQuantity(String productId, int currentQuantity) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc('items')
            .collection('items')
            .doc(productId)
            .update({'quantity': currentQuantity + 1});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity increased')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  Future<void> _decreaseQuantity(String productId, int currentQuantity) async {
    try {
      if (currentQuantity > 1) {
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc('items')
              .collection('items')
              .doc(productId)
              .update({'quantity': currentQuantity - 1});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Quantity decreased')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantity cannot be less than 1')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Set to false when loading is complete
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Cart',
      ),
      body: _isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : user == null
              ? Center(child: Text('Please log in to view your cart'))
              : StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(user.uid)
                      .collection('cart')
                      .doc('items')
                      .collection('items')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Your cart is empty'));
                    }

                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        String shoeId = doc.id;
                        int quantity = (doc.data()
                                as Map<String, dynamic>?)?['quantity'] ??
                            1;
                        String selectedSize = (doc.data()
                                as Map<String, dynamic>?)?['size'] ??
                            'Size not specified'; // Fetch 'size' instead of 'selectedSize'

                        return FutureBuilder<Map<String, dynamic>>(
                          future: _getShoeDetails(shoeId),
                          builder: (context, shoeSnapshot) {
                            if (shoeSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(); // Do not show loading indicator for each item
                            }

                            if (shoeSnapshot.hasError) {
                              return ListTile(
                                title: Text('Error: ${shoeSnapshot.error}'),
                              );
                            }

                            Map<String, dynamic> data = shoeSnapshot.data!;
                            List<dynamic> sizes = data['sizes'];

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.network(
                                      data['imageUrls'][0],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '\$${data['price']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Size: $selectedSize', // Display selected size
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                size: 16,
                                              ),
                                              onPressed: () =>
                                                  _decreaseQuantity(
                                                      shoeId, quantity),
                                            ),
                                            Text('$quantity'),
                                            IconButton(
                                              icon: Icon(
                                                Icons.add_circle,
                                                size: 20,
                                                color: kPrimary,
                                              ),
                                              onPressed: () =>
                                                  _increaseQuantity(
                                                      shoeId, quantity),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () => _removeFromCart(shoeId),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
    );
  }
}
