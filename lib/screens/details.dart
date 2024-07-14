import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/data/firebase_data.dart';
import 'package:shoesapp/model/shoe_model.dart';
import 'package:shoesapp/utils/theme.dart';
import 'package:shoesapp/widget/appbar.dart';

class Details extends StatefulWidget {
  final String shoeId;

  const Details({Key? key, required this.shoeId}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int selectedSizeIndex = -1; // Initially no size is selected
  int selectedImageIndex = 0; // Initially show the first image in the gallery
  late Future<Shoe?> _shoeFuture; // Change to Future<Shoe?>
  bool isFavourite = false; // Track if the shoe is in favourites
  bool isLoadingCart = false; // Track loading state for cart button
  bool isLoadingFavourite = false; // Track loading state for favourite button
  Shoe? shoe; // Class level variable to hold the Shoe data

  @override
  void initState() {
    super.initState();
    _shoeFuture = ShoeService().getShoeById(widget.shoeId);
    checkIfFavourite();
  }

  Future<void> checkIfFavourite() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userFavouriteRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favourite')
            .doc(widget.shoeId);

        final docSnapshot = await userFavouriteRef.get();
        if (docSnapshot.exists) {
          setState(() {
            isFavourite = true;
          });
        }
      }
    } catch (e) {
      print('Error checking favourite: $e');
    }
  }

  Future<void> _addToCart(String shoeId) async {
    if (selectedSizeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a size')),
      );
      return;
    }

    setState(() {
      isLoadingCart = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final userCartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc('items')
          .collection('items')
          .doc(shoeId);

      final docSnapshot = await userCartRef.get();
      if (docSnapshot.exists) {
        await userCartRef.update({
          'quantity': FieldValue.increment(1),
          'size':
              shoe!.sizes[selectedSizeIndex], // Use class-level shoe variable
        });
      } else {
        await userCartRef.set({
          'quantity': 1,
          'size':
              shoe!.sizes[selectedSizeIndex], // Use class-level shoe variable
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    } finally {
      setState(() {
        isLoadingCart = false;
      });
    }
  }

  Future<void> _toggleFavourite(String shoeId) async {
    setState(() {
      isLoadingFavourite = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final userFavouriteRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourite')
          .doc(widget.shoeId);

      final docSnapshot = await userFavouriteRef.get();
      if (docSnapshot.exists) {
        await userFavouriteRef.delete();
        setState(() {
          isFavourite = false;
        });
      } else {
        await userFavouriteRef.set({});
        setState(() {
          isFavourite = true;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavourite ? 'Added to favourites!' : 'Removed from favourites!',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favourites: $e')),
      );
    } finally {
      setState(() {
        isLoadingFavourite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBack: true,
        title: 'Men\'s Shoes',
      ),
      body: FutureBuilder<Shoe?>(
        future: _shoeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error loading shoe details'));
          }

          shoe = snapshot.data!; // Store fetched shoe data

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Image.network(
                      shoe!.imageUrls[selectedImageIndex],
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        shoe!.tag.toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kPrimary,
                        ),
                      ),
                      Text(
                        shoe!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\$${shoe!.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        shoe!.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff707B81),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 56,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: shoe!.imageUrls.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImageIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  width: 56,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xffF8F9FA),
                                  ),
                                  child: Image.network(
                                    shoe!.imageUrls[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Size',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: shoe!.sizes.length,
                          itemBuilder: (context, index) {
                            bool isSelected = selectedSizeIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSizeIndex = index;
                                });
                              },
                              child: Container(
                                width: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSelected ? kPrimary : Color(0xffF8F9FA),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: kPrimary.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    shoe!.sizes[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Shoe?>(
        future: _shoeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          } else if (snapshot.hasError || !snapshot.hasData) {
            return SizedBox.shrink();
          }

          final shoe = snapshot.data!;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '\$${shoe.price}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: kPrimary.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : Colors.grey,
                    ),
                    onPressed: isLoadingFavourite
                        ? null
                        : () => _toggleFavourite(widget.shoeId),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed:
                      isLoadingCart ? null : () => _addToCart(widget.shoeId),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: isLoadingCart
                      ? CupertinoActivityIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
