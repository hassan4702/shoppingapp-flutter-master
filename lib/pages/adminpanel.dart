import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/admin_func/add_items.dart';

import '../admin_func/remove_items.dart';
import '../admin_func/update_items.dart';

class adminpanel extends StatefulWidget {
  const adminpanel({super.key});

  @override
  State<adminpanel> createState() => _adminpanelState();
}

class _adminpanelState extends State<adminpanel> {
  late Stream<QuerySnapshot> dataStream;

  @override
  void initState() {
    super.initState();
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('items');
    dataStream = usersCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addItem(),
                  ),
                );
              },
              icon: Icon(Icons.add))
        ],
        title: Text('All products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Text('No data found in Firestore');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              List<DocumentSnapshot> reversedDocs =
                  List.from(snapshot.data!.docs.reversed);
              DocumentSnapshot document = reversedDocs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String name = data['name'];
              String description = data['description'];
              String price = data['price'];
              String image = data['image'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePage(documentId: document.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(Color.fromARGB(255, 226, 175, 171).value),
                      border: Border.all(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          Text(price),
                        ],
                      ),
                      subtitle: Text(description),
                      trailing: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    delete_data(documentId: document.id),
                              ),
                            );
                          },
                          child: Icon(Icons.highlight_remove_rounded)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
