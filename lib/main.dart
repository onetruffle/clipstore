import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Product {
  const Product({
    required this.name,
    required this.data,
  });
  final String name;
  final String data;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;

  Color _getColor(BuildContext context) {
    return inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await FlutterClipboard.copy(product.data);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text('Copied to Clipboard'),
        ));
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {

  List<Product> products = [];

  Future<String> _loadList() async {
    var assetString = await rootBundle.loadString('AssetManifest.json');
    var filepaths = json
        .decode(assetString)
        .keys
        .where((key) => key.startsWith('assets/') && !key.contains('.gitignore'))
        .toList();
    var productFutures = filepaths.map<Future<Product>>((String key) async {
      var data = await rootBundle.loadString(key);
      return Product(name: key.substring(7), data: data);
    });
    products = await Future.wait(productFutures);
    return 'List loaded';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadList(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('clipstore'),
          ),
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: products.map((Product product) {
                return ShoppingListItem(
                  product: product,
                  inCart: false,
                );
              }).toList(),
            ),
          )
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    darkTheme: ThemeData.dark(),
    home: ShoppingList(),
  ));
}
