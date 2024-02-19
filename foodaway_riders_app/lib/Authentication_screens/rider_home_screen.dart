import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/Authentication_screens/login_screen.dart';
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
              return Text(snapshot.data ?? 'Name not found'); // Display the retrieved name or a default message.
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height:16,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        CustomRichtText(identifier:'Rider Name', value: '$riderName',),
                        CustomRichtText(identifier:'Rider Email', value: '$riderEmail'),
                        CustomRichtText(identifier:'Rider Address', value: '$riderAddress')
                        ],
                        ),
                    ],
                    ),
                  SizedBox(height: 32,),
                  Text('Rider Photo:',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                  SizedBox(height: 32,),
                  Container(
                    width: 400.0,
                    height: 400.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image:NetworkImage(riderPhotoUrl!),fit: BoxFit.cover,)
                    ),
                    ),
                  SizedBox(height: 64,),
                  ElevatedButton(onPressed:() {
                  userSignOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login(),));
                  },style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0xff53E88B),
                    minimumSize: const Size(220, 57),
                    maximumSize: const Size(220, 57),
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                  ), 
                  child: Text('Log out',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold
                  )
                  )
                  )
                ],
              );
            }
          },
          )
        ),
    );
  }
}