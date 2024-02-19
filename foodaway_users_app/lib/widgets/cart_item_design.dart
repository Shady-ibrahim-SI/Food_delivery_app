import 'package:flutter/material.dart';
import 'package:foodaway_users_app/models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quantityNumber;
   CartItemDesign({
    this.model,
    this.context,
    this.quantityNumber
   });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Container(
        height: 0,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                Image.network(widget.model!.thumbnailUrl!,width: 140,height: 120,),
                SizedBox(width: 6,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text
                    (widget.model!.title!,style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      ),
                      ),
                      SizedBox(height: 1,),
                      Row(
                        children: [
                          Text(
                            'x ',
                    style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          ),
                          ),
                          Text(
                            widget.quantityNumber.toString(),
                    style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Price: ',style: TextStyle(fontSize: 15,color: Colors.grey),),
                          Text('E£ ',style: TextStyle(fontSize: 15,color: Colors.grey),),
                          Text(widget.model!.price!.toString(),style: TextStyle(fontSize: 16,color: Colors.blue),)
                        ],
                      )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}