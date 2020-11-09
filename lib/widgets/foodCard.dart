import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/podo/food.dart';

class FoodCard extends StatefulWidget {
  final Food food;
  final bool isCombo;

  const FoodCard({Key key, this.food, this.isCombo}) : super(key: key);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  Food food;
  Timer timer;
  ValueNotifier<int> orderCountNotifier = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    food = widget.food;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        width: widget.isCombo ? 400 : 200,
        child: Stack(children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 8.0, top: 8, bottom: 8, right: 2),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: widget.isCombo ? 380 : 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    children: [
                      foodImage(),
                      foodNamePriceRating(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: ValueListenableBuilder(
              valueListenable: orderCountNotifier,
              builder: (BuildContext context, int orderCount, Widget child) {
                if (orderCount == 0) return SizedBox();
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: .5, end: 1),
                  duration: Duration(milliseconds: 400),
                  builder: (BuildContext context, double value, Widget child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: CircleAvatar(
                    child: Text("$orderCount"),
                    backgroundColor: Colors.black,
                  ),
                );
              },
            ),
          ),
        ]));
  }

  Container foodNamePriceRating() {
    return Container(
      decoration: !food.isSpecial
          ? BoxDecoration(
              gradient: LinearGradient(
              colors: [
                Color(0xffB78628).withOpacity(.6),
                Color(0xffc69320).withOpacity(.7),
                Color(0xfffcc201).withOpacity(.8)
              ],
            ))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rs. ${food.price}",
                  style: Theme.of(context).textTheme.headline5,
                  //.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                incrementDecrementButtons(),
              ],
            ),
            Text(
              food.name,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
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
                      color: i <= (food.rating ?? 4)
                          ? Colors.orangeAccent
                          : Colors.grey,
                      size: 20,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<int> incrementDecrementButtons() {
    return ValueListenableBuilder(
      valueListenable: orderCountNotifier,
      builder: (BuildContext context, int value, Widget child) {
        return Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(maxWidth: 100, minWidth: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      child: value > 0
                          ? SizedBox(
                              child: GestureDetector(
                                  onLongPress: () {
                                    timer = Timer.periodic(
                                        Duration(milliseconds: 200), (timer) {
                                      if (orderCountNotifier.value != 0)
                                        orderCountNotifier.value--;
                                      else
                                        timer.cancel();
                                    });
                                  },
                                  onLongPressEnd: (d) {
                                    timer.cancel();
                                  },
                                  onTap: () {
                                    if (orderCountNotifier.value != 0)
                                      orderCountNotifier.value--;
                                  },
                                  child: Icon(Icons.remove_circle)),
                              width: 25,
                            )
                          : SizedBox(width: 25),
                    ),
                    SizedBox(
                      child: GestureDetector(
                          onLongPress: () {
                            timer = Timer.periodic(Duration(milliseconds: 200),
                                (timer) {
                              orderCountNotifier.value++;
                            });
                          },
                          onLongPressEnd: (d) {
                            timer.cancel();
                          },
                          onTap: () {
                            orderCountNotifier.value++;
                          },
                          child: Icon(Icons.add_circle)),
                      width: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded foodImage() {
    var image =
        'https://cheers.com.np/uploads/products/396210614012944066915392016262502224925792506.png';
    // image ='https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/delish-homemade-pizza-horizontal-1542312378.png';
    image =
        'https://images.unsplash.com/photo-1574126154517-d1e0d89ef734?ixlib=rb-1.2.1&w=1000&q=80';
    image =
        'https://www.posist.com/restaurant-times/wp-content/uploads/2020/02/complimentary-dish.jpg';

    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.white,
        width: widget.isCombo ? 380 : 180,
        child: Image.asset(
          food.image,
          fit: widget.isCombo ? BoxFit.fitWidth : BoxFit.fitHeight,
        ),
        //  child: Image.asset('assets/splash.png',fit: BoxFit.contain  ,),

        //child: Image.network(image,fit: BoxFit.cover,),
      ),
    );
  }
}

Text categoryHeading(String heading, BuildContext context,
    {bool selected = true}) {
  return Text(
    heading,
    style: Theme.of(context).textTheme.headline6.copyWith(
        color: selected
            ? CupertinoColors.activeOrange
            : CupertinoColors.activeOrange.withOpacity(.3)),
  );
}
