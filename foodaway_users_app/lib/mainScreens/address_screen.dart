import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_users_app/assistantMethods/address_changer.dart';
import 'package:foodaway_users_app/global/global.dart';
import 'package:foodaway_users_app/mainScreens/save_address_screen.dart';
import 'package:foodaway_users_app/models/address.dart';
import 'package:foodaway_users_app/widgets/address_design.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerUID;
  const AddressScreen({super.key,this.totalAmount,this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Future<String?> getUid() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("uid");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Away',style: TextStyle(fontSize: 25,letterSpacing: 1 , color: Colors.white),),
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
      floatingActionButton: FloatingActionButton.extended
      (onPressed:() {
        // save address to user collection
        Navigator.push(context, MaterialPageRoute(builder:(context) => SaveAddressScreen(),));
      }, label: Text('Add New Address'),
      backgroundColor: Colors.cyan,
      icon: Icon(Icons.add_location),
      ),
      body: FutureBuilder(
        future:getUid(),
         builder:(context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text('Error retrieving UID or UID not found.'));
        }

          final uid = snapshot.data!;

          return Column(
           crossAxisAlignment:CrossAxisAlignment.center,
           mainAxisSize:MainAxisSize.min,
           children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Select Address:',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),), 
                ),
            ),
            Consumer<AddressChanger>(builder:(context, address, c) {
              
              return Flexible(
                child: StreamBuilder(
                  stream:FirebaseFirestore.instance.collection("users").doc(uid)
                  .collection("userAddress").snapshots(), 
                  builder:(context, snapshot) {
                    return !snapshot.hasData ? Center(child: CircularProgressIndicator(),) : snapshot.data!.docs.length == 0 ? 
                    Container(child:Center(child: Text('Data did not arrived in save address screnn'),),) 
                    : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder:(context, index) {
                          return AddressDesign(
                            currentIndex: address.count,
                            value: index,
                            addressID: snapshot.data!.docs[index].id,
                            totalAmount: widget.totalAmount,
                            sellerUID: widget.sellerUID,
                            model: Address.fromJson(
                              snapshot.data!.docs[index].data() as Map<String, dynamic>
                            ),
                          );
                    },);
                  },
                  )
                );
            },)
           ],
        );
         },
        )
    );
  }
}