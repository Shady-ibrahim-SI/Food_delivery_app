import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_admin_web_portal/main%20screens/home_screen.dart';

class AllBlockedRidersScreen extends StatefulWidget {
  const AllBlockedRidersScreen({super.key});

  @override
  State<AllBlockedRidersScreen> createState() => _AllBlockedRidersScreenState();
}

class _AllBlockedRidersScreenState extends State<AllBlockedRidersScreen> {
  @override
  QuerySnapshot? allRiders;

  displayDialogBoxActivatingAccount(userDocumentID){
    return showDialog(context: context,
     builder:(context) {
      return AlertDialog(
        title: Text("Activate Account",style: TextStyle(fontSize: 25,letterSpacing:2,fontWeight: FontWeight.bold),),
        content: Text("Do you want to activate this account ?",style: TextStyle(fontSize: 16,letterSpacing:2),),
        actions: [
          ElevatedButton(onPressed:() {
            Navigator.pop(context);
          }, child: Text("No")
          ),
          ElevatedButton(onPressed:() {
            Map<String, dynamic> userDataMap = {
              "status" : "approved",
            };
            FirebaseFirestore.instance.collection("riders").doc(userDocumentID).update(userDataMap).then((value) {
              
              Navigator.push(context, MaterialPageRoute(builder:(context) => HomeScreen(),));
              SnackBar snackBar = SnackBar(content: Text("Activated Successfully.",style: TextStyle(fontSize: 36,color:Colors.black),
              ),
              backgroundColor: Colors.cyan,
              duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }, child:Text("Yes"))
        ],
      );
     },
     );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("riders").where("status",isEqualTo: "not approved")
    .get().then((allVerifiedRiders) {
      setState(() {
        allRiders = allVerifiedRiders;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget displayBlockedRidersDesign(){
      
      if(allRiders != null){
        return ListView.builder(
          itemCount: allRiders!.docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 45,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(allRiders!.docs[index].get("riderAvataUrl")),
                            fit:BoxFit.cover,
                            
                            )
                        ),
                      ),
                      title: Text(allRiders!.docs[index].get("riderName"),style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 24,),
                          Icon(Icons.email,color: Colors.black,),
                          SizedBox(width: 8,),
                          Text(allRiders!.docs[index].get("riderEmail"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed:() {
                          SnackBar snackBar = SnackBar(content: Text("Total Earnings" + "£" + allRiders!.docs[index].get("earnings").toString(),
                          style: TextStyle(fontSize: 36),
                          ),
                          backgroundColor: Colors.black,
                          duration: Duration(seconds: 5),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, icon:Icon(Icons.attach_money_outlined,color: Colors.white,), 
                      label:Text("Total Earnings" + "£" + allRiders!.docs[index].get("earnings").toString(),style: TextStyle(fontSize:15,color: Colors.white,letterSpacing: 3),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green
                      ),
                      
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed:() {
                      displayDialogBoxActivatingAccount(allRiders!.docs[index].id);
                    }, icon:Icon(Icons.person_pin_sharp,color: Colors.white,), 
                    label:Text("Activate this Account",style: TextStyle(fontSize:15,color: Colors.white,letterSpacing: 3),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red
                    ),
                    ),
                    SizedBox(height: 16,)
                  ],
                ),
              ),
            );
          },
        );
      }else{
        return Center(
          child: Text("No Record Found.",style: TextStyle(fontSize:30),),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("All Blocked Riders Accounts",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed:() {
          Navigator.push(context, MaterialPageRoute(builder:(context) => HomeScreen(),));
        }, icon: Icon(Icons.arrow_back)),
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
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: displayBlockedRidersDesign(),
          ),
        ),
      );
  }
}