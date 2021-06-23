import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/provider/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/authscreen";

  @override
  Widget build(BuildContext context) {
    final myDvies = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.amberAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            width: myDvies.width,
            height: myDvies.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 84, vertical: 9),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.indigo,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 150,
                              color: Colors.white,
                              offset: Offset(15, 55)),
                          BoxShadow(
                              blurRadius: 150,
                              color: Colors.blueAccent,
                              offset: Offset(15, 55))
                        ]),
                    child: Text(
                      "my Shop",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontFamily: "Anton",
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: myDvies.width > 600 ? 2 : 1,
                  child: AuthCard(),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { login, signup }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authDate = {"email": "", "password": ""};
  var _isLoading = false;
  final _passwordcontroller = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimtion;
  Animation<double> _obacityAnimation;
  @override
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimtion = Tween<Offset>(
      begin: Offset(0, -0.15),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _obacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formkey.currentState.validate()) {
      return null;
    }
    FocusScope.of(context).unfocus();
    _formkey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authDate['email'], _authDate['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .singup(_authDate['email'], _authDate['password']);
      }
    } on HttpException catch (error) {
      var errorMassege = 'Authentication failed';
      print(errorMassege);
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMassege = 'this email is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMassege = 'this IS not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMassege = 'this PASSWORD is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMassege = 'could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMassege = 'INvalid password';
      }
      _showErrorDialog(errorMassege);
    } catch (error) {
      const errorMassege = '';
      _showErrorDialog(errorMassege);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String errorMassege) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('an Error occurred !!'),
              content: Text(errorMassege),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("okay!"))
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  Widget build(BuildContext context) {
    final myDvies = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signup ? 380 : 280,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 380 : 280),
        width: myDvies.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty || !val.contains("@")) {
                      return "invalid Email";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authDate["email"] = val;
                  },
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  decoration: InputDecoration(
                    labelText: "password",
                  ),
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty || val.length < 5) {
                      return "password not strong";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authDate["password"] = val;
                  },
                ),

                // AnimatedContainer(
                //
                //     duration: Duration(milliseconds: 900),
                //     constraints: BoxConstraints(
                //         minHeight: _authMode == AuthMode.signup ? 60 : 0,
                //         maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                //     curve: Curves.easeIn,
                //     child: FadeTransition(
                //       opacity: _obacityAnimation,
                //       child: SlideTransition(
                //         position: _slideAnimtion,
                //         child: TextFormField(
                //
                //           enabled:_authMode==AuthMode.signup,
                //           decoration: InputDecoration(
                //             labelText: "confierm password",
                //           ),
                //           obscureText: true,
                //           validator: _authMode==AuthMode.signup?(val) {
                //             if (val != _passwordcontroller.text) {
                //               return "password not true";
                //             }
                //             return null;
                //           }:null,
                //           onSaved: (val) {
                //             _authDate["password"] = val;
                //           },
                //         ),
                //       ),
                //     )),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading) CircularProgressIndicator(),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.login ? "login" : "signup"),
                  ),
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    "${_authMode == AuthMode.login ? "login" : "signup"} insted",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
