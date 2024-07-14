import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/screens/cart.dart';
import 'package:shoesapp/screens/favourite.dart';
import 'package:shoesapp/screens/home.dart';
import 'package:shoesapp/screens/notification.dart';
import 'package:shoesapp/screens/profile.dart';
import 'package:shoesapp/utils/theme.dart';

enum MainScreenPage { home, favourite, cart, notifications, profile }

class MainScreen extends StatefulWidget {
  final MainScreenPage initialPage;

  const MainScreen({Key? key, this.initialPage = MainScreenPage.home})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Favourite(),
    const Cart(),
    const Notifications(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = _getIndexFromPage(widget.initialPage);
  }

  int _getIndexFromPage(MainScreenPage page) {
    switch (page) {
      case MainScreenPage.home:
        return 0;
      case MainScreenPage.favourite:
        return 1;
      case MainScreenPage.cart:
        return 2;
      case MainScreenPage.notifications:
        return 3;
      case MainScreenPage.profile:
        return 4;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            selectedItemColor: kPrimary,
            iconSize: 28,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined,
                    color: Colors.transparent),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '',
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
