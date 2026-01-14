
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/assistantMethds/get_current_address.dart';
import 'package:foodaway_riders_app/global/global.dart';
import 'package:foodaway_riders_app/mainScreens/rider_home_screen.dart';
import 'package:foodaway_riders_app/maps/map_utils.dart';
import 'package:foodaway_riders_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParcelDeliveringScreen extends StatefulWidget {

  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;

   ParcelDeliveringScreen({
    super.key,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId
    });

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}
class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {

 String orderTotalAmount="";
 
 confrimParcelHasBeenDelivered(getOrderId,sellerId,purchaserId,purchaserAddress,purchaserLat,purchaserLng){

    String RiderNewTotalEarningAmount = ((double.parse(previousRiderEarnings) +double.parse(perParcelDeliveryAmount))).toString();

    FirebaseFirestore.instance.collection("orders").doc(getOrderId)
    .update({
      "status":"ended",
      "address":completeAddress,
      "lat":position!.latitude,
      "lng":position!.longitude,
      "earnings":perParcelDeliveryAmount, // pay for delivery
    }).then((value) async{
      SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
      FirebaseFirestore.instance.collection("riders").doc(sharedPreferences.getString("Uid")).update({
        "earnings":RiderNewTotalEarningAmount, // total earnings for a rider
      });

    }).then((value) {
        FirebaseFirestore.instance.collection("sellers").doc(widget.sellerId).update({
          "earnings":(double.parse(orderTotalAmount) + double.parse(previousEarnings)).toString(), // total earnings for a sellers
        });

    }).then((value) async{
      SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
      FirebaseFirestore.instance.collection("users").doc(purchaserId).collection("orders").doc(getOrderId).update({
        "status":"ended",
        "riderUID":sharedPreferences.getString("Uid"),
      });
    });
    Navigator.push(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
  }
  getOrderTotalAmount(){
    FirebaseFirestore.instance.collection("orders").doc(widget.getOrderId).get().then((snap) {
     orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value){
      getSellerData();
    });
  }
  getSellerData(){
    FirebaseFirestore.instance.collection("sellers").doc(widget.sellerId).get().then((snap) {
      previousEarnings = snap.data()!["earnings"].toString();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // rider location update
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getOrderTotalAmount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Image.asset("assets/images/confirm2.png"),
            GestureDetector(
              onTap: () {
                // show location from rider current location towards seller location
                MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, widget.purchaserLat, widget.purchaserLng);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/restaurant.png",width: 50,),
                  SizedBox(width: 7,),
                  Column(
                    children: [
                      SizedBox(height: 12,),
                      Text("Show Delivery Drop-off Location",style: TextStyle(fontSize: 18,letterSpacing: 2),)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // rider location update
                      UserLocation uLocation = UserLocation();
                      uLocation.getCurrentLocation();

                      confrimParcelHasBeenDelivered(
                        widget.getOrderId, 
                        widget.sellerId, 
                        widget.purchaserId, 
                        widget.purchaserAddress, 
                        widget.purchaserLat, 
                        widget.purchaserLng);
                    },
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
                      width: MediaQuery.of(context).size.width -90,
                      height: 50,
                      child: Center(
                        child: Text('Order has been Delivered-Confirm',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  ElevatedButton(onPressed:() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
                  }, child: Text("Go back home",style: TextStyle(fontSize: 18),),
                  style:ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 100,right: 100)),
                    backgroundColor:MaterialStatePropertyAll(Colors.green) 
                  ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );;
  }
}