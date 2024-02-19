import 'package:flutter/material.dart';
import 'package:foodaway_users_app/mainScreens/items_screen.dart';
import 'package:foodaway_users_app/models/menus_model.dart';
import 'package:foodaway_users_app/models/seller_model.dart';

class MenusFoodDisplay extends StatefulWidget {
  Menus? model;
  BuildContext? context;
   MenusFoodDisplay({super.key,this.model,this.context});

  @override
  State<MenusFoodDisplay> createState() => _MenusFoodDisplayState();
}

class _MenusFoodDisplayState extends State<MenusFoodDisplay> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => ItemsScreen(model: widget.model,),));
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
                  widget.model!.thumbnailUrl!,
                  fit: BoxFit.fill,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    widget.model!.menuTitle!,
                    style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4,),
                  Text(
                    widget.model!.menuInfo!,
                    style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
                    )
              ],
            ),
          ), 
        ),
    );
  }
}