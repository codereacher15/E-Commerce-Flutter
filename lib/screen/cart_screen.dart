import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/order.dart';
import '../provider/cart.dart' show Cart; //imports only Cart
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context);
    final order = Provider.of<Order>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: Card(
              elevation: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 10.0),
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    label: Text(
                      "\$${cartItem.Amount.toStringAsFixed(2)}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: OrderButton(cartItem: cartItem, order: order),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartItem.items.length,
                itemBuilder: (ctx, i) => CartItem(
                      id: cartItem.items.values.toList()[i].id,
                      title: cartItem.items.values.toList()[i].title,
                      qty: cartItem.items.values.toList()[i].qty,
                      price: cartItem.items.values.toList()[i].price,
                      pid: cartItem.items.keys.toList()[i],
                    )),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    @required this.cartItem,
    @required this.order,
  });

  final Cart cartItem;
  final Order order;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading == true
          ? CircularProgressIndicator()
          : Text("ORDER NOW",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold)),
      onPressed: widget.cartItem.Amount <= 0 || _isLoading == true
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.order.addOrder(widget.cartItem.items.values.toList(),
                  widget.cartItem.Amount);
              setState(() {
                _isLoading = false;
              });
              widget.cartItem.clear();
            },
    );
  }
}
