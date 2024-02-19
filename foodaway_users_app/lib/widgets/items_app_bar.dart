import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsAppbar extends StatelessWidget {

   Future<String> getNameFromSharedPreferences() async {
      final sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString('name') ?? 'Name not found';
    }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
           // Navigator.push(context, MaterialPageRoute(builder:(context) => MenusUpload(),));
          }, icon: Icon(Icons.shopping_cart)),
          Positioned(child: Stack(
            children: [
              Icon(Icons.brightness_1,size: 20.0,color: Colors.blue,),
              Positioned(top: 3,right:6, child: Center(child: Text("0",style: TextStyle(color: Colors.white,fontSize: 12),),),)
            ],
          )
          )
            ],
          )
        ],
        leading: IconButton(onPressed:() {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
      );
  }
}