import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/order_screen.dart';
import 'package:flutter_complete_guide/screen/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber[600],
      child: Column(
        children: [
          AppBar(
            title: Text('Hello! '),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (() {
              Navigator.of(context).pushReplacementNamed('/');
            }),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (() {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            }),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Products'),
            onTap: (() {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            }),
          ),
        ],
      ),
    );
  }
}
