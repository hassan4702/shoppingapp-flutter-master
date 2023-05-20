import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class delete_data extends StatefulWidget {
  final String documentId;
  delete_data({required this.documentId});

  @override
  State<delete_data> createState() => _delete_dataState();
}

class _delete_dataState extends State<delete_data> {
  void deleteData(String documentId) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('items');

    await usersCollection.doc(documentId).delete();

    print('Data deleted successfully');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alert'),
      content: Text('Are you sure you want to delete ?'),
      actions: <Widget>[
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            print(widget.documentId);
            deleteData(
              widget.documentId,
            );
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
