import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoesapp/widget/appbar.dart';
import 'dart:io';

import 'package:shoesapp/widget/elevated_button.dart';
import 'package:shoesapp/widget/textfield.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _saveProfileDetails() async {
    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('userinfo')
            .doc('placeholder')
            .set({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'profileImageUrl':
              _imageFile != null ? await _uploadImageToFirebase(user.uid) : '',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile details saved')),
        );

        // Clear fields and reset image
        _nameController.clear();
        _emailController.clear();
        _addressController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile details')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user signed in')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _uploadImageToFirebase(String uid) async {
    if (_imageFile == null) return '';

    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
      return '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Details',
        isBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300],
                  ),
                  child: _imageFile == null
                      ? Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 40,
                        )
                      : null,
                ),
              ),
              CustomTextField(labelText: 'Name', controller: _nameController),
              CustomTextField(
                  labelText: 'Email Address', controller: _emailController),
              CustomTextField(
                  labelText: 'Address', controller: _addressController),
              SizedBox(height: 20),
                  CustomElevatedButton(
                      onPressed: _saveProfileDetails,
                      text: 'Save',
                      isLoading:_isLoading,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
