import 'package:flutter/material.dart';

class HeaderText extends SliverPersistentHeaderDelegate {

  String? headerText;
  HeaderText({this.headerText});
  @override
  Widget build(BuildContext context , double shrinkOffset , bool overlapsContent) {
    return InkWell(
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
          height: 80.0,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: InkWell(
            child: Text(
                        headerText!,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20,color: Colors.white),
                        ),
          ),
      ),
    );
  }
  
  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;
  
  @override
  // TODO: implement minExtent
  double get minExtent => 50;
  
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}