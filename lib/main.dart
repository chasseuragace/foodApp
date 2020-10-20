import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:food_app/common.dart';
import 'package:food_app/screens/login.dart';
import 'package:food_app/screens/testshop.dart';
import 'package:food_app/services/firebase/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => ServiceManager(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: TestShop()),
    );
  }
}

class LoginStateWrapper extends StatelessWidget {
  final PageController _controller =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    Widget containerMaker(Color color) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        color: color,
        child: Image.network(
          "https://cdn.shopify.com/s/files/1/0070/7032/files/food_photography_hero.jpg?v=1504106067",
          fit: BoxFit.cover,
        ),
      );
    }

    final manager = Provider.of<ServiceManager>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<LoginStates>(
          stream: manager.loginStream,
          builder: (contextx, snapshot) {
            final state = snapshot.data;
            print(state);
            if (state == LoginStates.error)
              Future.delayed(Duration(milliseconds: 100), () {
                Scaffold.of(contextx).showSnackBar(const SnackBar(
                    content: Text(
                        "🤷 ‍Oops! Couldn't log you in. Please retry in a minute.")));
              });
            animate(state);
            return Scaffold(
              body: Stack(
                children: [
                  ClipPath(
                      clipper: MyClipper(),
                      child: containerMaker(Colors.orange)),
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: [LoginPage(data: state), HomePage()],
                  ),
                ],
              ),
            );
          }),
    );
  }

  animate(LoginStates state) {
    Future.delayed(Duration(seconds: 3), () {
      if (_controller.hasClients) if (state == LoginStates.loggedIn)
        _controller.animateToPage(
          1,
          duration: Duration(seconds: 1),
          curve: Curves.easeOutCubic,
        );
      else if (state == LoginStates.loggedOut)
        _controller.animateToPage(0,
            duration: Duration(seconds: 1), curve: Curves.easeOutCubic);
    });
  }
}
