
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
import 'package:ppj_coins_app/lib/Assignment.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'dart:async';
import 'package:intl/intl.dart';



class LoaderAddVehdata extends StatefulWidget {
  final String vehicle_id;
  final String title;
  final String category;
  LoaderAddVehdata({Key? key, required this.vehicle_id,required this.title,required this.category}) : super(key: key);

  @override
   _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<LoaderAddVehdata> {
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
  print('here');

  
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
                                              "Add Vehicle Assignment Data ", // Replace with your actual title text
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
                          WidgetVehicle(vehicle_id: widget.vehicle_id,title :widget.title,category:widget.category),
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


class WidgetVehicle extends StatefulWidget {
  final String  vehicle_id;
  final String title;
  final String category;
   WidgetVehicle({Key? key, required this.vehicle_id, required this.title,required this.category}) : super(key: key);
@override
  WidgetVehicleState createState() => WidgetVehicleState();
}

class WidgetVehicleState extends State<WidgetVehicle>
{
    TextEditingController _No_Plate_Controller = TextEditingController();
  TextEditingController _init_Controller = TextEditingController();
  TextEditingController _final_Controller = TextEditingController();
  TextEditingController veh_info = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  String veh_info_="";

   @override
  void dispose() 
  {
     _No_Plate_Controller.dispose();
    _init_Controller.dispose();
    _final_Controller.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    fullNameController.dispose();
    veh_info.dispose();
     super.dispose();

  }

    @override
  Widget build(BuildContext context) {
       UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String Full_name = userDetails.isNotEmpty ? userDetails[6] : '';
      veh_info.text=widget.title;
      veh_info_ =widget.vehicle_id;
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
                  'Enter Assignment Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                 TextField(
                     controller: veh_info,
                       inputFormatters: 
                     [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        UpperCaseTextFormatter(), // Add this formatter
                      ],
                    decoration: InputDecoration(
                      labelText: 'Num Plate',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                           String vehicletext = veh_info.text;
                           if(vehicletext !="")
                           {
                            veh_info_ = await findListFuel().findVehicleName(vehicletext,"") ?? ''; 
                           }

                           print(veh_info_);
                          if(veh_info_.isEmpty )
                          {
                            showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Missing Information'),
                                content: Text('Num plate not found.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      veh_info.clear(); // Close the dialog
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
                                      // Close the dialog
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
                    initialValue: Full_name,
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
                    child: TextField(
                      readOnly: true, 
                      // Start date field
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
                        setState(() {
                          _startDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                        });
                      }
                    },

                    ),
                  ),

                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: TextField(
                        readOnly: true, 
                        // End date field
                        controller: _endDateController,
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
                        setState(() {
                          _endDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                        });
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
              child: TextField(
                controller: _init_Controller,
                decoration: InputDecoration(
                  labelText: 'Initial Mileage (KM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _final_Controller,
                decoration: InputDecoration(
                  labelText: 'Final Mileage (KM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(height: 20), // Add some space between the text fields and the button
            ElevatedButton(
              onPressed: () async{
                //  String vehicletext = veh_info.text;
                // if(vehicletext !="")
                // {
                // veh_info_ = await findListFuel().findVehicleName(vehicletext,widget.category) ?? ''; 
                // }
                if (veh_info.text.isEmpty && _init_Controller.text.isEmpty) {
                // Show a dialog box indicating that all fields are required
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Missing Information'),
                      content: Text('Num plate are required.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return; // Exit the function early
              }
              String No_Plate = veh_info.text;
              String init = _init_Controller.text;
              String final_mil = _final_Controller.text;
              if(final_mil =="")
              {
                final_mil="0";
              }
              String start_at =_startDateController.text;
              String end_at = _endDateController.text;
              print('date');
              print(start_at);
              print(end_at);
              print(veh_info_);
              String assign_id= await Vehicle_Save().savingVeh(No_Plate,init,final_mil,veh_info_,start_at,end_at,"",Full_name);
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



class Vehicle_Save
{
   Future<String> savingVeh(String no_plate,String init,String final_mil,String veh_info,String start_at,String end_at,String vehId,String Fullname) async
  {
      print(vehId);
      print(no_plate);
      print(veh_info);
      print(Fullname);

      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String id_user = userDetails.isNotEmpty ? userDetails[1] : '';
      String contactId= await findContact(Fullname);
      print(contactId);



      String metadata;
      if (vehId.isEmpty) 
      {
        print('niascdc');
        metadata ='"metadata":{"item_type_id":"ityp-2662e8be34ca40aba7ad5e3f38c361b0","item_id":"","container_id":"'+veh_info+'","item_type_id_container_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","title":"'+no_plate+'","contact_name":"'+contactId+'","item_type_id_contact_name":"ityp-11962a26708945e0a67be504cf31def6","disp_contact_name":"'+Fullname+'","user_id":"'+id_user+'","current":{"code":"true","value":"true","display":"Yes"},"future":{"code":"false","value":"false","display":"No"},"started_at":"'+start_at+'","starting_meter_entry_value":'+init+',"ended_at":"'+end_at+'","ending_meter_entry_value":'+final_mil+'}';
      }else
      {
        print('cdvdfvdfv');
         metadata ='"metadata":{"item_type_id":"ityp-2662e8be34ca40aba7ad5e3f38c361b0","item_id":"'+vehId+'","container_id":"'+veh_info+'","item_type_id_container_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","title":"'+no_plate+'","contact_name":"'+contactId+'","item_type_id_contact_name":"","disp_contact_name":"","user_id":"'+id_user+'","current":{"code":"true","value":"true","display":"Yes"},"future":{"code":"false","value":"false","display":"No"},"started_at":"'+start_at+'","starting_meter_entry_value":'+init+',"ended_at":"'+end_at+'","ending_meter_entry_value":'+final_mil+'}';
      }


      http.Response response;
        var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"action":"SAVE_ITEM",'+
        metadata+
        '}');
        
        Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];
      }

      response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

      if (response.statusCode == 200){

        Map<String, dynamic> result = json.decode(response.body);

        if (result['success'] == true){
          print(result);
           String itemId = result['item_id'];
           return itemId;

        }else
        {
         throw Exception('Error: ${result['message']}');

        }

      }
      else
      {
        print('statuscode fail');
         return "";
      }

  }

  Future<String> findContact(String fullname) async
  {
    print('fullname');
     String vehicleText =fullname.toUpperCase();
     print(vehicleText);
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String id_user = userDetails.isNotEmpty ? userDetails[1] : '';

      http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["cn002"],'+
        '"sort_order":"ASC",'+
        '"query":"( title LIKE &quot;'+vehicleText+'&quot; )",'+
        '"details":["item_id","item_number","title","registered_date","checkout_ind","checkin_ind","favourite_ind","content_id","item_type_id","item_type_title","item_type_icon","item_type_icon_color","child_count","has_doc_store","has_related_item","field_item_list"],'+
        '}');


      Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];
      }

      response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);

         if (response.statusCode == 200){

        Map<String, dynamic> result = json.decode(response.body);

        if (result['success'] == true){
          print(result);
           String itemId = result['results'][0]['item_id'];
            return itemId;

        }else
        {
         throw Exception('Error: ${result['message']}');

        }

      }
      else
      {
        print('statuscode fail');
          return Future.value("");
      }




  }

}
