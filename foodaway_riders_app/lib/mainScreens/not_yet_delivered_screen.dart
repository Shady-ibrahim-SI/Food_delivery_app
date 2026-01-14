import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/assistantMethds/assistant_methods.dart';
import 'package:foodaway_riders_app/widgets/order_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotYetDeliveredScreen extends StatefulWidget {
  const NotYetDeliveredScreen({super.key});

  @override
  State<NotYetDeliveredScreen> createState() => _NotYetDeliveredScreenState();
}

class _NotYetDeliveredScreenState extends State<NotYetDeliveredScreen> {
    Future<String?> getUid() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("Uid");
}
Future<List<String>> separateOrderItemIDs(dynamic orderIDs)async{

  List<String> separateItemIDsList =[] , defaultItemList=[];
  
  int i=0;
  
  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++){

    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0,pos) : item; // 56557657:7

    print("\n this is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);

  }

  print("\n this is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("To be Delivered"),
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
        ),),
        body: FutureBuilder(
          future:getUid(),
          builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error retrieving UID or UID not found.'));
          }
            final uid = snapshot.data!;
            return StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance
              .collection("orders").where("riderUID",isEqualTo:uid)
              .where("status" , isEqualTo: "delivering").snapshots(), 
              builder: (context, orderSnapshot) {
                if (!orderSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                return ListView.builder(
                  itemCount: orderSnapshot.data!.docs.length,
                  itemBuilder:(context, index) {
                      var orderData = orderSnapshot.data!.docs[index];
                      var productIDs = orderData.get('productIDs');
        
                      return FutureBuilder<List<String>>(
                         future: separateOrderItemIDs(productIDs),
                         builder:(context, itemIDsSnapshot) {
                           if (!itemIDsSnapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          var itemIDs = itemIDsSnapshot.data!;
                          return FutureBuilder<QuerySnapshot>(
                        future:FirebaseFirestore.instance.collection("items")
                        .where("itemID", whereIn: itemIDs)
                        .orderBy("publishedDate",descending: true).get(), 
                        builder:(context, itemsSnapshot) {
                          if (!itemsSnapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                              }
                              var quantities = separateOrderItemQuantities(productIDs);
                          return OrderCard(
                            itemCount: itemsSnapshot.data!.docs.length,
                            data: itemsSnapshot.data!.docs,
                            orderID: orderData.id,
                            seperateQuantitiesList: separateOrderItemQuantities((orderSnapshot.data!.docs[index].data()! as Map<String , dynamic> )["productIDs"]),
                          );
                        },
                        );
                         }, 
                         
                         );
                  }, 
                  );
              }, 
              );
          },
        
        )
      ),
    );
  }
}