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
      backgroundColor: const Color(0xff1A2530),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
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
                return const UserAccountsDrawerHeader(
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
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    userData['email'] ?? 'No Email',
                    style: const TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: userData['profileImageUrl'] != null
                        ? NetworkImage(userData['profileImageUrl'])
                        : null,
                    backgroundColor: Colors.white,
                    child: userData['profileImageUrl'] == null
                        ? Text(
                            (userData['name'] != null)
                                ? userData['name'].substring(0, 2).toUpperCase()
                                : 'JD',
                            style: const TextStyle(
                                fontSize: 24.0, color: Color(0xff1A2530)),
                          )
                        : null,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xff1A2530),
                  ),
                  margin: EdgeInsets.zero,
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white30),
            title: const Text(
              "Profile",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainScreen(
                          initialPage: MainScreenPage.profile,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.white30),
            title: const Text(
              "Home Page",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainScreen(
                          initialPage: MainScreenPage.home,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined, color: Colors.white30),
            title: const Text(
              "My Cart",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainScreen(
                          initialPage: MainScreenPage.cart,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline, color: Colors.white30),
            title: const Text(
              "Favourite",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainScreen(
                          initialPage: MainScreenPage.favourite,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined,
                color: Colors.white30),
            title: const Text(
              "Notifications",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainScreen(
                          initialPage: MainScreenPage.notifications,
                        )),
              );
            },
          ),
          const Divider(
            color: Colors.white24,
            indent: 50,
            endIndent: 50,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white30),
            title: const Text(
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
                  const SignIn())); // Example route name for login screen
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error signing out")),
      );
    }
  }
}
