import 'dart:math';

import 'package:flutter/material.dart';
import '../provider/order.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(
              DateFormat('dd.MM.yyyy   hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  expand = !expand;
                });
              },
              icon: Icon(expand ? Icons.expand_less : Icons.expand_more)),
        ),
        if (expand)
          Container(
            height: min(widget.order.products.length * 20.0 + 100, 100),
            child: ListView(
              children: widget.order.products
                  .map((prod) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.qty}x\$${prod.price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          )
      ]),
    );
  }
}
