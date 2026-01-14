import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/Model/address.dart';
import 'package:foodaway_sellers_app/widgets/shipment_address_design.dart';
import 'package:foodaway_sellers_app/widgets/status_banner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {

  final String? orderID;
  const OrderDetailsScreen({
    super.key,
    this.orderID
    });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  String? userUid;
 Future<void> getUid() async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // sellerUid = sharedPreferences.getString('Uid') ?? 'Address not found';
  userUid = sharedPreferences.getString("uid") ?? 'User ID not found';
}
  
  String orderStatus='';
  String orderByUser='';
  String sellerId="";

  getOrderInfo(){
    FirebaseFirestore.instance.collection("orders").doc(widget.orderID).get().then((DocumentSnapshot) {
        orderStatus = DocumentSnapshot.data()!["status"].toString();
        orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
        sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future:getUid(), 
          builder:(context, snapshot) {
            return FutureBuilder<DocumentSnapshot>(
              future:FirebaseFirestore.instance.collection("orders").doc(widget.orderID).get(), 
              builder:(context, snapshot) {
                
                Map? dataMap;
                if(snapshot.hasData){
                  dataMap = snapshot.data!.data()! as Map<String,dynamic>;
                  orderStatus = dataMap["status"].toString();
                }
                return snapshot.hasData ?
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      // StatusBanner(
                      //   status: dataMap!["isSuccess"],
                      //   orderStatus: orderStatus,
                      // ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Total Amount: £ '+dataMap!["totalAmount"].toString()
                          ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Order Id = '+widget.orderID!
                        ,style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text('Order at: ' + DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))),
                      ),
                      Divider(thickness: 4,),
                      orderStatus != "ended" ? Image.asset('assets/images/0_t7bicDeMIXHrfM3F.jpg') : Image.asset('assets/images/7819400_3771400.jpg'),
                      Divider(thickness: 4,),
                      FutureBuilder<DocumentSnapshot>(
                        future:FirebaseFirestore.instance.collection("users")
                        .doc(orderByUser).collection("userAddress").doc(dataMap["addressID"]).get(), 
                        builder:(context, snapshot) {
                          
                          return snapshot.hasData ? ShipmentAddressDesign(
                            model: Address.fromJson(snapshot.data!.data()! as Map<String,dynamic>),
                            orderStatus: orderStatus,
                            orderId: widget.orderID,
                            sellerId: sellerId,
                            orderByUser: orderByUser
                          ) : Center(child: CircularProgressIndicator(),);
                        },
                        )
                    ],
                  ),
                ) : Center(child: CircularProgressIndicator(),);
              },
              );
          },
          ),
      ),
    );
  }
}