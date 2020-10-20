import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/common.dart';
import 'package:food_app/services/firebase/firebase_auth.dart';
import 'package:provider/provider.dart';

class TestShop extends StatefulWidget {
  @override
  _TestShopState createState() => _TestShopState();
}

class _TestShopState extends State<TestShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Shop>>(
          stream:
              Provider.of<ServiceManager>(context, listen: false).shopsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            Shop shop = snapshot.data.first;
            Provider.of<ServiceManager>(context, listen: false)
                .getShopData(shop);
            return Center(
              child: Column(
                children: [
                  StreamBuilder<List<Food>>(
                    stream: shop.foodStream,
                    builder: (c, s) {
                      if (!s.hasData) return Text('nodata');
                      print(s.data.first.toJson().toString());
                      return Column(
                        children: [...s.data.map((e) => Text(e.name)).toList()],
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}

class AddFoodCard extends StatefulWidget {
  @override
  _AddFoodCardState createState() => _AddFoodCardState();
}

class _AddFoodCardState extends State<AddFoodCard> {
  File _image;
  Timer timer;
  var count = 0;
  var rating = 5;
  var image =
      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max";
  var name = "Food Name long name 12345 jsjsjsj";
  var price = "Rs. 250";
  ValueNotifier<int> countN = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1),
          Transform.scale(
            scale: 1.5,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: countN,
                builder: (BuildContext context, int value, Widget child) {
                  return SizedBox(
                    height: 250,
                    child: Stack(
                      children: [
                        child,
                        if (value > 0)
                          Positioned(
                            right: 0,
                            child: TweenAnimationBuilder(
                              tween: Tween<double>(begin: .5, end: 1),
                              duration: Duration(milliseconds: 400),
                              builder: (BuildContext context, double value,
                                  Widget child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: CircleAvatar(
                                child: Text("$value"),
                                backgroundColor: Colors.black,
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 8, bottom: 8, right: 2),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: 180,
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 3),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              price,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                              //.copyWith(fontSize: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            ValueListenableBuilder(
                                              valueListenable: countN,
                                              builder: (BuildContext context,
                                                  int value, Widget child) {
                                                return Row(
                                                  children: [
                                                    AnimatedSwitcher(
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      child: value > 0
                                                          ? SizedBox(
                                                              key:
                                                                  ValueKey("1"),
                                                              child:
                                                                  GestureDetector(
                                                                      onLongPress:
                                                                          () {
                                                                        timer = Timer.periodic(
                                                                            Duration(milliseconds: 200),
                                                                            (timer) {
                                                                          if (countN.value !=
                                                                              0)
                                                                            countN.value--;
                                                                          else
                                                                            timer.cancel();
                                                                        });
                                                                      },
                                                                      onLongPressEnd:
                                                                          (d) {
                                                                        timer
                                                                            .cancel();
                                                                      },
                                                                      onTap:
                                                                          () {
                                                                        if (countN.value !=
                                                                            0)
                                                                          countN
                                                                              .value--;
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .remove_circle)),
                                                              width: 25,
                                                            )
                                                          : spaceHorizontal(25),
                                                    ),
                                                    spaceHorizontal(25),
                                                    SizedBox(
                                                      child: GestureDetector(
                                                          onLongPress: () {
                                                            timer = Timer.periodic(
                                                                Duration(
                                                                    milliseconds:
                                                                        200),
                                                                (timer) {
                                                              countN.value++;
                                                            });
                                                          },
                                                          onLongPressEnd: (d) {
                                                            timer.cancel();
                                                          },
                                                          onTap: () {
                                                            countN.value++;
                                                          },
                                                          child: Icon(Icons
                                                              .add_circle)),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(fontSize: 16),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              for (int i = 1; i <= 5; i++)
                                                Icon(
                                                  Icons.star,
                                                  color: i <= rating
                                                      ? Colors.orangeAccent
                                                      : Colors.white,
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
              ),
            ),
          ),
          /*Expanded(flex:2,child: Form(
            child: ,
          ),),*/
        ],
      ),
    );
  }
}

createFood() {
  String image =
      "https://www.jing.fm/clipimg/full/155-1559839_prepared-by-world-famous-cook-food-momo-png.png";

  Food(
    name: "Lemon Ice Tea",
    increment: 1,
    isSpecial: true,
    price: 130,
    image: image,
  );
  Food(
    name: "Peach Ice Tea",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Mojito Ice Tea",
    increment: 1,
    isSpecial: true,
    price: 160,
    image: image,
  );
  Food(
    name: "Mint Lemonade",
    increment: 1,
    isSpecial: true,
    price: 160,
    image: image,
  );
  Food(
    name: "Peach Lemonade",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Strawberry Lemonade",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "English Breakfast Tea",
    increment: 1,
    isSpecial: true,
    price: 50,
    image: image,
  );
  Food(
    name: "Earl Grey Tea",
    increment: 1,
    isSpecial: true,
    price: 50,
    image: image,
  );
  Food(
      name: "Flavoured Tea",
      increment: 1,
      isSpecial: true,
      price: 50,
      image: image,
      variety: ['Peach', 'strawberry', 'chocolate']);
  Food(
    name: "Hot Lemon With Honey",
    increment: 1,
    isSpecial: true,
    price: 50,
    image: image,
  );
  Food(
    name: "Veg Burger",
    increment: 1,
    isSpecial: true,
    price: 120,
    image: image,
  );
  Food(
    name: "Veg Burger",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Additional cheese",
    increment: 1,
    isSpecial: true,
    price: 50,
    image: image,
  );
  Food(
    name: "Egg roll",
    increment: 1,
    isSpecial: true,
    price: 120,
    image: image,
  );
  Food(
    name: "Egg Chicken roll",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Egg Tuna roll",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Veg sandwich",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Tuna sandwich",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Chicken sandwich",
    increment: 1,
    isSpecial: true,
    price: 150,
    image: image,
  );
  Food(
    name: "Club sandwich",
    increment: 1,
    isSpecial: true,
    price: 200,
    image: image,
  );
  Food(
      name: "Buff kothey Momo",
      increment: 1,
      unit: "plate",
      isSpecial: true,
      price: 120,
      image: image,
      variety: ['Peach', 'strawberry', 'chocolate']);
  Food(
    name: "Chicken kothey Momo",
    increment: 1,
    unit: "plate",
    isSpecial: true,
    price: 150,
    image: image,
  );
}

createCategory() {
  FoodCategory(name: "Ice tea");
  FoodCategory(name: "Lemonade");
  FoodCategory(name: "Tea varieties");
  FoodCategory(name: "burger");
  FoodCategory(name: "egg rolls");
  FoodCategory(name: "sandwitch");
  FoodCategory(name: "momo");
}

createGroup() {
  List<String> groups = ["Drinks", "Food items"];
}
