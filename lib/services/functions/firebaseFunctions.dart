import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name});
  }
}

class Product {
  final String id;
  final String name;
  final String price;

  Product({required this.id, required this.name, required this.price});
}
