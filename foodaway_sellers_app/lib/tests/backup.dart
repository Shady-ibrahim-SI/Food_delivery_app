// image picking
// InkWell(
//                       onTap: () {
//                         _pickImage();
//                       },
//                       child:
//                       Container(
//                       width: 190.0,// Set your desired width
//                       height: 190.0, // Set your desired height
//                       decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: _image != null
//                       ? DecorationImage(
//                       image: FileImage(_image!),
//                       fit: BoxFit.cover, // You can adjust the fit as needed
//                       )
//                       : DecorationImage(
//                       image: AssetImage('assets/images/add_image.png'),
//                       fit: BoxFit.cover, // You can adjust the fit as needed
//                       ), // If _image is null, no image is displayed.
//                       ),
//                       ),
//                     ),

// // name part

// SizedBox(
//                         width:350,
//                         height: 57,
//                         child: CustomTextFormField(hintText: 'Name',prefixIcon: Icon(Icons.person_3),
//                         onChanged: (data) {
//                           nameController.text=data;
//                         },
//                         validator: (data) {
//                           if(data!.length == 0){
//                             return 'The name field is required';
//                           }
//                         },
//                         )
//                       ),

// phone part

// SizedBox(
//                       width:350,
//                       height: 57,
//                       child: CustomTextFormField(
//                       controller: phoneController,
//                       hintText: 'Phone',
//                       prefixIcon: Icon(Icons.phone),
//                       onChanged:(p0) {
//                         phoneController.text=p0;
//                       },
//                       validator: (data) {
//                         if(phoneController.text.length<11){
//                           phoneController.clear();
//                           return 'Phone number is less than 11-digits';
//                         }
//                       },
//                       )
//                     ),

// location part

// SizedBox(
//                       width:350,
//                       height: 57,
//                       child: CustomTextFormField(
//                       enabled: true,
//                       controller: locationController,
//                       hintText: 'Cafe/Restaurant Address',
//                       prefixIcon: Icon(Icons.location_city),
//                       onChanged:(data) {
//                         locationController.text=data;
//                       },
//                       validator: (data) {
//                         if(data!.length == 0){
//                           return 'U must provide a location';
//                         }
//                       },
//                       )
//                     ),
//                     ElevatedButton.icon(
//                             icon:Icon(Icons.location_on),
//                             onPressed:() {
//                                 getCurrentLocation();
//                               },style: ElevatedButton.styleFrom(
//                                 elevation: 0,
//                       backgroundColor:Colors.green,
//                       minimumSize: const Size(350, 30),
//                       maximumSize: const Size(350, 30),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                               ) ,label:const Text('Get Cafe/Restaurant location',style: TextStyle(fontSize: 20,color:Colors.white),)
                              
//                       ),

// create account button

//  ElevatedButton(onPressed:() async{
//                         if (formKey.currentState!.validate() && _image!=null) {
//                           setState(() {
//                            inAsyncCall=true;
//                           });
//                                 try {
//                                 String filename= DateTime.now().millisecondsSinceEpoch.toString();
//                                 Reference reference = FirebaseStorage.instance.ref().child('sellers').child(filename);
//                                 UploadTask uploadTask = reference.putFile(File(_image!.path));
//                                 TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//                                 await taskSnapshot .ref.getDownloadURL().then((url){
//                                   sellerImageUrl=url;
//                                 });
//                                 await createUserAndSaveToFirestore(context);
//                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Registered Successfully')));
//                                 } on FirebaseAuthException catch (e) {
//                                   if(e.code =='weak-password'){
//                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('weak-password')));
//                                   }
//                                 else if(e.code =='email-already-in-use'){
//                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('The email address is already in use by another account')));
//                                   }
//                                 }
//                           }
//                           else if(_image == null){
//                             _ImageValidation();
//                           }
//                               setState(() {
//                                 inAsyncCall=false;
//                                 });
//                       }, 
//                       style: ElevatedButton.styleFrom(
//                                       elevation: 0,
//                             backgroundColor:Color(0xff53E88B),
//                             minimumSize: const Size(200, 64),
//                             maximumSize: const Size(200, 64),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                                     ),
//                                     child: Text('Create Account',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
//                                     ),