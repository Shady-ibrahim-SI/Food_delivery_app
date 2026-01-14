import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_sellers_app/Model/items.dart';
import 'package:foodaway_sellers_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen({super.key,required this.model});
    
  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  Future<String> getNameFromSharedPreferences() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString('name') ?? 'Name not found';
    }
    TextEditingController counterController = TextEditingController();

    deleteItem(String itemID)async{
      final sharedPreferences = await SharedPreferences.getInstance();
      FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences.getString("Uid")).collection("menus")
      .doc(widget.model!.menUID!).collection("items").doc(itemID).delete().then((value) {
        FirebaseFirestore.instance.collection("items").doc(itemID).delete();
        Navigator.push(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
        Fluttertoast.showToast(msg: "Item Deleted Successfully");
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getNameFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...'); // Display "Loading..." while data is loading.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs.
            } else {
              return Text('Food Away'); // Display the retrieved name or a default message.
            }
          },
        ),
        centerTitle: true,
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
        leading: IconButton(onPressed:() {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
         
          Padding(
            padding: const EdgeInsets.only(left: 42,top: 8),
            child: Text(
              widget.model!.title.toString(),
              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42,top: 8),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42,top: 8),
            child: Text(
             'E£ ' +widget.model!.price.toString(),
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.red),
            ),
          ),
          SizedBox(height: 100,),
          Center(
            child: InkWell(
              onTap: () async{
                // delete item
                deleteItem(widget.model!.itemID!);
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
              width: MediaQuery.of(context).size.width-40,
              height: 50,
              child: Center(
                child: Text('Delete this Item',style: TextStyle(color: Colors.white,fontSize: 16),),
              ),
              ),
            ),
          )
        ],
      ),
    );
  }
}