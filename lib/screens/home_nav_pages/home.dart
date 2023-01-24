import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/screens/widgets/header_category.dart';
import 'package:short_tales/screens/widgets/single_category.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _future = firestore.collection('topics').orderBy('order').get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // FutureBuilder<QuerySnapshot>(
            //   future: firestore.collection('header').get(),
            //   builder: (BuildContext context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Container(
            //         height: 200,
            //         child: Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     }
            //     if (snapshot.hasError) {
            //       return Center(
            //         child: Text('Loading Error'),
            //       );
            //     }
            //     List<DocumentSnapshot> documents = snapshot.data!.docs;
            //     return ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: snapshot.data!.size,
            //       itemBuilder: (context, index) {
            //         return HeaderCategory(
            //           id: documents[index]['id'],
            //         );
            //       },
            //     );
            //   },
            // ),
            Container(
              //color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.88,
              child: FutureBuilder<QuerySnapshot>(
                future: _future,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Loading Error'),
                    );
                  }
                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    //shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      if (documents[index]['name'] == 'Header') {
                        return HeaderCategory(id: documents[index]['id']);
                      }
                      return SingleCategory(name: documents[index]['name']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
