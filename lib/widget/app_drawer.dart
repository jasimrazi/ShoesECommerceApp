import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/screens/auth/sign_in.dart';
import 'package:shoesapp/screens/main_screen.dart';

class CustomDrawer extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('userinfo')
          .doc('placeholder')
          .get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff1A2530),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    "",
                    style: TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: CupertinoActivityIndicator(),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff1A2530),
                  ),
                  margin: EdgeInsets.zero,
                );
              } else if (snapshot.hasError) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    "Error",
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    "",
                    style: TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.error, color: Color(0xff1A2530)),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff1A2530),
                  ),
                  margin: EdgeInsets.zero,
                );
              } else {
                var userData = snapshot.data!;
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    userData['name'] ?? 'No Name',
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    userData['email'] ?? 'No Email',
                    style: TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      (userData['name'] != null)
                          ? userData['name'].substring(0, 2).toUpperCase()
                          : 'JD',
                      style:
                          TextStyle(fontSize: 24.0, color: Color(0xff1A2530)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff1A2530),
                  ),
                  margin: EdgeInsets.zero,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white30),
            title: Text(
              "Profile",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(
                          initialPage: MainScreenPage.profile,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home_outlined, color: Colors.white30),
            title: Text(
              "Home Page",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(
                          initialPage: MainScreenPage.home,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined, color: Colors.white30),
            title: Text(
              "My Cart",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(
                          initialPage: MainScreenPage.cart,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_outline, color: Colors.white30),
            title: Text(
              "Favourite",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(
                          initialPage: MainScreenPage.favourite,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_active_outlined,
                color: Colors.white30),
            title: Text(
              "Notifications",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(
                          initialPage: MainScreenPage.notifications,
                        )),
              );
            },
          ),
          Divider(
            color: Colors.white24,
            indent: 50,
            endIndent: 50,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white30),
            title: Text(
              "Logout",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context); // Close the drawer
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SignIn())); // Example route name for login screen
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out")),
      );
    }
  }
}
