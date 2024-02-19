import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/Authentication_screens/signup_screen.dart';
import 'package:foodaway_riders_app/firebase_options.dart';
import 'package:foodaway_riders_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

  void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),  
    )
    );
}