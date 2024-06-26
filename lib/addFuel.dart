
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ppj_coins_app/Fuel_Entries.dart';

class LoaderAddFuel extends StatefulWidget {
  final String itemId;
   final String title_fe;

  LoaderAddFuel({Key? key, required this.itemId,required this.title_fe}) : super(key: key);
  @override
  State<LoaderAddFuel> createState() => _LoaderState(itemId,title_fe);
}

class _LoaderState extends State<LoaderAddFuel>  {
  final String itemId;
  final String title_fe;


  _LoaderState(this.itemId,this.title_fe);
  var shouldPop=false;
  var count;
  final findList fList = findList();
  late PageController controller;
  late int _selectedIndex;
  late List<vehicle> kenderaan;
  List<String> vehicleId=[];
  List<String> Vtitles=[];
  bool isLoading = true;
  void _onItemTapped(int index) {
    setState(() {

      if (controller.hasClients) {
        controller.jumpToPage(
          index,
        );
      }
    });
  
     
  }

  Future<void> loadDataVehicle() async{
      try {
            final findListFD fList = findListFD();
            kenderaan=await fList.findVehicle();
            print('checkpoint 5');
            print(kenderaan);
            setState(() {
              isLoading = false;
              Vtitles = kenderaan.map((vehicle) => vehicle.vehicle_title).toList();
              vehicleId = kenderaan.map((vehicle) => vehicle.vehicle_item_id).toList();
            });
          } catch (error) {
            setState(() {
              isLoading = false;
            });
          }

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
    loadDataVehicle();
    
  }

  Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
      if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }else
    {
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
                              color: ref.read(primaryLight),
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
                                        color: ref.read(primaryColor),
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
                                          "Add Fuel Consumption ", // Replace with your actual title text
                                          style: TextStyle(fontSize: h * 0.03, fontWeight: FontWeight.bold, color: Colors.black), // Customize the style as needed
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
                SizedBox(height: h*0.02,),
                
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: onPageChanged,
                    children: <Widget>[
                      MyTextFieldUI(itemId,title_fe,Vtitles,vehicleId)
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
  }



class MyTextFieldUI extends StatefulWidget {
    final String itemId;
    final String title_fe;
    final List<String> Vtitles;
    final List<String> vehicleId;

  MyTextFieldUI(this.itemId,this.title_fe,this.Vtitles,this.vehicleId);
  @override
  _MyTextFieldUIState createState() => _MyTextFieldUIState();
}

class _MyTextFieldUIState extends State<MyTextFieldUI> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
   String? _selectedTime;
    var  sample="";


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust the padding as needed
            child: TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust the padding as needed
              child: TextField(
                controller: TextEditingController(text: widget.title_fe), // Use the itemId to initialize the controller
                readOnly: true, // Make the TextField read-only
                decoration: InputDecoration(
                  labelText: 'Fuel Entries',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0), // Adjust the padding
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
                      border: Border.all(color: Colors.black, width: 1.0), // Add border
                    ),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: _selectedTime,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTime = newValue!;
                              sample = widget.vehicleId[widget.Vtitles.indexOf(newValue)];
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String Title = _firstNameController.text;
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class findListFuelType
{

 Future<String>  createList(String title,String item_id,String vehicleId,String fuel_id) async {

  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String id_user = userDetails.isNotEmpty ? userDetails[1] : '';



  String jsonMetadata;
  if (fuel_id.isEmpty) {
    jsonMetadata = '"metadata":{"item_type_id":"ityp-b19c8b7d68af470ca6ff11eda2fe41ab","item_id":"","item_number":"","title":"$title","user_id":"'+id_user+'","container_id":"$vehicleId","item_type_id_container_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","fuel_entries_id":"$item_id","item_type_id_fuel_entries_id":"ityp-e01c1454a6534723b73b71782b321ebc"}';
  } else {
    jsonMetadata = '"metadata":{"item_type_id":"ityp-b19c8b7d68af470ca6ff11eda2fe41ab","item_id":"$fuel_id","title":"$title","user_id":"'+id_user+'","container_id":"$vehicleId","item_type_id_container_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","fuel_entries_id":"$item_id","item_type_id_fuel_entries_id":"ityp-e01c1454a6534723b73b71782b321ebc"}';
  }


  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    jsonMetadata+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];

  }

  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);


  if (response.statusCode == 200) {

    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
      String itemId = result['item_id'];
      return itemId;
    } else {
       return "";
    }
  } else {
    return "";
  }
}

 void submitfuel(String item_id) async {
    print('Fuel Entires: $item_id');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';


  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-b19c8b7d68af470ca6ff11eda2fe41ab","item_id":"'+item_id+'","submit_ind":{"code":"true","value":"true","display":"Yes"}}'+
  '}');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);

  } 
}

 void Deletefuel(String item_id) async {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  http.Response response;

  var usell = Uri.encodeQueryComponent('{"bims_access_id":"$ifleetData","item_ids":["$item_id"]}');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }
  response = await http.delete(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
   
}

}




