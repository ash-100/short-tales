import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/screens/story_desc_screen.dart';

import '../models/story.dart';

class SeeAllStoriesScreen extends StatefulWidget {
  SeeAllStoriesScreen({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  State<SeeAllStoriesScreen> createState() => _SeeAllStoriesScreenState();
}

class _SeeAllStoriesScreenState extends State<SeeAllStoriesScreen> {
  var _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = firestore
        .collection('stories')
        .where('genre', arrayContains: widget.name)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot>(
              future: _future,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //add a place holder
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  // add a place holder
                  return Text('Error');
                }
                List<DocumentSnapshot> documents = snapshot.data!.docs;

                return Container(
                  height: 180,
                  padding: EdgeInsets.all(8),
                  // child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: documents.length,
                  //     itemBuilder: (BuildContext context, index) {
                  //                           }),
                  child: GridView.builder(
                      itemCount: documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        Story s = Story.fromSnap(documents[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StoryDescScreen(story: s)));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 130,
                                  child: Image.network(s.thumbnail),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(s.name),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }),
        ),
      ),
    );
  }
}
