import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  bool? passwordVisiblity;
  bool? enabled;
  TextEditingController? controller;
   CustomTextFormField({super.key,required this.hintText,  this.prefixIcon,this.suffixIcon,this.controller,this.onChanged,this.validator,this.passwordVisiblity=false,this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                controller: controller,
                enabled: enabled,
                obscureText: passwordVisiblity!,
                validator: validator,
                onChanged: onChanged,
                decoration: InputDecoration(
                  prefixIcon:prefixIcon,
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: TextStyle(color:Colors.grey),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:BorderSide(color: Color(0xFFF4F4F4),width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                 )
                 ),
              );
  }
}