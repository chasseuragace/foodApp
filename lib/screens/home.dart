import 'package:flutter/material.dart';
import 'package:food_app/podo/food.dart';
import 'package:food_app/util/carausalslider.dart';
import 'package:food_app/util/categories.dart';
import 'package:food_app/util/foods.dart';
import 'package:food_app/widgets/common.dart';
import 'package:food_app/widgets/foodCard.dart';
import 'package:food_app/widgets/grid_product.dart';
import 'package:food_app/widgets/home_category.dart';
import 'package:food_app/widgets/slider_item.dart';

import 'details.dart';
import 'dishes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Prime Dishes",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DishesScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10.0),

            //Slider Here

            CarousalSliderCustom(
              height: MediaQuery.of(context).size.height / 2.4,
              items: map<Widget>(
                foods,
                (index, i) {
                  var food = foods[index];
                  return SliderItem(
                    img: food.image,
                    isFav: false,
                    name: food.name,
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ).toList(),
              autoPlay: true,
              onpageChanged: (index) {
                _current = index;
              },
            ),
            SizedBox(height: 20.0),

            Text(
              "Food Categories",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return HomeCategory(
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: true,
                  );
                },
              ),
            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Popular Items",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10.0),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: foods == null ? 0 : foods.length,
              itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                var food = foods[index];
//                print(foods);
//                print(foods.length);
                return true
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ProductDetails();
                              },
                            ),
                          );
                        },
                        child: FoodCard(
                          food: food,
                          isCombo: false,
                        ))
                    : GridProduct(
                        img: food.image,
                        isFav: false,
                        name: food.name,
                        rating: 5.0,
                        raters: 23,
                      );
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
