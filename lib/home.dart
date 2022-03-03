import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _db.collection("Post").snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Container();
      },
    );
  }
}

class HomePage2 extends StatefulWidget {
  HomePage2({Key? key}) : super(key: key);

  State<HomePage2> createState() => Home();
}

class Home extends State<HomePage2> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void initState() async {
    super.initState();
    var snapshots = await _db.collection("posts").snapshots();
    snapshots.forEach((element) {
      element.docs.forEach((doc) {
        doc.data();
      });
    });

    @override
    Widget build(BuildContext context) {
      return StreamBuilder(
        stream: _db.collection("Post").snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
