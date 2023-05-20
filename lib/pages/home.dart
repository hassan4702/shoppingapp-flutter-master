import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/pages/cart.dart';
import 'package:flutterapp/services/functions/firebaseFunctions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Color appColor = Color(Colors.red.value);

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot> dataStream;

  int _crossAxisCount = 1;

  @override
  void initState() {
    super.initState();
    CollectionReference itemCollection =
        FirebaseFirestore.instance.collection('items');
    dataStream = itemCollection.snapshots();
  }

  void addToCart(Product product) async {
    try {
      CollectionReference cartCollection =
          FirebaseFirestore.instance.collection('shopping_cart');
      await cartCollection.add({
        'name': product.name,
        'price': product.price,
      });
      // Product added to cart successfully
    } catch (error) {
      // Error occurred while adding product to cart
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 900) {
      _crossAxisCount = 3;
    } else if (screenWidth > 600) {
      _crossAxisCount = 2;
    } else if (screenWidth > 400) {
      _crossAxisCount = 1;
    } else {
      _crossAxisCount = 1;
    }
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  if (true) //_cart.items.isNotEmpty
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  const Icon(Icons.shopping_cart),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => cart()),
                );
                // _openCart();
                //////////////////////
              },
            ),
          ],
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Handle drawer item tap for home
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Your cart'),
                onTap: () {
                  // Handle drawer item tap for settings
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => display_data()),
                  //   );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  // Handle drawer item tap for about
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: dataStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return Text('No data found in Firestore');
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                List<DocumentSnapshot> reversedDocs =
                    List.from(snapshot.data!.docs.reversed);
                DocumentSnapshot document = reversedDocs[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String name = data['name'];
                String description = data['description'];
                String price = data['price'];
                String image = data['image'];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Chip(label: Text(price)),
                            const Spacer(flex: 1),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Add to cart'),
                              onPressed: () {
                                Product product = Product(
                                    id: document.id, name: name, price: price);
                                addToCart(product);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
