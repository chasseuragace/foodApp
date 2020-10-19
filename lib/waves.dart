import 'package:flutter/material.dart';

class Waves extends StatefulWidget {
  @override
  _WavesState createState() => _WavesState();
}

class _WavesState extends State<Waves> {
  bool move = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Stack(
          children: [
            AnimatedPositioned(
              //curve: Curves.easeOut,

              onEnd: () {
                setState(() {
                  move = !move;
                });
              },
              duration: Duration(seconds: 4),
              left: move ? 0 : -MediaQuery.of(context).size.width * 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    move = !move;
                    print(move);
                  });
                },
                child: ClipPath(
                  clipper: SineClip(),
                  child: Container(
                    color: Colors.redAccent.withOpacity(.7),
                    width: MediaQuery.of(context).size.width * 4,
                    height: 100,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              //  curve: Curves.easeOut,
              onEnd: () {},
              duration: Duration(seconds: 4),
              top: 20,
              right: move ? 0 : -MediaQuery.of(context).size.width * 2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    move = !move;
                  });
                },
                child: ClipPath(
                  clipper: SineClip(),
                  child: Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width * 3,
                    height: 100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SineClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var x = size.width / 2;
    var y = size.height;
    Path p = Path();
    p
      ..moveTo(0, y * .5)
      ..quadraticBezierTo(x * .25, y, x * .5, y * .5)
      ..quadraticBezierTo(x * .75, 0, x, y * .5)
      ..quadraticBezierTo(x * 1.25, y, 1.5 * x, y * .5)
      ..quadraticBezierTo(x * 1.75, 0, 2 * x, y * .5)
      ..lineTo(2 * x, y)
      ..lineTo(0, y);
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
