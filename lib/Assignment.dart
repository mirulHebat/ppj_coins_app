import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ppj_coins_app/edit_vehicle.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';
import 'package:ppj_coins_app/loader/loader.dart';


class LoaderAssign_detail extends StatefulWidget {
   final String itemId; 

  LoaderAssign_detail({Key? key, required this.itemId}) : super(key: key);

   @override
  State<LoaderAssign_detail> createState() => _LoaderAssign();

}

class _LoaderAssign extends State<LoaderAssign_detail>{
  var shouldPop=false;
  late PageController controller;
  late int _selectedIndex;
   late List<ItemAssign> item_Assign;
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

  Future<void> ListviewAssign() async
  {
  final Assign_Detail assign_data = Assign_Detail();
  item_Assign = await assign_data.createList_Assign(widget.itemId);
  print(item_Assign);


 
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
        future: ListviewAssign(),
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
                                             Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoaderWork(), // Replace SecondScreen with the destination screen
                                              ),
                                            );
                                            // Handle the onTap action here
                                            // For example, you can navigate back to the previous screen
                                            // Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                            Text(
                                              " Vehicle Assignment Detail ", // Replace with your actual title text
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
                      // HomePage(),
                      
                     // DividerExample(items: items,itemId: widget.itemId),
                     Assignment_View(item_sign:item_Assign )


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

class Assignment_View extends StatelessWidget {
  
   final List<ItemAssign> item_sign;
   const Assignment_View({Key? key, required this.item_sign}) : super(key: key); 
  @override
  Widget build(BuildContext context) {
     String assign_Id="";
    return Center(
          child: Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              child: Container(
                color: Color.fromARGB(255, 23, 49, 70), // Background color
                padding: EdgeInsets.all(8.0), // Padding for the container
                child: Column(
                  children: [
                    Column(
                      children: item_sign.map((item) { 
                       assign_Id=item.num_id;
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(8.0), // Padding for each item container
                          color: Colors.white, // Background color for each item container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align data to the left
                            children: [
                              SizedBox(height: 15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Text(
                                    ' Vehicle Assignment Information ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // Text(
                              //   'Fuel Type', // Title
                              //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                              // ),
                              SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Num Plate: ${item.no_plate}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Full Name:  ${item.full_name}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                             SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Initial Mileage (KM): ${item.init_mile}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                             SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Final Mileage (KM): ${item.final_mile}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                            ),
                              ),
                             SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Started At: ${item.started_at}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                             SizedBox(height: 10),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                 'Ended At: ${item.ended_at}',
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
                      children: item_sign
                          .where((item) => item.submit_ind != "true")
                          .map((item) => ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoaderEditVehdata(vehiclId:assign_Id,editAssign:item_sign),
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
                    // Add some space between the text and the button
                  ],
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

class ItemAssign {
  final String num_id;
  final String no_plate;
  final String init_mile;
  final String final_mile;
  final String started_at;
  final String ended_at;
  final String submit_ind;
  final String full_name;
  // final String fuel_entries_id;
  ItemAssign({required this.no_plate,required this.init_mile, required this.final_mile,required this.started_at,required this.ended_at,required this.num_id,required this.submit_ind,required this.full_name});
}

class Assign_Detail
{
  Future<List<ItemAssign>> createList_Assign(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

       http.Response response;
        var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["va001"],'+
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

            if (response.statusCode == 200){
              Map<String, dynamic> result = json.decode(response.body);

              if (result['success'] == true){
                List<dynamic> results = result['results'];
                List<ItemAssign> item_assign = [];
                for(var itemData in results)
                {
                  String title_assign=Uri.decodeComponent(itemData['title']?? ''); 
                  String init_mil ="";
                  String final_mil = "";
                  String start_at="";
                  String end_at="";
                  String submit="";
                  String full_name="";
                  Map<String, dynamic>? metadata=itemData['metadata'];
                  print('metadata');
                  print(metadata);
                   if(metadata != null)
                   {
                    init_mil=(metadata['starting_meter_entry_value'] ?? '').toString();
                    final_mil = (metadata['ending_meter_entry_value'] ?? '').toString();
                    start_at =(metadata['started_at'] ?? '').toString();
                    end_at=(metadata['ended_at'] ?? '').toString();
                    submit=(metadata['submit_ind']?['value'] ?? '').toString();
                    full_name=(metadata['contact_name']?['title'] ?? '').toString();

                  

                   }

                    ItemAssign veh_assign = ItemAssign
                    (
                        num_id:itemId ,
                        no_plate:title_assign,
                        init_mile: init_mil,
                        final_mile:final_mil,
                        started_at:start_at,
                        ended_at:end_at,
                        submit_ind:submit,
                        full_name:full_name,
     
                    );
                    item_assign.add(veh_assign);
                }
                return item_assign; 

              }
              else
              {
                print(response.body);
                return []; 
              }

            }else
            {
               print('Request failed with status code: ${response.statusCode}');
              return []; 
            }

     

  }
}