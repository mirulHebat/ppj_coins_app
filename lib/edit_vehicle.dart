
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
import 'package:ppj_coins_app/addFuel.dart';
import 'package:ppj_coins_app/add_vehicle.dart';
import 'package:ppj_coins_app/Assignment.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class LoaderEditVehdata extends StatefulWidget {
  final String vehiclId;
  List <ItemAssign> editAssign;
  LoaderEditVehdata({Key? key, required this.vehiclId,required this.editAssign}) : super(key: key);

  @override
   State<LoaderEditVehdata>  createState() => _LoaderStateEditVeh();
}

class _LoaderStateEditVeh extends  State<LoaderEditVehdata> {
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
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:ref.read(truewhite).withOpacity(1),
                                    width: MediaQuery.of(context).size.width * 0.002,
                                  ),
                                  color: customColor,
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
                                              "Edit Vehicle Assignment Data ", // Replace with your actual title text
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
                         WidgetVeh(editAssign:widget.editAssign, vehId:widget.vehiclId),
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

class WidgetVeh extends StatefulWidget {
    List <ItemAssign> editAssign;
    final String vehId;
      WidgetVeh({Key? key, required this.editAssign, required this.vehId}) : super(key: key);
@override
   State<WidgetVeh>  createState() => WidgetVehicleState();
}

class WidgetVehicleState extends State<WidgetVeh>
{
    TextEditingController _No_Plate_Controller = TextEditingController();
  TextEditingController _init_Controller = TextEditingController();
  TextEditingController _final_Controller = TextEditingController();
  TextEditingController veh_information = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  String veh_info_="";

   @override
  void dispose() 
  {
     _No_Plate_Controller.dispose();
    _init_Controller.dispose();
    _final_Controller.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    veh_information.dispose();
     super.dispose();

  }

    @override
  Widget build(BuildContext context) {
     _startDateController.text=widget.editAssign.isNotEmpty ? widget.editAssign[0].started_at : '';
     _endDateController.text=widget.editAssign.isNotEmpty ? widget.editAssign[0].ended_at : '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              color: Color.fromARGB(255, 145, 203, 250),
              child: Center(
                child: Text(
                  'Edit Assignment Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                        TextFormField(
                      inputFormatters: 
                     [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        UpperCaseTextFormatter(), // Add this formatter
                      ],
                      initialValue: widget.editAssign.isNotEmpty ? widget.editAssign[0].no_plate : '',
                        onChanged: (value) {
                        // Update the controller's text when user types
                        veh_information.text = value;
                      },
                    decoration: InputDecoration(
                      labelText: 'Num Plate',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                           String vehicletext = veh_information.text;
                           veh_info_ = await findListFuel().findVehicle(vehicletext) ?? ''; 
                           print(veh_info_);
                           if(veh_info_.isEmpty )
                          {
                            showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Missing Information'),
                                content: Text('Number plate not found.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      veh_information.clear(); // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return; 
                          }else
                          {
                             showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Successful'),
                                content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Number plate found.'),
                                  SizedBox(height: 8.0), // Add some space between the lines if needed
                                  Text('Please proceed to insert Fuel Information'),
                                ],
                              ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      veh_information.clear(); // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;

                          }
                        },
                      ),
                    ),
                  ),
                
                SizedBox(height: 10), 
                TextFormField(
                  initialValue: widget.editAssign.isNotEmpty ?widget.editAssign[0].full_name : '',
                  enabled: false, // Disable the TextField
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey[200], // Set background color to gray
                    filled: true,
                  ),
                ),
                SizedBox(height: 10), // Add some space between the text field and date fields
                Row(
                children: [
                  Expanded(
                    child: Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: TextFormField(
                      readOnly: true, 
                      // initialValue: widget.editAssign.isNotEmpty ? widget.editAssign[0].started_at : '',
                      // onChanged: (value) {
                      //   // Update the controller's text when user types
                      //   _startDateController.text = value;
                      // },
                       controller: _startDateController,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                      // Show date picker when text field is tapped
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      // Update the text field's value if a date is selected
                      if (selectedDate != null) {
                        // setState(() {
                          _startDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                          return;
                        // });
                         
                      }
                    },

                    ),
                  ),

                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: TextFormField(
                      readOnly: true, 
                      // initialValue: widget.editAssign.isNotEmpty ? widget.editAssign[0].ended_at : '',
                      // onChanged: (value) {
                      //   // Update the controller's text when user types
                      //   _endDateController.text = value;
                      // },
                      controller:_endDateController ,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                      // Show date picker when text field is tapped
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      // Update the text field's value if a date is selected
                      if (selectedDate != null) {
                        // setState(() {
                          _endDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                          return;
                        // });
                      }
                    },
                      ),
                    ),
                  ),
                ],
              ),

              ],
            ),
          ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                initialValue: widget.editAssign.isNotEmpty ? widget.editAssign[0].init_mile : '',
                onChanged: (value) {
                  // Update the controller's text when user types
                  _init_Controller.text = value;
                },
                decoration: InputDecoration(
                  labelText: 'Initial Mileage (KM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                initialValue: widget.editAssign.isNotEmpty ? widget.editAssign[0].final_mile : '',
                onChanged: (value) {
                  // Update the controller's text when user types
                  _final_Controller.text = value;
                },
                decoration: InputDecoration(
                  labelText: 'Final Mileage (KM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 20), // Add some space between the text fields and the button
            ElevatedButton(
              onPressed: ()async {
               
              String No_Plate = veh_information.text.isEmpty ? widget.editAssign[0].no_plate : veh_information.text;
              String init = _init_Controller.text.isEmpty ? widget.editAssign[0].init_mile : _init_Controller.text;
              String final_mil = _final_Controller.text.isEmpty ? widget.editAssign[0].final_mile : _final_Controller.text;
              String start_at = _startDateController.text.isEmpty ? widget.editAssign[0].started_at : _startDateController.text;
              String end_at =_endDateController.text.isEmpty ? widget.editAssign[0].ended_at : _endDateController.text;
              String FullName = widget.editAssign.isNotEmpty ?widget.editAssign[0].full_name : '';

              if(veh_info_ =="")
              {
                veh_info_= await findListFuel().findVehicle( widget.editAssign.isNotEmpty ? widget.editAssign[0].no_plate : '') ?? ''; 
              }
              String assign_id= await Vehicle_Save().savingVeh(No_Plate,init,final_mil,veh_info_,start_at,end_at,widget.vehId,FullName);
                Timer(Duration(seconds: 5),(){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoaderAssign_detail(itemId:assign_id), // Replace SecondScreen with the destination screen
                ),
              );

              });
                // Add your save logic here
              },
              child: Text('Save'),
               style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
            ),
            ),
          ],
        ),
      ),
    );
  }

}