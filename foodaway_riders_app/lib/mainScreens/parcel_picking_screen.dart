import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/assistantMethds/get_current_address.dart';
import 'package:foodaway_riders_app/global/global.dart';
import 'package:foodaway_riders_app/mainScreens/parcel_delivering_screen.dart';
import 'package:foodaway_riders_app/maps/map_utils.dart';
import 'package:foodaway_riders_app/screens/splash_screen.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;
  String? purchaserLat;
  String? purchaserLng;
   ParcelPickingScreen({
    super.key,
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng
    });

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  
  double? sellerLat, sellerLng;

  getSellerData()async{
    FirebaseFirestore.instance.collection("sellers").doc(widget.sellerId).get().then((DocumentSnapshot) {
      
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }
  confrimParcelHasBeenPicked(getOrderId,sellerId,purchaserId,purchaserAddress,purchaserLat,purchaserLng){
    FirebaseFirestore.instance.collection("orders").doc(getOrderId)
    .update({
      "status":"delivering",
      "address":completeAddress,
      "lat":position!.latitude,
      "lng":position!.longitude
    });
    Navigator.push(context,MaterialPageRoute(builder:(context) => ParcelDeliveringScreen(
        purchaserId: purchaserId,
        purchaserAddress: purchaserAddress,
        purchaserLat:  double.parse(purchaserLat),
        purchaserLng: double.parse(purchaserLng),
        sellerId: sellerId,
        getOrderId:getOrderId
    ),));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Image.asset("assets/images/confirm1.png"),
            GestureDetector(
              onTap: () {
                // show location from rider current location towards seller location
                MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, sellerLat!, sellerLng!);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/restaurant.png",width: 50,),
                  SizedBox(width: 7,),
                  Column(
                    children: [
                      SizedBox(height: 12,),
                      Text("Show cafe/Restaurant Location",style: TextStyle(fontSize: 18,letterSpacing: 2),)
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
                      // confirm-that rider has picked parcel from seller
                      UserLocation uLocation = UserLocation();
                      uLocation.getCurrentLocation();

                      confrimParcelHasBeenPicked(
                        widget.getOrderID, 
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
                        child: Text('Order has been picked-Confirmed',style: TextStyle(color: Colors.white,fontSize: 15),),
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  ElevatedButton(onPressed:() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
                  }, child: Text("Go back",style: TextStyle(fontSize: 18),),
                  style:ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 128,right: 128)),
                    backgroundColor:MaterialStatePropertyAll(Colors.green) 
                  ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}