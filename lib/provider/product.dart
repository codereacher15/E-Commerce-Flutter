import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isfavorite = false,
  });

  void setFav(oldstatus) {
    isfavorite = oldstatus;
    notifyListeners();
  }

  //to toggle the favorite button
  //linked with onpressed
  //listener listens to the product_overview screen listener and changes whenver the method is pressed
  Future<void> toggleFav() async {
    final oldstatus = isfavorite;
    final url = Uri.https(
        'flutter-29634-default-rtdb.firebaseio.com', '/products/$id.json');
    isfavorite = !isfavorite;
    notifyListeners();
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isfavorite': isfavorite,
          }));
      if (response.statusCode >= 400) {
        setFav(oldstatus);
      }
    } catch (error) {
      setFav(oldstatus);
    }
  }
}
