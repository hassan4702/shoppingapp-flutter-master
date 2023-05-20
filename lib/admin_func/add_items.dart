import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class addItem extends StatefulWidget {
  const addItem({super.key});

  @override
  State<addItem> createState() => _addItemState();
}

class _addItemState extends State<addItem> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController despcontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();

  void AddData(String name, String desp, String price, String image) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('items');

    DocumentReference docRef = await usersCollection.add(
        {'name': name, 'description': desp, 'price': price, 'image': image});
    if (docRef.id != null) {
      // Data added successfully
      print('Data submitted to Firestore with document ID: ${docRef.id}');
    } else {
      // Failed to add data
      print('Failed to submit data to Firestore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add data in firebase")),
        body: Form(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: namecontroller,
                decoration: InputDecoration(
                    labelText: "name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: despcontroller,
                decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: pricecontroller,
                decoration: InputDecoration(
                    labelText: "price",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_bitcoin)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: imagecontroller,
                decoration: InputDecoration(
                    labelText: "image",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image_sharp)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 1, 8, 0),
              child: ElevatedButton(
                  onPressed: () {
                    AddData(namecontroller.text, despcontroller.text,
                        pricecontroller.text, imagecontroller.text);
                    print(namecontroller.text);
                    print(despcontroller.text);
                    print(pricecontroller.text);
                    namecontroller.clear();
                    despcontroller.clear();
                    pricecontroller.clear();
                    imagecontroller.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Submit")),
            ),
          ],
        )));
  }
}
