import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/data/firebase_data.dart';
import 'package:shoesapp/model/shoe_model.dart';
import 'package:shoesapp/model/task_model.dart';
import 'package:shoesapp/screens/products.dart';
import 'package:shoesapp/utils/theme.dart';
import 'package:shoesapp/widget/app_drawer.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/searchbar.dart';
import 'details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _searchController;
  late List<Shoe> bestSellerShoes;
  late List<Shoe> bestChoiceShoes;
  bool _isLoading = true;

  @override
  void initState() {
    _searchController = TextEditingController();
    _fetchShoes();
    super.initState();
  }

  Future<void> _fetchShoes() async {
    ShoeService shoeService = ShoeService();
    List<Shoe> shoes = await shoeService.fetchShoes();
    if (mounted) {
      setState(() {
        bestSellerShoes =
            shoes.where((shoe) => shoe.tag == 'Best Seller').toList();
        bestChoiceShoes =
            shoes.where((shoe) => shoe.tag == 'Best Choice').toList();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    String searchTerm = _searchController.text;
    print('Performing search for: $searchTerm');
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
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(
        title: 'Home',
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Shoes',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Products(isBestseller: true,)));
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      height: 230,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: bestSellerShoes.length,
                        itemBuilder: (context, index) {
                          final Shoe shoe = bestSellerShoes[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetails(shoe.id),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 157,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 120,
                                        child: Transform.rotate(
                                          angle: -0.3,
                                          child: Image.network(
                                            shoe.imageUrls[0],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              'BEST SELLER',
                                              style: TextStyle(
                                                  color: kPrimary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              shoe.name,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              '\$${shoe.price}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: kPrimary,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Arrivals',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Products(
                                          isBestseller: false,
                                        )));
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 21, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: PageView.builder(
                        physics: BouncingScrollPhysics(),
                        pageSnapping: true,
                        itemCount: bestChoiceShoes.length,
                        itemBuilder: (context, index) {
                          final Shoe shoe = bestChoiceShoes[index];
                          return GestureDetector(
                            onTap: () => _navigateToDetails(shoe.id),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 144,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'BEST CHOICE',
                                        style: TextStyle(
                                            color: kPrimary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        shoe.name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        '\$${shoe.price}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Transform.rotate(
                                      angle: -0.3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          shoe.imageUrls[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
