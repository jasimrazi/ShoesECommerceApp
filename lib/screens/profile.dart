import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/screens/auth/sign_in.dart';
import 'package:shoesapp/utils/theme.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'package:shoesapp/widget/textbar.dart';
import 'package:shoesapp/widget/textfield.dart';
import 'package:shoesapp/widget/elevated_button.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  final TextEditingController _emailController = TextEditingController();
  String _userName = '';
  String _userEmail = '';
  String _userAddress = '';
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _emailController.text = _user.email!;
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('userinfo')
          .doc('placeholder')
          .get();

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _userName = data['name'] ?? '';
        _userEmail = data['email'] ?? '';
        _userAddress = data['address'] ?? '';
        _profileImageUrl = data['profileImageUrl'] ?? '';
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        isEdit: true,
        isBack: false,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Implement image loading logic or navigation to full-size image view
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kSecondary.withOpacity(0.3),
                ),
                child: _profileImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: NetworkImage(_profileImageUrl),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: kSecondary,
                        size: 100,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextBar(title: 'Name', fieldTitle: _userName),
            CustomTextBar(title: 'Email', fieldTitle: _userEmail),
            CustomTextBar(title: 'Address', fieldTitle: _userAddress),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: _logout,
              text: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
