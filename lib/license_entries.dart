
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
import 'package:ppj_coins_app/fuelData.dart';
import 'package:ppj_coins_app/license_info.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:ppj_coins_app/work_entries.dart';

class LoaderLicense extends StatefulWidget {
  LoaderLicense({Key? key}) : super(key: key);

  @override
  State<LoaderLicense> createState() => LoaderLicenseState();
}

class LoaderLicenseState extends State<LoaderLicense>  {
  var shouldPop=false;
  var count;
   final findListLicense fList = findListLicense();
  late PageController controller;
  String role_assign="";
   ItemListWithCountLicense itemListWithCount = ItemListWithCountLicense(count: 0, items: []); 
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
   Color customColor = Color(0xFF1647AF);
   Color custom = Color(0xFFF2F2F2);
  late int _selectedIndex;
  void _onItemTapped(int index) {
    setState(() {
      if (controller.hasClients) {
        controller.jumpToPage(
          index,
        );
      }
    });
  
     
  }

Future<void> Listview() async {
   final findListLicense fList = findListLicense();
  if(itemListWithCount.items.isEmpty)
  {
      itemListWithCount = await fList.createListLicense();
  }

    int newCount = itemListWithCount.count;
     if (newCount != count) { // Only update state if count has changed
    setState(() {
      count = newCount;
    });
  }


  // print(itemListWithCount.items); // Obtain item list with count
  // int newCount = itemListWithCount.count;

  // if (newCount != count) { // Only update state if count has changed
  //   setState(() {
  //     count = newCount;
  //   });
  // }
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


void showMonthPicker(BuildContext context) {
  // List of months
  List<String> months = [
    'All','January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Show the dialog with the drop-down button
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Month'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Select a month',
                border: OutlineInputBorder(),
              ),
              value: null, // No initial value
              onChanged: (String? newValue) {
                if (newValue != null) {
                  // Update the text field with the selected month
                  _monthController.text = newValue;
                  print('_monthController');
                  print(_monthController);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              items: months.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      );
    },
  );
}

void showYearPicker(BuildContext context) {
  // Generate a list of years
  int currentYear = DateTime.now().year;
  List<int> years = List.generate(10, (index) => currentYear - 5 + index);

  // Add "All" option at the beginning of the list
  years.insert(0, 0);

  // Show the bottom sheet with the list of years
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: years.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(years[index] == 0 ? 'All' : years[index].toString()),
            onTap: () {
              // Update the text field with the selected year
              _yearController.text = years[index] == 0 ? 'All' : years[index].toString();
              Navigator.pop(context); // Close the bottom sheet
            },
          );
        },
      );
    },
  );
}

void getRole()async
{
    findListWork assign =findListWork();
    role_assign =await assign.assignRole();
 

}



  Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  bool showFloatingActionButton = true;
  getRole();
  print('role');
  print(role_assign);
  if(role_assign =="iFMS Manager")
  {
    showFloatingActionButton=false;
  }
   
  String _getMonthName(int month) {
  // List of month names
  List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Subtract 1 from the month value to get the correct index in the list
  int index = month - 1;

  // Return the corresponding month name
  return monthNames[index];
}
  
  return WillPopScope(
    onWillPop: () async {
      return shouldPop;
    },
    child: Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        height: h*0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      print('Home button tapped');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print('Search button tapped');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      print('Profile button tapped');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      print('Settings button tapped');
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: h*0.06),
                    child: FloatingActionButton(
                      heroTag: 'fab1',
                      onPressed: () 
                      {
                        print('hello');
                            Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (
                                
                                builder: (context) => Loader(),
                              ),
                            );
                        print('Floating action 1 button tapped');
                      },
                      child: Icon(Icons.home),
                      backgroundColor: customColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: showFloatingActionButton, 
                     child: Padding(
                    padding:  EdgeInsets.only(bottom: h*0.12,right: w*0.04),
                    child: FloatingActionButton(
                      heroTag: 'fab2',
                      onPressed: () 
                      {
                        print('hello');
                            Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (
                                
                                builder: (context) => LoaderAddFueldata(),
                              ),
                            );
                        print('Floating action 2 button tapped');
                      },
                      child: Icon(Icons.add),
                      backgroundColor: customColor,
                    ),
                  ),
                  ),
                 
                ),
              ],
            ),

            
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      body: FutureBuilder(
        future: Listview(),
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
          } else {
            // Future completed, proceed to build UI
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
                          padding: EdgeInsets.only(top: h * 0.0, bottom: h * 0.00, left: w * 0.0, right: w * 0.0),
                          child: Container(
                            height: h * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ref.read(truewhite).withOpacity(1),
                                width: MediaQuery.of(context).size.width * 0.002,
                              ),
                              color: customColor,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: h * 0.0, bottom: h * 0.01, left: w * 0.02, right: w * 0.02),
                                  child: Container(
                                    height: h * 0.05,
                                    width: h * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(200),
                                      border: Border.all(color: ref.read(truewhite).withOpacity(1), width: h * 0.002),
                                      color: ref.read(truewhite).withOpacity(1),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: InkWell(
                                        onTap: () {
                                          // Handle icon tap here
                                        },
                                        child: Container(
                                          height: h * 0.1,
                                          width: h * 0.1,
                                          decoration: BoxDecoration(color: Colors.white),
                                          child: Center(
                                            child: Icon(FontAwesome5.user, color: ref.read(primaryColor), size: h * 0.02),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "License Entries",
                                    style: TextStyle(fontSize: h * 0.03, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                    
                    SizedBox(height: h*0.02,),
                    Expanded(
                    child: Column(
                      children: [
                        // Text field for month selection
                    //    Row(
                    //   children: [
                    //    Container(
                    //         width: 180, // Adjust the width as needed
                    //          padding: EdgeInsets.only(left: 8.0), // Add left padding
                    //         child: TextField(
                    //           controller: _monthController,
                    //           readOnly: true,
                    //           onTap: () {
                    //             showMonthPicker(context);
                    //           },
                    //           decoration: InputDecoration(
                    //             labelText: 'Select Month',
                    //             border: OutlineInputBorder(),
                    //             suffixIcon: Icon(Icons.calendar_today),
                    //           ),
                    //         ),
                    //       ),

                    //     SizedBox(width: 8),
                    //     Container(
                    //       width: 170, // Adjust the width as needed
                    //       child: Stack(
                    //         alignment: Alignment.centerRight,
                    //         children: [
                    //           TextField(
                    //             controller: _yearController,
                    //             readOnly: true,
                    //             onTap: () {
                    //               showYearPicker(context);
                    //             },
                    //             decoration: InputDecoration(
                    //               labelText: 'Select Year',
                    //               border: OutlineInputBorder(),
                    //               suffixIcon: Icon(Icons.calendar_today),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(width: 4),
                    //     IconButton(
                    //       icon: Icon(Icons.search), // Search icon
                    //       onPressed: ()async {
                    //         // final findList fList = findList();
                    //         print('month controller');
                    //         print(_monthController.text);
                    //         print(_yearController.text);
                    //         // var filtered = await fList.createList(_monthController.text,_yearController.text);
                    //         print("filtered");
                    //         // print(filtered.count);
                    //         // if (filtered.count != 0) {
                    //         //   setState(() {
                    //         //     itemListWithCount = filtered;
                    //         //     // Update the state with the new itemListWithCount
                    //         //   });
                    //         // }else {
                    //         //   showDialog(
                    //         //     context: context,
                    //         //     builder: (BuildContext context) {
                    //         //       return AlertDialog(
                    //         //         title: Text('No Data'),
                    //         //         content: Text('No data available for the selected month.'),
                    //         //         actions: <Widget>[
                    //         //           TextButton(
                    //         //             onPressed: () {
                    //         //               Navigator.of(context).pop();
                    //         //             },
                    //         //             child: Text('OK'),
                    //         //           ),
                    //         //         ],
                    //         //       );
                    //         //     },
                    //         //   );
                    //         // }
                    //         // Implement search functionality for month here
                    //       },
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: h*0.01,),




                        // PageView
                        Expanded(
                          child: PageView(
                            controller: controller,
                            onPageChanged: onPageChanged,
                            children: <Widget>[
                               ListTilesLicense(itemListWithCount),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),


                  ],
                )
                
              ],
            );

        }
        }
      ),
    ),
  );
}


 Widget ListTilesLicense(ItemListWithCountLicense itemListWithCount) {
   List<Widget> tiles = [];
     for (var item in itemListWithCount.items) {
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
                 onTap: () => _handleItemTapLicense(context, item.license_id), // Trigger onTap only for the icon
                child: Icon(
                  Icons.credit_card, // Display the card icon
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
                          'Expired Date: ', // Change "Title" to "Document"
                          style: TextStyle(fontSize: 16.0, color: Colors.grey), // Gray color for the prefix
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${item.expired_date ?? 'N/A'}',
                          style: TextStyle(fontSize: 16.0, color: Colors.black), // Black color for the item title
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                    ),
                   Row(
                    children: [
                      Text(
                        'Class: ',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text(
                          '${item.license_class ?? 'N/A'}',
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
               PopupMenuButton(
               itemBuilder: (BuildContext context) {
                List<PopupMenuEntry<String>> menuItems = [
                  PopupMenuItem(
                    child: Text('View Detail'),
                    value: 'View',
                  ),
                ];
                return menuItems;
              },
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                
               if( value == 'View')
                {
                  _handleItemTapLicense(context, item.license_id); 
                }
              },
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
//   List<Widget> tiles = [];


//   // Generate list tiles based on the items in itemListWithCount
//   for (var item in itemListWithCount.items) {
//     print('icon checkpoint');
//     print(item.submit);
//     tiles.add(
  
//       Container(
//         margin: EdgeInsets.symmetric(vertical: 5.0),
//         padding: EdgeInsets.symmetric(vertical: 0.5),
//         decoration: BoxDecoration(
//           color: custom,
//           // borderRadius: BorderRadius.circular(10.0),
//            border: Border.all(
//             color:const Color.fromARGB(31, 42, 41, 41),
//           //   width: 2.0,
//            ),
//         ),
//         child: ListTile(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left)
//             children: [
//             Padding(
//                 padding: EdgeInsets.only(bottom: 10.0), // Add padding to the top
//                 child: GestureDetector(
//                   onTap: () => _handleItemTap(context, item.itemId), // Trigger onTap only for the icon
//                    child: item.submit == 'true'
//                   ? Icon(Icons.done, size: 30, color: Colors.green) // Display a checkmark icon if submit is 'yes'
//                   : Icon(Icons.description, size: 30), // Display a document icon if submit is not 'yes'// Add icon to the left of the title
//                 ),
//               ),
//               SizedBox(width: 10), // Add space between the icon and the title
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the start (left)
//                   children: [
//                     Text(
//                       '${item.item_number}',
//                       style: TextStyle(fontSize: 20.0),
//                       textAlign: TextAlign.center, // Center the text
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       children: [
//                         Text(
//                           'No Plate: ', // Change "Title" to "Document"
//                           style: TextStyle(fontSize: 16.0, color: Colors.grey), // Gray color for the prefix
//                           textAlign: TextAlign.center,
//                         ),
//                         Text(
//                           '${item.title}',
//                           style: TextStyle(fontSize: 16.0, color: Colors.black), // Black color for the item title
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
                      
//                     ),
//                    Row(
//                     children: [
//                       Text(
//                         'Date: ',
//                         style: TextStyle(fontSize: 16.0, color: Colors.grey),
//                         textAlign: TextAlign.center,
//                       ),
//                       Flexible(
//                         child: Text(
//                           '${item.registered_date}',
//                           style: TextStyle(fontSize: 16.0, color: Colors.black),
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                    Row(
//                     children: [
//                       Text(
//                         'Driver: ',
//                         style: TextStyle(fontSize: 16.0, color: Colors.grey),
//                         textAlign: TextAlign.center,
//                       ),
//                       Flexible(
//                         child: Text(
//                           '${item.user}',
//                           style: TextStyle(fontSize: 16.0, color: Colors.black),
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   )

//                   ],
//                 ),
//               ),
//             Opacity(
//             opacity: item.submit =="true" ? 0.0 : 1.0, // Set the opacity based on the condition
//             child: PopupMenuButton(
//               itemBuilder: (BuildContext context) {
//                 return <PopupMenuEntry>[
//                   PopupMenuItem(
//                     child: Text('Submit'),
//                     value: 'Submit',
//                   ),
//                   PopupMenuItem(
//                     child: Text('Delete'),
//                     value: 'Delete',
//                   ),
//                 ];
//               },
//               icon: Icon(Icons.more_vert),
//               onSelected: (value) {
//                 // Handle menu item selection
//                 if (value == 'Submit') {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Submit Confirmation'),
//                         content: Text('Are you sure you want to submit?'),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () {
//                               // Close the dialog
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Cancel'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               final findListFuelType fuelType = findListFuelType();
//                               fuelType.submitfuel(item.itemId);
//                               print(item.itemId);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => LoaderFuel(),
//                                 ),
//                               );
//                             },
//                             child: Text('Submit'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 } else if (value == 'Delete') {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Delete Confirmation'),
//                         content: Text('Are you sure you want to Delete?'),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () {
//                               // Close the dialog
//                               Navigator.of(context).pop();
//                             },
//                             child: Text('Cancel'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               final findListFuelType fuelType = findListFuelType();
//                               fuelType.Deletefuel(item.itemId);
//                               print(item.itemId);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => LoaderFuel(),
//                                 ),
//                               );
//                             },
//                             child: Text('Delete'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),




//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   return Padding(
//   padding: EdgeInsets.only(bottom:310),
//   child: ListView(
//     padding: EdgeInsets.zero, // Remove default padding
//     children: tiles,
//   ),
// );

// }


        




void _handleItemTapLicense(BuildContext context, String itemId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => License_info(itemId: itemId),
    ),
  );
}



  
}

class findListLicense
{ 
  Future<ItemListWithCountLicense> createListLicense() async
  { findListWork listingLicense =findListWork();
    String role_assign =await listingLicense.assignRole();
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
    String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
    String role=userDetails.isNotEmpty ? userDetails[5] : '';

      if (userDetails.isEmpty) 
      {
        return ItemListWithCountLicense(count: 0, items: []);

      } 

      http.Response response;
        var usell = Uri.encodeQueryComponent('{'+
          '"bims_access_id":"$ifleetData",'+
          '"item_type_ids":["ityp-11962a26708945e0a67be504cf31def6"],'+
          '"action":"LIST_ITEM",'+
          '"details":["item_id","item_number","title","registered_date","finalized_ind","User","content_id","item_type_id","item_type_title","item_type_icon","item_type_icon_color","child_count","has_doc_store","has_related_item","field_item_list","metadata"]'+
        '}');

          Map<String, String> headersModified = {};
        if (userDetails.isNotEmpty) {
          headersModified['cookie'] = userDetails[3];

        }

        response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);

         if (response.statusCode == 200){
           Map<String, dynamic> result = json.decode(response.body);
            if (result['success'] == true){
              print(result);
              List<dynamic> results = result['results'];
               List<license_data> items = [];
                for (var itemData in results){
                  String title = Uri.decodeComponent(itemData['title']?? '');
                  String itemId = Uri.decodeComponent(itemData['item_id']?? '');
                  Map<String, dynamic>? user_data=itemData['metadata'];
                  String lic_exp="";
                  String lic_class="";
                  lic_exp = user_data?['license_expired_date']?? '';
                  lic_class = user_data?['license_class']?? '';
                   
                  items.add(license_data(title:title,license_id:itemId ,expired_date:lic_exp ,license_class:lic_class ));
                  
                }

                int count = items.length;     
                 return ItemListWithCountLicense(count: count, items: items);
             
            }else 
            {
              return ItemListWithCountLicense(count: 0, items: []);
            }
         }
         else
         {
           return ItemListWithCountLicense(count: 0, items: []);
         }
   
         
    
  }

}

class license_data {
  final String title;
  final String license_id;
  final String expired_date;
  final String license_class;

  license_data({required this.title,required this.license_id,required this.expired_date,required this.license_class});
}

class ItemListWithCountLicense {
  final int count;
  final List<license_data> items;

  ItemListWithCountLicense({required this.count, required this.items});
}