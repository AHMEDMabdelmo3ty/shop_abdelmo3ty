import 'package:flutter/material.dart';

class cartScreen extends StatelessWidget {
  static const routeName = "/cartscreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
