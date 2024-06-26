
import 'dart:ffi';
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
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:ppj_coins_app/editFuelData.dart';

class LoaderEdit extends StatefulWidget {
  final String itemId;

  LoaderEdit({Key? key, required this.itemId}) : super(key: key);
    // LoaderAddFuel({Key? key}) : super(key: key);

  @override
  State<LoaderEdit> createState() => _LoaderState();
}

class _LoaderState extends State<LoaderEdit>  {
  var shouldPop=false;
  var count;
  final findList fList = findList();
  late PageController controller;
  late int _selectedIndex;
  late List<Item> items;
  late List<vehicle> kenderaan;
    bool isLoading = true;
  List<String> vehicleId=[];
  List<String> Vtitles=[];
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

Future<void> loadData() async {
  try {
    final findListFD fList = findListFD();
    final List<Item> data = await fList.createListFD(widget.itemId);
     kenderaan=await fList.findVehicle();
     print('checkpoint 5');
     print(kenderaan);
    setState(() {
      items = data;
      isLoading = false;
      Vtitles = kenderaan.map((vehicle) => vehicle.vehicle_title).toList();
    vehicleId = kenderaan.map((vehicle) => vehicle.vehicle_item_id).toList();
    });
  } catch (error) {
    setState(() {
      isLoading = false;
    });
    // Handle error
    print('Error fetching data: $error');
  }
}


@override
void initState() {
  controller = PageController(initialPage: 0);
  _selectedIndex=0;
  super.initState();
  loadData();
}


@override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          return shouldPop;
        },
        child: Scaffold(
          extendBody: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: h * 0.05),
                  Consumer(builder: (context, ref, child) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: h * 0.0,
                              bottom: h * 0.00,
                              left: w * 0.0,
                              right: w * 0.0,
                            ),
                            child: Container(
                              height: h * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ref.read(truewhite).withOpacity(1),
                                  width: MediaQuery.of(context).size.width * 0.002,
                                ),
                                color: ref.read(primaryLight),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: w * 0.02),
                                        child: IconButton(
                                          icon: Icon(
                                            FontAwesome5.arrow_circle_left,
                                            color: ref.read(primaryColor),
                                            size: h * 0.02,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Text(
                                        "Edit Fuel Consumption",
                                        style: TextStyle(
                                          fontSize: h * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
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
                  }),
                  SizedBox(height: h * 0.02),
                  Expanded(
                    child: PageView(
                      controller: controller,
                      onPageChanged: onPageChanged,
                      children: <Widget>[
                  
                        MyTextFieldUI(items: items, itemId: widget.itemId,Vtitles :Vtitles,vehicleId:vehicleId),
                      ],
                    ),
                  ),
                ],
              ),
              // Additional widgets in the stack can go here
            ],
          ),
        ),
      );
    }
  }
}



class MyTextFieldUI extends StatefulWidget {
  final List<Item> items;
  final String itemId;
  final List<String> Vtitles;
  final List<String> vehicleId;

  const MyTextFieldUI({Key? key, required this.items,required this.itemId,required this.Vtitles,required this.vehicleId}) : super(key: key);
    // MyTextFieldUI();
  @override
  _MyTextFieldUIState createState() => _MyTextFieldUIState();
}

class _MyTextFieldUIState extends State<MyTextFieldUI> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String? _selectedTime;
  String fuelID ="";
  String fuelEntries="";
   var  sample="";
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
    fuelID = widget.itemId;
    print('widget.itemId: ${widget.itemId}');

  }

  @override
  Widget build(BuildContext context) {
    print(widget.Vtitles);
    List<Item> items = widget.items;
    String titleFType="";
    String titleFentities="";
    String title_veh="";
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              color: const Color.fromARGB(255, 2, 87, 157),
              child: Center(
                child: Text(
                  'Fuel Type',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                fuelEntries=item.fuel_entries_id;
                titleFType=item.titleFT;
                titleFentities=item.titleFE;
                print('checkpoint vehicle id');
                title_veh=widget.vehicleId[widget.Vtitles.indexOf(item.titleVeh)];
                print(item.titleVeh);
                // _selectedTime=item.vehicle_id;
                //  _firstNameController.text = item.titleFT; // Set initial value

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue:item.titleFT,
                        // controller: _firstNameController,
                        onChanged: (value) {
                          // Update the controller's text when user types
                          _firstNameController.text = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextField(
                          controller: TextEditingController(text: item.titleFE),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Fuel Entries',
                            border: OutlineInputBorder(),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Handle icon tap here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoaderEditFueldata(fuelEntriesId: item.fuel_entries_id),
                                  ),
                                );
                              },
                              child: Icon(Icons.description),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle:',
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  width: double.infinity,
                                  child: DropdownButton<String>(
                              
                                    value: item.titleVeh,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedTime = newValue!;
                                        sample = widget.vehicleId[widget.Vtitles.indexOf(newValue!)];
                                        print(sample);
                                       
                                      });
                                    },
                                    items: widget.Vtitles.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            value,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                                    iconSize: 24,
                                    isExpanded: true,
                                    underline: Container(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Get values from text fields
                String title = _firstNameController.text;
                print(sample);
                if(title =="")
                {
                  title=titleFType;
                }
                print(title);
                print(fuelID);
                 print('widget.itemId in build: ${widget.itemId}'); 

                if(sample =="")
                {
                  sample=title_veh;
                }

                // Call createList function with the values
                findList().createList(title, widget.itemId,fuelEntries,sample);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


class findList
{

  void createList(String title,String itemId,String entriesID,String vehicleId ) async {
    print('First Name: $title'); 
     print('First Name: $itemId');
      print('First Name: $entriesID');
      print('First Name: $vehicleId');
 
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isNotEmpty) {
    // Accessing the first element
    print('Data of ifleet-e19ed3688291407ab4da4d50d665769e: $ifleetData');
  } else {
    print('User details list is empty or does not contain the ifleet data.');

  }

  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+      
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-b19c8b7d68af470ca6ff11eda2fe41ab","item_id":"'+itemId+'","title":"'+title+'","container_id":"'+vehicleId+'","item_type_id_container_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","fuel_entries_id":"'+entriesID+'","item_type_id_fuel_entries_id":"ityp-e01c1454a6534723b73b71782b321ebc",}'+
  '}');

  print('findGap');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  print(usell);
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  // body: usell,
  // ?param=$usell

  if (response.statusCode == 200) {
    print('welcom');
    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {


    } else {

      print(response.body);

    }
  } else {
    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
// Return 0 if request failed
  }
}

}