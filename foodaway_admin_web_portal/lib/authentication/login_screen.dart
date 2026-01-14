import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_admin_web_portal/main%20screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  String adminEmail = "";
  String adminPassword = "";
  
  allowAdminToLogin() async{
    SnackBar snackBar = SnackBar(content: Text("Checking Credentials, please wait...",
      style: TextStyle(fontSize: 36),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    User? currentAdmin;

    await FirebaseAuth.instance.signInWithEmailAndPassword(email:adminEmail , password:adminPassword)
    .then((value) {
      currentAdmin = value.user;
    }).catchError((onError){

      final snackBar = SnackBar(content: Text("Error Occured: "+ onError.toString(),
      style: TextStyle(fontSize: 36),
      ),
      backgroundColor: Colors.pinkAccent,
      duration: Duration(seconds: 5),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if(currentAdmin != null){
        await FirebaseFirestore.instance.collection("admins").doc(currentAdmin!.uid).get().then((value) {

          if(value.exists){
            Navigator.push(context, MaterialPageRoute(builder:(context) => HomeScreen(),));
          }else{
            SnackBar snackBar = SnackBar(content: Text("No record found for this admin.",
            style: TextStyle(fontSize: 36),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 5),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child:Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network("https://t4.ftcdn.net/jpg/03/59/09/01/360_F_359090172_vsL1da5fNVENKKMoQTq7NSwPPrllQcRB.jpg"),
                    SizedBox(height: 20,),
                    TextField(
                      onChanged: (value) {
                        adminEmail = value;
                      },
                      style: TextStyle(fontSize: 16,color: Colors.white),
                      decoration: InputDecoration(
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.cyan,
                        //     width: 2
                        //   )
                        // ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.email,color: Colors.cyan,)
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextField(
                      onChanged: (value) {
                        adminPassword = value;
                      },
                      obscureText: true,
                      style: TextStyle(fontSize: 16,color: Colors.white),
                      decoration: InputDecoration(
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.cyan,
                        //     width: 2
                        //   )
                        // ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.admin_panel_settings,color: Colors.cyan,)
                      ),
                    ),
                    SizedBox(height: 16,),
                    ElevatedButton(
                      onPressed:() {
                       allowAdminToLogin();
                      },style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 100,vertical: 20)),
                        backgroundColor: MaterialStateProperty.all(Colors.cyan)
                      ), child: Text("Login",style: TextStyle(color: Colors.white,letterSpacing: 3,fontSize:16),))
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}