import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_users_app/models/seller_model.dart';
import 'package:foodaway_users_app/widgets/sellers_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Future<QuerySnapshot>? restaurantDocumentsList;
  String sellerNameText="";
  initSearchingRestaurant(String textEntered){
    restaurantDocumentsList = FirebaseFirestore.instance.collection("sellers")
    .where("sellerName",isGreaterThanOrEqualTo: textEntered).get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: TextField(
          onChanged: (textEntered) {
            // Start search
            setState(() {
              sellerNameText = textEntered;
            });
            initSearchingRestaurant(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Restaurant here...",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: IconButton(onPressed:() {
              initSearchingRestaurant(sellerNameText);
            }, 
            icon: Icon(Icons.search),
            color: Colors.white,
            )
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future:restaurantDocumentsList, 
        builder:(context, snapshot) {
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder:(context, index) {
              Sellers model = Sellers.fromJson(snapshot.data!.docs[index].data()! as Map<String,dynamic>);
              return SellersFoodDisplay(
                model: model,
                context: context,
              );
            },
            ) : Center(child: Text("No Record Found"),);  
        },
        ),
    );
  }
}