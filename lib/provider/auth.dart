import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get idUser {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDCEbDQa4-7i_g8NCjm1gURHcvWUQ00zC4");
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseDate = json.decode(res.body);
      if (responseDate['error'] != null) {
        throw HttpException(responseDate["error"]['message']);
      }
      _token = responseDate['idToken'];
      _userId = responseDate['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDate['expiresIn'])));
      notifyListeners();
      _auotoLogout();
      final prefs = await SharedPreferences.getInstance();
      String userdate = json.encode({
        'token': _token,
        'userid': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userDate', userdate);
    } catch (e) {
      throw e;
    }
  }

  Future<void> singup(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userDate')) return false;
    final Map<String, Object> extractedDate =
        json.decode(prefs.getString('userDate')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedDate['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extractedDate['token'];
    _userId = extractedDate['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _auotoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _auotoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
