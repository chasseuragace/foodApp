import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarousalSliderCustom extends StatefulWidget {
  final double height;
  final List<Widget> items;
  final bool autoPlay;
  final Function(int) onpageChanged;
  final int changeAfterSeconds;

  const CarousalSliderCustom(
      {Key key,
      this.height = 250,
      this.items = const [],
      this.autoPlay = true,
      this.onpageChanged,
      this.changeAfterSeconds = 5})
      : super(key: key);

  @override
  _CarousalSliderCustomState createState() => _CarousalSliderCustomState();
}

class _CarousalSliderCustomState extends State<CarousalSliderCustom> {
  Timer timer;
  PageController _controller;
  List<Widget> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = List.from(widget.items);
    items.insert(0, widget.items[widget.items.length - 1]);
    _controller = PageController(keepPage: false, initialPage: 1);

    if (widget.autoPlay)
      timer =
          Timer.periodic(Duration(seconds: widget.changeAfterSeconds), (timer) {
        changePage();
      });
  }

  changePage() {
    int length = items.length;
    if (mounted)
      _controller.animateToPage(
          _controller.page + 1 > length - 1 ? 0 : _controller.page.ceil() + 1,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              itemCount: items.length,
              controller: _controller,
              onPageChanged: (current) {
                print(current);
                if (current == items.length - 1 && mounted)
                  Future.delayed(Duration(milliseconds: 0), () {
                    _controller.jumpToPage(0);
                  });
                widget.onpageChanged(current);
              },
              itemBuilder: (BuildContext context, int index) {
                return TweenAnimationBuilder(
                    tween: Tween<double>(begin: .8, end: 1),
                    builder:
                        (BuildContext context, double value, Widget child) {
                      return Transform.scale(
                        child: child,
                        scale: value,
                      );
                    },
                    curve: Curves.easeInCubic,
                    duration: Duration(milliseconds: 600),
                    child: items[index]);
              },
            )));
  }
}
