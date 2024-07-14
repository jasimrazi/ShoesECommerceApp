import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/screens/details.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/searchbar.dart';

class Products extends StatefulWidget {
  final bool isBestseller;

  const Products({Key? key, required this.isBestseller}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late TextEditingController _searchController;
  late Future<List<Map<String, dynamic>>> _products;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _products = _fetchProducts();
  }

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('shoes').get();

      List<Map<String, dynamic>> products = querySnapshot.docs
          .where((doc) =>
              doc.data()['tag'] != null &&
              doc.data()['tag'].contains(
                  widget.isBestseller ? 'Best Seller' : 'Best Choice') &&
              (doc.data()['name'] as String).toLowerCase().contains(_searchTerm
                  .toLowerCase())) // Filter based on tags and search term
          .map((doc) => doc.data())
          .toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  void _performSearch(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _products =
          _fetchProducts(); // Re-fetch products with the new search term
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Products', isBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onSearch: _performSearch,
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CupertinoActivityIndicator());
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return Center(child: Text('No products available'));
                  }

                  List<Map<String, dynamic>> products = snapshot.data!;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 10),
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.65, // Adjust as needed
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> product = products[index];
                        return _buildProductItem(product);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    bool isFavorite = product['isFavorite'] ?? false;

    return GestureDetector(
      onTap: () => _navigateToDetails(product['id']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Image.network(
                      product['imageUrls'][0],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'BEST SELLER',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '\$${product['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleFavorite(product['id'], !isFavorite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(String productId, bool isFavorite) async {
    try {
      // Update Firestore document for the product to toggle favorite status
      await FirebaseFirestore.instance
          .collection('shoes')
          .doc(productId)
          .update({
        'isFavorite': isFavorite,
      });
      setState(() {
        // Update local UI state
        _products = _fetchProducts();
      });
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  void _navigateToDetails(String productId) {
    // Navigate to details page for the selected product
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(shoeId: productId),
      ),
    );
  }
}
