import 'package:flutter/material.dart';
import 'package:foodaway_users_app/screens/on_boarding_screens/on_boarding_screen2.dart';

class OnBoardingSCreen1 extends StatelessWidget {
  const OnBoardingSCreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 108,),
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/food_image.png'),
                fit: BoxFit.cover
                )
              ),
            ),
            SizedBox(height: 62,),
            Text('  Find your Comfort \n        Food here',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Text('Here You Can find a chef or dish for every'),
            SizedBox(height: 8,),
            Text('taste and color. Enjoy!'),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 13,
                  child: Icon(Icons.circle,color: Colors.black,size: 15,),
                  ),
              CircleAvatar(
              backgroundColor: Colors.white,
              radius: 13,
              child: Icon(Icons.circle,color: Colors.grey,size: 15,),
              ),
              ],
            ),
            SizedBox(height: 16,),
            ElevatedButton(onPressed:() {
              Navigator.push(context, MaterialPageRoute(builder:(context) => OnBoardingSCreen2(),));
            }, 
            style:ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color(0xff53E88B),
              minimumSize: const Size(151, 57),
              maximumSize: const Size(151, 57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('Next',style: TextStyle(fontSize: 16),))
          ],
        ),
      ),
    );
  }
}