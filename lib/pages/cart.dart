import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../services/functions/firebaseFunctions.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  void removeFromCart(String documentId) async {
    try {
      CollectionReference cartCollection =
          FirebaseFirestore.instance.collection('shopping_cart');
      await cartCollection.doc(documentId).delete();
      // Product removed from cart successfully
    } catch (error) {
      // Error occurred while removing product from cart
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('shopping_cart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data!.docs.map((doc) {
              return Product(
                id: doc.id,
                name: doc['name'],
                price: doc['price'],
              );
            }).toList();

            // Display the products in the cart
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text('Price: \$${products[index].price}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeFromCart(products[index].id);
                    },
                  ),
                );
              },
            );
          } else {
            // Display a loading indicator or error message
            return CircularProgressIndicator();
          }
        },
      ),
    );
    ;
  }
}
