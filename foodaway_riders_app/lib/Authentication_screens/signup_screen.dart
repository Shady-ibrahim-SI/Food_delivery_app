import 'dart:io';
import 'dart:ffi' as ffi;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_riders_app/Authentication_screens/login_screen.dart';
import 'package:foodaway_riders_app/Authentication_screens/rider_home_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/custom_textfield.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool staySignedIn = false;
  bool emailingAboutOffers = false;
  String? name;
  String? email;
  String? Password;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passswordController = TextEditingController();
  TextEditingController confirmPassswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool passwordVisible=false;
  bool confirmPassswordVisible=false;
  bool inAsyncCall=false;
  bool enabled=false;

  File? _image;
  Position? position;
  List<Placemark>? PlaceMarks;
  String sellerImageUrl="";
  String? completeAddress;

  Future<void> _pickImage() async 
  {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }

  }

   getCurrentLocation() async
   {

    LocationPermission permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    position = newPosition;
    PlaceMarks =await placemarkFromCoordinates(
        position!.latitude , position!.longitude
      );
    Placemark pMarks =PlaceMarks![0];

     completeAddress = '${pMarks.subThoroughfare!} ${pMarks.thoroughfare} ${pMarks.subLocality} ${pMarks.locality}, ${pMarks.subAdministrativeArea}, ${pMarks.administrativeArea} ${pMarks.postalCode} ${pMarks.country}';
    locationController.text=completeAddress!;

   }

   Future<void> _ImageValidation() async 
   {
    
    if (_image == null) {
     showDialog(context:context, builder:(context) {
       return CustomAlertDialog(alertMessage: 'Please Add a picture',);
     },);
    }
  }

  Future saveDataToFirestore(User currentUser) async{
    FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).set(
    {
      "riderUID": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": nameController.text.trim(),
      "riderAvataUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    }
    );
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('Uid',currentUser.uid);
    await sharedPreferences.setString('email',currentUser.email.toString());
    await sharedPreferences.setString('name',nameController.text.trim());
    await sharedPreferences.setString('photoUrl',sellerImageUrl);
  }
  Future<void> createUserAndSaveToFirestore(BuildContext context) async {
    User? currentUser;
    final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
    await firebaseAuth.createUserWithEmailAndPassword(
      email: email!, password:Password!).then((auth){
      currentUser = auth.user;  
    });
    if(currentUser !=null){
      saveDataToFirestore(currentUser!).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => RiderHome(),));
      });
    }
  }
   

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        body: Center(
          child:SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    SizedBox(height:32,),
                      InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child:
                      Container(
                      width: 190.0,// Set your desired width
                      height: 190.0, // Set your desired height
                      decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _image != null
                      ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover, // You can adjust the fit as needed
                      )
                      : DecorationImage(
                      image: AssetImage('assets/images/add_image.png'),
                      fit: BoxFit.cover, // You can adjust the fit as needed
                      ), // If _image is null, no image is displayed.
                      ),
                      ),
                    ),
                      SizedBox(height: 16,),
                      Text('Food Away',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 40,color:Color(0xff53E88B),fontFamily:'viga'),),
                      SizedBox(height: 8,),
                      Text('Deliver Favourite Food',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                      SizedBox(height:16  ,),
                      Text('Sign Up For Free',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: 40,),
                      SizedBox(
                        width:350,
                        height: 57,
                        child: CustomTextFormField(hintText: 'Name',prefixIcon: Icon(Icons.person_3),
                        onChanged: (data) {
                          nameController.text=data;
                        },
                        validator: (data) {
                          if(data!.length == 0){
                            return 'The name field is required';
                          }
                        },
                        )
                      ),
                      SizedBox(height: 8,),
                      SizedBox(
                        width:350,
                        height: 57,
                        child: CustomTextFormField(
                        controller: emailController,
                        hintText: 'Email',prefixIcon:Icon(Icons.email),
                        onChanged: (p0) {
                          email=p0;
                        },
                        validator: (data) {
                          if(data!.contains('@') && data!.contains('.com')){ 
                          }
                          else{
                            emailController.clear();
                            return 'Email must contains @ and .com';
                          }
                        },
                        )
                      ),
                      SizedBox(height: 8,),
                      SizedBox(
                        width:350,
                        height: 57,
                        child: CustomTextFormField(
                          controller: passswordController,
                          passwordVisiblity: passwordVisible,
                          hintText: 'Password',suffixIcon:IconButton(onPressed:() {
                          setState(() {
                            passwordVisible=!passwordVisible;
                          });
                        }, icon: Icon(Icons.remove_red_eye)),
                        prefixIcon: Icon(Icons.lock),
                        onChanged:(data) {
                          passswordController.text=data;
                          Password=data;
                        },
                        validator: (data) {
                          if(data!.length<=8){
                            passswordController.clear();
                            return 'Password length must be more 8';
                          }
                        },
                        )
                      ),
                       SizedBox(height: 8,),
                    SizedBox(
                      width:350,
                      height: 57,
                      child: CustomTextFormField(
                      passwordVisiblity:confirmPassswordVisible,
                      controller: confirmPassswordController,
                      hintText: 'Confirm Password',suffixIcon:IconButton(onPressed:() {
                        setState(() {
                          confirmPassswordVisible=!confirmPassswordVisible;
                        });
                      }, icon: Icon(Icons.remove_red_eye)),
                      prefixIcon: Icon(Icons.lock),
                      onChanged:(data) {
                        confirmPassswordController.text=data;
                        Password=data;
                      },
                      validator: (data) {
                        if(confirmPassswordController.text!=passswordController.text){
                          confirmPassswordController.clear();
                          return 'Cofirm Password isnt the same as Password';
                        }
                      },
                      )
                    ),
                    SizedBox(
                      width:350,
                      height: 57,
                      child: CustomTextFormField(
                      controller: phoneController,
                      hintText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      onChanged:(p0) {
                        phoneController.text=p0;
                      },
                      validator: (data) {
                        if(phoneController.text.length<11){
                          phoneController.clear();
                          return 'Phone number is less than 11-digits';
                        }
                      },
                      )
                    ),
                    SizedBox(
                      width:350,
                      height: 57,
                      child: CustomTextFormField(
                      enabled: true,
                      controller: locationController,
                      hintText: 'my current Address',
                      prefixIcon: Icon(Icons.location_city),
                      onChanged:(data) {
                        locationController.text=data;
                      },
                      validator: (data) {
                        if(data!.length == 0){
                          return 'U must provide a location';
                        }
                      },
                      )
                    ),
                    ElevatedButton.icon(
                            icon:Icon(Icons.location_on),
                            onPressed:() {
                                getCurrentLocation();
                              },style: ElevatedButton.styleFrom(
                                elevation: 0,
                      backgroundColor:Colors.green,
                      minimumSize: const Size(350, 30),
                      maximumSize: const Size(350, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                              ) ,label:const Text('Get my current location',style: TextStyle(fontSize: 20,color:Colors.white),)
                              
                      ),
                      Row(
                        children: [
                          SizedBox(width:28,),
                          Checkbox(
                            activeColor:Color(0xff39d683),
                            shape: CircleBorder(),
                            value: staySignedIn,
                            onChanged: (value) {
                              setState(() {
                                staySignedIn = value!;
                              });
                            },
                          ),
                          Text('Keep Me Sgined In',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),)
                        ],
                      ),
                      SizedBox(height: 24,),
                      ElevatedButton(onPressed:() async{
                        if (formKey.currentState!.validate() && _image!=null) {
                          setState(() {
                           inAsyncCall=true;
                          });
                                try {
                                String filename= DateTime.now().millisecondsSinceEpoch.toString();
                                Reference reference = FirebaseStorage.instance.ref().child('riders').child(filename);
                                UploadTask uploadTask = reference.putFile(File(_image!.path));
                                TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                                await taskSnapshot .ref.getDownloadURL().then((url){
                                  sellerImageUrl=url;
                                });
                                await createUserAndSaveToFirestore(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Registered Successfully')));
                                } on FirebaseAuthException catch (e) {
                                  if(e.code =='weak-password'){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('weak-password')));
                                  }
                                else if(e.code =='email-already-in-use'){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('The email address is already in use by another account')));
                                  }
                                }
                          }
                          else if(_image == null){
                            _ImageValidation();
                          }
                              setState(() {
                                inAsyncCall=false;
                                });
                      }, 
                      style: ElevatedButton.styleFrom(
                                      elevation: 0,
                            backgroundColor:Color(0xff53E88B),
                            minimumSize: const Size(200, 64),
                            maximumSize: const Size(200, 64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                                    ),
                                    child: Text('Create Account',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                    ),
                    SizedBox(height: 2,),
                   TextButton(onPressed:() {
                     Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) {
                      return Login();
                     },));
                   }, child:Text('already have an account?',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17,color: Color(0xff53E88B)),))
            
                ],
              ),
            ),
          ),
          ),
      ),
    );
  }
}