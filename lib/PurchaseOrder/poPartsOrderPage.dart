import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:iFleet_app/PurchaseOrder/purchaseOrderPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPO.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';

class POPartsPageOrder extends ConsumerStatefulWidget {
  final String POTitle;
  final String POid;
  const POPartsPageOrder({super.key, required this.POTitle, required this.POid});
  
  

  @override
  ConsumerState<POPartsPageOrder> createState() => _POPartsPageOrderState();
  
}

class _POPartsPageOrderState extends ConsumerState<POPartsPageOrder> {
  @override
  void initState(){
    super.initState();
  }

    @override
  void dispose() {
    super.dispose();
  }

String title = '';
String id = '';
String part = '';
String quantity = '';
String cost = '';
String total = '';
final formatter = NumberFormat('#,###');
final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    print('yehawww');
    final partsList = ref.read(poList);
    print(partsList);
    
    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(50),
                    color: ref.watch(primaryColor),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref.read(shouldIrb.notifier).state =true;
                            Navigator.pop(context);
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderPage(title: widget.POTitle, id: widget.POid)));
                            // String route1 = (context) => purchaseOrderPage(title: widget.POTitle, id: widget.POid);
                            // Navigator.pushNamedAndRemoveUntil(context, MaterialPageRoute(builder: (context) => purchaseOrderPage(title: widget.POTitle, id: widget.POid)),(Route<dynamic> route) => false);
                          },
                          icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
                          color: ref.read(truewhite),
                        ),
                        Text(
                          'Items',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  partsList.isNotEmpty ?
                  Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: partsList.length, 
                      itemBuilder: (context, index) {
                        var item =partsList[index];
                        id = item['part_id'];
                        part = item['disp_part_id'];
                        quantity = item['quantity'];
                        cost = item['unit_cost'];
                        total = item['subtotal'];
                        if (index < partsList.length) {
                          return Card(
                            elevation: 10, 
                            margin: EdgeInsets.all(8), 
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Part Name: ',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              '$part',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                              softWrap: true,
                                            ),
                                            Spacer(),
                                            // PopupMenuButton<int>(
                                            //       icon: IconTheme(
                                            //           data: IconThemeData(
                                            //             size: h*0.02, // Specify the desired size here
                                            //           ),
                                            //           child: Icon(Icons.more_vert, color: Colors.black),
                                            //         ),
                                            //       onSelected: (int result) async{
                                            //         // Handle the selection of the menu items here
                                            //         switch (result) {
                                            //           case 0:
                                            //             // Handle option 1
                                            //             List<dynamic> ids = [];
                                            //             ids.add(item['id_POLI']);
                                            //             await PurchaseOrder().deleteItems(ids);
                                            //             partsList.removeWhere((item) => ids.contains(item['id_POLI']));
                                            //             print('here in parts list');
                                            //             print(partsList);
                                            //             ref.invalidate(poList);
                                            //             ref.read(poList.notifier).state = partsList;
                                            //             setState(() {});
                                            //             break;
                                            //         }
                                            //       },
                                            //       itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                            //         PopupMenuItem<int>(
                                            //           value: 0,
                                            //           child: Text('Delete'),
                                            //         ),
                                            //   ],
                                            // ),
                                        
                                          ]
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Quantity: ',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              formatter.format(int.parse(quantity)),
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Unit Cost: ',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              currencyFormat.format(double.parse(cost)),
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Subtotal: ',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              currencyFormat.format(double.parse(total)),
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          );
                        } else {
                          return Container(); 
                        }
                      },
                    ),
                  ),
                ) :
                Expanded(child: Text('No Item is Found'))
                  
                ],
              ),
            ); 
  }
}
