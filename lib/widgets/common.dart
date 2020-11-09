import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

Widget spaceVertical(double height) {
  return SizedBox(
    height: height,
  );
}

Widget spaceHorizontal(double height) {
  return SizedBox(
    width: height,
  );
}

Widget spinner() {
  return SpinKitCircle(
    color: Colors.orangeAccent,
  );
}

class MyClipper extends CustomClipper<Path> {
  final bool flip;

  MyClipper({this.flip = false});

  @override
  Path getClip(Size size) {
    var x = size.width;
    var y = size.height;
    Offset cp1 = Offset(x * .15, y * .45);
    Offset cp2 = Offset(x * .85, y * .55);

    Path p = Path();
    p
      ..moveTo(0, y)
      ..quadraticBezierTo(cp1.dx, cp1.dy, x / 2, y / 2)
      ..quadraticBezierTo(cp2.dx, cp2.dy, x, 0)
      // ..quadraticBezierTo(,x, 0)

      ..lineTo(0, 0);
    //addOvals([cp1,cp2,Offset(44,75)], p);
    return p;
  }

  addOvals(List<Offset> os, Path p) {
    os.forEach((element) {
      p.addOval(
        Rect.fromCenter(
          center: element,
          height: 12,
          width: 12,
        ),
      );
    });
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

Widget menu() {
  var height = 12.0;
  var width = 80.0;
  return Center(
      child: Container(
    width: width,
    height: height * 3 + 15.0,
    child: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: width * .6,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.black),
          ),
        ),
        Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.black),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: width * .6,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.black),
          ),
        ),
      ],
    ),
  ));
}

class ShopTitle extends StatelessWidget {
  final Function onLeadingTap;
  final Function onTailingTap;
  final String title;
  final String slogan;

  const ShopTitle(
      {Key key, this.onLeadingTap, this.onTailingTap, this.title, this.slogan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onLeadingTap,
          icon: FittedBox(fit: BoxFit.contain, child: menu()),
        ),
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Text(
                  (title == "" ? "Your Eatery Name" : title).toSentenseCase(),
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        letterSpacing: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
                if ((slogan ?? "").trim() != "")
                  Text(
                    slogan.toSentenseCase(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          letterSpacing: 1,
                        ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onTailingTap,
          icon: Icon(Icons.shopping_cart),
        )
      ],
    );
  }
}

Widget chipsMaker(String name, {bool isSelected, Function(bool) onTap}) {
  return ChoiceChip(
    label: Text(name),
    selected: isSelected,
    onSelected: onTap,
  );
}

showAlertDialog(BuildContext context, List<String> selected) {
  TextEditingController _controller = TextEditingController();
  final _key = GlobalKey<FormState>();
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Add"),
    onPressed: () {
      if (_key.currentState.validate()) {
        selected.add(_controller.text);
        Navigator.of(context).pop();
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Add custom Category"),
    content: Form(
      key: _key,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _controller,
        validator: (v) {
          return v.trim() == ""
              ? "Name can't be empty"
              : selected
                      .map((e) => e.toLowerCase())
                      .toList()
                      .contains(v.toLowerCase())
                  ? "Category already Exists"
                  : null;
        },
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

extension extend on String {
  toSentenseCase() {
    if (this == "") return " ";
    String camelCase = "";
    this.split(" ").forEach((element) {
      if (element != "")
        camelCase += element.substring(0, 1).toUpperCase() +
            element.substring(1, element.length) +
            " ";
    });
    return camelCase..trim();
  }
}
