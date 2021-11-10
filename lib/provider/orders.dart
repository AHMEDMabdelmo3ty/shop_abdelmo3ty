import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  getData(String authtoken, String uId, List<OrderItem> orders) {
    authToken = authtoken;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders([bool filterByUser = false]) async {
    var url =
        'https://fluttershop-cbef1-default-rtdb.firebaseio.com/orders/$userId.josn=$authToken';
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return null;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrders(List <CartItem> cartProduct,double total) async {

    final url =
        'https://fluttershop-cbef1-default-rtdb.firebaseio.com/orders/$userId.josn=$authToken';
    try {
      final timestamp= DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toString(),
            'imageUrl': cartProduct.map((cp) =>{
              'id':cp.id,
              'title':cp.title,
              'price':cp.price,
              'quantity':cp.quantity,
            }).toList(),

          }));
     
      _orders.insert( 0, OrderItem(id:json.decode(res.body)['name'],
          amount: total,
          dateTime: timestamp,
          products:cartProduct));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
