import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_sellers_app/widgets/alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenusUpload extends StatefulWidget {
  const MenusUpload({super.key});

  @override
  State<MenusUpload> createState() => _MenusUploadState();
}

class _MenusUploadState extends State<MenusUpload> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Menu'),
        leading: IconButton(onPressed:() {
          clearMenusUploadForm();
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        centerTitle: true,
        flexibleSpace:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.black,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shop_two,color: Colors.white,size: 200.0,),
              ElevatedButton(onPressed:() {
                takeImage(context);
              }, child: Text('Add New Menu',style: TextStyle(color: Colors.white,fontSize: 18),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                )
              ),
              
              )
            ],
          ),
        ),
      ),
    );
  }
  takeImage(mcontext){
    return showDialog(context:mcontext, builder:(context) {
      return SimpleDialog(
        title: Text('Menu Image',style: TextStyle(color: Colors.cyan,fontWeight: FontWeight.bold),),
        children: [
          SimpleDialogOption( 
            child: Text('Capture With Phone Camera',style: TextStyle(color: Colors.grey),),
            onPressed: () {
              captureImageWithCamera();
            },
          ),
          SimpleDialogOption( 
            child: Text('Select From Gallery',style: TextStyle(color: Colors.grey),),
            onPressed: () {
              pickImageFromGallery();
            },
          ),
          SimpleDialogOption( 
            child: Text('Cancel',style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },);
  }
  captureImageWithCamera() async{
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }
  pickImageFromGallery() async{
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }
  menusUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploading New Menu'),
        centerTitle: true,
        flexibleSpace:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.black,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp
            )
          ),
        ),
        actions: [
          TextButton(onPressed:() {
           uploading ? null : validateUploadForm();
          }, child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 17),))
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? LinearProgressIndicator() : Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
                child: AspectRatio(
                  aspectRatio:16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                            image: FileImage(File(imageXFile!.path)),
                            fit: BoxFit.cover
                        )
                    ),
                  ), 
                ),      
            ),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: InputDecoration(
                  hintText: 'Menu Info',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none
                ),
                ),
            ),
          ),
          Divider(
            color: Colors.pink,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.title,color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Menu title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none
                ),
                ),
            ),
          )
        ],
      ),
    );
  }
  clearMenusUploadForm(){
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile=null;
    });
  }
  validateUploadForm() async{

    if(imageXFile != null){

      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty){
        
        setState(() {
        uploading=true;
        });
        // uploading image to firestore
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        // save uploading info firestore database
          saveInfo(downloadUrl,shortInfoController.text,titleController.text); 
      }else{

        showDialog(context:context, builder:(context) {
        return CustomAlertDialog(alertMessage: 'Please Write title and info for menu.',);
        },);
      
      }

    }else{

      showDialog(context:context, builder:(context) {
       return CustomAlertDialog(alertMessage: 'Please Add a Menu',);
     },);
    
    }
  }
  uploadImage(mImageFile) async{

    Reference reference =FirebaseStorage.instance.ref().child("menus");
    UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
  saveInfo(String downloadUrl,String shortInfo,String menuTitle) async{
    final sharedPreferences = await SharedPreferences.getInstance();
    final ref = FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences.getString("Uid")).collection("menus");

    ref.doc(uniqueIdName).set({

      "menuID": uniqueIdName,
      "sellerUID" : sharedPreferences.getString("Uid"),
      "menuInfo" : shortInfoController.text.toString(),
      "menuTitle" : titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status" : "avaliable",
      "thumbnailUrl" : downloadUrl
    });  
    clearMenusUploadForm();
    setState(() {

      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}