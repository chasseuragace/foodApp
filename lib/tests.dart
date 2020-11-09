import 'package:flutter/material.dart';
import 'package:food_app/podo/shop.dart';
import 'package:food_app/podo/tempdata.dart';
import 'package:food_app/providers/firebase/service_manager.dart';
import 'package:food_app/util/foods.dart';
import 'package:provider/provider.dart';

class TestWidget extends StatelessWidget {
  String selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Expanded(
        child: StreamBuilder(
          initialData: <Shop>[],
          stream: Provider.of<ServiceManager>(context).shopsStream,
          builder: (BuildContext context, AsyncSnapshot<List<Shop>> snapshot) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                selected = "${snapshot.data[index].id}";
                              },
                              child: Text(snapshot.data[index].title +
                                  "${snapshot.data[index].id}")),
                          if (index == snapshot.data.length - 1)
                            FlatButton(
                              onPressed: () {
                                foods.forEach((element) {
                                  element.ofShop = snapshot.data[index].id;
                                });
                                Provider.of<ServiceManager>(context,
                                        listen: false)
                                    .addFood(foods);
                              },
                              child: Text('add food'),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Provider.of<ServiceManager>(context, listen: false)
                        .addNewShop(createShop());
                  },
                  child: Text('addSop'),
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}
