import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/models/story.dart';
import 'package:short_tales/screens/story_desc_screen.dart';

class HeaderCategory extends StatefulWidget {
  HeaderCategory({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<HeaderCategory> createState() => _HeaderCategoryState();
}

class _HeaderCategoryState extends State<HeaderCategory> {
  var _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _future = firestore
          .collection('stories')
          .where('id', isEqualTo: widget.id)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: FutureBuilder<QuerySnapshot>(
        future: _future,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Loading Error'),
            );
          }
          var documents = snapshot.data!.docs;
          Story story = Story.fromSnap(documents[0]);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoryDescScreen(story: story)));
            },
            //child: Image.network(story.thumbnail),
            child: CachedNetworkImage(
              imageUrl: story.thumbnail,
            ),
          );
        },
      ),
    );
  }
}
