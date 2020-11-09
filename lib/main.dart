import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/podo/tempdata.dart';
import 'package:food_app/providers/theme_provider.dart';
import 'package:food_app/providers/firebase/service_manager.dart';
import 'package:food_app/screens/login_wrapper.dart';
import 'package:food_app/screens/walkthrough.dart';
import 'package:food_app/services/shared_prefrernces/shared_pref.dart';
import 'package:food_app/tests.dart';
import 'package:provider/provider.dart';

import 'util/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(
          create: (_) => ServiceManager(),
        ),
        Provider(
          create: (_) => createShop(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider appProvider, Widget child) {
        return MaterialApp(
            key: appProvider.key,
            debugShowCheckedModeBanner: false,
            navigatorKey: appProvider.navigatorKey,
            title: Constants.appName,
            theme: appProvider.theme,
            darkTheme: Constants.darkTheme,
            home:
                // TestWidget()
                LocalStorage.shouldSkipIntro
                    ? LoginStateWrapper()
                    : Walkthrough());
      },
    );
  }
}