import 'package:flutter/material.dart';
import '../provider/products.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class ProductsGrid extends StatelessWidget {
  var showFav;
  ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context);
    //in approach 2 here we will use alternate getter to get only the items where favorite is toggled
    final products = showFav ? productsdata.getFav : productsdata.getItem;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      //here it is bettter to use .value() instead of normal provider in list/grid
      itemBuilder: (c, i) => ChangeNotifierProvider<Product>.value(
        //when providing list or grid items mention their generic type explicitly
        //normally the provider recycles the widget and just adds the new data to the recycled widget
        //in case of .value every time a new widget created with new value
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
