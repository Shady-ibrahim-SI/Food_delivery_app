import 'package:flutter/material.dart';

class CustomDirectionsElevatedButton extends StatelessWidget {
   VoidCallback onPressed;
   String buttonText;
   CustomDirectionsElevatedButton({super.key,required this.onPressed,required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0xff28cb7d),
                    minimumSize: const Size(220, 57),
                    maximumSize: const Size(220, 57),
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                  ), 
                  child: Text('$buttonText',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold
                  )
                  )
                  );
  }
}