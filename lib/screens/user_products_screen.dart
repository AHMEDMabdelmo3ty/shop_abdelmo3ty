import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';

class userProductsScreen extends StatelessWidget {
  static const routeName = "/userProductsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("the new shops"),
      ),
      drawer: appDrawer(),

      body: Container(
        child: Center(
          child: Text("hi"),
        ),
      ),
    );
  }
}
