import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_users_app/assistantMethods/assistant_methods.dart';
import 'package:foodaway_users_app/models/menus_model.dart';
import 'package:foodaway_users_app/models/seller_model.dart';
import 'package:foodaway_users_app/screens/splash_screen.dart';
import 'package:foodaway_users_app/widgets/custom_drawer.dart';
import 'package:foodaway_users_app/widgets/menus_design.dart';
import 'package:foodaway_users_app/widgets/sellers_design.dart';
import 'package:foodaway_users_app/widgets/header_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key,required this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
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
        leading: IconButton(onPressed:() {
          clearCartNow(context);
          Navigator.push(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
          // Fluttertoast.showToast(msg: "cart has been cleared");
        }, icon: Icon(Icons.arrow_back_ios)),
        title: FutureBuilder<String>(
          future: getNameFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...'); // Display "Loading..." while data is loading.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs.
            } else {
              return Text('Food Away'); // Display the retrieved name or a default message.
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
      ),
      // drawer: CustomDrawer(),
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
                      delegate: HeaderText(headerText: widget.model!.sellerName.toString()+' Menus'),
                      pinned: true,
                      ),
                    StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("sellers")
                    .doc(widget.model!.sellerUID).collection("menus").orderBy("publishedDate",descending: true).snapshots(),

                    builder:(context, snapshot) {
                      return !snapshot.hasData ? SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()),)
                       : SliverGrid(
                        delegate:SliverChildBuilderDelegate(
                          (context, index) {
                          Menus sModel = Menus.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String,dynamic>
                          );
                          return MenusFoodDisplay(model: sModel,context: context,);
                        },
                        childCount: snapshot.data!.docs.length
                        ) , 
                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10.0, // Spacing between columns
                        mainAxisSpacing: 1.0, // Spacing between rows
                        childAspectRatio: 0.9, // Aspect ratio of grid items
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