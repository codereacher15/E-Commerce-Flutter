import 'dart:convert';

import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    this.id,
    this.amount,
    this.dateTime,
    this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchandSetorders() async {
    final url = Uri.https(
        'flutter-29634-default-rtdb.firebaseio.com', '/products/.json');
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return;
    }
    extractData.forEach((ordId, ordData) {
      loadedOrder.add(OrderItem(
          id: ordId,
          amount: ordData['amount'],
          dateTime: DateTime.parse(ordData['dateTime']),
          products: (ordData['products'] as List<dynamic>).map(
            (e) => CartItem(
                id: e['id'],
                title: e['title'],
                qty: e['qty'],
                price: e['price']),
          )));
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'flutter-29634-default-rtdb.firebaseio.com', '/products/.json');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'qty': e.qty,
                    'id': e.id,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: timestamp.toString(),
            amount: total,
            dateTime: DateTime.now(),
            products: cartProducts));
    notifyListeners();
  }
}
