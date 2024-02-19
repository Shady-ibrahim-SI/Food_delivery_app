import 'package:flutter/material.dart';
import 'package:foodaway_users_app/mainScreens/user_home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  const StatusBanner({
    super.key,
    this.status,
    this.orderStatus
    });

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "successfull" : message ="unsuccessfull";

    return Container(
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
          height: 40,
          child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => UserHome(),));
                },
                child: Icon(Icons.arrow_back,color: Colors.white,),
              ),
              SizedBox(width: 20,),
              Text(orderStatus == "ended" ? "parcel Delivered $message" : "Order placed $message"),
              SizedBox(width: 5,),
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.grey,
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              )
            ],
          ),
    );
  }
}