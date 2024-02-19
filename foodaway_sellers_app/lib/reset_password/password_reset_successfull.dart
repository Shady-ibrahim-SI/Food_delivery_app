import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/Authentication_screens/Login.dart';
import '../../widgets/custom_directions_elevatedButton.dart';

class PasswordRestSuccessfully extends StatelessWidget {
  const PasswordRestSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image:AssetImage('assets/images/reset_password_successfuly.png'))
              ),
            ),
            SizedBox(height:8,),
            Text('Congrats!',style: TextStyle(fontSize: 35,color: Color(0xff2bcd7e),fontWeight: FontWeight.bold),),
            SizedBox(height: 16,),
            Text('Password reset successfully',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            SizedBox(height: 250,),
            CustomDirectionsElevatedButton(onPressed:() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login(),));
            }, buttonText:'Back')          
          ],
        ),
      ),
    );
  }
}