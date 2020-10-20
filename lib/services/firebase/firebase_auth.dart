import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginStates { loggedIn, loggedOut, loading, error }

class FireBaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

//user login state
  Stream<User> get loggedInUser {
    return auth.authStateChanges().map((user) {
      if (user == null) {
        //  print('User is currently signed out!');
      } else {
        print("last login/creation difference");
        print(user.metadata.lastSignInTime
                .difference(user.metadata.creationTime)
                .inSeconds <
            5);
        /*{
          storeService.adduser(user);
        }*/
        //  print('User is signed in!');
        // print('User ${user.email}');
      }
      return user;
    });
  }

  //signInAnonymously
  signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print('Failed signInAnonymously error code: ${e.code}');
      print(e.message);
    }
  }

  //signout
  signOut() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  //delete my account
  delete() async {
    try {
      await FirebaseAuth.instance.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

//sign in with google
  Future<UserCredential> signInWithGoogle(
      {bool silent = false, Null Function() onError}) async {
    // Trigger the authentication flow
    try {
      GoogleSignInAccount googleUser;
      if (silent)
        googleUser = await GoogleSignIn().signInSilently();
      else
        googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print("exception on login ${e.runtimeType}");
      onError();
      return null;
    }
  }
}

class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference shops = FirebaseFirestore.instance.collection('Shops');
  CollectionReference foods = FirebaseFirestore.instance.collection('Foods');
  CollectionReference combos = FirebaseFirestore.instance.collection('Combos');
  CollectionReference events = FirebaseFirestore.instance.collection('Events');

  adduser(User data) {
    users.doc(data.email).set(
      {
        'name': data.displayName,
      },
    ).then((value) => print("User Added"));
  }
}

class ServiceManager {
  User _loggedInUser;

  final FireBaseAuthService _authservice = FireBaseAuthService();
  final FireStoreService _storeService = FireStoreService();
  final _controller = StreamController<LoginStates>.broadcast();

  ServiceManager() {
    watchLoginStates();
    // login(silent: true);
  }

  User get user => _loggedInUser;

  login({bool silent = false}) async {
    _updateLoginState(LoginStates.loading);
    UserCredential credential = await _authservice.signInWithGoogle(
        silent: silent,
        onError: () {
          _updateLoginState(LoginStates.error);
          return;
        });
    if (credential == null)
      _updateLoginState(LoginStates.loggedOut);
    else {
      if (credential.additionalUserInfo.isNewUser)
        await _storeService.adduser(credential.user);
      _updateLoginState(LoginStates.loggedIn);
    }
  }

  logout() {
    _authservice.signOut();
  }

  delete() {
    _authservice.delete();
  }

  LoginStates _current;

  _updateLoginState(LoginStates state) async {
    if (_current == LoginStates.error)
      await Future.delayed(Duration(milliseconds: 100));
    _current = state;
    print("updating $state");

    _controller.sink.add(_current);
  }

  _closeSink() {
    _controller.close();
  }

  Stream<LoginStates> get loginStream =>
      _controller.stream.asBroadcastStream(onListen: (w) {
        w.resume();
      });

  watchLoginStates() {
    _updateLoginState(LoginStates.loading);
    _authservice.loggedInUser.listen((event) {
      if (event == null)
        Future.delayed(Duration(seconds: 2), () {
          _loggedInUser = event;
        });
      else
        _loggedInUser = event;
      final w = (event == null) ? LoginStates.loggedOut : LoginStates.loggedIn;
      print("watcher says $w");
      _updateLoginState(w);
    });
  }

  Stream<List<Shop>> get shopsStream {
    List<Shop> list = [];
    return _storeService.shops.snapshots().map((event) {
      for (var x in event.docs) {
        list.add(Shop.fromJson(x.data()));
      }
      print(list.length);
      return list;
    });
  }

  getShopData(Shop shop) async {
    shop.foodStream = _getFoodOfShop(shop);
    /*  await _getComboOfShop();
    await _getEventsOfShop();*/
    return shop;
  }

  Stream<List<Food>> _getFoodOfShop(Shop shop) {
    return _storeService.foods
        .
        /*  where('ofShop',isEqualTo: shop.id).*/
        snapshots()
        .map((snap) {
      List<Food> list = [];
      for (var x in snap.docs) {
        list.add(Food.fromJson(x.data()));
      }
      return list;
    }).asBroadcastStream();
  }

  _getComboOfShop() async {
    List<Shop> shops = [];
    var res = await _storeService.users.get();

    for (var x in res.docs) {
      shops.add(Shop.fromJson(x.data()));
    }
    print(shops.length);
    return shops;
  }

  _getEventsOfShop() async {
    List<Shop> shops = [];
    var res = await _storeService.users.get();

    for (var x in res.docs) {
      shops.add(Shop.fromJson(x.data()));
    }
    print(shops.length);
    return shops;
  }
}

class Shop {
  Stream<List<Food>> foodStream;
  String image;
  bool isOpen;
  String phone;
  int count;
  double rating;
  String name;
  String currency;
  String id;
  String email;
  List<String> foodGroups;

  Shop(
      {this.image,
      this.isOpen,
      this.phone,
      this.count,
      this.rating,
      this.name,
      this.currency,
      this.id,
      this.foodGroups,
      this.email});

  Shop.fromJson(Map<String, dynamic> json) {
    print(json);
    image = json['image'];
    isOpen = json['isOpen'];
    phone = json['phone'];
    count = json['count'];
    rating = json['rating'];
    name = json['name'];
    currency = json['currency'];
    id = json['id'];
    email = json['email'];
    foodGroups = json['foodGroups'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['isOpen'] = this.isOpen;
    data['phone'] = this.phone;
    data['count'] = this.count;
    data['rating'] = this.rating;
    data['name'] = this.name;
    data['currency'] = this.currency;
    data['id'] = this.id;
    data['email'] = this.email;
    data['foodGroups'] = this.foodGroups;
    return data;
  }
}

class Food {
  String image;
  String unit;
  String ofShop;
  bool isSpecial;
  double price;
  double rating;
  int count;
  String name;
  double increment;
  String description;
  int discount;
  String id;
  String category;
  List<String> variety;


  Food({this.image,
    this.unit,
    this.ofShop,
    this.isSpecial,
    this.price,
    this.rating,
    this.count,
    this.name,
    this.increment,
    this.description,
    this.discount,
    this.category,
    this.variety,
    this.id});

  Food.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    unit = json['unit'];
    ofShop = json['ofShop'];
    isSpecial = json['isSpecial'];
    price = json['price'];
    rating = json['rating'];
    count = json['count'];
    name = json['name'];
    increment = json['increment'];
    description = json['description'];
    discount = json['discount'];
    id = json['id'];
    category = json['category'];
    variety = json['variety'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['unit'] = this.unit;
    data['ofShop'] = this.ofShop;
    data['isSpecial'] = this.isSpecial;
    data['price'] = this.price;
    data['rating'] = this.rating;
    data['count'] = this.count;
    data['name'] = this.name;
    data['increment'] = this.increment;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['id'] = this.id;
    data['category'] = this.category;
    return data;
  }
}

class FoodCategory {
  String name;
  String ofGroup;
  String id;

  FoodCategory({this.name, this.id});

  FoodCategory.fromJson(Map<String, dynamic> json) {
    this.name = json['image'];
    this.ofGroup = json['ofGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ofGroup'] = this.ofGroup;


    return data;
  }
}


