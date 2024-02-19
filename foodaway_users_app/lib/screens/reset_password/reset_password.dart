import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_users_app/screens/reset_password/password_reset_successfull.dart';

import '../../widgets/custom_directions_elevatedButton.dart';

class ResetPassword extends StatefulWidget {
  TextEditingController emailController;
  ResetPassword({super.key,required this.emailController});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController currentPassswordController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool passwordVisible=false;
  bool confirmPasswordVisible=false;
  bool currentPasswordVisible=false;

  Future<void> changeUserPassword(BuildContext context) async {
    try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: widget.emailController.text, // Replace with the user's email
    password: currentPassswordController.text, // Replace with the user's current password
    );
    User? user = userCredential.user;
    // Change the user's password
    await user!.updatePassword(passwordController.text); // Replace with the new password
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Password reset Successfully')));
    Navigator.push(context, MaterialPageRoute(builder:(context) =>PasswordRestSuccessfully(),));
    } catch (e) {
    print('Error changing password: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfffefeff),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          key:formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 32,),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xfffdf5ed)
                      ),
                      child: IconButton(onPressed:() {
                        Navigator.pop(context);
                      }, icon:Icon(Icons.arrow_back_ios_new,color: Color(0xffDA6317),)),
                    )
                  ],
                  ),
                  SizedBox(height: 16,),
                  Text('\t\t\t\t\t  Reset your password \n \t\t\t\t\t here',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 16,),
                  Text('\t\t\t\t\t\t\t\t\t\t\t\tSelect which contact details should we'),
                  Text('\t\t\t\t\t\t\t\t\t\t\t use to reset your password'),
                  SizedBox(height: 32,),
                   Container(
                    margin: EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: currentPasswordVisible,
                        controller: currentPassswordController,
                        onChanged: (data) {
                          currentPassswordController.text=data;
                        },
                        validator: (data) {
                          if(data!.isNotEmpty && data.length>8){ 
                            }
                            else if(data.isEmpty){
                              return 'Enter current password';
                            }else if(data.length<8){
                              currentPassswordController.clear();
                              return 'password length should be greater than 8';
                            }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed:() {
                            setState(() {
                              currentPasswordVisible=!currentPasswordVisible;
                            });
                          }, icon: Icon(Icons.remove_red_eye,color: Colors.grey,)),
                          hintText: 'Current Password',
                          hintStyle: TextStyle(color:Colors.grey),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 28.0, horizontal: 32.0),
                          enabledBorder: OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                         )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: passwordVisible,
                        controller: passwordController,
                        onChanged: (data) {
                          passwordController.text=data;
                        },
                        validator: (data) {
                          if(data!.isNotEmpty && data.length>8){ 
                            }
                            else if(data.isEmpty){
                              return 'Enter New password';
                            }else if(data.length<8){
                              passwordController.clear();
                              return 'password length should be greater than 8';
                            }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed:() {
                            setState(() {
                              passwordVisible=!passwordVisible;
                            });
                          }, icon: Icon(Icons.remove_red_eye,color: Colors.grey,)),
                          hintText: 'New Password',
                          hintStyle: TextStyle(color:Colors.grey),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 28.0, horizontal: 32.0),
                          enabledBorder: OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                         )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText:confirmPasswordVisible,
                        controller: confirmPasswordController,
                        onChanged: (data) {
                          confirmPasswordController.text=data;
                        },
                        validator: (data) {
                          if(confirmPasswordController.text == passwordController.text){ 
                            }else{
                              confirmPasswordController.clear();
                              return 'Confirm Password is not equal to New Passsword';
                            }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed:() {
                            setState(() {
                              confirmPasswordVisible=!confirmPasswordVisible;
                            });
                          }, icon: Icon(Icons.remove_red_eye,color:Colors.grey,)),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color:Colors.grey),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 28.0, horizontal: 32.0),
                          enabledBorder: OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                         )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 230,),
                  Container(
                    margin: EdgeInsets.only(left: 88),
                    child: CustomDirectionsElevatedButton(onPressed:() async{
                      if(formKey.currentState!.validate()){
                        await changeUserPassword(context);
                      }
                    }, buttonText: 'Next'),
                  )
              ],
              ),
          ),
        ),
          ),
    );
  }
}