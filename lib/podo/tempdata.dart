import 'shop.dart';

Shop createShop() {
  String image =
      "https://www.printechdigital.com/wp-content/uploads/2017/03/Picture13-1.jpg";
  Shop shop = Shop(
      id: "ajay@gmail.com",
      title: "Ajay Stores",
      image: image,
      currency: "Rs.",
      email: "ajayContact@gmail.com",
      isOpen: true,
      phone: "9862146252",
      count: 56,
      rating: 4.5);
  return shop;
}
