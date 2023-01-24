import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:short_tales/screens/auth/login_screen.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  PageDecoration pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyPadding: EdgeInsets.zero,
      //pageColor: Colors.white,
      contentMargin: EdgeInsets.zero,
      footerPadding: EdgeInsets.zero,
      imagePadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IntroductionScreen(
          autoScrollDuration: 3000,
          pages: [
            PageViewModel(
                decoration: pageDecoration,
                titleWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFF4B91F1),
                  child: Image.asset('assets/images/logo.png'),
                ),
                bodyWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                      child: Text(
                          '"Read short stories anytime, anywhere with Short Tales."')),
                )),
            PageViewModel(
                decoration: pageDecoration,
                titleWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFF4B91F1),
                  child: Image.asset('assets/images/logo.png'),
                ),
                bodyWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                      child: Text(
                          '"Discover new stories with Short Tales\' curated selection."')),
                )),
            PageViewModel(
                decoration: pageDecoration,
                titleWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFF4B91F1),
                  child: Image.asset('assets/images/logo.png'),
                ),
                bodyWidget: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                      child: Text(
                          '"Save your favorite stories and access them anytime with Short Tales."')),
                )),
          ],
          showSkipButton: false,
          back: Icon(Icons.arrow_back),
          skip: Text('skip'),
          next: Icon(Icons.arrow_forward),
          done: Text('Done'),
          onDone: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          onSkip: () {},
        ),
      ),
    );
  }
}
