import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.qty,
      @required this.price});
}

class Cart with ChangeNotifier {
  //map of cart items where prouduct id is the key
  Map<String, CartItem> _items = {};

  //getter for map
  Map<String, CartItem> get items {
    //returning copy of map instead of pointer to the original map
    return {..._items};
  }
  //return no of entries,items in cart

  int get countitem {
    return _items == null ? 0 : _items.length;
  }

  //method to add something to map

  void addItem(String pid, double price, String title) {
    //if item already present in map
    //increase the quantity
    if (_items.containsKey(pid)) {
      _items.update(
          pid,
          //here update provides the existing value automatically so we can use that
          (existing) => CartItem(
                id: existing.id,
                price: existing.price,
                qty: existing.qty + 1, //qty=qty+1
                title: existing.title,
              ));
    } else {
      //add the new item to cart
      _items.putIfAbsent(
        pid,
        () => CartItem(
          id: DateTime.now()
              .toString(), //using datetime to create unique cartitem id
          title: title,
          qty: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String pid) {
    _items.remove(pid);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removesigle(String pid) {
    if (!_items.containsKey(pid)) {
      return;
    }
    if (_items[pid].qty > 1) {
      _items.update(
          pid,
          (existing) => CartItem(
                id: existing.id,
                price: existing.price,
                qty: existing.qty - 1,
                title: existing.title,
              ));
    } else {
      _items.remove(pid);
      notifyListeners();
    }
  }

  double get Amount {
    double tot = 0.0;
    _items.forEach((key, value) {
      tot += value.price * value.qty;
    });
    return tot;
  }
}
