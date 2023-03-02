import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/order.dart';
import 'package:flutter_complete_guide/screen/cart_screen.dart';
import 'package:flutter_complete_guide/screen/edit_product_screen.dart';
import 'package:flutter_complete_guide/screen/order_screen.dart';
import '../screen/user_product_screen.dart';
import './provider/cart.dart';
import './screen/product_overviews_screen.dart';
import '../screen/product_details_screen.dart';
import './provider/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //instead of using multiple nested provider it is better to use multiprovider
    return MultiProvider(
      providers: [
        //here we should use this constructor instead of .value()
        //when we pass a new object to provider each time we use create
        //when we pass existing object again and again use create
        ChangeNotifierProvider(
          create: (c) => Products(),
        ),
        ChangeNotifierProvider(
          create: (c) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (cxt) => Order(),
        )
      ],
      child: MaterialApp(
        title: 'ShopApp',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.white),
            bodyText2: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
            ),
          ),
          fontFamily: 'Lato',
          scaffoldBackgroundColor: Colors.pink[100],
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
              .copyWith(secondary: Color.fromARGB(255, 215, 109, 121)),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen()
        },
      ),
    );
  }
}
