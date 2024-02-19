import 'package:flutter/material.dart';

class CustomRichtText extends StatelessWidget {
  String identifier;
  String value;
   CustomRichtText({super.key, required this.identifier,required this.value});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                    width: 410,
                    child: RichText(
                      text:TextSpan(
                        text:'$identifier:',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: ' $value',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue))
                      ]
                    )
                    ),
                  );
  }
}