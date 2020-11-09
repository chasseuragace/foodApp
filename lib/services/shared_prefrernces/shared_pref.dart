import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static init() async {
    sp ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences sp;

  static skipIntro({bool shouldSip = true}) {
    sp.setBool("intro", shouldSip);
  }

  static bool get shouldSkipIntro => sp.getBool('intro') ?? false;

  static setLogin({bool setLoginTo = true}) {
    sp.setBool("login", setLoginTo);
  }

  static bool get isLoggedIn => sp.getBool('login') ?? false;

  setOrder({String id, double count}) {
    Map<dynamic, dynamic> orders = _getOrders();
    orders.putIfAbsent("$id", () => count);
    sp.setString('orders', json.encode(orders));
    _updateOrderList();
    print('setorders');
  }

  Map<String, dynamic> _getOrders() {
    return json.decode(sp.getString('orders') ?? '{}');
  }

  _updateOrderList() {
    _controller.sink.add(_getOrders());
  }

  closeSink() {
    _controller.close();
  }

  StreamController<Map<String, dynamic>> _controller;

  Stream<Map> get orderStream {
    _controller =
        StreamController<Map<String, dynamic>>.broadcast(onListen: () {
      _updateOrderList();
    });
    return _controller.stream;
  }
}
