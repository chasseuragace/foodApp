import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/podo/food.dart';
import 'package:food_app/podo/shop.dart';

class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference shops = FirebaseFirestore.instance.collection('Shops');
  CollectionReference foods = FirebaseFirestore.instance.collection('Foods');
  CollectionReference combos = FirebaseFirestore.instance.collection('Combos');
  CollectionReference events = FirebaseFirestore.instance.collection('Events');

  addUser(User data) {
    users.doc(data.email).set(
      {
        'name': data.displayName,
      },
    ).then((value) => print("User Added"));
  }

  Future<bool> addShop(Shop shop) async {
    bool result = false;
    try {
      await shops.doc().set(
            shop.toJson(),
          );
      result = true;
    } on Exception catch (e) {
      print(e.toString());
      return result;
    }
    return result;
  }

  addFood(Food food) async {
    bool result = false;
    try {
      await foods.doc().set(
            food.toJson(),
          );
      result = true;
    } on Exception catch (e) {
      print(e.toString());
      return result;
    }
    return result;
  }
}
