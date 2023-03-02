import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/side_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userproduct';

  Future<void> refreshProduct(BuildContext context) async {
    //listen:false indicates only fetching of data and not setting a listener up
    await Provider.of<Products>(context, listen: false).fetchandSet();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, EditProductScreen.routeName),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: productsData.getItem.length,
              itemBuilder: (ctx, i) => Column(
                    children: [
                      UserProductItem(
                        title: productsData.getItem[i].title,
                        imgurl: productsData.getItem[i].imageUrl,
                        id: productsData.getItem[i].id,
                      ),
                      Divider(),
                    ],
                  )),
        ),
      ),
    );
  }
}
