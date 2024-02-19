import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:foodaway_users_app/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemCounter extends ChangeNotifier {

  int? cartListItemCounter;
  Future<void> displayCartListItemNumber() async{

    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    
    cartListItemCounter =  sharedPreferences.getStringList("userCart")!.length;

    await Future.delayed( Duration(milliseconds: 100) , (){
      notifyListeners();
    });
  }
  int? get count => cartListItemCounter;
}