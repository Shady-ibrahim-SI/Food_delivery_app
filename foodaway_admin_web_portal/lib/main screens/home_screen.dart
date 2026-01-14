import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_admin_web_portal/authentication/login_screen.dart';
import 'package:foodaway_admin_web_portal/riders/all_blocked_riders_screen.dart';
import 'package:foodaway_admin_web_portal/riders/all_verified_riders_screen.dart';
import 'package:foodaway_admin_web_portal/sellers/all_blocked_sellers_screen.dart';
import 'package:foodaway_admin_web_portal/sellers/all_verified_sellers_screen.dart';
import 'package:foodaway_admin_web_portal/users/all_blocked_users_screen.dart';
import 'package:foodaway_admin_web_portal/users/all_verified_users_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  String timeText='';
  String dateText='';
 
  String formatCurrentLiveTime(DateTime time)
  {
    return DateFormat("hh:mm:ss a").format(time);
  }
  String formatCurrentDate(DateTime date)
  {
    return DateFormat("dd MMMM, yyyy").format(date);
  }
  getCurrentLiveTime(){

    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentDate(timeNow);

    if(this.mounted){
      setState(() {
        timeText = liveTime;
        dateText = liveDate;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeText = formatCurrentLiveTime(DateTime.now());
    dateText = formatCurrentDate(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (timer) { 
      getCurrentLiveTime();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.red,
                Colors.black,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ),
        ),
        title: Text("Admin Web Portal",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(timeText + "\n" + dateText,style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 3  ,fontWeight: FontWeight.bold),),
            ),
            // user activate and block accounts
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // Activate user
                ElevatedButton.icon(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => AllVerifiedUsersScreen(),));
                }, icon:Icon(Icons.person_add,color: Colors.white,),
                 label: Text("All Verified Users Accounts",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.blue
                ) 
               ),
                SizedBox(width: 20,),
               // Block user 
               ElevatedButton.icon(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => AllBlockedUsersScreen(),));
                }, icon:Icon(Icons.block_flipped,color: Colors.white,),
                 label: Text("All Blocked Users Accounts",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.red
                ) 
               )
              ],
            ),

            // sellers activate and block accounts
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // Activate seller
                ElevatedButton.icon(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => AllVerifiedSellersScreen(),));
                }, icon:Icon(Icons.person_add,color: Colors.white,),
                 label: Text("All Verified Sellers Accounts",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.blue
                ) 
               ),
                SizedBox(width: 20,),
               // Block seller 
               ElevatedButton.icon(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => AllBlockedSellersScreen(),));
                }, icon:Icon(Icons.block_flipped,color: Colors.white,),
                 label: Text("All Blocked Sellers Accounts",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.red
                ) 
               )
              ],
            ),

            // riders activate and block accounts

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // Activate rider
                ElevatedButton.icon(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => AllVerifiedRidersScreen(),));
                }, icon:Icon(Icons.person_add,color: Colors.white,),
                 label: Text("All Verified Riders Accounts",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.blue
                ) 
               ),
                SizedBox(width: 20,),
               // Block rider 
               ElevatedButton.icon(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => AllBlockedRidersScreen(),));
                }, icon:Icon(Icons.block_flipped,color: Colors.white,),
                 label: Text("All Blocked Riders Accounts",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.red
                ) 
               )
              ],
            ),
            
            // Logout button
            ElevatedButton.icon(onPressed:() {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder:(context) => LoginScreen(),));
                }, icon:Icon(Icons.logout,color: Colors.white,),
                 label: Text("Logout",
                 style: TextStyle(fontSize: 16,color:Colors.white,letterSpacing: 3),
                 ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.red
                ) 
               )
            
          ],
        ),
      ),
    );
  }
}