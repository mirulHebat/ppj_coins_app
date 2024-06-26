
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
import 'package:ppj_coins_app/add_vehicle.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VehicleCategory extends StatefulWidget {
  final String category;
  VehicleCategory({Key? key, required this.category}) : super(key: key);

  @override
    Vehicle_Cat createState() => Vehicle_Cat();
}

class Vehicle_Cat extends State<VehicleCategory> 
{
   var shouldPop=false;
    var count;
    late PageController controller;
    ItemListWithCountVeh itemListWithCount = ItemListWithCountVeh(count: 0, items: []); 
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

  Future<void> Listvehicle() async {
   final findlistveh veh = findlistveh();
    if(itemListWithCount.items.isEmpty)
    {
        itemListWithCount = await veh.createListVeh(widget.category);
    }

    int newCount = itemListWithCount.count;
     if (newCount != count) { // Only update state if count has changed
    setState(() {
      count = newCount;
    });
  }

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
            body:FutureBuilder(
              future: Listvehicle(),
               builder: (context, snapshot) 
               {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(), // Display a loading indicator while waiting for the future to complete
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'), // Display an error message if the future completes with an error
                  );
                }else{
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
                                                    "List of ${widget.category}",
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
                            List_Category(itemListWithCount,widget.category),
                            ],
                          ),
                        )
                      ],
                    )
                    
                  ],
                );
                }

               }
            ) 
    )
  );
          
  }

  Widget List_Category(ItemListWithCountVeh itemListWithCount,String category) {
  IconData vehicleIcon = FontAwesomeIcons.car; 
  List<Widget> tiles = [];
    if(category =="Car")
    {
      vehicleIcon =FontAwesomeIcons.carSide;
    }
    if(category =="SUV")
    {
      vehicleIcon =FontAwesomeIcons.vanShuttle;
    }
    if(category =="Motocycle")
    {
      vehicleIcon =FontAwesomeIcons.motorcycle;
    }
    if(category =="Lorry")
    {
      vehicleIcon =FontAwesomeIcons.truck;
    }
   for (var item in itemListWithCount.items) {
       Color custom = Color(0xFFF2F2F2);
       tiles.add(


        Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: custom,
          // borderRadius: BorderRadius.circular(10.0),
           border: Border.all(
            color:const Color.fromARGB(31, 42, 41, 41),
          //   width: 2.0,
           ),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left)
            children: [
           Padding(
              padding: EdgeInsets.only(bottom: 10.0), // Add padding to the bottom
              child: GestureDetector(
                  onTap: () => _handleItemTapVeh(context,item.vehicle_id,item.title,category), // Trigger onTap only for the icon
                child: Icon(
                 vehicleIcon,// Display the card icon
                  size: 30,
                  color: Colors.blue, // You can customize the color as needed
                ),
              ),
            ),

              SizedBox(width: 10), // Add space between the icon and the title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the start (left)
                  children: [
                    Text(
                      '${item.title}',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center, // Center the text
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Road Tax Expiration Date: ', // Change "Title" to "Document"
                          style: TextStyle(fontSize: 16.0, color: Colors.grey), // Gray color for the prefix
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${item.road_tax ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0, color: Colors.black), // Black color for the item title
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                    ),
                   Row(
                    children: [
                      Text(
                        'Vehicle Status: ',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text(
                          '${item.vehicle_status ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  ]
  
                ),
              ),

            ],
          ),
        ),
      ),

       );

     }
     return Padding(
  padding: EdgeInsets.only(bottom:100),
  child: ListView(
    padding: EdgeInsets.zero, // Remove default padding
    children: tiles,
  ),
);
}


void _handleItemTapVeh(BuildContext context, String itemId, String title,String category) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoaderAddVehdata(vehicle_id: itemId,title:title ,category:category),
    ),
  );
}
  

}






class findlistveh
{
  Future<ItemListWithCountVeh> createListVeh(String category) async
  { String veh_type="";
    if(category =="Car")
    {
      veh_type ="VT01";
    }
    if(category =="SUV")
    {
      veh_type ="VT04";
    }
    if(category =="Motocycle")
    {
      veh_type ="VT03";
    }
    if(category =="Lorry")
    {
      veh_type ="VT06";
    }
    if(category =="MPV")
    {
      veh_type ="VT05";
    }
    if(category =="Boat")
    {
      veh_type ="VT07";
    }
    if(category =="Helicopter")
    {
      veh_type ="VT09";
    }
    if(category =="Tank")
    {
      veh_type ="VT08";
    }
    if(category =="van")
    {
      veh_type ="VT02";
    }
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
    print(ifleetData);

    if (userDetails.isEmpty) {
      return ItemListWithCountVeh(count: 0, items: []);

  } 
  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"item_type_codes":["vc001"],'+
    '"query":"( vehicle_type_id = &quot;'+veh_type+'&quot; && vehicle_status_id = &quot;VS01&quot; )",'+
    '"sort_order":"ASC",'+
    '"sort_field":"",'+
    '"action":"ADVANCED_SEARCH",'+
    '"details":["item_id","item_number","title","metadata"]'+
  '}');

      Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];

  }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), headers: headersModified);

      if (response.statusCode == 200){
         Map<String, dynamic> result = json.decode(response.body);
         print(result);
          if (result['success'] == true) {

             List<dynamic> results = result['results'];
            List<veh_data> items = [];
            for (var itemData in results) {
              String title = Uri.decodeComponent(itemData['title']?? '');
              String itemId = Uri.decodeComponent(itemData['item_id']?? '');
              Map<String, dynamic>? user_data=itemData['metadata'];
              String vehicle_status="";
              String road_tax="";
              Map<String, dynamic>? vehicleStatus = user_data?['vehicle_status_id'] as Map<String, dynamic>?;
              vehicle_status = vehicleStatus?['display'] ?? '';
              road_tax = user_data?['registration_expiration_date']?? '';
                items.add(veh_data(title:title,vehicle_id:itemId ,vehicle_status:vehicle_status ,road_tax:road_tax));

            }

             int count = items.length;
            print('Count of results: $count');
            return ItemListWithCountVeh(count: count, items: items);

          }else {
          print('Failed to retrieve data');
          return ItemListWithCountVeh(count: 0, items: []);// Return 0 if success is false
        }
      }else {
        // Handle the case where the request failed
        print('Request failed with status code: ${response.statusCode}');
        return ItemListWithCountVeh(count: 0, items: []);// Return 0 if request failed
      }
      

  }





}

class ItemListWithCountVeh {
  final int count;
  final List<veh_data> items;

  ItemListWithCountVeh({required this.count, required this.items});
}

class veh_data {
  final String title;
  final String vehicle_id;
  final String vehicle_status;
  final String  road_tax;


  veh_data({required this.title,required this.vehicle_id,required this.vehicle_status,required this.road_tax});
}