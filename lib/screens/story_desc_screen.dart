import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/models/story.dart';
import 'package:short_tales/screens/pdf_screen.dart';

import '../controllers/ad_helper.dart';

class StoryDescScreen extends StatefulWidget {
  StoryDescScreen({Key? key, required this.story}) : super(key: key);
  Story story;
  @override
  State<StoryDescScreen> createState() => _StoryDescScreenState();
}

class _StoryDescScreenState extends State<StoryDescScreen> {
  int selected = 1;
  bool isFavourite = false;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
    firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('favouriteStories')
        .where('id', isEqualTo: widget.story.id)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        setState(() {
          isFavourite = false;
        });
      } else {
        setState(() {
          isFavourite = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            //height: MediaQuery.of(context).size.height,
            //color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //child: Image.network(widget.story.thumbnail),
                    child: CachedNetworkImage(
                      imageUrl: widget.story.thumbnail,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.story.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            if (isFavourite) {
                              firestore
                                  .collection('users')
                                  .doc(firebaseAuth.currentUser!.uid)
                                  .collection('favouriteStories')
                                  .where('id', isEqualTo: widget.story.id)
                                  .get()
                                  .then((value) {
                                for (var doc in value.docs) {
                                  doc.reference.delete();
                                }
                              });
                              setState(() {
                                isFavourite = false;
                              });
                            } else {
                              firestore
                                  .collection('users')
                                  .doc(firebaseAuth.currentUser!.uid)
                                  .collection('favouriteStories')
                                  .add({'id': widget.story.id});
                              setState(() {
                                isFavourite = true;
                              });
                            }
                          },
                          icon: isFavourite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_outline),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.story.description),
                  ),
                  Container(
                    height: 100,
                    child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        crossAxisCount: 7,
                        children:
                            List.generate(widget.story.pdfUrl.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index + 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: index + 1 == selected
                                      ? Colors.blue
                                      : Colors.transparent,
                                  border: Border.all()),
                              child:
                                  Center(child: Text((index + 1).toString())),
                            ),
                          );
                        })),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
            ),
            onPressed: () {
              //
              //
              // if (_interstitialAd == null) {
              //   print('Warning: attempt to show interstitial before loaded.');
              //   return;
              // }
              // _interstitialAd!.fullScreenContentCallback =
              //     FullScreenContentCallback(
              //   onAdShowedFullScreenContent: (InterstitialAd ad) =>
              //       print('ad onAdShowedFullScreenContent.'),
              //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
              //     print('$ad onAdDismissedFullScreenContent.');
              //     ad.dispose();
              //     _createInterstitialAd();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => PDFScreen(
              //                   pdfUrls: widget.story.pdfUrl,
              //                   selected: selected,
              //                 )));
              //   },
              //   onAdFailedToShowFullScreenContent:
              //       (InterstitialAd ad, AdError error) {
              //     print('$ad onAdFailedToShowFullScreenContent: $error');
              //     ad.dispose();
              //     _createInterstitialAd();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => PDFScreen(
              //                   pdfUrls: widget.story.pdfUrl,
              //                   selected: selected,
              //                 )));
              //   },
              // );
              // _interstitialAd!.show();
              // _interstitialAd = null;
              _showInterstitialAd();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PDFScreen(
                            pdfUrls: widget.story.pdfUrl,
                            selected: selected,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'Read',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
