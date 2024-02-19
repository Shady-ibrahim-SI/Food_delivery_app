import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/reset_password/reset_password.dart';
import 'package:foodaway_sellers_app/widgets/custom_directions_elevatedButton.dart';

class ForgotPassword extends StatelessWidget {
   ForgotPassword({super.key});
  TextEditingController emailController= TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
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
                  Text('\t\t\t\t\t  Forgot password?',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 16,),
                  Text('\t\t\t\t\t\t\t\t\t\t\t\tSelect which contact details should we'),
                  Text('\t\t\t\t\t\t\t\t\t\t\t use to reset your password'),
                  SizedBox(height: 32,),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: emailController,
                        onChanged: (data) {
                          emailController.text=data;
                        },
                        validator: (data) {
                          if(data!.contains('@') && data.contains('.com') && data.length>0){ 
                            }
                            else if(data.isEmpty){
                              return 'Enter your Email to reset password';
                            }else{
                              emailController.clear();
                              return 'Email must contains @ and .com';
                            }
                        },
                        style: TextStyle(height: 1),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,color: Color(0xff37d582),),
                          hintText: 'Enter your Email',
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
                  SizedBox(height: 400,),
                  Container(
                    margin: EdgeInsets.only(left: 88),
                    child: CustomDirectionsElevatedButton(onPressed:() {
                      if(formKey.currentState!.validate()){
                        Navigator.push(context, MaterialPageRoute(builder:(context) =>ResetPassword(emailController: emailController,),));
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