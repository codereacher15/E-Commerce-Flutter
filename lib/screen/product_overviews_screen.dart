import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/cart_screen.dart';
import '../provider/cart.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/side_drawer.dart';
import '../provider/products.dart';

enum Filter {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFav = false;
  var isLoading = false;
  var isInit = true;

  @override
  //whenever a new product is there we want to add that to the prod_overview screen
  //we thus use GET request inside the initState as soon as the page loads
  void initState() {
    // TODO: implement initState
    //we use Future delayed constructor to avoid an error
    //inside init state .of(context) doesnt work as the class is still building
    //so to make it execute later in the order we add this constructor
    //like this we ensure the class widget is created and the GET happens after that
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchandSet();
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchandSet().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //we only need the data so listen is false
    //final productlist = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          //setting up listener with consumer as the cart count is only needed by the Badge here
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.countitem.toString(),
            ),
            //this child automatically passes to ch
            //as this doesnt need to be rebuilt if listener state changes
            //we pass it here in child
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (() {
                Navigator.pushNamed(context, CartScreen.routeName);
              }),
            ),
          ),
          PopupMenuButton(
            //when we use the popmenu
            onSelected: (Filter value) {
              setState(() {
                //if we select the favorites option
                if (value == Filter.Favorites) {
                  showFav = true;
                  //turn the value of showfavorites to true
                  //productlist.showFavorites();
                } else {
                  showFav = false;
                  //turn the value of showfavorites to false
                  //productlist.showAll();
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: Filter.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: Filter.All,
              ),
            ],
          ),
        ],
        title: Text('EShop'),
      ),
      drawer: AppDrawer(),
      //approach 2 to show fav this is used as we want to implement this favaorite toggle only when in
      //the screen and not presist thorughtout the app
      //use a stateful widget and take a variable which turn true if we select favorite in popup
      //pass that to productgrid which mainly shows what grid is build
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(showFav),
    );
  }
}
