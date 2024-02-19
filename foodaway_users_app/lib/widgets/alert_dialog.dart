import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  String? alertMessage;
  CustomAlertDialog({super.key,this.alertMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(alertMessage!),
      actions: [
        TextButton(onPressed:() {
          Navigator.pop(context);
          
        }, child: Text('OK'))
      ],
    );
  }
}