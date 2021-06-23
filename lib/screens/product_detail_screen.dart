import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';

class productDetail extends StatelessWidget {
  static const routeName = "/produdct-detail";

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
