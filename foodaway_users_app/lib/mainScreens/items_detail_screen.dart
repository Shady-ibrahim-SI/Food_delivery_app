import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_users_app/assistantMethods/assistant_methods.dart';
import 'package:foodaway_users_app/assistantMethods/cart_item_counter.dart';
import 'package:foodaway_users_app/mainScreens/cart_screen.dart';
import 'package:foodaway_users_app/models/items.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
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
        actions: [
          Stack(
            children: [
              IconButton(onPressed:() {
                
           Navigator.push(context, MaterialPageRoute(builder:(context) => CartScreen(sellerUID: widget.model!.sellerUID),));
          }, icon: Icon(Icons.shopping_cart)),
          Positioned(child: Stack(
            children: [
              Icon(Icons.brightness_1,size: 25.0,color: Colors.blue,),
              Positioned(top: 1,right:6, child: Center(
                child:Consumer<CartItemCounter>(builder:(context, counter, child) {
                  int x = counter.count!-1;
                    return Text((x-1).toString(),style: TextStyle(color: Colors.white,fontSize: 20));
                },)
                ),
                )
            ],
          )
          )
            ],
          )
        ],
        leading: IconButton(onPressed:() {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
            child: NumberInputPrefabbed.roundedButtons(
              controller:counterController,
              incDecBgColor: Colors.red,
              min: 1,
              max: 10,
              initialValue: 1,
              buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
          ),
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
                int itemCounter = int.parse(counterController.text);
                List<dynamic> separateItemIDsList =await separateItemIDs();
                // check if item already exist in the cart
                separateItemIDsList.contains(widget.model!.itemID) ? Fluttertoast.showToast(msg: "Item is already in cart."): 
                // add to cart
                adddToCart(widget.model!.itemID,context,itemCounter);
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
                child: Text('Add to Cart',style: TextStyle(color: Colors.white,fontSize: 16),),
              ),
              ),
            ),
          )
        ],
      ),
    );
  }
}