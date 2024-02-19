import 'package:flutter/material.dart';
import 'package:foodaway_users_app/mainScreens/items_detail_screen.dart';
import 'package:foodaway_users_app/models/items.dart';
import 'package:foodaway_users_app/models/seller_model.dart';

class ItemsFoodDisplay extends StatefulWidget {
  Items? model;
  BuildContext? context;
   ItemsFoodDisplay({super.key,this.model,this.context});

  @override
  State<ItemsFoodDisplay> createState() => _ItemsFoodDisplayState();
}

class _ItemsFoodDisplayState extends State<ItemsFoodDisplay> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context) => ItemDetailsScreen(model: widget.model,),));
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
                // Image.network(
                //   widget.model!.thumbnailUrl!,
                //   fit: BoxFit.fill,
                //   ),
                //   SizedBox(height: 4,),
                //   Text(
                //     widget.model!.title!,
                //     style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
                //     ),
                //     SizedBox(height: 4,),
                //   Text(
                //     widget.model!.shortInfo!,
                //     style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),
                //     ),
                Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                // BoxShadow(
                // color: Colors.brown.withOpacity(0.5),
                // spreadRadius: 5,
                // blurRadius: 10,
                // offset: Offset(0, 3),
                // ),
                ],
                // gradient: LinearGradient(
                // colors: [Colors.orange, Colors.amber],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
                // ),
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
                Text(
                    widget.model!.title!,
                    style: TextStyle(color: Colors.red,fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4,),
                    Text(
                    widget.model!.shortInfo!,
                    style: TextStyle(color: Colors.red,fontSize: 16, fontWeight: FontWeight.bold),
                    )
              ],
            ),
          ), 
        ),
    );
  }
}