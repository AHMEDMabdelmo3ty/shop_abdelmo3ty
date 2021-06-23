import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';

class ordersScreen extends StatelessWidget {
  static const routeName = "/orders-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: appDrawer(),

      appBar: AppBar(
        title: Text("the new shops"),
      ),
      body: Container(
        child: Center(
          child: Text("hi"),
        ),
      ),
    );
  }
}
