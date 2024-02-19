import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodaway_users_app/assistantMethods/assistant_methods.dart';
import 'package:foodaway_users_app/models/seller_model.dart';
import 'package:foodaway_users_app/widgets/custom_drawer.dart';
import 'package:foodaway_users_app/widgets/sellers_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_richt_text.dart';
import '../Authentication_screens/login_screen.dart';

class UserHome extends StatefulWidget {
   UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String? userName;
  String? userPhotoUrl;
  String? userEmail;
  String? sellerAddress;
  Future<String> getNameFromSharedPreferences() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString('name') ?? 'Name not found';
    }
    Future<void> getDataFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString('name') ?? 'Name not found';
    userPhotoUrl = sharedPreferences.getString('photoUrl') ?? 'photoUrl not found';
    userEmail = sharedPreferences.getString('email') ?? 'Email not found';
    // You can set other properties in a similar manner.
  }
 void userSignOut() {
    FirebaseAuth firebaseAuth =FirebaseAuth.instance;
    firebaseAuth.signOut();
  }
  final items = [
      'slider/0.jpg','slider/1.jpg','slider/2.jpg','slider/3.jpg','slider/4.jpg','slider/5.jpg',
      'slider/6.jpg','slider/7.jpg','slider/8.jpg','slider/9.jpg','slider/10.jpg','slider/11.jpg',
      'slider/12.jpg','slider/13.jpg','slider/14.jpg','slider/15.jpg','slider/16.jpg','slider/17.jpg',
      'slider/18.jpg','slider/19.jpg','slider/20.jpg','slider/21.jpg','slider/22.jpg','slider/23.jpg',
      'slider/24.jpg','slider/25.jpg','slider/26.jpg','slider/27.jpg'
    ];
    @override
  void initState() {
    super.initState();
    clearCartNow(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: FutureBuilder<String>(
          future: getNameFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...'); // Display "Loading..." while data is loading.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display an error message if an error occurs.
            } else {
              return Text('Foood Away'); // Display the retrieved name or a default message.
            }
          },
        ),
        centerTitle: true,
        flexibleSpace:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.black,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ),
        ),
      ),
      drawer: CustomDrawer(),

      body: Center(
        child:FutureBuilder(
          future: getDataFromSharedPreferences(),
          builder:(context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if( snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }else{
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child:SizedBox(height: 8,)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width:  MediaQuery.of(context).size.width,
                        child: CarouselSlider(
                        items: items.map((index){
                          return Builder(
                            builder:(context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Image.asset(index,fit: BoxFit.fill,width: 300,height: 400,),
                                ),
                            );
                          },
                          );
                        } 
                        ).toList(), 
                        options:CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.2,
                          aspectRatio: 16/9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayAnimationDuration: Duration(milliseconds: 600),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        )
                        ),
                      ),
                      ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height:16),),
                  SliverToBoxAdapter(child: Divider(
                  height: 4,
                  thickness: 3,
                  color: Colors.grey[300],
                ),),
                  StreamBuilder<QuerySnapshot>(
                    stream:FirebaseFirestore.instance.collection("sellers").snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData ? SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()),)
                       : SliverGrid(
                        delegate:SliverChildBuilderDelegate(
                          (context, index) {
                          Sellers sModel = Sellers.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String,dynamic>
                          );
                          return SellersFoodDisplay(model: sModel,context: context,);
                        },
                        childCount: snapshot.data!.docs.length
                        ) , 
                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 15.0, // Spacing between columns
                        mainAxisSpacing: 30.0, // Spacing between rows
                        childAspectRatio: 0.99, // Aspect ratio of grid items
                        )
                      );
                    },
                    )
                ],
              );
            }
          },
          )
        ),
    );
  }
}