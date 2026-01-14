import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/mainScreens/order_details_screen.dart';
import 'package:foodaway_riders_app/models/items.dart';

class OrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuantitiesList;

  const OrderCard({
    super.key,
    this.itemCount,
    this.data,
    this.orderID,
    this.seperateQuantitiesList
    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context) => OrderDetailsScreen(orderID: orderID),));
      },
      child: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors:[
        //         Colors.red,
        //         Colors.black,
        //     ],
        //     begin: FractionalOffset(0.0, 0.0),
        //     end: FractionalOffset(1.0, 0.0),
        //     stops: [0.0,1.0],
        //     tileMode: TileMode.clamp
        //     )
        //   ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          height: itemCount! * 125,
          child: ListView.builder(
            itemCount: itemCount,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder:(context, index) {
              Items model = Items.fromJson(data![index].data()! as Map<String, dynamic>);
              return placeOrderDesignWidget(model, context, seperateQuantitiesList![index]);
          },),
      ),
    );
  }

  Widget placeOrderDesignWidget(Items model , BuildContext context , seperateQuantitiesList){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        color: Colors.grey[200],
        child: Row(
          children: [
            Image.network(model.thumbnailUrl!, width: 120,),
            SizedBox(width: 5.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      mainAxisSize:MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title!,style: TextStyle(color: Colors.black,fontSize: 16),)
                          ),
                          SizedBox(width: 10,),
                          Text("£ ",style: TextStyle(color: Colors.blue,fontSize: 16.0),),
                          Text(model.price.toString(),style: TextStyle(color: Colors.blue,fontSize: 18.0),)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            'x ',
                    style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          ),
                          ),
                          Expanded(
                            child: Text(seperateQuantitiesList,style: TextStyle(color: Colors.black54,fontSize: 30),) 
                            )
                      ],
                    )
                ],
              )
              )
          ],
        ),
    );
  }
}