import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/edit_product_screen.dart';
import './provider/auth.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './provider/products.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';

import 'screens/product_overwiew_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Products>(
            create: (_)=>Products(),
            update:(context,authValue,previousProduct)=>previousProduct
              ..getData(
                  authValue.token,
                  authValue.idUser,
                  previousProduct==null?null:previousProduct.items
              )
        ),
        ChangeNotifierProxyProvider<Auth,Orders>(
            create: (_)=>Orders(),
            update:(context,authValue,previousOrders)=>previousOrders
              ..getData(
                authValue.token,
                authValue.idUser,
                  previousOrders==null?null:previousOrders.orders
              )
            ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.deepPurpleAccent,
              accentColor: Colors.blueAccent,
              fontFamily: "Lato"),
          home: auth.isAuth
              ? productOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            productDetail.routeName: (_) => productDetail(),
            cartScreen.routeName: (_) => cartScreen(),
            ordersScreen.routeName: (_) => ordersScreen(),
            userProductsScreen.routeName: (_) => userProductsScreen(),
            editProductsScreen.routeName: (_) => editProductsScreen(),
          },
        ),
      ),
    );
  }
}
