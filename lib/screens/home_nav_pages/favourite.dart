import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';

import '../../models/story.dart';
import '../story_desc_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List _storyIds = [];
  var _future = firestore.collection('stories').get();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List temp = [];
    firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('favouriteStories')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        _storyIds.add(doc.data()['id'].toString());
        //print(doc.data()['id']);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _storyIds.isEmpty
          ? Center(child: Text("Favourite Stories Collection is empty"))
          : SafeArea(
              child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
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
                          child: Text('Error Loading'),
                        );
                      }
                      if (snapshot.hasData && snapshot.data!.docs.length == 0) {
                        return Center(
                          child: Text('No favourite story found'),
                        );
                      }
                      var documents = snapshot.data!.docs;

                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            Story story = Story.fromSnap(documents[index]);
                            if (_storyIds.contains(documents[index].id) ==
                                false) {
                              return SizedBox.shrink();
                            }
                            return ListTile(
                              title: Text(story.name),
                              subtitle: Text(story.description),
                              leading: Image.network(story.thumbnail),
                              // leading:
                              //     CachedNetworkImage(imageUrl: story.thumbnail),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StoryDescScreen(story: story)));
                              },
                            );
                          });
                    }),
              ),
            )),
    );
  }
}
