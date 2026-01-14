import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/assistantMethds/get_current_address.dart';
import 'package:foodaway_riders_app/global/global.dart';
import 'package:foodaway_riders_app/mainScreens/parcel_picking_screen.dart';
import 'package:foodaway_riders_app/models/address.dart';
import 'package:foodaway_riders_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;
  const ShipmentAddressDesign({
    super.key,
    this.model,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByUser
    });

    confirmedParcelShippment(BuildContext context , String getOrderID , String sellerId , String purchaserId)async{
      SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
      FirebaseFirestore.instance.collection("orders")
      .doc(getOrderID).update({
        "riderUID":sharedPreferences.getString("Uid"),
        "riderName":sharedPreferences.getString("name"),
        "status":"picking",
        "lat":position!.latitude,
        "lng":position!.longitude,
        "address":completeAddress
      });
      // send rider to shipment screen
      Navigator.push(context, MaterialPageRoute(builder:(context) => ParcelPickingScreen(
        purchaserId: purchaserId,
        purchaserAddress: model!.fullAddress,
        purchaserLat: model!.lat,
        purchaserLng:model!.lng,
        sellerId: sellerId,
        getOrderID:getOrderID
      ),));
    }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Shipping Details'
              ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 90,vertical: 5),
            width: MediaQuery.of(context).size.width,
            child: Table(
              children: [
                TableRow(
                  children:[
                    Text("Name",style: TextStyle(color: Colors.black),),
                    Text(model!.name!),
                  ]
                ),
                TableRow(
                  children:[
                    Text("Phone Number",style: TextStyle(color: Colors.black),),
                    Text(model!.phoneNumber!),
                  ]
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(model!.fullAddress! ,textAlign:TextAlign.justify,),
          ),
          orderStatus == "ended" ?
          Container() : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();
                  confirmedParcelShippment(context, orderId!, sellerId!, orderByUser!);
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
                  width: MediaQuery.of(context).size.width -40,
                  height: 50,
                  child: Center(
                    child: Text('Confirm - To Deliver this Parcel',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
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
                  width: MediaQuery.of(context).size.width -40,
                  height: 50,
                  child: Center(
                    child: Text('Go back',style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
      ],
    );
  }
}