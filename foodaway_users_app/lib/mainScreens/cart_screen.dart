import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_users_app/assistantMethods/assistant_methods.dart';
import 'package:foodaway_users_app/assistantMethods/cart_item_counter.dart';
import 'package:foodaway_users_app/assistantMethods/total_amount.dart';
import 'package:foodaway_users_app/mainScreens/address_screen.dart';
import 'package:foodaway_users_app/models/items.dart';
import 'package:foodaway_users_app/screens/splash_screen.dart';
import 'package:foodaway_users_app/widgets/cart_item_design.dart';
import 'package:foodaway_users_app/widgets/header_text.dart';
import 'package:foodaway_users_app/widgets/items_design.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<List<int>>? separateItemQuantityListFuture;
  num totalAmount = 0;


  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context,listen: false).displayTotalAmount(0);
    separateItemQuantityListFuture = separateItemQuantities();
  }

  
  Future<List<int>> separateItemQuantities()async{
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
  
  List<int> separateItemQuantityList =[];
  List<String> defaultItemList=[];
  
  int i=1;
  
  defaultItemList = sharedPreferences.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++){

    String item = defaultItemList[i].toString();
     // 56557657:7
    List<String> listItemCharacters = item.split(":").toList();
    
    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print("\n this is Quantity Number = " + quantityNumber.toString());

    separateItemQuantityList.add(quantityNumber);

  }

  print("\n this is Quantity List now = ");
  // print(defaultItemList);
  print(separateItemQuantityList);

  return separateItemQuantityList;
}
String? testName;
  String? sellerFirstName;
  String? sellerLastName;
  String? sellerPhotoUrl;
  String? sellerEmail;
  String? sellerAddress;
  String? sellerUid;
  Future<String> getNameFromSharedPreferences() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString('name') ?? 'Name not found';
    }

    Future<void> getDataFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    testName = sharedPreferences.getString('name') ?? 'Name not found';
    // sellerFirstName = sharedPreferences.getString('firstName') ?? 'Name not found';
    // sellerLastName = sharedPreferences.getString('lastName') ?? 'Name not found';
    sellerPhotoUrl = sharedPreferences.getString('photoUrl') ?? 'photoUrl not found';
    sellerEmail = sharedPreferences.getString('email') ?? 'Email not found';
    sellerAddress = sharedPreferences.getString('address') ?? 'Address not found';
    sellerUid = sharedPreferences.getString('Uid') ?? 'Address not found';
    // You can set other properties in a similar manner.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
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
                
           Navigator.push(context, MaterialPageRoute(builder:(context) => CartScreen(sellerUID: widget.sellerUID),));
          }, icon: Icon(Icons.shopping_cart)),
          Positioned(child: Stack(
            children: [
              Icon(Icons.brightness_1,size: 25.0,color: Colors.blue,),
              Positioned(top: 1,right:6, child: Center(
                child:Consumer<CartItemCounter>(builder:(context, counter, child) {
                  int x = counter.count!-1;
                    return Text(x.toString(),style: TextStyle(color: Colors.white,fontSize: 20));
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 4,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
            backgroundColor: Colors.cyan,
            icon: Icon(Icons.clear_all),  
            onPressed:() {
              clearCartNow(context);
              Navigator.push(context, MaterialPageRoute(builder:(context) => SplashScreen(),));
              Fluttertoast.showToast(msg: "cart has been cleared");
            },
            heroTag: "btn1",
             label:Text('Clear Cart')),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
            backgroundColor: Colors.cyan,
            icon: Icon(Icons.navigate_next),  
            onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder:(context) => AddressScreen(
                totalAmount: totalAmount.toDouble(),
                sellerUID: widget.sellerUID,
              ),));
            },
            heroTag: "btn2",
             label:Text('Check Out')),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: separateItemIDs(), // This is your asynchronous function to get item IDs
          builder: (BuildContext context, AsyncSnapshot<List<String>> futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading spinner while waiting
            } else if (futureSnapshot.hasError) {
              return Text('Error: ${futureSnapshot.error}'); // Display errors, if any
            } else {
              // Once the item IDs data is available, proceed to build another FutureBuilder for item quantities
              return FutureBuilder<List<int>>(
                future: separateItemQuantityListFuture, // This is the future for item quantities
                builder: (context, quantitySnapshot) {
                  if (!quantitySnapshot.hasData) {
                    return CircularProgressIndicator(); // Show loading spinner while waiting for quantities
                  } else {
                    // Both item IDs and quantities are now loaded, proceed to build the UI
                    return buildCustomScrollView(quantitySnapshot.data!, futureSnapshot.data!);
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildCustomScrollView(List<int> itemQuantities, List<String> itemIds) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: HeaderText(headerText: 'My Cart List'),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Consumer2<TotalAmount,CartItemCounter>(builder: (context, anountProvider, cartProvider, c) {
            return Padding(
              padding: EdgeInsets.all(0),
              child: Center(
                child: cartProvider.count == 0 ? 
                SliverFillRemaining(child: Center(child: Text("No items found"))) 
                : Text('Total Price: ' + anountProvider.tAmount.toString()
                ,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),
                ),
              ), 
              );
          },),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("items")
              .where("itemID", whereIn: itemIds.isNotEmpty ? itemIds : ["dummyID"]) // Prevent querying with an empty list
              .orderBy("publishedDate", descending: true)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            } else if (streamSnapshot.data!.docs.isEmpty) {
              return SliverFillRemaining(child: Center(child: Text("No items found")));
            } else {
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.35,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Items model = Items.fromJson(
                      streamSnapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );
                    int quantityNumber = index < itemQuantities.length ? itemQuantities[index] : 0;
                    
                    if(index == 0){
                      totalAmount=0;
                      totalAmount= totalAmount + (model.price! * quantityNumber);
                    }else{
                      totalAmount = totalAmount + (model.price! * quantityNumber);
                    }

                    if(streamSnapshot.data!.docs.length-1 == index){
                      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { 
                        Provider.of<TotalAmount>(context,listen: false).displayTotalAmount(totalAmount.toDouble());
                      });
                    }

                    return CartItemDesign(
                      model: model,
                      context: context,
                      quantityNumber: quantityNumber,
                    );
                  },
                  childCount: streamSnapshot.data!.docs.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}