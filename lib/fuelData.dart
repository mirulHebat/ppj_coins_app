
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
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:ppj_coins_app/addService.dart';
import 'dart:async';

class LoaderAddFueldata extends StatefulWidget {
  LoaderAddFueldata({Key? key}) : super(key: key);

  @override
  State<LoaderAddFueldata> createState() => _LoaderState();
}

class _LoaderState extends State<LoaderAddFueldata>  {
  var shouldPop=false;
  var count;
  final findListFuel fList = findListFuel();
  late PageController controller;

   Color customColor = Color(0xFF1647AF);
  late int _selectedIndex;
  Map<String,dynamic> fuel_id={};
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
    // Listview();
    
  }




  Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
          return WillPopScope(
        onWillPop: () async {
          return shouldPop;
        },
        child: Scaffold(
          extendBody: true ,      // Future completed, proceed to build UI
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
                                          Navigator.push
                                          (
                                            context,
                                            MaterialPageRoute
                                            (
                                              
                                              builder: (context) => LoaderFuel(),
                                            ),
                                          );
                                          },
                                        ),
                                      ),
                                            Text(
                                              "Add Fuel Consumption Data ", // Replace with your actual title text
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
                    
                    Expanded(
                      child: PageView(
                        controller: controller,
                        onPageChanged: onPageChanged,
                        children: <Widget>[
                          MyTextFieldUI(fuel_id)
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



class MyTextFieldUI extends StatefulWidget {
 final Map<String,dynamic> veh;

 MyTextFieldUI(this.veh);
  @override
  _MyTextFieldUIState createState() => _MyTextFieldUIState();
}

class _MyTextFieldUIState extends State<MyTextFieldUI> {
  TextEditingController _priceLiterController = TextEditingController();
  TextEditingController _liters_per_hr = TextEditingController();
  TextEditingController liters_per_100km = TextEditingController();
  TextEditingController usage_in_1km = TextEditingController();
  TextEditingController usage_in_hr = TextEditingController();
  TextEditingController cost_per_km = TextEditingController();
  TextEditingController cost_per_hr = TextEditingController();
  TextEditingController  vehiclefield = TextEditingController();
  TextEditingController  max_capacity = TextEditingController();
  TextEditingController  km_liter = TextEditingController();
  String vehicleId="";
  String errorMessage = '';
  bool costusageview=true;
  bool fuel_info_view=true;
  String fuel_title="";
  String fuelll_id="";
  
  @override
  void dispose() 
  {
    _priceLiterController.dispose();
    _liters_per_hr.dispose();
    liters_per_100km.dispose();
    usage_in_1km.dispose();
    usage_in_hr.dispose();
    cost_per_km.dispose();
    cost_per_hr.dispose();
    vehiclefield.dispose();
    max_capacity.dispose();
    km_liter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
     _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    await nilaiFuel();
    setState(() {
      vehiclefield.text = fuel_title;
      vehicleId = fuelll_id;
    });
    print('vehiclefield ${vehiclefield.text}');
  }

 Future<void> nilaiFuel()async {
        findListFuel listfuel=findListFuel();
        Map<String,dynamic> fuelfound =await listfuel.findFuel();
        fuel_title=fuelfound['fuel_title'];
        fuelll_id=fuelfound['fuel_id'];
        print('jsijsei $fuel_title');

  }

 Future<void> _showLoadingDialogFAdd(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60.0,
            color: Color.fromARGB(255, 145, 203, 250),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
              child: Center(
                child: Text(
                  ' Enter Fuel Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
              IconButton(
                icon: Icon(
                fuel_info_view?  Icons.arrow_drop_down: Icons.arrow_right,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {

                      if(fuel_info_view)
                      {
                        fuel_info_view = false;
                      }
                      else
                      {
                        fuel_info_view = true;
                      }
                                                        
                    });
                },
              ),
            ],
          ),

          ),
          
          Visibility(
            visible:fuel_info_view,
          child:
            Column(
              children:[
                Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: vehiclefield,
                          inputFormatters: 
                          [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              UpperCaseTextFormatter(), // Add this formatter
                            ],
                          decoration: InputDecoration(
                             filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Num Plate',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                            enabled: false, 
                            // suffixIcon: IconButton(
                            //   icon: Icon(Icons.search),
                            //   onPressed: () async {
                            //     String vehicletext = vehiclefield.text;
                            //     vehicleId = await findListFuel().findVehicle(vehicletext) ?? ''; 
                            //     print(vehicleId);
                            //     if(vehicleId.isEmpty )
                            //     {
                            //       showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           title: Text('Missing Information'),
                            //           content: Text('Num plate not found.'),
                            //           actions: <Widget>[
                            //             TextButton(
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //                 vehiclefield.clear(); // Close the dialog
                            //               },
                            //               child: Text('OK'),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //     return; 
                            //     }else
                            //     {
                            //       showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           title: Text('Successful'),
                            //           content: Column(
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             Text('Number plate found.'),
                            //             SizedBox(height: 8.0), // Add some space between the lines if needed
                            //             Text('Please proceed to insert Fuel Information'),
                            //           ],
                            //         ),
                            //           actions: <Widget>[
                            //             TextButton(
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //                 // Close the dialog
                            //               },
                            //               child: Text('OK'),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //     return;

                            //     }
                                
                            //   },
                            // ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
                  
              ),
              Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _priceLiterController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        // Calculate liters per 100 km and update litersPer100Km field
                        double kmPerLiter = double.tryParse(km_liter.text) ?? 0.0;
                        double pricePerLiter = double.tryParse(_priceLiterController.text) ?? 0.0; // Calculate liters per km
                        double costPerKm = kmPerLiter != 0 ? pricePerLiter / kmPerLiter : 0.0;
                        double litersPerHour = double.tryParse(_liters_per_hr.text) ?? 0.0;
                        double costPerHour = litersPerHour * pricePerLiter;
                        cost_per_hr.text = costPerHour.toStringAsFixed(2);
                        cost_per_km.text =costPerKm.toStringAsFixed(2);
                      },
                      decoration: InputDecoration(
                        labelText: 'Price Per Liter (RM)',
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red), // Set the error border color to red
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'This field is required'; // Return error message if field is empty or null
                        }
                        return null; // Return null if validation succeeds
                      },
                    ),
                  ),


                ),
                SizedBox(width: 5),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: km_liter,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          double kmPerLiter = double.tryParse(value) ?? 0.0;
                          double litersPerKm = kmPerLiter != 0 ? 1 / kmPerLiter : 0.0;
                          double pricePerLiter = double.tryParse(_priceLiterController.text) ?? 0.0; // Calculate liters per km
                          usage_in_1km.text = litersPerKm.toStringAsFixed(2);
                          double costPerKm = kmPerLiter != 0 ? pricePerLiter / kmPerLiter : 0.0;
                          cost_per_km.text =costPerKm.toStringAsFixed(2);
                        },
                        maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Mileage (KM/L)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _liters_per_hr,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              double pricePerLiter = double.tryParse(_priceLiterController.text) ?? 0.0;
               double litersPerHour = double.tryParse(_liters_per_hr.text) ?? 0.0;
              double costPerHour = litersPerHour * pricePerLiter;
              cost_per_hr.text = costPerHour.toStringAsFixed(2);

            },
              maxLines: null,
            decoration: InputDecoration(
              labelText: 'Liters Per Hour (L)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: liters_per_100km,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Liters per 100KM (L)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
           Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: max_capacity,
              keyboardType: TextInputType.numberWithOptions(decimal: true), // Set maxLines to null to allow unlimited lines
              decoration: InputDecoration(
                labelText: 'Max Capacity in Liters (L)',
                border: OutlineInputBorder(),
              ),
            ),
          ),

              ],
            ),
            
          ),
          
          
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60.0,
            color: Color.fromARGB(255, 145, 203, 250),
            child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
              child: Center(
                child: Text(
                  'Cost And Usage ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
              IconButton(
                icon: Icon(
                  costusageview? Icons.arrow_drop_down:Icons.arrow_right,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                      if(costusageview)
                      {
                        costusageview = false;
                      }
                      else
                      {
                        costusageview = true;
                      }
                                                        
                    });
                },
              ),
            ],
          ),

            
            
          ),

          Visibility(
            visible:costusageview,
            child:Column(
              children:[
                Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: usage_in_1km,
                  enabled: false, // Disable the TextField
                  style: TextStyle(color: Colors.black), // Set text color to gray
                  decoration: InputDecoration(
                    labelText: 'Usage in 1KM (L)',
                    labelStyle: TextStyle(color: Colors.black), // Set label color to black
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey[200], // Set background color to gray
                    filled: true,
                  ),
                ),
              ),

               Row(
                children: [
                  Expanded(

                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: cost_per_km,
                        enabled: false,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Cost per KM (RM)',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.grey[200], // Set background color to gray
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: cost_per_hr,
                        enabled: false,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Cost Per Hour (RM)',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.grey[200], // Set background color to gray
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


            ],) ,
            ),
          


         
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: ()async {
              _showLoadingDialogFAdd(context);
                if (vehiclefield.text.isEmpty) {
                // Show a dialog box indicating that all fields are required
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Missing Information'),
                      content: Text('No plate are required.'),
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
              String vehicle_text=vehiclefield.text.replaceAll(' ', '');
              String priceLiter = _priceLiterController.text.isEmpty ? "0.00" : _priceLiterController.text;
              String literHr = _liters_per_hr.text.isEmpty ? "0.00" : _liters_per_hr.text;
              String literKm = liters_per_100km.text.isEmpty ? "0.00" : liters_per_100km.text;
              String usage_in_1 = usage_in_1km.text.isEmpty ? "0.00" : usage_in_1km.text;
              String usageinhr = usage_in_hr.text.isEmpty ? "0.00" : usage_in_hr.text;
              String cost_perkm = cost_per_km.text.isEmpty ? "0.00" : cost_per_km.text;
              String cost_perhr = cost_per_hr.text.isEmpty ? "0.00" : cost_per_hr.text;
              String max = max_capacity.text.isEmpty ? "0.00" : max_capacity.text;
              String km_lite = km_liter.text;
                Map<String, dynamic> resultMap = await findListFuel().createList(vehicle_text, priceLiter, literHr, literKm,usage_in_1,usageinhr,cost_perkm,cost_perhr,max,km_lite);
                String title_fe=resultMap['title'];
                String itemId_fe=resultMap['itemId'];
              
                String fuel_type_id = await findListFuelType().createList(vehicle_text, itemId_fe, vehicleId,"");               
                  Timer(Duration(seconds: 5), () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoaderFDetail(itemId: fuel_type_id),
                      ),
                    );
                  });
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

class findListFuel
{


Future<Map<String, String>> createList(String title,String priceLiter,String literHr,String literKm,String usage_in_1km,String usage_in_hr,String cost_per_km,String cost_per_hr,String max,String km_lite) async {
  print('point kat sini');
  print(cost_per_hr);
  print(max);
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';


  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-e01c1454a6534723b73b71782b321ebc","item_id":"","title":"'+title+'","price_per_liter":"'+priceLiter+'","liters_max_capacity":'+max+',"liters_per_hr":"'+literHr+'","liters_per_100km":'+literKm+',"km_per_liters":"'+km_lite+'","usage_in_km":'+usage_in_1km+',"cost_per_km":'+cost_per_km+',"cost_per_hr":'+cost_per_hr+'""}'+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  // body: usell,
  // ?param=$usell

  if (response.statusCode == 200) {

    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
          String itemId = result['item_id'];
          String title = result['title'];
         Map<String, String> resultMap = 
         {
            'itemId': itemId,
            'title': title
         };
       print('result create ftfe');
       print(result);
        return resultMap;

    } else {

        throw Exception('Error: ${result['message']}');


    }
  } else {
    print('fail');
    return {};
    // Handle the case where the request failed
// Return 0 if request failed
  }
}

Future<Map<String,dynamic>> findFuel()async{
    String fuel_name="";
    String fuel_id="";
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String userId = userDetails.isNotEmpty ? userDetails[1] : '';
     http.Response response;
     var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"(user_id = &quot;$userId&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["va001"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date" ,"metadata"]'+
      '}');
      Map<String, String> headersModified = {};
         headersModified['cookie'] = userDetails[3];
      

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

      if (response.statusCode == 200){
         Map<String, dynamic> result = json.decode(response.body);
         print(result);
         if (result['success'] == true){
          List<dynamic> results = result['results'];
          for(var result in results)
          {  
             Map<String,dynamic> metadata=result['metadata'];
             String date_end=metadata['ended_at'] ??"";
              List<String> dateParts = date_end.split('/');
              int day = int.parse(dateParts[0]);
              int month = int.parse(dateParts[1]);
              int year = int.parse(dateParts[2]);
              DateTime date = DateTime(year, month, day);
              DateTime currentDate = DateTime.now();
              if(currentDate.isAfter( date))
              {
                print('no $date_end');
              }else
              {
                Map<String,dynamic> vehicle = metadata['container_id'];
                if(vehicle !=null)
                {
                  fuel_name=vehicle['title'];
                  fuel_id=vehicle['item_id'];


                }

              }

          }
           Map <String,dynamic> mapping={
           'fuel_title':fuel_name,
           'fuel_id':fuel_id


           };
          return mapping;

         }
         else
         {
          return {};
         }

      }
      else
      {
        return {};
      }

 }

Future<String> findVehicle(String vehicletitle) async {
    print('vehicle Name: $vehicletitle');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
   String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
   print(user_session_id);

  // Check if the userDetails list is not empty and has at least one element


  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"query":"( user_id = &quot;'+user_session_id+'&quot; )",'+
    '"action":"ADVANCED_SEARCH",'+
    '"item_type_codes":["va001"],'+
    '"sort_field":"",'+
    '"sort_order":"ASC",'+
    '"details":["item_id","metadata"]'+
  '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);


  if (response.statusCode == 200) {
    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
    print('checkpoint vehicle id');
    List< dynamic>results = result['results'] ?? [];
     String vehicleId ="";
    for (var item in results){
      Map<String, dynamic> metadata = item['metadata'];
      String title = metadata['title'];
     
      if (title == vehicletitle)
      {
        Map<String, dynamic> containerId = metadata['container_id'];
         vehicleId =containerId['item_id'];
         return vehicleId;
        
      }
    }
    return vehicleId;
    
   } else {
       print("failed vehicle id");
      return "";


    }
  } else {
    return "";
    // Handle the case where the request failed
// Return 0 if request failed
  }
}

Future<String> findVehicleName(String vehicletitle,String category) async {
    print('vehicle Name: $vehicletitle');
    print(category);
    String code_type="";
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
   String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
   print(user_session_id);
   String vehicle_code="";

   
  // Check if the userDetails list is not empty and has at least one element


  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"query":"( title = &quot;$vehicletitle&quot; )",'+
    '"action":"ADVANCED_SEARCH",'+
    '"item_type_codes":["vc001"],'+
    '"sort_field":"",'+
    '"sort_order":"ASC",'+
    '"details":["item_id","metadata"]'+
  '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);


  if (response.statusCode == 200) {
    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
    print('checkpoint vehicle id');
    List< dynamic>results = result['results'] ?? [];
    print(results);
    String vehicleId="";

    for (var item in results){
       vehicleId =item['item_id'];
      Map<String, dynamic> metadata = item['metadata'];
      print('nilai ncnr $vehicleId');
      return vehicleId;
    
    }
    return vehicleId;
    
   } else {
       print("failed vehicle id");
      return "";


    }
  } else {
    return "";
    // Handle the case where the request failed
// Return 0 if request failed
  }
}

Future<List<Map<String,dynamic>>> findDriver(String drivertext) async {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"query":"( title LIKE  &quot;'+drivertext+'&quot; )",'+
    '"action":"ADVANCED_SEARCH",'+
    '"item_type_codes":["cn002"],'+
    '"sort_field":"",'+
    '"sort_order":"ASC",'+
    '"details":["item_id","metadata"]'+
  '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);


  if (response.statusCode == 200) {
    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
    print('checkpoint vehicle id');
    List< dynamic>results = result['results'] ?? [];
     String vehicleId ="";
     print('result');
     print(result);
     List<Map<String,dynamic>> hello=[];
     Map<String,dynamic>world ={};
    for (var item in results){
      Map<String, dynamic> metadata = item['metadata'];
      String title = metadata['title'];
      print('result');
      print(result);
      print(title);
      print(drivertext);
      String titleWithoutSpaces = title.replaceAll(' ', '');
      String drivertextWithoutSpaces = drivertext.replaceAll(' ', '');
     
      if (titleWithoutSpaces.contains(drivertextWithoutSpaces))
      {
         vehicleId =item['item_id'];
        
        
      }
      world={
        'title':title,
        'vehicleId':vehicleId
      };
      hello.add(world);
    }
    return hello;
    
   } else {
       print("failed vehicle id");
      return [];


    }
  } else {
    return [];
  }
}

}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
