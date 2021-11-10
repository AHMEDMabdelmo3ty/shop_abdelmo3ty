import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';

class editProductsScreen extends StatelessWidget {
  static const routeName = "/editProductsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: appDrawer(),

      appBar: AppBar(
        title: Text("the new shops"),
      ),
      body: Container(
        child: Center(
          child: Text("edit"),
        ),
      ),
    );
  }
}
