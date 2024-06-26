import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:ppj_coins_app/home/homepage.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'dart:convert';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import '../riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/add_vehicle.dart';
import 'package:ppj_coins_app/Assignment.dart';
import 'package:ppj_coins_app/license_detail.dart';
import 'package:ppj_coins_app/sample.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class License_info extends StatefulWidget {
  final String itemId; 
  License_info({Key? key,required this.itemId}) : super(key: key);

  @override
   State<License_info>  createState() => License_info_state();

}


class License_info_state extends  State<License_info>{
   var shouldPop=false;
   late PageController controller;
  late int _selectedIndex;
  String role_assign="";
  bool showEditButton = true;
   ContactData Contact = ContactData(expired_date: "", license_num: "", license_class: "",image: "",fleetData: "");
    picture pic =picture();
    Color customColor = Color(0xFF1647AF);
    // File? imageFile;
    void _onItemTapped(int index) {
    setState(() {

      if (controller.hasClients) {
        controller.jumpToPage(
          index,
        );
      }
    });
  
     
  }

   void onPageChanged(int pagenum) {
    setState(() {
      _selectedIndex = pagenum;
    });
  }

  

  Future<void> License_View() async
  {
    final findContact fContact = findContact();
    Contact=await fContact.createContact(widget.itemId);
      await getRoleLic();
      if(role_assign =="iFMS Manager")
      {
        showEditButton=false;
      }

   }

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
  
   
  }

    Future<void> getRoleLic()async
  {
      findListWork assign =findListWork();
      role_assign =await assign.assignRole();

  }



     Widget build(BuildContext context){
      var w = MediaQuery.of(context).size.width;
      var h = MediaQuery.of(context).size.height;


       return WillPopScope
       (
            onWillPop: () async {
              return shouldPop;
            },
                child: Scaffold(
                extendBody: true,


            // Future completed, proceed to build UI
            body:FutureBuilder(
            future: License_View(),
            builder: (context, snapshot){
               if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(), // Display a loading indicator while waiting for the future to complete
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'), // Display an error message if the future completes with an error
                );
              }else {
              return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: h*0.05,),
                            Consumer(builder: (context, ref, child) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.00 ,left: w*0.0,right: w*0.0),
                                      child: Container(
                                        height: h*0.12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truewhite).withOpacity(1),
                                            width: MediaQuery.of(context).size.width * 0.002,
                                          ),
                                          color: customColor
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                padding: EdgeInsets.only(right: w * 0.02), // Adjust the right padding as needed
                                                child: IconButton(
                                                  icon: Icon(
                                                    FontAwesome5.arrow_circle_left,
                                                    color: Colors.white,
                                                    size: h * 0.02,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                  },
                                                ),
                                              ),
                                                    Text(
                                                      " License Detail Information ", // Replace with your actual title text
                                                      style: TextStyle(fontSize: h * 0.03, fontWeight: FontWeight.bold, color: Colors.white), // Customize the style as needed
                                                    ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            ),
                            // SizedBox(height: h*0.02,),
                            
                            Expanded(
                              child: PageView(
                                controller: controller,
                                onPageChanged: onPageChanged,
                                children: <Widget>[
                                  Info_License(licenseInfo :Contact,showEditButton:showEditButton)

                                ],
                              ),
                            )
                          ],
                        )
                        
                      ],
                    );
              }

            },

            ),

                                 
    )


       );


   }
}

class Info_License extends StatelessWidget{
  final ContactData licenseInfo;
  final bool showEditButton;
  Info_License({required this.licenseInfo,required this.showEditButton});
    @override
        Widget build(BuildContext context)   
    { UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];
      }
      print(showEditButton);
        return Center(
          child: Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              child: Container(
                color: Color.fromARGB(255, 23, 49, 70), // Background color
                padding: EdgeInsets.all(8.0), 
                child: Container(
                color: Colors.white, // Background color for inner container
                padding: EdgeInsets.all(16.0), 
                 child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    color: Color.fromARGB(255, 145, 203, 250),
                    child: Center(
                      child: Text(
                        'License Information',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'License Expired Date:  ${licenseInfo.expired_date}',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  Text(
                    'License Class:  ${licenseInfo.license_class}',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  Text(
                    'License Number:  ${licenseInfo.license_num}',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                   Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    color: Color.fromARGB(255, 145, 203, 250),
                    child: Center(
                      child: Text(
                        'License Image',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                    Column(
                    children: <Widget>[
 

                  Container(
                    alignment: Alignment.center,
                    child: licenseInfo.image.isNotEmpty
                      ? Image.network(
                          '${licenseInfo.image}?param=${Uri.encodeQueryComponent('{"bims_access_id" : "${licenseInfo.fleetData}"}')}',
                          headers: headersModified,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : SizedBox.shrink(), // Use SizedBox.shrink() to show nothing if the image is empty
                  )


                    

                    ],
                  ),

                  Align(
                  alignment: Alignment.center,
                  child: Visibility(
                     visible: showEditButton, 
                    child: ElevatedButton(
                    onPressed: () async {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => License_detail(licenseData: licenseInfo), // Replace SecondScreen with the destination screen
                        ),
                      );
                    },
                    child: Text('Edit'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                    ),
                  ),

                  ),
                  
                )


                ],
                ),
               
                    // Column(
                    //   children: licenseInfo.map((item) { 
                       
                    //     return Container(
                    //       margin: EdgeInsets.symmetric(vertical: 4.0),
                    //       padding: EdgeInsets.all(8.0), // Padding for each item container
                    //       color: Colors.white, // Background color for each item container
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start, // Align data to the left
                    //         children: [
                    //           // Text(
                    //           //   'Fuel Type', // Title
                    //           //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    //           // ),
                    //            Row(
                                
                    //             children: [
                    //               Text(
                    //                 'License Information', // Title
                    //                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), // Larger font size
                    //               ),
                    //             ],
                    //           ),
                    //           Divider(),
                    //           SizedBox(height: 10),
                    //           Text(
                    //             // 'Title: ${item.titleFT}',
                    //              'Num Plate: ${item.expired_date}',
                    //             style: TextStyle(fontSize: 18.0),
                    //           ),
                    //           Text(
                    //             // 'Title: ${item.titleFT}',
                    //              'Full Name: ${item.license_class}',
                    //             style: TextStyle(fontSize: 18.0),
                    //           ),
                    //           Text(
                    //             // 'Item Number: ${item.item_number}',
                    //             'Initial Mileage (KM): ${item.license_num}',
                    //             style: TextStyle(fontSize: 18.0),
                    //           ),

                    //         ],
                    //       ),
                    //     );
                        
                    //    }).toList(),

                    // ),

                    // SizedBox(height: 16),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: licenseInfo
                    //       .where((item) => item.submit_ind != "true")
                    //       .map((item) => ElevatedButton(
                    //             onPressed: () {
                    //               // Navigator.push(
                    //               //   context,
                    //               //   MaterialPageRoute(
                    //               //     builder: (context) =>
                    //               //         //LoaderEditVehdata(vehiclId:assign_Id,editAssign:item_sign),
                    //               //   ),
                    //               // );
                    //             },
                    //             child: Text('Edit'),
                    //               style: ButtonStyle(
                    //               backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
                    //               foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                    //             ),
                    //           ))
                    //       .toList(),
                    // ),
                    // Add some space between the text and the button
                  
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    );
    }


}

