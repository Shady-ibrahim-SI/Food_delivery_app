import 'package:flutter/material.dart';

class CheckOutTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  const CheckOutTextField({super.key,this.hint,this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          validator:(value) => value!.isEmpty ? 'Field can not be empty': null,
        ),
       );
  }
}