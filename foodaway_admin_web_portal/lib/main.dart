import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_admin_web_portal/authentication/login_screen.dart';
import 'package:foodaway_admin_web_portal/main%20screens/home_screen.dart';

 void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyCHuDvebLD8KZEjNghAK1i0JlTwj9giESI"
    , appId: "1:819804085202:web:6f80c3c32f9bd8474cc60b",
     messagingSenderId: "819804085202",
      projectId: "food-away-sellers-app")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Portal',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:FirebaseAuth.instance.currentUser == null ? LoginScreen() : HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

