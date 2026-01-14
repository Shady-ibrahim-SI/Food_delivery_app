import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_users_app/assistantMethods/assistant_methods.dart';
import 'package:foodaway_users_app/global/global.dart';
import 'package:foodaway_users_app/mainScreens/user_home_screen.dart';
import 'package:foodaway_users_app/screens/splash_screen.dart';
import 'package:foodaway_users_app/tests/open_gallery_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

   PlacedOrderScreen({
    super.key,
    this.addressID,
    this.totalAmount,
    this.sellerUID
    });

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {

  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails()async{
    
        SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
        
        writeOrderDetailsForUser({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences.getString("uid"),
        "productIDs": sharedPreferences.getStringList("userCart"),
        "paymentDetails" : "Cash on Delivery",
        "orderTime": orderId,
        "isSuccess": true,
        "sellerUID": widget.sellerUID,
        "riderUID": "",
        "status":"normal",
        "orderId": orderId, 
      });

      writeOrderDetailsForSeller({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences.getString("uid"),
        "productIDs": sharedPreferences.getStringList("userCart"),
        "paymentDetails" : "Cash on Delivery",
        "orderTime": orderId,
        "isSuccess": true,
        "sellerUID": widget.sellerUID,
        "riderUID": "",
        "status":"normal",
        "orderId": orderId,
      }).whenComplete(() {
        clearCartNow(context);
        setState(() {
          orderId="";
          Navigator.push(context, MaterialPageRoute(builder:(context) => UserHome(),));
          Fluttertoast.showToast(msg: "Congratulations, Order has been placed successfully");
        });
      });
  }

  Future writeOrderDetailsForUser( Map<String, dynamic> data) async{
    
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    
    await FirebaseFirestore.instance.collection("users").doc(sharedPreferences.getString("uid"))
    .collection("orders").doc(orderId).set(data);



  }

  Future writeOrderDetailsForSeller( Map<String, dynamic> data) async{
    
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    
    await FirebaseFirestore.instance.collection("orders").doc(orderId).set(data);

      

  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [

                Image.asset('assets/images/delivery.jpg'),
                SizedBox(height: 10,),
                ElevatedButton(onPressed:() {
                  addOrderDetails();
                }, child:Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                ),
                ),
                SizedBox(height: 12,),
                ElevatedButton(onPressed:() {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
                }, child:Text("Home"),
                 style:ElevatedButton.styleFrom(primary: Colors.green) ,
                )
            ],
          ),
      ),
    );
  }
}