import 'package:flutter/material.dart';

class Food {
  String image;
  String imageLarge;
  String unit;
  String ofShop;
  bool isSpecial;
  double price;
  double rating;
  int count;
  String name;
  double increment;
  String description;
  double discount;
  String id;
  String category;
  List<String> variety;

  Food(
      {this.image,
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

  Food.dummy() {
    this.image =
        "https://i1.wp.com/digital-photography-school.com/wp-content/uploads/2018/04/pizza_margherita.jpg?fit=700%2C467&ssl=1";
    this.unit = "Food Unit";
    this.ofShop = "Food Shop id";
    this.isSpecial = false;
    this.price = 1400;
    this.rating = 2.5;
    this.count = 6;
    this.name = "Food name";
    this.increment = .5;
    this.description = "food description";
    this.discount = 20;
    this.category = "food Category";
    this.variety = ["Food Variety 1", 'Food Vriety 2'];
    this.id = UniqueKey().toString();
  }

  Food.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    unit = json['unit'];
    ofShop = json['ofShop'];
    isSpecial = json['isSpecial'];
    price = json['price'] != null ? double.tryParse("${json['price']}") : null;
    rating =
        json['rating'] != null ? double.tryParse("${json['rating']}") : null;
    count = json['count'];
    name = json['name'];
    increment = json['increment'] != null
        ? double.tryParse("${json['increment']}")
        : null;
    description = json['description'];
    discount = json['discount'] != null
        ? double.tryParse("${json['discount']}")
        : null;
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
  String id;

  FoodCategory({this.name, this.id});

  FoodCategory.fromJson(Map<String, dynamic> json) {
    this.name = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
