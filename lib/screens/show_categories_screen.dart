import 'package:flutter/material.dart';
import 'package:food_app/util/categories.dart';
import 'package:food_app/util/foods.dart';
import 'package:food_app/widgets/badge.dart';
import 'package:food_app/widgets/foodCard.dart';
import 'package:food_app/widgets/grid_product.dart';
import 'package:food_app/widgets/home_category.dart';

import 'notifications_screen.dart';


class ShowCategoriesScreen extends StatefulWidget {
  @override
  _ShowCategoriesScreenState createState() => _ShowCategoriesScreenState();
}

class _ShowCategoriesScreenState extends State<ShowCategoriesScreen> {

  String catie = "Drinks";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Categories",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications,
              size: 22.0,
            ),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return NotificationsScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null?0:categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return HomeCategory(
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: false,
                    tap: (){
                      setState((){catie = "${cat['name']}";});
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 20.0),

            Text(
              "$catie",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            Divider(),
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
              itemCount: foods == null ? 0 :foods.length,
              itemBuilder: (BuildContext context, int index) {
                var food = foods[index];
                return /*GridProduct(
                  img: food.image ,
                  isFav: false,
                  name: food.name,
                  rating: 5.0,
                  raters: 23,
                );*/
                FoodCard(food: food,isCombo:false ,);
              },
            ),

          ],
        ),
      ),
    );
  }
}
