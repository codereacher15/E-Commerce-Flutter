import 'package:flutter/material.dart';
import '../provider/cart.dart';
import '../provider/product.dart';
import '../screen/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String url;

  // ProductItem(this.id, this.title, this.url);
  @override
  Widget build(BuildContext context) {
    //this takes the product item from the provider in main
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailScreen.routeName,
              arguments: product.id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            //this is a widget version of Provider.of
            //used when we specify the part where we will require the listener or which will change
            //child here is used for something that will not rebuild
            //Consumer Rebuilds part of a subtree when the listening state changes.
            leading: Consumer<Product>(
              builder: (c, value, child) => IconButton(
                //change the button using togglefav
                //works as the consumer provider changes the data accordingly
                icon: Icon(product.isfavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  //to toggle the favorite button
                  product.toggleFav();
                },
              ),
            ),
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added Item to cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removesigle(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
