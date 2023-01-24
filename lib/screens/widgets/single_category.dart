import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/models/story.dart';
import 'package:short_tales/screens/see_all_stories_screen.dart';
import 'package:short_tales/screens/story_desc_screen.dart';

class SingleCategory extends StatefulWidget {
  SingleCategory({Key? key, required this.name}) : super(key: key);
  String name;

  @override
  State<SingleCategory> createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  List<Story> stories = [];
  var _future;

  Future getStories() async {
    firestore
        .collection('stories')
        //.where('genre', arrayContains: widget.name)
        .get()
        .then((value) {
      List<DocumentSnapshot> _docs = value.docs;
      List<Story> _stories = [];
      for (int i = 0; i < _docs.length; i++) {
        _stories.add(Story.fromSnap(_docs[i]));
      }
      setState(() {
        stories = _stories;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getStories();
    setState(() {
      _future = firestore
          .collection('stories')
          .where('genre', arrayContains: widget.name)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(widget.name),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SeeAllStoriesScreen(name: widget.name)));
              },
              child: Text('See all'),
            )
          ],
        ),
        FutureBuilder<QuerySnapshot>(
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
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, index) {
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
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 130,
                                //child: Image.network(s.thumbnail),
                                child:
                                    CachedNetworkImage(imageUrl: s.thumbnail),
                              ),
                              Container(
                                width: 130,
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
            })
      ]),
    );
  }
}


// Container(
//           height: 180,
//           child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 2,
//               itemBuilder: (BuildContext context, index) {
//                 return Card(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 140,
//                         width: 130,
//                         child: Image.asset('assets/images/logo.png'),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Title'),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//         ),