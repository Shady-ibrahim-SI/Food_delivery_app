import 'package:flutter/material.dart';
import 'package:foodaway_users_app/mainScreens/user_home_screen.dart';
import 'package:foodaway_users_app/models/address.dart';
import 'package:foodaway_users_app/screens/splash_screen.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  const ShipmentAddressDesign({
    super.key,
    this.model
    });

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
          )
      ],
    );
  }
}