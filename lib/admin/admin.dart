import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoesapp/widget/elevated_button.dart';
import 'package:shoesapp/widget/textfield.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizesController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  List<File?> _images = [null, null, null];
  bool _isLoading = false;

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _images[index] = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _brandController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _sizesController.text.isEmpty ||
        _tagController.text.isEmpty ||
        _images.any((image) => image == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select all images')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imageUrls = [];
      for (int i = 0; i < _images.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('${_nameController.text}_$i.png');
        await ref.putFile(_images[i]!);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Generate a unique ID for the product
      String productId =
          FirebaseFirestore.instance.collection('shoes').doc().id;

      final shoe = {
        'id': productId, // Add the generated ID to the product data
        'name': _nameController.text,
        'description': _descriptionController.text,
        'brand': _brandController.text,
        'price': double.parse(_priceController.text),
        'imageUrls': imageUrls,
        'color': _colorController.text,
        'sizes': _sizesController.text.split(',').map((s) => s.trim()).toList(),
        'tag': _tagController.text,
      };

      // Use the generated ID to create the document in Firestore
      await FirebaseFirestore.instance
          .collection('shoes')
          .doc(productId)
          .set(shoe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );

      // Clear all fields
      _nameController.clear();
      _descriptionController.clear();
      _brandController.clear();
      _priceController.clear();
      _colorController.clear();
      _sizesController.clear();
      _tagController.clear();
      setState(() {
        _images = [null, null, null];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              CustomTextField(
                labelText: 'Product Name',
                controller: _nameController,
              ),
              CustomTextField(
                labelText: 'Description',
                controller: _descriptionController,
              ),
              CustomTextField(
                labelText: 'Brand',
                controller: _brandController,
              ),
              CustomTextField(
                labelText: 'Price',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                labelText: 'Color',
                controller: _colorController,
              ),
              CustomTextField(
                labelText: 'Sizes (comma separated)',
                controller: _sizesController,
              ),
              CustomTextField(
                labelText: 'Tag',
                controller: _tagController,
              ),
              SizedBox(height: 20),
              ...List.generate(3, (index) {
                return Column(
                  children: [
                    _images[index] == null
                        ? Text('No image selected.')
                        : Image.file(_images[index]!, height: 150),
                    ElevatedButton(
                      onPressed: () => _pickImage(index),
                      child: Text('Select Image ${index + 1}'),
                    ),
                  ],
                );
              }),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _addProduct,
                text: 'Add Product',
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
