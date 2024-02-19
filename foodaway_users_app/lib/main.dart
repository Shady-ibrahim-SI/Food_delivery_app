import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_users_app/assistantMethods/address_changer.dart';
import 'package:foodaway_users_app/assistantMethods/cart_item_counter.dart';
import 'package:foodaway_users_app/assistantMethods/total_amount.dart';
import 'package:foodaway_users_app/firebase_options.dart';
import 'package:foodaway_users_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';


  void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context) => CartItemCounter(),),
        ChangeNotifierProvider(create:(context) => TotalAmount(),),
        ChangeNotifierProvider(create:(context) => AddressChanger(),)
      ],
       child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),  
         ),
     )
    );
}