import 'package:flutter/material.dart';
import '../provider/products.dart';
import '../screen/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imgurl;
  final String id;
  const UserProductItem({this.title, this.imgurl, this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: (() => Navigator.pushNamed(
                  context, EditProductScreen.routeName,
                  arguments: id)),
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteprod(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('Deleting Failed!'),
                  ));
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
