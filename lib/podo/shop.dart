import 'food.dart';

class Shop {
  Stream<List<Food>> foodStream;
  String image;
  bool isOpen;
  String phone;
  int count;
  double rating;
  String title;
  String slogan;
  String currency;
  String id;
  String email;
  String location;
  String coordinate;
  String ofUser;
  List<String> foodGroups;

  Shop(
      {this.image,
      this.isOpen,
      this.phone,
      this.count,
      this.rating,
      this.title,
      this.slogan,
      this.currency,
      this.id,
      this.location,
      this.coordinate,
      this.foodGroups,
      this.ofUser,
      this.email});

  Shop.fromJson(Map<String, dynamic> json, String docId) {
    try {
      image = json['image'] ?? null;
      isOpen = json['isOpen'] ?? false;
      phone = json['phone'];
      count = json['count'];
      rating =
          json['rating'] != null ? double.tryParse("${json['rating']}") : null;
      title = json['title'];
      currency = json['currency'];
      id = docId;
      email = json['email'];
      location = json['location'];
      coordinate = json['coordinate'];
      ofUser = json['ofUser'];
      foodGroups = json['foodGroups'] != null
          ? json['foodGroups'].toList().cast<String>()
          : null;
    } on Exception catch (e) {
      print(e.runtimeType);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['isOpen'] = this.isOpen ?? false;
    data['phone'] = this.phone;
    data['count'] = this.count ?? 0;
    data['rating'] = this.rating ?? 3;
    data['title'] = this.title;
    data['currency'] = this.currency ?? "Rs.";
    data['email'] = this.email;
    data['foodGroups'] = this.foodGroups;
    data['ofUser'] = this.ofUser;
    data['location'] = this.location;
    data['coordinate'] = this.coordinate;
    return data;
  }
}
