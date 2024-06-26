import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/vehicleCategoryPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPOPage.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPOPageManager.dart';
// import 'package:iFleet_app/home/homepage.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import '../riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/login/roles.dart';

class Order extends ConsumerStatefulWidget {
  const Order({Key? key}) : super(key: key);
  

  @override
  ConsumerState<Order> createState() => _OrderState();
  
}

class _OrderState extends ConsumerState<Order> {
  String roleList ='';

    @override
  void initState(){
    super.initState();
     Future.delayed(Duration.zero, () async {
      String role = await assignRole();
      setState(() {
        roleList = role; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    print(roleList);
    bool isRowVisible = false;
    if(roleList == 'iFMS Manager'){
      isRowVisible = false;
    }else{
      isRowVisible = true;
    }
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 50, right: 50, left: 0.001),
              color: ref.watch(primaryColor),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Loader()));
                    },
                    icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
                    color: ref.read(truewhite),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: h*0.1),
                    child: Text(
                      'Purchase Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     Visibility(
                      //       visible: isRowVisible,
                      //       child: Consumer(builder: (context, ref, child) =>
                      //         Padding(
                      //         padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.0),
                      //         child: InkWell(
                      //           onTap: (){
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => vehicleCategoryPage()));
                      //           },
                      //           child: Container(
                      //             height: h*0.15,
                      //             width: w*1,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //               border: Border.all(
                      //                 color:ref.read(truewhite).withOpacity(1),
                      //                 width: h*0.002
                      //               ),
                      //               color: ref.read(truewhite).withOpacity(0.8),
                      //             ),
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 SizedBox(width: w*0.02,),
                      //                 Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //                     Padding(
                      //                             padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                      //                             child: Row(
                      //                               children: [
                      //                                 Expanded(
                      //                                   child: Text(
                      //                                     'Add Purchase Order',
                      //                                     style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.black),
                      //                                     textAlign: TextAlign.start,
                      //                                     overflow: TextOverflow.ellipsis,
                      //                                   ),
                      //                                 ),
                      //                                 Icon(
                      //                                   Icons.arrow_forward, 
                      //                                   size: h * 0.03,
                      //                                   color: Colors.grey, 
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           ],
                      //                         )
                      //                       ],
                      //                     ),
                      //                   ),
                      //              ),
                      //            ),
                      //         ),
                      //     ),
                      //     ],
                        // ),

                        Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Consumer(builder: (context, ref, child) =>
                            Padding(
                            padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.0),
                            child: InkWell(
                              onTap: (){
                                if(roleList == 'iFMS Manager'){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPageM()));
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));
                                }
                              },
                              child: Container(
                                height: h*0.15,
                                width: w*1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:ref.read(truewhite).withOpacity(1),
                                    width: h*0.002
                                  ),
                                  color: ref.read(truewhite).withOpacity(0.8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: w*0.02,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                                padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'View Purchase Order',
                                                        style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.black),
                                                        textAlign: TextAlign.start,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward, 
                                                      size: h * 0.03,
                                                      color: Colors.grey, 
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                 ),
                               ),
                            ),
                          ],
                        ),
                      
                      ],
                  ),
                ),
              ),
          ],
        ),
      );
  }
}

