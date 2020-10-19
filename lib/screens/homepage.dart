import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/common.dart';
import 'package:food_app/services/firebase/firebase_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> scale;
  Animation<Offset> slide;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animController.addListener(() {
      isTouchable.value = animController.status != AnimationStatus.completed;
    });
  }

  scrollListener() {
    if (_scrollController.offset == 0) forcedHide = false;
    bool state = (_scrollController.offset > 360 && !forcedHide);
  }

  BuildContext contextsaved;
  ValueNotifier<bool> isTouchable = ValueNotifier(true);
  ValueNotifier<int> selectedCatNotifier = ValueNotifier(0);
  bool forcedHide = false;
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    ServiceManager manager = initializeManagerAndAnimations(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          //drawer background filter
          Container(
            color: Colors.white.withOpacity(.85),
          ),
          //dashboard page
          AnimatedBuilder(
            animation: animController,
            builder: (c, child) {
              return drawerTransition(child);
            },
            child: GestureDetector(
              onHorizontalDragUpdate: drawerSwipeHandler,
              child: SafeArea(
                child: Container(
                  height: height(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: topRow(context, manager),
                      ),
                      Expanded(
                        flex: 1,
                        child: ValueListenableBuilder(
                          valueListenable: isTouchable,
                          builder: (BuildContext context,
                              bool isDashboardTouchable, Widget child) {
                            return Stack(
                              children: [
                                child,
                                if (!isDashboardTouchable)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          slide.value.dx / 15),
                                      color: Colors.white70,
                                    ),
                                  )
                              ],
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: ChoiceChipsWrapper(
                                choices: catList(),
                                selectedChoiceNotifier: selectedCatNotifier,
                              )),
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Column(
                                    children: [
                                      specialAndCombo(context),
                                      Container(
                                        height: 250,
                                        child: true
                                            ? AnimatedItemList(
                                                list: [
                                                  "1",
                                                  "1",
                                                  "1",
                                                  "1",
                                                  "1",
                                                  "1",
                                                  "1",
                                                  "1",
                                                  "1",
                                                ],
                                                listItemMaker: (item) {
                                                  Timer timer;
                                                  var count = 0;
                                                  var rating = 5;
                                                  var image =
                                                      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max";
                                                  var name =
                                                      "Food Name long name 12345 jsjsjsj";
                                                  var price = "Rs. 250";
                                                  ValueNotifier<int> countN =
                                                      ValueNotifier(0);
                                                  return ValueListenableBuilder(
                                                    valueListenable: countN,
                                                    builder:
                                                        (BuildContext context,
                                                            int value,
                                                            Widget child) {
                                                      return Stack(
                                                        children: [
                                                          child,
                                                          if (value > 0)
                                                            Positioned(
                                                              right: 0,
                                                              child:
                                                                  TweenAnimationBuilder(
                                                                tween: Tween<
                                                                        double>(
                                                                    begin: .5,
                                                                    end: 1),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        400),
                                                                builder: (BuildContext
                                                                        context,
                                                                    double
                                                                        value,
                                                                    Widget
                                                                        child) {
                                                                  return Transform
                                                                      .scale(
                                                                    scale:
                                                                        value,
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  child: Text(
                                                                      "$value"),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8,
                                                              bottom: 8,
                                                              right: 2),
                                                      child: Material(
                                                        elevation: 2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        child: SizedBox(
                                                          width: 180,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container(
                                                                    width: 180,
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                4,
                                                                            horizontal:
                                                                                3),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  price,
                                                                                  style: Theme.of(context).textTheme.headline5,
                                                                                  //.copyWith(fontSize: 16),
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                                ValueListenableBuilder(
                                                                                  valueListenable: countN,
                                                                                  builder: (BuildContext context, int value, Widget child) {
                                                                                    return Row(
                                                                                      children: [
                                                                                        AnimatedSwitcher(
                                                                                          duration: Duration(milliseconds: 400),
                                                                                          child: value > 0
                                                                                              ? SizedBox(
                                                                                                  key: ValueKey("1"),
                                                                                                  child: GestureDetector(
                                                                                                      onLongPress: () {
                                                                                                        timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
                                                                                                          if (countN.value != 0)
                                                                                                            countN.value--;
                                                                                                          else
                                                                                                            timer.cancel();
                                                                                                        });
                                                                                                      },
                                                                                                      onLongPressEnd: (d) {
                                                                                                        timer.cancel();
                                                                                                      },
                                                                                                      onTap: () {
                                                                                                        if (countN.value != 0) countN.value--;
                                                                                                      },
                                                                                                      child: Icon(Icons.remove_circle)),
                                                                                                  width: 25,
                                                                                                )
                                                                                              : spaceHorizontal(25),
                                                                                        ),
                                                                                        spaceHorizontal(25),
                                                                                        SizedBox(
                                                                                          child: GestureDetector(
                                                                                              onLongPress: () {
                                                                                                timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
                                                                                                  countN.value++;
                                                                                                });
                                                                                              },
                                                                                              onLongPressEnd: (d) {
                                                                                                timer.cancel();
                                                                                              },
                                                                                              onTap: () {
                                                                                                countN.value++;
                                                                                              },
                                                                                              child: Icon(Icons.add_circle)),
                                                                                          width: 25,
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              name,
                                                                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  for (int i = 1; i <= 5; i++)
                                                                                    Icon(
                                                                                      Icons.star,
                                                                                      color: i <= rating ? Colors.orangeAccent : Colors.white,
                                                                                      size: 20,
                                                                                    )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              image,
                                                                            ),
                                                                            fit: BoxFit.cover)),
                                                                    //child: Image.network(image,fit: BoxFit.cover,),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : ListView.builder(
                                                itemCount: 18,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (c, i) {
                                                  Timer timer;
                                                  var count = 0;
                                                  var rating = 5;
                                                  var image =
                                                      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max";
                                                  var name =
                                                      "Food Name long name 12345 jsjsjsj";
                                                  var price = "Rs. 250";
                                                  ValueNotifier<int> countN =
                                                      ValueNotifier(0);
                                                  return ValueListenableBuilder(
                                                    valueListenable: countN,
                                                    builder:
                                                        (BuildContext context,
                                                            int value,
                                                            Widget child) {
                                                      return Stack(
                                                        children: [
                                                          child,
                                                          if (value > 0)
                                                            Positioned(
                                                              right: 0,
                                                              child:
                                                                  TweenAnimationBuilder(
                                                                tween: Tween<
                                                                        double>(
                                                                    begin: .5,
                                                                    end: 1),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        400),
                                                                builder: (BuildContext
                                                                        context,
                                                                    double
                                                                        value,
                                                                    Widget
                                                                        child) {
                                                                  return Transform
                                                                      .scale(
                                                                    scale:
                                                                        value,
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  child: Text(
                                                                      "$value"),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 8,
                                                              bottom: 8,
                                                              right: 2),
                                                      child: Material(
                                                        elevation: 2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        child: SizedBox(
                                                          width: 180,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container(
                                                                    width: 180,
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                4,
                                                                            horizontal:
                                                                                3),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  price,
                                                                                  style: Theme.of(context).textTheme.headline5,
                                                                                  //.copyWith(fontSize: 16),
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                                ValueListenableBuilder(
                                                                                  valueListenable: countN,
                                                                                  builder: (BuildContext context, int value, Widget child) {
                                                                                    return Row(
                                                                                      children: [
                                                                                        AnimatedSwitcher(
                                                                                          duration: Duration(milliseconds: 400),
                                                                                          child: value > 0
                                                                                              ? SizedBox(
                                                                                                  key: ValueKey("1"),
                                                                                                  child: GestureDetector(
                                                                                                      onLongPress: () {
                                                                                                        timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
                                                                                                          if (countN.value != 0)
                                                                                                            countN.value--;
                                                                                                          else
                                                                                                            timer.cancel();
                                                                                                        });
                                                                                                      },
                                                                                                      onLongPressEnd: (d) {
                                                                                                        timer.cancel();
                                                                                                      },
                                                                                                      onTap: () {
                                                                                                        if (countN.value != 0) countN.value--;
                                                                                                      },
                                                                                                      child: Icon(Icons.remove_circle)),
                                                                                                  width: 25,
                                                                                                )
                                                                                              : spaceHorizontal(25),
                                                                                        ),
                                                                                        spaceHorizontal(25),
                                                                                        SizedBox(
                                                                                          child: GestureDetector(
                                                                                              onLongPress: () {
                                                                                                timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
                                                                                                  countN.value++;
                                                                                                });
                                                                                              },
                                                                                              onLongPressEnd: (d) {
                                                                                                timer.cancel();
                                                                                              },
                                                                                              onTap: () {
                                                                                                countN.value++;
                                                                                              },
                                                                                              child: Icon(Icons.add_circle)),
                                                                                          width: 25,
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              name,
                                                                              style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  for (int i = 1; i <= 5; i++)
                                                                                    Icon(
                                                                                      Icons.star,
                                                                                      color: i <= rating ? Colors.orangeAccent : Colors.white,
                                                                                      size: 20,
                                                                                    )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              image,
                                                                            ),
                                                                            fit: BoxFit.cover)),
                                                                    //child: Image.network(image,fit: BoxFit.cover,),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: categoryHeading(
                                            context, "More from menu"),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: selectedCatNotifier,
                                        builder: (BuildContext context,
                                            int value, Widget child) {
                                          _scrollController.animateTo(335,
                                              curve: Curves.easeIn,
                                              duration:
                                                  Duration(milliseconds: 600));
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 22,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var image =
                                                  "https://i.pinimg.com/originals/db/ee/65/dbee65d6d5de6444199f02d9eb37e140.png";
                                              var image2 =
                                                  "https://kailiuusa.files.wordpress.com/2014/11/p1200656-as-smart-object-1.png";
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TweenAnimationBuilder(
                                                  curve: Curves.easeInCubic,
                                                  key:
                                                      ValueKey("$index-$value"),
                                                  duration: Duration(
                                                      milliseconds: 600),
                                                  tween: Tween<double>(
                                                      begin: .7, end: 1),
                                                  builder:
                                                      (BuildContext context,
                                                          double valuex,
                                                          Widget child) {
                                                    return Transform.scale(
                                                      scale: valuex,
                                                      child: child,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80),
                                                        child: SizedBox(
                                                          width: 120,
                                                          height: 120,
                                                          child: Image.network(
                                                            index % 2 == 0
                                                                ? image2
                                                                : image,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 80,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .5,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Text(
                                                              " $value Ranga ko masu dsalkdlakjd laks jdla ko dammi momo",
                                                              maxLines: 2,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );

                                          return AnimatedItemList(
                                            key: ValueKey(value),
                                            vertical: true,
                                            shrinkWrap: true,
                                            disableScroll: true,
                                            list: [
                                              1,
                                              2,
                                              3,
                                              4,
                                              5,
                                              6,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              6,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              6,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                              1,
                                            ],
                                            listItemMaker: (itm) {
                                              var image =
                                                  "https://i.pinimg.com/originals/db/ee/65/dbee65d6d5de6444199f02d9eb37e140.png";
                                              var image2 =
                                                  "https://kailiuusa.files.wordpress.com/2014/11/p1200656-as-smart-object-1.png";
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              80),
                                                      child: SizedBox(
                                                        width: 120,
                                                        height: 120,
                                                        child: Image.network(
                                                          image2,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 80,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .5,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Text(
                                                            " $value Ranga ko masu dsalkdlakjd laks jdla ko dammi momo",
                                                            maxLines: 2,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      logoutButton()
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          /* ValueListenableBuilder(
            valueListenable: hasScrolledMuch,
            builder: (BuildContext context, bool value, Widget child) {
              return AnimatedPositioned(
                  height: 110,
                  top: value ? MediaQuery.of(context).padding.top : -300,
                  left: 0,
                  right: 0,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                  child: GestureDetector(
                    onVerticalDragUpdate: (de) {
                      if (de.delta.dy < -3) {
                        forcedHide = true;
                        hasScrolledMuch.value = false;
                      }
                    },
                    child:
                        Material(color: Colors.white,elevation: 6, child: Center(child: wrapper())),
                  ));
            },
          )*/
        ],
      ),
    );
  }

  double height(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }

  void drawerSwipeHandler(detail) {
    if (animController.status == AnimationStatus.completed &&
        detail.delta.dx < -10) animController.reverse();
  }

  Transform drawerTransition(Widget child) {
    return Transform.scale(
      scale: scale.value,
      child: Transform.translate(
          offset: slide.value,
          child: Material(
              color: Colors.white,
              elevation: slide.value.dx / 40,
              borderRadius: BorderRadius.circular(slide.value.dx / 15),
              child: child)),
    );
  }

  ServiceManager initializeManagerAndAnimations(BuildContext context) {
    contextsaved ??= context;
    slide = Tween<Offset>(
            end: Offset(MediaQuery.of(context).size.width * .65, 0),
            begin: Offset.zero)
        .animate(
            CurvedAnimation(parent: animController, curve: Curves.easeInExpo));
    scale = Tween<double>(end: .8, begin: 1.0).animate(
        CurvedAnimation(parent: animController, curve: Curves.easeOutExpo));
    final manager = Provider.of<ServiceManager>(context, listen: false);
    return manager;
  }

  Padding specialAndCombo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          categoryHeading(
            context,
            "Today's Special",
          ),
          categoryHeading(context, "Combo", selected: false),
        ],
      ),
    );
  }

  Text categoryHeading(BuildContext context, String heading,
      {bool selected = true}) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline6.copyWith(
          color: selected
              ? CupertinoColors.activeOrange
              : CupertinoColors.activeOrange.withOpacity(.3)),
    );
  }

  Row topRow(BuildContext context, ServiceManager manager) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            animController.status == AnimationStatus.completed
                ? animController.reverse()
                : animController.forward();
          },
          icon: FittedBox(fit: BoxFit.contain, child: menu()),
        ),
        Text(
          "HARA HETTA",
          style: Theme.of(context).textTheme.headline5.copyWith(
                letterSpacing: 1,
              ),
        ),
        IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            backgroundImage: NetworkImage(manager.user.photoURL),
          ),
        )
      ],
    );
  }

  logoutButton() {
    return Center(
      child: SizedBox(
        height: 80,
        child: TextButton(
          onPressed: () {
            Provider.of<ServiceManager>(context, listen: false).logout();
          },
          child: Text("logout"),
        ),
      ),
    );
  }
}

class AnimatedItemList extends StatefulWidget {
  final bool shrinkWrap;
  final bool disableScroll;
  final List list;
  Function(dynamic) listItemMaker;
  final bool vertical;

  AnimatedItemList(
      {Key key,
      this.list,
      this.listItemMaker,
      this.shrinkWrap = false,
      this.disableScroll = false,
      this.vertical = false})
      : super(key: key);

  @override
  _AnimatedItemListState createState() => _AnimatedItemListState();
}

class _AnimatedItemListState extends State<AnimatedItemList> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Widget> itemTiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _additems();
    });
  }

  void _additems() {
    // get data from db

    Future ft = Future(() {});
    widget.list.forEach((item) {
      ft = ft.then((data) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          itemTiles.add(widget.listItemMaker(item));

          _listKey.currentState.insertItem(itemTiles.length - 1);
        });
      });
    });
  }

  Tween<double> scale = Tween(begin: .5, end: 1);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.disableScroll
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal,
        key: _listKey,
        initialItemCount: itemTiles.length,
        itemBuilder: (context, index, animation) {
          return ScaleTransition(
            scale: animation.drive(scale),
            child: itemTiles[index],
          );
        });
  }
}

class ChoiceChipsWrapper extends StatefulWidget {
  final List<Category> choices;
  final ValueNotifier<int> selectedChoiceNotifier;

  const ChoiceChipsWrapper({Key key, this.choices, this.selectedChoiceNotifier})
      : super(key: key);

  @override
  _ChoiceChipsWrapperState createState() => _ChoiceChipsWrapperState();
}

class _ChoiceChipsWrapperState extends State<ChoiceChipsWrapper> {
  FocusNode focus = FocusNode();
  List<Category> choices;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choices = widget.choices;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimatedContainer(
            curve: Curves.easeInCubic,
            duration: Duration(milliseconds: 400),
            width: focus.hasFocus ? 120 : 0,
            height: focus.hasFocus ? 60 : 0,
            child: Center(
              child: TextFormField(
                focusNode: focus,
                onChanged: (c) {
                  print(choices);
                  setState(() {
                    choices.clear();
                    choices.addAll(widget.choices
                        .where((element) => element.name
                            .toLowerCase()
                            .contains(c.trim().toLowerCase()))
                        .toList());
                  });
                },
                decoration: InputDecoration(
                  hintText: "Try Stick, Chinese",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
            width: 40,
            child: IconButton(
                icon: Icon(focus.hasFocus ? Icons.close : Icons.search),
                onPressed: () async {
                  focus.hasFocus
                      ? FocusScope.of(context).unfocus()
                      : focus.requestFocus();
                })),
        ValueListenableBuilder(
          valueListenable: widget.selectedChoiceNotifier,
          builder: (BuildContext context, int value, Widget child) {
            return Expanded(
              flex: 1,
              child: Theme(
                data: ThemeData(
                    chipTheme: ChipThemeData(
                  backgroundColor: Colors.black12,
                  labelStyle: TextStyle(color: Colors.grey),
                  secondaryLabelStyle: TextStyle(color: Colors.white),
                  secondarySelectedColor: Colors.orange,
                  padding: EdgeInsets.all(6),
                  shape: StadiumBorder(),
                  elevation: 1,
                  selectedColor: Colors.green,
                  brightness: Brightness.light,
                  disabledColor: Colors.grey,
                )),
                child: choices.length > 5
                    ? SizedBox(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: choices
                              .map((e) => Container(
                                    margin: EdgeInsets.all(8),
                                    child: chipsMaker(e, selectedIndex: value),
                                  ))
                              .toList(),
                        ),
                      )
                    : Wrap(
                        spacing: 13.0,
                        alignment: WrapAlignment.center,
                        children: choices
                            .map((e) => chipsMaker(e, selectedIndex: value))
                            .toList(),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget chipsMaker(Category cat, {int selectedIndex}) {
    return ChoiceChip(
      label: Text(cat.name),
      selected: cat.id == selectedIndex,
      onSelected: (b) {
        /*_scrollController.animateTo(315,
              curve: Curves.easeOutCubic,
              duration: Duration(milliseconds: 600));*/
        widget.selectedChoiceNotifier.value = cat.id;
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class Category {
  final String name;
  final int id;

  Category({this.name, this.id});
}

List<Category> catList() {
  List<Category> list = [];
  for (int i = 0; i < 12; i++) list.add(Category(name: "cat name $i", id: i));
  return list;
}
