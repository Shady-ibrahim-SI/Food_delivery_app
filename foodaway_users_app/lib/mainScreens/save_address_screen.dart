// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodaway_users_app/models/address.dart';
import 'package:foodaway_users_app/widgets/check_out_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAddressScreen extends StatelessWidget {

  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // const SaveAddressScreen({super.key});
  List<Placemark>? Placemarks;
  Position? position;
  String? userUid;
  Future<void> getDataFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    userUid = sharedPreferences.getString('Uid') ?? 'Address not found';
    // You can set other properties in a similar manner.
  }

  getUserLocationAddress()async{
      LocationPermission permission = await Geolocator.requestPermission();
      Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high);
      position = newPosition;
      Placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
      Placemark pMark = Placemarks![0];
      String fullAddress = '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode} ${pMark.country}';
      _locationController.text = fullAddress;
      _flatNumber.text = '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}';
      _city.text = '${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}';
      _state.text = '${pMark.country}';
      _completeAddress.text = fullAddress;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Away',style: TextStyle(fontSize: 25,letterSpacing: 1 , color: Colors.white),),
        centerTitle: true,
        flexibleSpace:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.red,
                Colors.black,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton.extended(
        onPressed:() async{
        // save address info
        if(formKey.currentState!.validate())
        {
          final model = Address(
            name: _name.text.trim(),
            state: _state.text.trim(),
            fullAddress: _completeAddress.text.trim(),
            phoneNumber: _phoneNumber.text.trim(),
            flatNumber: _flatNumber.text.trim(),
            city: _city.text.trim(),
            lat: position!.latitude.toString(),
            lng: position!.longitude.toString()
          ).toJson();
          SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
          FirebaseFirestore.instance.collection("users").doc(sharedPreferences.getString("uid"))
          .collection("userAddress").doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(model).then((value) {
            Fluttertoast.showToast(msg: "New Address has been saved.");
            formKey.currentState!.reset();
          });
        }
      }, 
      label: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Save'),
      ),
      icon: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 6,),
            Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Save New Address:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                ),
            ),
            ListTile(
              leading: Icon(Icons.person_pin_circle,color: Colors.black,size: 35,),
              title: Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: "What's your address?"
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(onPressed:() {
                // get current location with address
                getUserLocationAddress();
            }, 
            icon: Icon(Icons.location_on,color: Colors.white,),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.cyan)
                )
              )
            ),
             label: Text('Get my location')
             ),
             Form(
              key: formKey,
              child: Column(
                children: [
                  CheckOutTextField(
                    hint: 'Name',
                    controller: _name,
                  ),
                  CheckOutTextField(
                    hint: 'phone',
                    controller: _phoneNumber,
                  ),
                  CheckOutTextField(
                    hint: 'City',
                    controller: _city,
                  ),
                  CheckOutTextField(
                    hint: 'State / Country',
                    controller: _state,
                  ),
                  CheckOutTextField(
                    hint: 'Address Line',
                    controller: _flatNumber,
                  ),
                  CheckOutTextField(
                    hint: 'Complete Address',
                    controller: _completeAddress,
                  ),
                ],
              )
              )
          ],
        ),
      ),
    );
  }
}