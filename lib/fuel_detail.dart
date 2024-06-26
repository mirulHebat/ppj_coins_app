
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ppj_coins_app/editFuelData.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';

class LoaderFDetail extends StatefulWidget {
  final String itemId; // Declare itemId as a parameter

  LoaderFDetail({Key? key, required this.itemId}) : super(key: key);

  @override
  State<LoaderFDetail> createState() => _LoaderState();
}

class _LoaderState extends State<LoaderFDetail> {
  var shouldPop=false;
  late PageController controller;
  late int _selectedIndex;
    Color customColor = Color(0xFF1647AF);
  late List<Item> items;
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

  Future<void> Listview() async
  {
    final findListFD fList = findListFD();
    items = await fList.createListFD(widget.itemId);
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
      onWillPop: ()async{
        return shouldPop;
      },
      child: Scaffold(
        extendBody: true,
              bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   IconButton(
                  icon: Icon(Icons.local_gas_station),
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
                  IconButton(
                    icon: Icon( Icons.assignment),
                    onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderWork(),
                      ),
                    );
                  },
                  ),
                  IconButton(
                    icon: Icon(Icons.credit_card),
                    onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderLicense(),
                      ),
                    );
                  },
                  ),
                  IconButton(
                    icon: Icon(Icons.car_repair),
                    onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderMaintenance(),
                      ),
                    );
                  },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('Floating action button tapped');
              Navigator.push
              (
                context,
                MaterialPageRoute
                (
                  
                  builder: (context) => Loader(),
                ),
              );
              },
              child: Icon(Icons.home),
              backgroundColor: customColor,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          
        body:FutureBuilder(
        future: Listview(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Display a loading indicator while waiting for the future to complete
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Display an error message if the future completes with an error
            );
          } else {
         return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // background(h,w),

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
                                        " Fuel Consumption Detail ", // Replace with your actual title text
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
                      DividerExample(items: items,itemId: widget.itemId),
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
      ),
    );
  }
}

class DividerExample extends StatelessWidget {
  final List<Item> items; // Declare items parameter
  final String itemId; // Declare itemId parameter
   
  const DividerExample({Key? key, required this.items, required this.itemId}) : super(key: key); // Include itemId in the constructor

@override
Widget build(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(bottom: 100.0),
      child: Column(
        children: <Widget>[
          Expanded(
             child: SingleChildScrollView(
              child: Card(
              child: Container(
                color: Color.fromARGB(255, 23, 49, 70), // Background color
                 padding: EdgeInsets.all(8.0), // Padding for the container
                child: Column(
                  children: [
                    Column(
                      children: items.map((item) { 
                        print(item.submit);
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(8.0), // Padding for each item container
                          color: Colors.white, // Background color for each item container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align data to the left
                            children: [
                              SizedBox(height: 15),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Num Plate: ${item.titleFT}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Item Number: ${item.item_number}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Registered Date: ${item.registered_date}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                           
                              SizedBox(height: 15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Text(
                                    ' Fuel Information ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Price Per Liter (RM): ${item.price_per_liter.map((itemFuel) => itemFuel.price_per_liter?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Mileage (KM/L): ${item.price_per_liter.map((itemFuel) => itemFuel.km_lit).join(', ')}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Liters per 100KM (L): ${item.price_per_liter.map((itemFuel) => itemFuel.liters_per_100km?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Liters Per Hour (L): ${item.price_per_liter.map((itemFuel) => itemFuel.liters_per_hr?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Max Capacity in Liters (L): ${item.price_per_liter.map((itemFuel) => itemFuel.max_cap?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            
                              SizedBox(height: 15),
                               Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Text(
                                    ' Cost and Usage ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                               Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                               'Cost per KM (RM): ${item.price_per_liter.map((itemFuel) => itemFuel.cost_per_km?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Cost Per Hour (RM): ${item.price_per_liter.map((itemFuel) => itemFuel.cost_per_hr?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                 'Usage in 1KM (L) ${item.price_per_liter.map((itemFuel) => itemFuel.usage_in_km?['display']).toList().first.toString()}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            ],
                          ),
                        );
                        
                      }).toList(),

                    ),

                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: items
                          .where((item) => item.submit != "true")
                          .map((item) => ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoaderEditFueldata(fuelEntriesId: itemId),
                                    ),
                                  );
                                },
                                child: Text('Edit'),
                                  style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),


             )
            
          ),
        ],
      ),
    ),
  );
}


}




class findListFD
{
  late List<ItemFuel> itemF;
   Future<List<Item>> createListFD(String itemId) async  {
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';


    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
      '"bims_access_id":"$ifleetData",'+
      '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
      '"action":"ADVANCED_SEARCH",'+
      '"item_type_codes":["ft001"],'+
      '"sort_field":"",'+
      '"sort_order":"ASC",'+
      '"details":["item_id","item_number","title","registered_date" ,"metadata"]'+
    '}');

    Map<String, String> headersModified = {};
    if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];

  }

  response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
  headers: headersModified);


  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {

      List<dynamic> results = result['results'];
      List<Item> items = [];
      for(var itemData in results)
      {
          
            String titleFT=Uri.decodeComponent(itemData['title']?? ''); 
            String item_number =Uri.decodeComponent(itemData['item_number']?? '') ;
            String registered_date=Uri.decodeComponent(itemData['registered_date']?? '');
            String titleVeh="";
            String submit="";
            String itemId="";
            String titleFE="";
            Map<String, dynamic>? metadata=itemData['metadata'];

             if(metadata != null)
             {
                   titleVeh=metadata['container_id']?['title'] ?? '';
                   itemF=await viewFuel(metadata['fuel_entries_id']['item_id']);
                   itemId = metadata['fuel_entries_id']?['item_id'] ?? '';
                   titleFE=metadata['fuel_entries_id']?['title'] ?? '';
                   submit=metadata['submit_ind']?['value']?? '';
             }

             Item item = Item
            (
            titleFT:titleFT,
            item_number: item_number,
            registered_date: registered_date,
            price_per_liter: itemF,
            fuel_entries_id:itemId,
            titleFE:titleFE,
            titleVeh:titleVeh,
            submit:submit,
            );
            items.add(item);


      }

      return items;
    } else {
      print(response.body);
      return []; 
    }
  } else {
    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
    return []; 
  }
}


   Future<List<ItemFuel>> viewFuel(String itemId) async  {
    print(itemId);
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';


  http.Response response;

    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
    '"action":"ADVANCED_SEARCH",'+
    '"item_type_codes":["fe001"],'+
    '"sort_field":"",'+
    '"sort_order":"ASC",'+
    '"details":["item_id","item_number","title","registered_date" ,"metadata"]'+
  '}');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
  headers: headersModified);


  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);
    print(result);
    // Handle the response data
    if (result['success'] == true) {
       List<dynamic> results = result['results'];
       List<ItemFuel> items = [];
      for(var result in results)
      {
              var title=Uri.decodeComponent(result['title']);
              var price_per_liter;
              var liters_per_hr;
              var liters_per_100km;
              var cost_per_km;
              var usage_in_km;
              var usage_in_hr;
              var cost_per_hr;
              var kmliter;
              var maxcap;

    
              Map<String,dynamic> metadata=result['metadata'];
              if (metadata['price_per_liter'] != null)
              {
                  price_per_liter=metadata['price_per_liter'];
              }
              else
              {
                price_per_liter=[];
              }
              if ( metadata['liters_per_hr'] != null)
              {
                  liters_per_hr=metadata['liters_per_hr'];
              }
              else
              {
                liters_per_hr=[];

              }
              if ( metadata['liters_per_100km'] != null)
              {
                  liters_per_100km=metadata['liters_per_100km'];
              }
              else
              {
                liters_per_100km=[];

              }
              if (metadata['cost_per_km'] != null)
              {
                  cost_per_km=metadata['cost_per_km'];
              }
              else
              {
                cost_per_km=[];
              }
              if (metadata['usage_in_km'] != null)
              {
                  usage_in_km=metadata['usage_in_km'];
              }
              else
              {
                  usage_in_km=[];
              }
              if (metadata['usage_in_hr'] != null)
              {
                  usage_in_hr=metadata['usage_in_hr'];
              }
              else
              {
                  usage_in_hr=[];
              }
              if (metadata['cost_per_hr'] != null)
              {
                  cost_per_hr=metadata['cost_per_hr'];
              }
              else
              {
                  cost_per_hr=[];
              }
              if (metadata['liters_max_capacity'] != null)
              {
                  maxcap=metadata['liters_max_capacity'];
              }
              else
              {
                  maxcap=[];
              }
              if (metadata['km_per_liters'] != null)
              {
                  kmliter=metadata['km_per_liters'];
              }
              else
              {
                  kmliter=[];
              }
          
      
              print(metadata['price_per_liter']);

              ItemFuel item = ItemFuel
              (
               title:title,
               price_per_liter: price_per_liter,
               liters_per_hr:liters_per_hr,
               liters_per_100km:liters_per_100km,
               cost_per_km:cost_per_km,
               usage_in_km:usage_in_km,
               usage_in_hr:usage_in_hr,
               cost_per_hr:cost_per_hr,
               km_lit:kmliter,
               max_cap:maxcap,  

              );
            items.add(item);

      }

    return items;
 
    } else {
      print(response.body);
     return []; 
    }
  } else {

     return []; 
  }
}

   Future<List<vehicle>> findVehicle() async  {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isEmpty) {
    return []; 
  }

  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"item_type_id":"ityp-b19c8b7d68af470ca6ff11eda2fe41ab",'+
    '"action":"LIST_ITEM_CONTAINER",'+
    '"custom_field_name":"container_id",'+
    '"details":["item_id","item_number","title","item_type_id","item_type_title"]'+
  '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  response = await http.get(Uri.parse('https://lawanow.com//bims-web/ItemForm?param=$usell'), 
  headers: headersModified);


  if (response.statusCode == 200) {

    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {

      List<dynamic> results = result['results'];
      List<vehicle> items = [];
      for(var itemData in results)
      {
          
            String vehicle_title=Uri.decodeComponent(itemData['title']?? ''); 
            String vehicle_item_id =Uri.decodeComponent(itemData['item_id']?? '') ;

             vehicle vehic = vehicle
            (
              vehicle_title:vehicle_title,
              vehicle_item_id:vehicle_item_id
            );
            items.add(vehic);


      }

      return items;
    } else {
      print(response.body);
      return []; 
    }
  } else {
    return []; 
  }
} 
}

class ItemFuel {
  var title;
  final  Map<String,dynamic>? price_per_liter;
  final  Map<String,dynamic>? liters_per_hr;
  final  Map<String,dynamic>? liters_per_100km;
  final  Map<String,dynamic>? cost_per_km;
  final  Map<String,dynamic>? usage_in_km;
  final  Map<String,dynamic>? usage_in_hr;
  final  Map<String,dynamic>? cost_per_hr;
  final  int? km_lit;
  final  Map<String,dynamic>? max_cap;

  ItemFuel({required this.title,required this.price_per_liter,required this.liters_per_hr,
  required this.liters_per_100km,required this.cost_per_km,required this.usage_in_km,required this.usage_in_hr,required this.cost_per_hr,required this.km_lit,required this.max_cap});
}

class Item {
  final String titleFT;
  final String registered_date;
  final String item_number;
  final String fuel_entries_id;
  final String titleFE;
  final String titleVeh;
  final String submit;

  final  List<ItemFuel> price_per_liter;


  Item({required this.titleFT,required this.registered_date, required this.item_number,required this.price_per_liter,required this.fuel_entries_id,required this.titleFE,required this.titleVeh,required this.submit});

}

class vehicle{
  final String vehicle_title;
  final String vehicle_item_id;

  vehicle({required this.vehicle_title,required this.vehicle_item_id});
}