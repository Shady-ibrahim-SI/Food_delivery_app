import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/mainScreens/Seller_Home.dart';
import 'package:foodaway_sellers_app/screens/on_boarding_screens/on_boarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer(){
    Timer
    (Duration(seconds: 3), () async
    {
      // checking if seller already logged in
       FirebaseAuth firebaseAuth =FirebaseAuth.instance;
      if(firebaseAuth.currentUser !=null){
        Navigator.push(context, MaterialPageRoute(builder:(context) => SellerHome(),));  
      }
      else{
        // if seller didn't logg in
      Navigator.push(context, MaterialPageRoute(builder:(context) => OnBoardingSCreen1(),));
      }
     }
    );
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                  decoration: BoxDecoration(
                  image:DecorationImage(image: AssetImage('assets/images/image 44.png'),)
                  ),
                  ),
                  Text('Food Away',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,color:Color(0xff53E88B),fontFamily:'viga'),),
                  SizedBox(height: 4,),
                  Text('Deliver Favourite Food',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
          ],
          )
          ),
    );
  }
}