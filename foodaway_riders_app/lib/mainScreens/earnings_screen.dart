import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/global/global.dart';
import 'package:foodaway_riders_app/screens/splash_screen.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("£"+previousRiderEarnings,style: TextStyle(fontSize: 30,color: Colors.white),),
            Text("Total Earnings",style: TextStyle(fontSize: 30,color: Colors.grey,letterSpacing: 3,fontWeight: FontWeight.bold),),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                thickness: 1.5,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
              },
              child: Card(
                color: Colors.white54,
                margin: EdgeInsets.symmetric(vertical: 40,horizontal: 140),
                child: ListTile(
                  leading: Icon(Icons.arrow_back,color: Colors.white,),
                  title: Text("Back",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                ),
              ),
            )
          ],
        )
          ) 
        ),
    );
  }
}