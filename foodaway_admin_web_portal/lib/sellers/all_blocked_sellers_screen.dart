import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodaway_admin_web_portal/main%20screens/home_screen.dart';

class AllBlockedSellersScreen extends StatefulWidget {
  const AllBlockedSellersScreen({super.key});

  @override
  State<AllBlockedSellersScreen> createState() => _AllBlockedSellersScreenState();
}

class _AllBlockedSellersScreenState extends State<AllBlockedSellersScreen> {
  @override
  QuerySnapshot? allSellers;

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
            FirebaseFirestore.instance.collection("sellers").doc(userDocumentID).update(userDataMap).then((value) {
              
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
    FirebaseFirestore.instance.collection("sellers").where("status",isEqualTo: "not approved")
    .get().then((allVerifiedUsers) {
      setState(() {
        allSellers = allVerifiedUsers;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget displayBlockedSellersDesign(){
      
      if(allSellers != null){
        return ListView.builder(
          itemCount: allSellers!.docs.length,
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
                            image: NetworkImage(allSellers!.docs[index].get("sellerAvataUrl")),
                            fit:BoxFit.cover,
                            
                            )
                        ),
                      ),
                      title: Text(allSellers!.docs[index].get("sellerName"),style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 24,),
                          Icon(Icons.email,color: Colors.black,),
                          SizedBox(width: 8,),
                          Text(allSellers!.docs[index].get("sellerEmail"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed:() {
                        SnackBar snackBar = SnackBar(content: Text("Total Earnings" + "£" + allSellers!.docs[index].get("earnings").toString(),
                        style: TextStyle(fontSize: 36),
                        ),
                        backgroundColor: Colors.black,
                        duration: Duration(seconds: 5),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }, icon:Icon(Icons.attach_money_outlined,color: Colors.white,), 
                    label:Text("Total Earnings" + "£" + allSellers!.docs[index].get("earnings").toString(),style: TextStyle(fontSize:15,color: Colors.white,letterSpacing: 3),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green
                    ),
                    ),
                    SizedBox(height: 16,),
                    ElevatedButton.icon(
                      onPressed:() {
                      displayDialogBoxActivatingAccount(allSellers!.docs[index].id);
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
        title: Text("All Blocked Selles Accounts",style: TextStyle(color: Colors.white),),
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
            child: displayBlockedSellersDesign(),
          ),
        ),
      );
  }
}