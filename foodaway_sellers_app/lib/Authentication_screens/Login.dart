import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_sellers_app/mainScreens/Seller_Home.dart';
import 'package:foodaway_sellers_app/Authentication_screens/Signup.dart';
import 'package:foodaway_sellers_app/reset_password/forget_password.dart';
import 'package:foodaway_sellers_app/widgets/custom_textfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? name;
  String? email;
  String? Password;
  GlobalKey<FormState> formKey = GlobalKey();
  bool passwordVisible=false;
  bool inAsyncCall=false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void userSignOut() {
    FirebaseAuth firebaseAuth =FirebaseAuth.instance;
    firebaseAuth.signOut();
  }

  Future readDataAndSetDataLocally(User currentUser) async{
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).get().then((snapshot)async{
      if(snapshot.exists){
        if(snapshot.data()!["status"] == "approved"){
          await sharedPreferences.setString("Uid", currentUser.uid);
          await sharedPreferences.setString("email", snapshot.data()!["sellerEmail"]);
          await sharedPreferences.setString("name", snapshot.data()!["sellerName"]);
          await sharedPreferences.setString("photoUrl",snapshot.data()!["sellerAvataUrl"]);
          await sharedPreferences.setString("address",snapshot.data()!["address"]);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => SellerHome(),));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Logged In successfully')));
        }
        else{
          userSignOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login(),));
          Fluttertoast.showToast(msg: "Admin has Blocked your account.");
        }
      
      }else{
        userSignOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Login(),));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Seller does not exist')));
      }
    });
  }
  Future<void> AuthenticateUserAndSaveDataLocally(BuildContext context) async {
    User? currentUser;
    FirebaseAuth firebaseAuth =  FirebaseAuth.instance;
    await firebaseAuth.signInWithEmailAndPassword(email: email!, password:Password!).then((auth){
      currentUser = auth.user!;
    });
    if(currentUser != null){
      readDataAndSetDataLocally(currentUser!);  
    }
  }
  // Future<User?> _handleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //     if (googleUser == null) {
  //       // User canceled the sign-in process.
  //       return null;
  //     }

  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential authResult = await _auth.signInWithCredential(credential);
  //     final User? user = authResult.user;

  //     return user;
  //   } catch (error) {
  //     print("Error: $error");
  //     return null;
  //   }
  // }
  // Future<void> _handleSignOut() async {
  //   await googleSignIn.signOut();
  //   await _auth.signOut();
  // }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                  Container(
                          height: 200,
                          width: double.infinity,
                        decoration: BoxDecoration(
                        image:DecorationImage(image: AssetImage('assets/images/image 44.png'),)
                        ),
                        ),
                        Text('Food Away',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,color:Color(0xff53E88B),fontFamily:'viga'),),
                        SizedBox(height: 8,),
                        Text('Deliver Favourite Food',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                        SizedBox(height:32,),
                        Text('Login To Your Account',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 56,),
                        SizedBox(
                          width:350,
                          height: 57,
                          child: CustomTextFormField(
                           onChanged: (data) {
                                  email=data;
                              },
                          validator: (data) {
                            if(data!.contains('@') && data!.contains('.com')){ 
                            }
                            else{
                              return 'Email must contains @ and .com';
                            }
                          },
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          )
                        ),
                        SizedBox(
                          width:350,
                          height: 57,
                          child: CustomTextFormField(
                          passwordVisiblity: passwordVisible,
                          suffixIcon: IconButton(onPressed:() {
                            setState(() {
                              passwordVisible=!passwordVisible;
                            });
                          }, icon:Icon(Icons.remove_red_eye)),
                          hintText: 'Password',
                          onChanged:(p0) {
                          Password=p0;
                        },
                        validator: (data) {
                          if(data!.length<8){
                            return 'Password length must be more 8';
                          }
                        },
                          )
                        ),
                        SizedBox(height: 8,),
                        TextButton(onPressed:() {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) {
                            return SignUp();
                          },));
                        }, child: Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: Color(0xff53E88B)))),
                        SizedBox(height: 4,),
                        Text('Or Continue With',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Color(0xff09051C)),),
                        SizedBox(height: 32,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             ElevatedButton.icon(
                                    icon: Ink.image(image: const AssetImage('assets/images/facebook-icon.png'),
                                    width: 25,
                                    height: 25,
                                    ),
                                    onPressed:() {
                                      },style: ElevatedButton.styleFrom(
                                        elevation: 0,
                              backgroundColor:Colors.white,
                              minimumSize: const Size(150, 57),
                              maximumSize: const Size(150, 57),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                                      ) ,label:const Text('Facebook',style: TextStyle(fontSize: 20,color:Color(0xff202430)),)
                                      
                                      ),
                                      SizedBox(width: 4,),
                            ElevatedButton.icon(
                                    icon: Ink.image(image: const AssetImage('assets/images/google-icon.png'),
                                    width: 25,
                                    height: 25,
                                    ),
                                    onPressed:() async{
                                        // User? user = await _handleSignIn();
                                        // if (user != null) {
                                        // // User signed in successfully, you can navigate to another screen or perform actions here.
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User signed in as : ${user.displayName}')));
                                        // // Navigator.push(context, MaterialPageRoute(builder:(context) {
                                        // //   return ChatScreen(email:user.displayName!);
                                        // // },));
                                        // }
                                      },style: ElevatedButton.styleFrom(
                                        elevation: 0,
                              backgroundColor:Colors.white,
                              minimumSize: const Size(152, 57),
                              maximumSize: const Size(152, 57),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                                      ) ,label:const Text('Google',style: TextStyle(fontSize: 20,color:Color(0xff202430)),)
                                      
                              ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:(context) => ForgotPassword(),));
                          },
                          child: Text('Forgot Your Password?',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: Color(0xff53E88B
                          )
                          ),
                          )
                          ),
                        SizedBox(height: 8,),
                        ElevatedButton(onPressed:() async{
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              inAsyncCall=true;
                            });
                                  try {
                                  await AuthenticateUserAndSaveDataLocally(context);
                                  } on FirebaseAuthException catch (e) {
                                    if(e.code =='user-not-found'){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('user-not-found')));
                                    }
                                  else if(e.code =='wrong-password'){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('wrong-password')));
                                    }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('User does not exist')));
                                  }
                                  }
                          }
                                setState(() {
                                  inAsyncCall=false;
                                  });
                        }, 
                        style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:Color(0xff53E88B),
                              minimumSize: const Size(200, 57),
                              maximumSize: const Size(200, 57),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              ),child: Text('Log In',style: TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold),)
                              )
              ],
            )
            ),
          ),
        ),
      ),
    );
  }
}