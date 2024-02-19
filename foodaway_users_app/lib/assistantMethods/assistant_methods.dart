
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_users_app/assistantMethods/cart_item_counter.dart';
import 'package:foodaway_users_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

 Future<List<String>> separateOrderItemIDs(dynamic orderIDs)async{

  List<String> separateItemIDsList =[] , defaultItemList=[];
  
  int i=0;
  
  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++){

    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0,pos) : item; // 56557657:7

    print("\n this is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);

  }

  print("\n this is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

Future<List<String>> separateItemIDs()async{
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
  
  List<String> separateItemIDsList =[] , defaultItemList=[];
  
  int i=0;
  
  defaultItemList = sharedPreferences.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++){

    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0,pos) : item; // 56557657:7

    print("\n this is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);

  }

  print("\n this is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

  clearCartNow(context)async{
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    FirebaseAuth firebaseAuth =FirebaseAuth.instance;
    await sharedPreferences.setStringList("userCart", ['garbageValue']);
    List<String>? emptyList = sharedPreferences.getStringList("userCart");

    FirebaseFirestore.instance
    .collection("users")
    .doc(firebaseAuth.currentUser!.uid)
    .update({"userCart": emptyList}).then((value) {
        sharedPreferences.setStringList("userCart", emptyList!);
        Provider.of<CartItemCounter>(context,listen: false).displayCartListItemNumber();
    });
  }

 separateOrderItemQuantities(orderIDs){

  List<String> separateItemQuantityList =[];
  List<String> defaultItemList=[];
  
  int i=1;
  
  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++){

    String item = defaultItemList[i].toString();
     // 56557657:7
    List<String> listItemCharacters = item.split(":").toList();
    
    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print("\n this is Quantity Number = " + quantityNumber.toString());

    separateItemQuantityList.add(quantityNumber.toString());

  }

  print("\n this is Quantity List now = ");
  // print(defaultItemList);
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

 Future<List<int>> separateItemQuantities()async{
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
  
  List<int> separateItemQuantityList =[];
  List<String> defaultItemList=[];
  
  int i=1;
  
  defaultItemList = sharedPreferences.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++){

    String item = defaultItemList[i].toString();
     // 56557657:7
    List<String> listItemCharacters = item.split(":").toList();
    
    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print("\n this is Quantity Number = " + quantityNumber.toString());

    separateItemQuantityList.add(quantityNumber);

  }

  print("\n this is Quantity List now = ");
  // print(defaultItemList);
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

void adddToCart(String? foodItemId, BuildContext context, int itemCounter) async{
      SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
      final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
      List<String>? tempList = sharedPreferences.getStringList("userCart");
      tempList!.add(foodItemId! + ":$itemCounter");

      FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid).update({
        "userCart": tempList,
      }).then((value) async{
        Fluttertoast.showToast(msg: "Item Added Successfully.");
        sharedPreferences.setStringList("userCart", tempList);

        // updating the number of cart icon 
        await Provider.of<CartItemCounter>(context,listen: false).displayCartListItemNumber();
      });
  }