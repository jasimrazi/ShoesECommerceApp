import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;
  final Category category;
  final List<Map<String, dynamic>> ratings;
  final List<String> tags;
  final List<Map<String, dynamic>> variants;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.ratings,
    required this.tags,
    required this.variants,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
      image: map['image'],
      category: Category.fromMap(map['category']),
      ratings: List<Map<String, dynamic>>.from(map['ratings']),
      tags: List<String>.from(map['tags']),
      variants: List<Map<String, dynamic>>.from(map['variants']),
    );
  }
}

class Category {
  final int id;
  final String name;
  final List<String> subcategories;

  Category({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      subcategories: List<String>.from(map['subcategories']),
    );
  }
}

final List<Map<String, dynamic>> products = [
  {
    'id': 1,
    'name': 'Smartphone',
    'price': 999.99,
    'description': 'A powerful smartphone with advanced features.',
    'image': 'assets/images/smartphone.jpg',
    'category': {
      'id': 1,
      'name': 'Electronics',
      'subcategories': ['Mobiles', 'Laptops', 'Accessories']
    },
    'ratings': [
      {'userId': 1, 'rating': 4.5},
      {'userId': 2, 'rating': 4.8},
      {'userId': 3, 'rating': 4.2},
    ],
    'tags': ['mobile', 'tech', 'communication'],
    'variants': [
      {'color': 'Black', 'storage': '64GB', 'price': 999.99},
      {'color': 'White', 'storage': '128GB', 'price': 1099.99},
    ]
  },
  {
    'id': 2,
    'name': 'Laptop',
    'price': 1499.99,
    'description': 'High-performance laptop for work and gaming.',
    'image': 'assets/images/laptop.jpg',
    'category': {
      'id': 1,
      'name': 'Electronics',
      'subcategories': ['Laptops', 'Desktops', 'Accessories']
    },
    'ratings': [
      {'userId': 1, 'rating': 4.8},
      {'userId': 2, 'rating': 4.9},
    ],
    'tags': ['computer', 'tech', 'work'],
    'variants': [
      {'processor': 'Intel i7', 'ram': '16GB', 'price': 1499.99},
      {'processor': 'AMD Ryzen 9', 'ram': '32GB', 'price': 1799.99},
    ]
  },
  {
    'id': 3,
    'name': 'Headphones',
    'price': 199.99,
    'description': 'Wireless headphones with noise-canceling technology.',
    'image': 'assets/images/headphones.jpg',
    'category': {
      'id': 2,
      'name': 'Accessories',
      'subcategories': ['Headphones', 'Cases', 'Chargers']
    },
    'ratings': [
      {'userId': 1, 'rating': 4.3},
      {'userId': 2, 'rating': 4.0},
    ],
    'tags': ['audio', 'music', 'sound'],
    'variants': [
      {'type': 'Wireless', 'color': 'Black', 'price': 199.99},
      {'type': 'Bluetooth', 'color': 'White', 'price': 219.99},
    ]
  },
  {
    'id': 4,
    'name': 'Running Shoes',
    'price': 129.99,
    'description': 'Comfortable running shoes for all types of runners.',
    'image': 'assets/images/shoes.jpg',
    'category': {
      'id': 3,
      'name': 'Sports',
      'subcategories': ['Running', 'Fitness', 'Outdoor']
    },
    'ratings': [
      {'userId': 1, 'rating': 4.7},
      {'userId': 2, 'rating': 4.5},
    ],
    'tags': ['sports', 'running', 'fitness'],
    'variants': [
      {'size': 'US 7', 'color': 'Red', 'price': 129.99},
      {'size': 'US 8', 'color': 'Blue', 'price': 139.99},
    ]
  },
  // Add more products as needed
];

List<Product> productList =
    products.map((product) => Product.fromMap(product)).toList();
