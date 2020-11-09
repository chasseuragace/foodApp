import 'package:flutter/material.dart';
import 'package:food_app/screens/login_wrapper.dart';
import 'package:food_app/services/shared_prefrernces/shared_pref.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  List pageInfos = [
    {
      "title": "Hungry?",
      "body":
          "We've got you covered! Choose your favourite dish from a large collection gathered together to best suit your preference!",
      "img": "assets/on1.png",
    },
    {
      "title": "Want a quick meal ?",
      "body":
          "We got that covered to! Browse through the catalogue, pick your meal and we'll deliver it right yo your doors!",
      "img": "assets/on2.png",
    },
    {
      "title": "Preparing for something special?",
      "body":
          "We have that covered too, set up an event, specify the details, and that's it! We'll work our best to set up the mood!",
      "img": "assets/on3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      for (int i = 0; i < pageInfos.length; i++) _buildPageModel(pageInfos[i])
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: IntroductionScreen(
            pages: pages,
            onDone: _onDone,
            onSkip: _onDone,
            showSkipButton: true,
            skip: Text("Skip"),
            next: Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item) {
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset(
        item['img'],
        height: 185.0,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).accentColor,
        ),
        bodyTextStyle: TextStyle(fontSize: 15.0),
//        dotsDecorator: DotsDecorator(
//          activeColor: Theme.of(context).accentColor,
//          activeSize: Size.fromRadius(8),
//        ),
        pageColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _onDone() {
    LocalStorage.skipIntro();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginStateWrapper();
        },
      ),
    );
  }
}
