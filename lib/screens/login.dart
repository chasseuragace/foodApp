import 'package:flutter/material.dart';
import 'package:food_app/providers/firebase/firebase_auth.dart';
import 'package:food_app/providers/firebase/service_manager.dart';
import 'package:food_app/widgets/common.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final LoginStates data;

  const LoginPage({Key key, this.data}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<ServiceManager>(context, listen: false);
    final data = widget.data;
    final height = MediaQuery.of(context).size.height * .5;
    final width = MediaQuery.of(context).size.width * .75;

    return Stack(
      children: [
        AnimatedContainer(
          curve: Curves.easeInCubic,
          duration: Duration(seconds: 3),
          color: widget.data == LoginStates.loggedIn
              ? Colors.white
              : widget.data == LoginStates.loading
                  ? Colors.black.withOpacity(.55)
                  : Colors.transparent,
        ),
        TweenAnimationBuilder(
          duration: Duration(seconds: 1),
          curve: Curves.easeOutBack,
          tween: Tween<double>(begin: .5, end: 1),
          builder: (BuildContext context, double value, Widget child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 6,
              child: Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/splash.png",
                          fit: BoxFit.contain,
                          height: height * .5,
                        ),
                        spaceVertical(6),
                        Text(
                          "Hara Hetta",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                    Container(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 600),
                        child: (data == LoginStates.loggedOut)
                            ? SizedBox(
                                key: UniqueKey(),
                                child: Center(
                                  child: OutlineButton(
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      manager.login();
                                    },
                                    child: Text(
                                      "Login",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                ),
                              )
                            : spinner(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
