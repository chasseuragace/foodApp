import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/podo/food.dart';
import 'package:food_app/podo/shop.dart';

import 'firebase_auth.dart';
import 'firebase_db.dart';

enum ShopRegStatus { processing, done, fail, idle }

class ServiceManager {
  User _loggedInUser;
  final FireBaseAuthService _authservice = FireBaseAuthService();
  final FireStoreService _storeService = FireStoreService();
  final _controller = StreamController<LoginStates>.broadcast();
  final _selectedShopController = StreamController<Shop>.broadcast();
  final _shopRegistrationUpdateController =
      StreamController<ShopRegStatus>.broadcast();

  ServiceManager() {
    _watchLoginStates();
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
        await _storeService.addUser(credential.user);
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
  ShopRegStatus _currentRegStatus = ShopRegStatus.idle;

  _updateLoginState(LoginStates state) async {
    if (_current == LoginStates.error)
      await Future.delayed(Duration(milliseconds: 100));
    _current = state;
    print("updating $state");

    _controller.sink.add(_current);
  }

  _updateRegistrationState(ShopRegStatus state) async {
    print("egistration to $state");
    if (_currentRegStatus == ShopRegStatus.fail)
      await Future.delayed(Duration(milliseconds: 100));
    _currentRegStatus = state;

    _shopRegistrationUpdateController.sink.add(_currentRegStatus);
  }

  _closeSink() {
    _controller.close();
    _selectedShopController.close();
    _shopRegistrationUpdateController.close();
  }

  Stream<LoginStates> get loginStream =>
      _controller.stream.asBroadcastStream(onListen: (w) {
        w.resume();
      });

  Stream<ShopRegStatus> get registrationStream =>
      _shopRegistrationUpdateController.stream.asBroadcastStream(onListen: (w) {
        w.resume();
      });

  _watchLoginStates() {
    _updateLoginState(LoginStates.loading);
    _authservice.loggedInUser.listen((event) {
      if (event == null)
        Future.delayed(Duration(seconds: 2), () {
          _loggedInUser = event;
        });
      else
        _loggedInUser = event;
      final w = (event == null) ? LoginStates.loggedOut : LoginStates.loggedIn;
      _updateLoginState(w);
    });
  }

  Stream<List<Shop>> get shopsStream {
    return _storeService.shops.snapshots().map((event) {
      List<Shop> list = [];
      event.docs.forEach((e) {
        var s = Shop.fromJson(e.data(), e.id);
        if (_currentShop != null && _currentShop.id == s.id)
          updateCurrentShop(s);
        list.add(s);
      });

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
        print(x.data());
        list.add(Food.fromJson(x.data()));
      }
      return list;
    }).asBroadcastStream();
  }

  /*_getComboOfShop() async {
    List<Shop> shops = [];
    var res = await _storeService.users.get();

    for (var x in res.docs) {
      shops.add(Shop.fromJson(x.data()));
    }
    print(shops.length);
    return shops;
  }*/

/*  _getEventsOfShop() async {
    List<Shop> shops = [];
    var res = await _storeService.users.get();

    for (var x in res.docs) {
      shops.add(Shop.fromJson(x.data()));
    }
    print(shops.length);
    return shops;
  }*/

  Stream<Shop> get selectedShopStream =>
      _selectedShopController.stream.asBroadcastStream(onListen: (w) {
        w.resume();
      });
  Shop _currentShop;

  updateCurrentShop(Shop shop) async {
    _currentShop = shop;
    _selectedShopController.sink.add(shop);
  }

  Shop get getCurrentShop {
    return _currentShop;
  }

  addNewShop(Shop shop) async {
    _updateRegistrationState(ShopRegStatus.processing);
    shop.ofUser = (user?.email) ?? "not logged in";
    var result = await _storeService
        .addShop(shop)
        .timeout(Duration(seconds: 5))
        .then((value) => null,
            onError: (err) => _updateRegistrationState(ShopRegStatus.fail));
    if (result ?? false)
      _updateRegistrationState(ShopRegStatus.done);
    else
      _updateRegistrationState(ShopRegStatus.fail);
  }

  addFood(List<Food> foods) {
    foods.forEach((element) {
      _storeService.addFood(element);
    });
  }
}
