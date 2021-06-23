import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

class appDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(height: 2),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(height: 2),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('order'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(
                    ordersScreen.routeName),
          ),
          Divider(height: 2),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('manage product'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(userProductsScreen.routeName),
          ),
          Divider(height: 2),
          ListTile(
            leading: Icon(Icons.exit_to_app_rounded),
            title: Text('loguot'),
            onTap: () {
              Navigator.of(context).pop();
               Navigator.of(context).pushReplacementNamed('/');
               Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
