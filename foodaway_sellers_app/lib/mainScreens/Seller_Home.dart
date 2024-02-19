import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/Authentication_screens/Login.dart';
import 'package:foodaway_sellers_app/Model/menus_model.dart';
import 'package:foodaway_sellers_app/UploadScreens/menus_upload_screen.dart';
import 'package:foodaway_sellers_app/widgets/custom_drawer.dart';
import 'package:foodaway_sellers_app/widgets/custom_richt_text.dart';
import 'package:foodaway_sellers_app/widgets/food_info_design.dart';
import 'package:foodaway_sellers_app/widgets/header_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerHome extends StatefulWidget {
  const SellerHome({super.key});

  @override
  State<SellerHome> createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  String? testName;
  String? sellerFirstName;
  String? sellerLastName;
  String? sellerPhotoUrl;
  String? sellerEmail;
  String? sellerAddress;
  String? sellerUid;
  Future<String> getNameFromSharedPreferences() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString('name') ?? 'Name not found';
    }

    Future<void> getDataFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    testName = sharedPreferences.getString('name') ?? 'Name not found';
    // sellerFirstName = sharedPreferences.getString('firstName') ?? 'Name not found';
    // sellerLastName = sharedPreferences.getString('lastName') ?? 'Name not found';
    sellerPhotoUrl = sharedPreferences.getString('photoUrl') ?? 'photoUrl not found';
    sellerEmail = sharedPreferences.getString('email') ?? 'Email not found';
    sellerAddress = sharedPreferences.getString('address') ?? 'Address not found';
    sellerUid = sharedPreferences.getString('Uid') ?? 'Address not found';
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
        actions: [
          IconButton(onPressed:() {
            Navigator.push(context, MaterialPageRoute(builder:(context) => MenusUpload(),));
          }, icon: Icon(Icons.post_add))
        ],
      ),
      drawer: CustomDrawer(),
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
              return CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      delegate: HeaderText(headerText: 'My Menu'),
                      pinned: true,
                      ),
                    StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("sellers")
                    .doc(sellerUid).collection("menus").orderBy("publishedDate",descending: true).snapshots(),

                    builder:(context, snapshot) {
                      return !snapshot.hasData ? SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()),)
                       : SliverGrid(
                        delegate:SliverChildBuilderDelegate(
                          (context, index) {
                          Menus sModel = Menus.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String,dynamic>
                          );
                          return FoodDisplay(model: sModel,context: context,);
                        },
                        childCount: snapshot.data!.docs.length
                        ) , 
                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Number of columns
                        crossAxisSpacing: 10.0, // Spacing between columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        childAspectRatio: 1.33, // Aspect ratio of grid items
                        )
                      );
                    },
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