import 'package:flutter/material.dart';
import 'package:foodaway_users_app/mainScreens/menus_screen.dart';
import 'package:foodaway_users_app/models/seller_model.dart';

class SellersFoodDisplay extends StatefulWidget {
  Sellers? model;
  BuildContext? context;
   SellersFoodDisplay({super.key,this.model,this.context});

  @override
  State<SellersFoodDisplay> createState() => _SellersFoodDisplayState();
}

class _SellersFoodDisplayState extends State<SellersFoodDisplay> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => MenusScreen(model: widget.model,),));
      },
      splashColor: Colors.amber,
      child: Padding(
          padding:EdgeInsets.all(1.0),
          child: Container(
            height: 265,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Divider(
                //   height: 4,
                //   thickness: 3,
                //   color: Colors.grey[300],
                // ),
                Image.network(
                  widget.model!.sellerAvataUrl!,
                  fit: BoxFit.fill,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    widget.model!.sellerName!,
                    style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
                    )
              ],
            ),
          ), 
        ),
    );
  }
}