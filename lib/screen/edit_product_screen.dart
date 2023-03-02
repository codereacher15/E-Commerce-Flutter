import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/product.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editproduct';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //for moving to the next field on pressing next button from current field
  //focusnode var for price field
  //to be passed to onfieldsubmitted of title field
  //title -> price

  final _pricefocus = FocusNode();
  final descfocus = FocusNode();
  final imagecontroller = TextEditingController();
  final imagefocus = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);
  @override
  var _isInit = true;
  var _isLoading = false;
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': '',
  };
  void initState() {
    // TODO: implement initState

    imagefocus.addListener(updateimgurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).itembyId(productID);
        _initValue = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'imageurl': '',
          'price': editedProduct.price.toString(),
        };
        imagecontroller.text = editedProduct.imageUrl;
      }
    }
    _isInit =
        false; //as didchangedependancies execute multiple times we use this flag to stop our code
    //executing multiple times
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  //to avoid memory leak
  @override
  void dispose() {
    _pricefocus.dispose();
    descfocus.dispose();
    imagefocus.removeListener(updateimgurl);
    imagecontroller.dispose();
    imagefocus.dispose();
    super.dispose();
  }

  void updateimgurl() {
    if (!imagefocus.hasFocus) setState(() {});
  }

  void saveForm() async {
    final isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateprod(editedProduct.id, editedProduct);
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(editedProduct)
          .catchError((err) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error has occured'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay!'))
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      //instead of manually creating and connecting TextControllers we can use Form widget
      //it doesnt show anything but internally provides many inputs for user input
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          Focus.of(context).requestFocus(_pricefocus);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          editedProduct = Product(
                            title: newValue,
                            description: editedProduct.description,
                            imageUrl: editedProduct.imageUrl,
                            price: editedProduct.price,
                            isfavorite: editedProduct.isfavorite,
                            id: editedProduct.id,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocus,
                        onFieldSubmitted: (_) {
                          Focus.of(context).requestFocus(descfocus);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter price greater than zero';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          editedProduct = Product(
                              isfavorite: editedProduct.isfavorite,
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              imageUrl: editedProduct.imageUrl,
                              price: double.parse(newValue));
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a description';
                          }
                          if (value.length < 10) {
                            return 'Enter a description of at least 10 characters';
                          }
                          return null;
                        },
                        maxLines: 3,
                        focusNode: descfocus,
                        onSaved: (newValue) {
                          editedProduct = Product(
                              isfavorite: editedProduct.isfavorite,
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: newValue,
                              imageUrl: editedProduct.imageUrl,
                              price: editedProduct.price);
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Container(
                              child: imagecontroller.text.isEmpty
                                  ? Text("Enter a URL")
                                  : FittedBox(
                                      child:
                                          Image.network(imagecontroller.text),
                                    ),
                            ),
                          ),
                          //As the row takes all the width of a screen and textformfield
                          //cannot have unbounded width this will throw an error
                          //soln-wrap it in expanded which fills the available space
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: imagecontroller,
                              focusNode: imagefocus,
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a URL';
                                }
                                if (!value.startsWith('http') ||
                                    !value.startsWith('https')) {
                                  return 'Please provide a valid URL';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                editedProduct = Product(
                                    isfavorite: editedProduct.isfavorite,
                                    id: editedProduct.id,
                                    title: editedProduct.title,
                                    description: editedProduct.description,
                                    imageUrl: newValue,
                                    price: editedProduct.price);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
