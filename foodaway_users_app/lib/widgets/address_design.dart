import 'package:flutter/material.dart';
import 'package:foodaway_users_app/assistantMethods/address_changer.dart';
import 'package:foodaway_users_app/assistantMethods/total_amount.dart';
import 'package:foodaway_users_app/mainScreens/palced_order_screen.dart';
import 'package:foodaway_users_app/maps/maps.dart';
import 'package:foodaway_users_app/models/address.dart';
import 'package:provider/provider.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const AddressDesign
      ({
        super.key,
        this.model,
        this.currentIndex,
        this.value,
        this.addressID,
        this.totalAmount,
        this.sellerUID
      });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // select this address
        Provider.of<AddressChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    value: widget.value, 
                    groupValue: widget.currentIndex,
                    onChanged:(value) 
                    {
                      // provider
                      Provider.of<AddressChanger>(context,listen: false).displayResult(value);
                      print(value);
                    },
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Container(
                        padding:EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Table(
                          children: [
                            TableRow(
                              children:[
                                Text('Name: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text(widget.model!.name.toString())
                              ]
                            ),
                            TableRow(
                              children:[
                                Text('Phone Number: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text(widget.model!.phoneNumber.toString())
                              ]
                            ),
                            TableRow(
                              children:[
                                Text('Flat Number: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text(widget.model!.flatNumber.toString())
                              ]
                            ),
                            TableRow(
                              children:[
                                Text('city: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text(widget.model!.city.toString())
                              ]
                            ),
                            TableRow(
                              children:[
                                Text('state: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text(widget.model!.state.toString())
                              ]
                            ),
                            TableRow(
                              children:[
                                Text('Full Address: ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text(widget.model!.fullAddress.toString())
                              ]
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ],
            ),
            ElevatedButton(
                  onPressed:() {
                    MapUtils.openMapWithPosition(double.parse(widget.model!.lat!), double.parse(widget.model!.lng!));
                }, child: Text('Check on Maps'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black54
                ),
                
                ),
                // button
                widget.value == Provider.of<AddressChanger>(context).count?
                ElevatedButton(onPressed:() {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => PlacedOrderScreen(
                    addressID: widget.addressID,
                    totalAmount: widget.totalAmount,
                    sellerUID: widget.sellerUID,
                  ),));
                }, child: Text('Proceed'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                ),
                ) : Container(child: Center(child: Text('not proceeded'),),),
                SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}