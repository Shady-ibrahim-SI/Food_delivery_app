import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_users_app/mainScreens/address_screen.dart';
import 'package:foodaway_users_app/mainScreens/history_screen.dart';
import 'package:foodaway_users_app/mainScreens/my_orders_screen.dart';
import 'package:foodaway_users_app/mainScreens/search_screen.dart';
import 'package:foodaway_users_app/mainScreens/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication_screens/login_screen.dart';

class CustomDrawer extends StatelessWidget {
   CustomDrawer({super.key});
  String? userPhotoUrl;
  String? userName;
  Future<void> getDataFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString('name') ?? 'Name not found';
    userPhotoUrl = sharedPreferences.getString('photoUrl') ?? 'photoUrl not found';
    // You can set other properties in a similar manner.
  }
  void userSignOut() {
    FirebaseAuth firebaseAuth =FirebaseAuth.instance;
    firebaseAuth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      child: FutureBuilder(
        future: getDataFromSharedPreferences(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if( snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }else{
           return  ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(80)),
                    elevation: 10,
                    child: Padding(
                      padding:EdgeInsets.all(1.0),
                      child: Container(
                        height: 160,
                        width: 160,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userPhotoUrl!),
                        ),
                      ),
                      ),
                  ),
                  SizedBox(height: 16,),
                  Text(userName!,style: TextStyle(color: Colors.black,fontSize: 20),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.home,color: Colors.black,),
                    title: Text('Home',style: TextStyle(color: Colors.black),),
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => UserHome(),));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.reorder,color: Colors.black,),
                    title: Text('My orders',style: TextStyle(color: Colors.black),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => MyOrdersScreen(),));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time,color: Colors.black,),
                    title: Text('History',style: TextStyle(color: Colors.black),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => HistoryScreen(),));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.search,color: Colors.black,),
                    title: Text('Search',style: TextStyle(color: Colors.black),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => SearchScreen(),));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_location,color: Colors.black,),
                    title: Text('Add New Address',style: TextStyle(color: Colors.black),),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => AddressScreen(),));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app,color: Colors.black,),
                    title: Text('Sign Out',style: TextStyle(color: Colors.black),),
                    onTap: () {
                      userSignOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login(),));
                    },
                  )
                ],
              ),
            )
          ],
        );
        
       }
        },

      ),
    );
  }
}