import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_riders_app/Authentication_screens/login_screen.dart';
import 'package:foodaway_riders_app/assistantMethds/get_current_address.dart';
import 'package:foodaway_riders_app/global/global.dart';
import 'package:foodaway_riders_app/mainScreens/earnings_screen.dart';
import 'package:foodaway_riders_app/mainScreens/history_screen.dart';
import 'package:foodaway_riders_app/mainScreens/new_orders_screen.dart';
import 'package:foodaway_riders_app/mainScreens/not_yet_delivered_screen.dart';
import 'package:foodaway_riders_app/mainScreens/parcel_in_progress_screen.dart';
import 'package:foodaway_riders_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_richt_text.dart';

class RiderHome extends StatefulWidget {
   RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  String? riderName;
  String? riderPhotoUrl;
  String? riderEmail;
  String? riderAddress;
  Future<String> getNameFromSharedPreferences() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString('name') ?? 'Name not found';
    }
    Future<void> getDataFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    riderName = sharedPreferences.getString('name') ?? 'Name not found';
    riderPhotoUrl = sharedPreferences.getString('photoUrl') ?? 'photoUrl not found';
    riderEmail = sharedPreferences.getString('email') ?? 'Email not found';
    riderAddress = sharedPreferences.getString('address') ?? 'Address not found';
    // You can set other properties in a similar manner.
  }
 void userSignOut() {
    FirebaseAuth firebaseAuth =FirebaseAuth.instance;
    firebaseAuth.signOut();
  }
  Card makeDashboardItem(String title , IconData iconData , int index){
      return Card(
        elevation: 2,
        margin: EdgeInsets.all(8),
        child: Container(
           decoration: index==0 || index==3 || index==4 ? BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.red,
                Colors.cyan,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ): BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.white,
                Colors.cyan,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
          )
        ),
        child: InkWell(
          onTap: () {
            if(index == 0){
              // New Avaliable Orders 
              Navigator.push(context, MaterialPageRoute(builder:(context) => NewOrdersScreen(),));
            }
            if(index == 1){
              // pracels in progress 
              Navigator.push(context, MaterialPageRoute(builder:(context) => ParcelInProgreessScreen(),));
            }
            if(index == 2){
              // Not yet delivered 
              Navigator.push(context, MaterialPageRoute(builder:(context) => NotYetDeliveredScreen(),));
            }
            if(index == 3){
              // History
              Navigator.push(context, MaterialPageRoute(builder:(context) => HistoryScreen(),)); 
            }
            if(index == 4){
              // Totoal Earnings 
              Navigator.push(context, MaterialPageRoute(builder:(context) => EarningsScreen(),));
            }
            if(index == 5){
              // Log out 
              FirebaseAuth firebaseAuth =FirebaseAuth.instance;
              firebaseAuth.signOut().then((value) {
                Navigator.push(context, MaterialPageRoute(builder:(context) => Login(),));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              SizedBox(height: 50,),
              Center(child: Icon(iconData,size: 40,color: Colors.black,), ),
              SizedBox(height: 10,),
              Center(child: Text(title,style: TextStyle(fontSize: 16,color: Colors.black),),)
            ],
          ),
        ),
        )
      );
  }
  restrictBlockedRidersFreomUsingApp() async{
      FirebaseAuth firebaseAuth =FirebaseAuth.instance;
      await FirebaseFirestore.instance.collection("riders")
      .doc(firebaseAuth.currentUser!.uid).get().then((snapshot) {
        if(snapshot.data()!["status"] != "approved"){

          Fluttertoast.showToast(msg: "you have been Blocked.");
          firebaseAuth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
        }
        else{
          UserLocation uLocation = UserLocation();
          uLocation.getCurrentLocation();
          getPerParcelDeliveryAmount();
          getRiderPreviousEarnings();
        }
      }
      );
    }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restrictBlockedRidersFreomUsingApp();
  }
  getRiderPreviousEarnings()async{
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection("riders").doc(sharedPreferences.getString("Uid")).get().then((snap) {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount(){
      FirebaseFirestore.instance.collection("perDelivery").doc("alizeb438").get().then((snap) {
        perParcelDeliveryAmount = snap.data()!["amount"].toString();
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: FutureBuilder<String>(
          future: getNameFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...'); // Display "Loading..." while data is loading.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs.
            } else {
              return Text("Welcome ${snapshot.data}" ?? 'Name not found',style:TextStyle(fontSize: 20,letterSpacing: 1),); // Display the retrieved name or a default message.
            }
          },
        ),
        centerTitle: true,
        flexibleSpace:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.black,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ),
        ),
      ),

      body: Center(
        child:FutureBuilder(
          future: getDataFromSharedPreferences(),
          builder:(context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if( snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }else{
              return Container(
                padding: EdgeInsets.symmetric(vertical: 50,horizontal: 1),
                child:GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(2),
                  children: [
                    makeDashboardItem("New Avaliable Orders", Icons.assignment, 0),
                    makeDashboardItem("Parcels in progress", Icons.airport_shuttle, 1),
                    makeDashboardItem("Not yet delivered", Icons.location_history, 2),
                    makeDashboardItem("History", Icons.done_all, 3),
                    makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
                    makeDashboardItem("Logout", Icons.logout, 5)
                  ],
                  ),
              );
            }
          },
          )
        ),
    );
  }
}