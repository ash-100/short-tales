import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/models/story.dart';
import 'package:short_tales/screens/story_desc_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _future = firestore.collection('stories').get();
  bool searched = false;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (searchController.text.toString().trim() == "") {
                            var snackBar =
                                SnackBar(content: Text('Enter a name'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            setState(() {
                              searched = true;
                              _future = firestore
                                  .collection('stories')
                                  .where('name',
                                      isGreaterThanOrEqualTo: searchController
                                          .text
                                          .toString()
                                          .trim())
                                  .get();
                            });
                          }
                        },
                      ),
                      border: InputBorder.none,
                      label: Text('Search a story'),
                    ),
                  ),
                ),
              ),
              searched ? Text('Search Results') : Text('Recommended'),
              Container(
                //color: Colors.black,
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
                          child: Text('No story found'),
                        );
                      }
                      var documents = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            Story story = Story.fromSnap(documents[index]);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
