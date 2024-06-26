
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
import 'package:ppj_coins_app/vehicle_category.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VehicleSelection extends StatefulWidget {
  VehicleSelection({Key? key}) : super(key: key);

  @override
   Vehicle_Select createState() => Vehicle_Select();
}

class Vehicle_Select extends State {
    var shouldPop=false;
    var count;
    late PageController controller;
    late int _selectedIndex;
    Color customColor = Color(0xFF1647AF);
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

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();

    
  }

   Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;

  
  return WillPopScope(
    onWillPop: () async {
      return shouldPop;
    },
    child: Scaffold(
      extendBody: true,


            // Future completed, proceed to build UI
            body: Stack(
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
                                  // borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:ref.read(truewhite).withOpacity(1),
                                    width: MediaQuery.of(context).size.width * 0.002,
                                  ),
                                  color:customColor,
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

                                         
                                            // Handle the onTap action here
                                            // For example, you can navigate back to the previous screen
                                            // Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                            Text(
                                              " Vehicle Selection ", // Replace with your actual title text
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
                         Vehicle_Category(),
                        ],
                      ),
                    )
                  ],
                )
                
              ],
            )
    )
  );
          
  }
  
     

}

class Vehicle_Category extends StatefulWidget {
@override
  Vehicle_CategoryState createState() => Vehicle_CategoryState();
}

class Vehicle_CategoryState extends State{
   String selectedValue = ''; 

  @override
  Widget build(BuildContext context) {
     return SingleChildScrollView(
      child: Column(
       children: [
        SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                        FontAwesomeIcons.vanShuttle,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'SUV',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Radio<String>(
                      value: 'SUV',
                      groupValue: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = 'SUV';
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleCategory(category:selectedValue),
                            ),
                          );
                        });
                      },
  
                    ),
                ),
              ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                      FontAwesomeIcons.carSide,
                      color: Colors.white,
                    ),
                ),
                title: Text(
                  'Car',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                      value: 'Car',
                      groupValue: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value!;
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleCategory(category:selectedValue),
                            ),
                          );
                        });
                      },
                    ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    FontAwesomeIcons.motorcycle,
                  color: Colors.white,
                    ),
                ),
                title: Text(
                  'Motorcycle',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                value: 'Motorcycle',
                groupValue: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!;
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleCategory(category:selectedValue),
                      ),
                    );
                  });
                },
                    ),

              ),
            ),
          ),
           SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                      FontAwesomeIcons.truck,
                      color: Colors.white,
                    ),
                ),
                title: Text(
                  'Lorry',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                value: 'Lorry',
                groupValue: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!;
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleCategory(category:selectedValue),
                      ),
                    );
                  });
                },
                ),
              ),
            ),
          ),
           SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    FontAwesomeIcons.vanShuttle,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'MPV',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                  value: 'MPV',
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleCategory(category:selectedValue),
                        ),
                      );
                    });
                  },
                    ),
              ),
            ),
          ),
           SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    FontAwesomeIcons.ship,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Boat',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                  value: 'Boat',
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleCategory(category:selectedValue),
                      ),
                    );
                    });
                  },
                    ),
              ),
            ),
          ),
           SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    FontAwesomeIcons.helicopter,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Helicopter',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                  value: 'Helicopter',
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleCategory(category:selectedValue),
                      ),
                    );
                    });
                  },
                    ),
              ),
            ),
          ),
           SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    FontAwesomeIcons.truckMonster,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Tank',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                  value: 'Tank',
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleCategory(category:selectedValue),
                      ),
                    );
                    });
                  },
                    ),
              ),
            ),
          ),
           SizedBox(height: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    FontAwesomeIcons.vanShuttle,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'van',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Radio<String>(
                  value: 'van',
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleCategory(category:selectedValue),
                      ),
                    );
                    });
                  },
                    ),
              ),
            ),
          ),
           SizedBox(height: 50),

        //   ElevatedButton(
        //   onPressed: () {
        //      Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => VehicleCategory(category:selectedValue),
        //       ),
        //     );
        //   },
        //   child: Text('Select'),
        // ),

       ]

     ),

     );
     
  }

}