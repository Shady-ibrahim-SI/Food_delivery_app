import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/Model/menus_model.dart';
import 'package:foodaway_sellers_app/mainScreens/itemsScreen.dart';

class FoodDisplay extends StatefulWidget {
  Menus? model;
  BuildContext? context;
   FoodDisplay({super.key,this.model,this.context});

  @override
  State<FoodDisplay> createState() => _FoodDisplayState();
}

class _FoodDisplayState extends State<FoodDisplay> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => ItemsScreen(model: widget.model,),));
      },
      splashColor: Colors.amber,
      child: Padding(
          padding:EdgeInsets.all(4.0),
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
                Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                BoxShadow(
                color: Colors.brown.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3),
                ),
                ],
                gradient: LinearGradient(
                colors: [Colors.orange, Colors.amber],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                ),
                image: DecorationImage(
                image: NetworkImage(
                widget.model!.thumbnailUrl!,
                ),
                fit: BoxFit.cover,
                ),
                ),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.1),
                BlendMode.srcATop,
                ),
                child: Container(
                color: Colors.transparent,
                ),
                ),
                ),
                ),
                // Image.network(
                //   widget.model!.thumbnailUrl!,
                //   fit: BoxFit.cover,
                //   ),
                  SizedBox(height: 1.0,),
                  Text(
                    widget.model!.menuTitle!,
                    style: TextStyle(color: Colors.black,fontSize: 20),
                    ),
                    Text(
                    widget.model!.menuInfo!,
                    style: TextStyle(color: Colors.grey,fontSize: 14,),
                    )
              ],
            ),
          ), 
        ),
    );
  }
}