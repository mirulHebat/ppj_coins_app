
import 'package:ppj_coins_app/maintenance_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppj_coins_app/addService.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';


class LoaderMaintenance extends StatefulWidget {
  LoaderMaintenance({Key? key}) : super(key: key);

  @override
  State<LoaderMaintenance> createState() => LoaderStateMaintenance();
}

class LoaderStateMaintenance extends State<LoaderMaintenance> 
{
  var shouldPop=false;
  var count;
  late PageController controller;
  String role_assign="";
   ItemListWithCountMaint itemListWithCount = ItemListWithCountMaint(count: 0, items: []); 
    Color customColor = Color(0xFF1647AF);
   Color custom = Color(0xFFF2F2F2);
  bool showFloatingActionButton = true;
  late int _selectedIndex;
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  void _onItemTapped(int index) {
    setState(() {
      // selectedIndex = index;
      if (controller.hasClients) {
        controller.jumpToPage(
          index,
          // duration: const Duration(milliseconds: 400),
          // curve: Curves.fastOutSlowIn,
        );
      }
    });
  
     
  }

  void MaintenanceTap(BuildContext context, String itemId,String? status) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => maintainDetail(itemId: itemId,status:status),
    ),
  );
}

  Future<void> ListviewMaintenance() async {
  final findlist_maint fmain = findlist_maint();
  if(itemListWithCount.items.isEmpty)
  {
      itemListWithCount = await fmain.createList("","","");
  }


  print(itemListWithCount.items); // Obtain item list with count
  int newCount = itemListWithCount.count;

  if (newCount != count) { // Only update state if count has changed
    setState(() {
      count = newCount;
    });
  }
}

  void onPageChanged(int pagenum) {
    setState(() {
      _selectedIndex = pagenum;
    });
  }


  Future<void> _showLoadingDialog(BuildContext context) async {
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
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  role_assign  = userDetails.isNotEmpty ? userDetails[5] : '';
  print('role');
  print(role_assign);
  if(role_assign == "iFMS Driver")
  {
    // setState(){
      showFloatingActionButton=false;
    // };
    
  }
  
    
  }

  Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  
  
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

void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Filters'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Month Selection Field
              TextField(
                controller: _monthController,
                readOnly: true,
                onTap: () {
                  List<String> months = [
                    'All', 'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'
                  ];

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
                              value: null,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _monthController.text = newValue;
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
                },
                decoration: InputDecoration(
                  labelText: 'Select Month',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              SizedBox(height: 8),

              // Year Selection Field
              TextField(
                controller: _yearController,
                readOnly: true,
                onTap: () {
                  int currentYear = DateTime.now().year;
                  List<int> years = List.generate(10, (index) => currentYear - 5 + index);
                  years.insert(0, 0); // Add "All" option

                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ListView.builder(
                        itemCount: years.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(years[index] == 0 ? 'All' : years[index].toString()),
                            onTap: () {
                              _yearController.text = years[index] == 0 ? 'All' : years[index].toString();
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          );
                        },
                      );
                    },
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Select Year',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              SizedBox(height: 8),

              // Work Order Status Field
              TextField(
                controller: _statusController,
                readOnly: true,
                onTap: () {
                  List<String> statuses = ['All', 'Completed', 'In Progress', 'Terminated','New'];

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Status'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Select a status',
                                border: OutlineInputBorder(),
                              ),
                              value: null,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  _statusController.text = newValue;
                                  Navigator.of(context).pop(); // Close the dialog
                                }
                              },
                              items: statuses.map<DropdownMenuItem<String>>((String value) {
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
                },
                decoration: InputDecoration(
                  labelText: 'Select Status',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.filter_list),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                print('month controller: ${_monthController.text}');
                print('year controller: ${_yearController.text}');
                print('status controller: ${_statusController.text}');

                final findlist_maint fmain = findlist_maint();
                var filtered = await fmain.createList(_monthController.text, _yearController.text, _statusController.text);

                print("filtered");
                print(filtered.count);

                if (filtered.count != 0) {
                  setState(() {
                    itemListWithCount = filtered;
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('No Data'),
                        content: Text('No data available for the selected filters.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }

                Navigator.of(context).pop(); // Close the filter dialog
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
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
                     child:Consumer(builder: (context, ref, child) => Padding(
                    padding:  EdgeInsets.only(bottom: h*0.12,right: w*0.04),
                    child: FloatingActionButton(
                      heroTag: 'fab2',
                      onPressed: () 
                      {
                        print('hello');
                         ref.invalidate(poDetArray);
                          ref.invalidate(Labor_pricing);
                          ref.invalidate(Part_pricing);
                          ref.invalidate(tax_pricing);
                          ref.invalidate(total_pricing);
                          ref.invalidate(tax_percent);
                            Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (
                                
                                builder: (context) => AddService(),
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
                ),
              ],
            ),

            
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      body: FutureBuilder(
        future: ListviewMaintenance(),
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
                                    "Service Entries",
                                    style: TextStyle(fontSize: h * 0.03, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),

                                Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.filter_list, size: 30.0, color: Colors.white),// Filter icon
                                  onPressed: () {
                                    _showFilterDialog(context);
                                  },
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
                          // Month Selection Field
                          // Expanded(
                          //   flex: 2,
                          //   child: Container(
                          //     padding: EdgeInsets.only(left: 8.0),
                          //     child: TextField(
                          //       controller: _monthController,
                          //       readOnly: true,
                          //       onTap: () {
                          //         List<String> months = [
                          //           'All', 'January', 'February', 'March', 'April', 'May', 'June',
                          //           'July', 'August', 'September', 'October', 'November', 'December'
                          //         ];

                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('Select Month'),
                          //               content: Column(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   DropdownButtonFormField<String>(
                          //                     decoration: InputDecoration(
                          //                       hintText: 'Select a month',
                          //                       border: OutlineInputBorder(),
                          //                     ),
                          //                     value: null, // No initial value
                          //                     onChanged: (String? newValue) {
                          //                       if (newValue != null) {
                          //                         _monthController.text = newValue;
                          //                         Navigator.of(context).pop(); // Close the dialog
                          //                       }
                          //                     },
                          //                     items: months.map<DropdownMenuItem<String>>((String value) {
                          //                       return DropdownMenuItem<String>(
                          //                         value: value,
                          //                         child: Text(value),
                          //                       );
                          //                     }).toList(),
                          //                   ),
                          //                 ],
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       },
                          //       decoration: InputDecoration(
                          //         labelText: 'Select Month',
                          //         border: OutlineInputBorder(),
                          //         suffixIcon: Icon(Icons.calendar_today),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(width: 8),

                          // // Year Selection Field
                          // Expanded(
                          //   flex: 2,
                          //   child: Container(
                          //     child: Stack(
                          //       alignment: Alignment.centerRight,
                          //       children: [
                          //         TextField(
                          //           controller: _yearController,
                          //           readOnly: true,
                          //           onTap: () {
                          //             int currentYear = DateTime.now().year;
                          //             List<int> years = List.generate(10, (index) => currentYear - 5 + index);

                          //             years.insert(0, 0); // Add "All" option

                          //             showModalBottomSheet(
                          //               context: context,
                          //               builder: (BuildContext context) {
                          //                 return ListView.builder(
                          //                   itemCount: years.length,
                          //                   itemBuilder: (BuildContext context, int index) {
                          //                     return ListTile(
                          //                       title: Text(years[index] == 0 ? 'All' : years[index].toString()),
                          //                       onTap: () {
                          //                         _yearController.text = years[index] == 0 ? 'All' : years[index].toString();
                          //                         Navigator.pop(context); // Close the bottom sheet
                          //                       },
                          //                     );
                          //                   },
                          //                 );
                          //               },
                          //             );
                          //           },
                          //           decoration: InputDecoration(
                          //             labelText: 'Select Year',
                          //             border: OutlineInputBorder(),
                          //             suffixIcon: Icon(Icons.calendar_today),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(width: 8),

                          // // Work Order Status Field
                          // Expanded(
                          //   flex: 2,
                          //   child: Container(
                          //     padding: EdgeInsets.only(left: 8.0),
                          //     child: TextField(
                          //       controller: _statusController,
                          //       readOnly: true,
                          //       onTap: () {
                          //         List<String> statuses = ['All', 'Completed', 'In Progress', 'Pending'];

                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('Select Status'),
                          //               content: Column(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   DropdownButtonFormField<String>(
                          //                     decoration: InputDecoration(
                          //                       hintText: 'Select a status',
                          //                       border: OutlineInputBorder(),
                          //                     ),
                          //                     value: null, // No initial value
                          //                     onChanged: (String? newValue) {
                          //                       if (newValue != null) {
                          //                         _statusController.text = newValue;
                          //                         Navigator.of(context).pop(); // Close the dialog
                          //                       }
                          //                     },
                          //                     items: statuses.map<DropdownMenuItem<String>>((String value) {
                          //                       return DropdownMenuItem<String>(
                          //                         value: value,
                          //                         child: Text(value),
                          //                       );
                          //                     }).toList(),
                          //                   ),
                          //                 ],
                          //               ),
                          //             );
                          //           },
                          //         );
                          //       },
                          //       decoration: InputDecoration(
                          //         labelText: 'Select Status',
                          //         border: OutlineInputBorder(),
                          //         suffixIcon: Icon(Icons.filter_list),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(width: 8),

                          // Search Button
                          // IconButton(
                          //   icon: Icon(Icons.search),
                          //   onPressed: () async {
                          //     print('month controller');
                          //     print(_monthController.text);
                          //     print(_yearController.text);
                          //     print(_statusController.text); // Add this line
                          //     final findlist_maint fmain = findlist_maint();
                          //     var filtered = await fmain.createList(_monthController.text, _yearController.text, _statusController.text);
                          //     print("filtered");
                          //     print(filtered.count);
                          //     if (filtered.count != 0) {
                          //       setState(() {
                          //         itemListWithCount = filtered;
                          //       });
                          //     } else {
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return AlertDialog(
                          //             title: Text('No Data'),
                          //             content: Text('No data available for the selected filters.'),
                          //             actions: <Widget>[
                          //               TextButton(
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop();
                          //                 },
                          //                 child: Text('OK'),
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     }
                          //   },
                          // ),
                      
                      
                      
                    SizedBox(height: h*0.01,),
                        // PageView
                        Expanded(
                          child: PageView(
                            controller: controller,
                            onPageChanged: onPageChanged,
                            children: <Widget>[
                              buildListTiles(itemListWithCount),
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

Widget buildListTiles(ItemListWithCountMaint itemListWithCount)
{
  List<Widget> tiles = [];

  for (var item in itemListWithCount.items)
  {
    tiles.add(
  
      Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.symmetric(vertical: 0.5),
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
                padding: EdgeInsets.only(bottom: 10.0), // Add padding to the top
                child: GestureDetector(
                onTap: () => MaintenanceTap(context, item.itemId, item.work_status), // Trigger onTap only for the icon
                child: item.work_status == 'Completed'
                ? Icon(Icons.done, size: 30, color: Colors.green)
                : item.work_status == 'Terminated'
                    ? Icon(Icons.cancel, size: 30, color: Colors.red) // Terminate icon
                    : Icon(FontAwesomeIcons.carRear, size: 30, color: Colors.black),
                  ),
             

              ),
              SizedBox(width: 10), // Add space between the icon and the title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the start (left)
                  children: [
                    // Text(
                    //   '${item.item_number}',
                    //   style: TextStyle(fontSize: 20.0),
                    //   textAlign: TextAlign.center, // Center the text
                    // ),
                    // SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '${item.title}',
                          style: TextStyle(fontSize: 20.0, color: Colors.black), // Black color for the item title
                          textAlign: TextAlign.center,
                        ),
                        //  Container(
                        //   padding: EdgeInsets.all(4.0), // Add padding around the icon
                          
                        //   child: Icon(Icons.notifications, size: 20.0, color: Colors.black), // Icon properties
                        // ),
                      ],
                      
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Work Order Status:${item.work_status}',
                          style: TextStyle(fontSize: 15.0, color: Colors.black), // Black color for the item title
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                    ),
                      SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Driver: ${item.driver}',
                            style: TextStyle(fontSize: 15.0, color: Colors.black), // Black color for the item title
                            // textAlign: TextAlign.center,
                            maxLines: null, // Allow unlimited lines
                            overflow: TextOverflow.visible, // Handle overflow by wrapping text
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Start At:',
                                style: TextStyle(fontSize: 15.0, color: Colors.black), // Gray color for "Start At:"
                              ),
                              TextSpan(
                                text: ' ${item.startAt}',
                                style: TextStyle(fontSize: 15.0, color: Colors.black), // Black color for the item.startAt value
                              ),
                            ],
                          ),
                        )
                      ],
                      
                    ),
                  //  Row(
                  //   children: [
                  //     Text(
                  //       'Date: ',
                  //       style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     Flexible(
                  //       child: Text(
                  //         '${item.registered_date}',
                  //         style: TextStyle(fontSize: 16.0, color: Colors.black),
                  //         textAlign: TextAlign.center,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Visibility(
                  //   visible: showFloatingActionButton,
                  //    child: Row(
                  //     children: [
                  //       Text(
                  //         'Driver: ',
                  //         style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       Flexible(
                  //         child: Text(
                  //           '${item.user}',
                  //           style: TextStyle(fontSize: 16.0, color: Colors.black),
                  //           textAlign: TextAlign.center,
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //       ),

                  //       ],
                    
                  // ),

                  // )

                  ]
  
                ),
              ),


               PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                child: Text('View Service Detail'),
                value: 'View',
                ),
                if (showFloatingActionButton) 
                PopupMenuItem<String>(
                child: Text('Update Status'),
                value: 'Update',
                ),
                if (showFloatingActionButton) 
                PopupMenuItem<String>(
                child: Text('Delete'),
                value: 'Delete',
                ),
                ];

              },
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                // Handle menu item selection
                if (value == 'Update') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Update Status Work Order'),
                          
                          actions: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch, // To make buttons take full width
                              children: [
                                ElevatedButton(
                                  onPressed: ()async {
                                    if(item.POState =="Completed"||item.POState =="")
                                    {
                                      _showLoadingDialog(context);
                                        f_Service f_ss=f_Service();
                                      await f_ss.updateWorkOrder(item.workID,"Terminated");
                                      
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoaderMaintenance(),
                                        ),
                                      );

                                    }
                                    else
                                    {
                                      showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Purchase Order Status Not Complete'),
                                          content: Text('Ensure to review the status of the purchase Order to confirm if it is completed.'),
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

                                    }
                                   
                                  },
                                  child: Text('Terminated'),
                                ),
                                ElevatedButton(
                                  onPressed: ()async {
                                    _showLoadingDialog(context);
                                    f_Service f_ss=f_Service();
                                   await f_ss.updateWorkOrder(item.workID,"Work in Progress");
                                     Navigator.pop(context);
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoaderMaintenance(),
                                    ),
                                  );
                                  },
                                  child: Text('Work in Progress'),
                                ),
                                ElevatedButton(
                                  onPressed: ()async {
                                    if(item.POState =="Completed"||item.POState =="")
                                    {
                                      f_Service f_ss=f_Service();
                                      bool validation=true;
                                      validation=await f_ss.WorkValidate(item.workID);
                                      print('nilai bool $validation');
                                      print('Help button pressed');

                                      if (!validation) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Work Order Status Not Complete'),
                                                content: Text('Ensure to review the status of the work order line item to confirm if it is completed or terminated.'),
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
                                        }
                                        else
                                        {
                                          f_Service f_ss=f_Service();
                                          _showLoadingDialog(context);
                                        await f_ss.updateWorkOrder(item.workID,"Completed");
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoaderMaintenance(),
                                          ),
                                        );

                                        }

                                    }
                                    else
                                    {
                                      showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Purchase Order Status Not Complete'),
                                          content: Text('Ensure to review the status of the purchase Order to confirm if it is completed.'),
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

                                    }
                                    
                                  },
                                  child: Text('Completed'),
                                ),
                              ],
                            ),
                          ],
                        );

                    },
                  );
                } else if (value == 'Delete') {
                  if(item.work_status =="Terminated")
                  {
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Confirmation'),
                        content: Text('Are you sure you want to Delete?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              
                              final findlist_maint deleMaintenance = findlist_maint();
                              deleMaintenance.Deletemaintenance(item.itemId);
                              print(item.itemId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoaderMaintenance(),
                                ),
                              );
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  }
                  else
                  {
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Work Order Status Not terminated'),
                        content: Text('Ensure to review the status of the work order to confirm  it is terminated.'),
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

                  }
                  
                }
                else if(value =='View')
                {
                   MaintenanceTap(context, item.itemId,item.work_status);
                }
              },
            ),
  
          // ),




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


}

class findlist_maint
{



Future<List<String>> createWorkOrder(String itemId) async {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  http.Response response;

  var usell = Uri.encodeQueryComponent('{' +
      '"bims_access_id":"$ifleetData",' +
      '"action":"ITEM_DETAIL",' +
      '"item_id":"$itemId",' +
      '"item_type_id":"ityp-7fd81cb7d5b94374acb37a6ce23f3b41",' +
      '"details":["item_id","item_number","item_type_id","content_id","checkout_ind","checkout_id","checkin_ind","access_control","metadata"]' +
      '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);

  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);
    print('nilai maintenance');
    print(result);

    if (result['success'] == true) {
      List<dynamic> results = result['results'];
      String issuedby = "";
      String work_status = "";
      String POstatus="";
     // Uncomment if needed
      for (var itemData in results) {
        Map<String, dynamic>? user_data = itemData['metadata'];
        print('userdata $user_data');
        if (user_data != null) {
          Map<String, dynamic>? user_data_nilai = user_data['issued_by_id'];
          if (user_data_nilai?['title'] == null) {
            issuedby = "";
          } else {
            issuedby = user_data_nilai?['title'];
          }

          // Uncomment if you need to fetch work order status
          Map<String, dynamic>? user_data_status = user_data['work_order_status'];
          if (user_data_status?['display'] == null) {
            work_status = "";
          } else {
            work_status = user_data_status?['display'];
            print(work_status);
          }

          Map<String,dynamic>? user_purchase =user_data['purchase_order_number'];
          if(user_purchase?['item_id']!=null) {
                POstatus= await createPurchaseOrder(user_purchase?['item_id']);
          }
        }
      }
      return [issuedby, work_status,itemId,POstatus]; // Return a list containing issuedby and work_status
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<String> createPurchaseOrder(String itemId) async{
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  http.Response response;
    var usell = Uri.encodeQueryComponent('{' +
      '"bims_access_id":"$ifleetData",' +
      '"action":"ITEM_DETAIL",' +
      '"item_id":"$itemId",' +
      '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",' +
      '"details":["item_id","item_number","item_type_id","content_id","checkout_ind","checkout_id","checkin_ind","access_control","metadata"]' +
      '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);

   if (response.statusCode == 200){
    Map<String, dynamic> result = json.decode(response.body);
    print('nilai purchase order');
    print(result);

    if (result['success'] == true){
      List<dynamic> results = result['results'];
      for (var itemData in results) {
         Map<String, dynamic>? user_data = itemData['metadata'];
         if (user_data != null)
         { 
           Map<String, dynamic>? user_data_POstat = user_data['purchase_order_status'];
           if(user_data_POstat?['display'] !=null)
           {
            print('postate ${user_data_POstat?['display']}');
            return user_data_POstat?['display'];
           }


         }



      }
      return "";

    }
    else
    {
      return "";
    }

   }
   else
   {
    return "";
   }
}

 void Deletemaintenance(String item_id) async {
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

   

  if (response.statusCode == 200) {

    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
      print('done success submit');
    } else {

      print(response.body);

    }
  } else {
      print('response.body');
      print(response.body);

    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
// Return 0 if request failed
  }
}



   Future<ItemListWithCountMaint> createList(String month,String year,String status) async
   {
    findList fList=findList();
    int targetMonth = fList.parseMonth(month);
    int targetYear;
     if (year.isNotEmpty) {
      if (year == 'All') {
        targetYear = 0;
      } else {
        targetYear = int.parse(year);
      }
    } else {
      targetYear = 0;
    }
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
    String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
    String role=userDetails.isNotEmpty ? userDetails[5] : '';
    String namadri = userDetails.isNotEmpty 
    ? userDetails[6].replaceAll(' ', '').toUpperCase() 
    : '';



    if(userDetails.isEmpty)
    {
      return ItemListWithCountMaint(count: 0, items: []);
    }

      http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"item_type_ids":["ityp-c4a658cde9394eb5a03e599702e9a351"],'+
    '"action":"LIST_ITEM",'+
    '"details":["item_id","item_number","title","registered_date","finalized_ind","User","content_id","item_type_id","item_type_title","item_type_icon","item_type_icon_color","child_count","has_doc_store","has_related_item","field_item_list","metadata"]'+
    '}');

      Map<String, String> headersModified = {};
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];
      print(headersModified['cookie']);
    }
      response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);
    print('response');

    if (response.statusCode == 200) 
    {
      Map<String, dynamic> result = json.decode(response.body);
      if (result['success'] == true)
      {
         List<dynamic> results = result['results'];
         print(results);
         print('nilai list service');
          List<Service_entries> items = [];
          for (var itemData in results)
          {
             String title = Uri.decodeComponent(itemData['title']?? '');
             String itemId = Uri.decodeComponent(itemData['item_id']?? '');
             String start_date = Uri.decodeComponent(itemData['registered_date']?? '');
             Map<String, dynamic>? user_data=itemData['metadata'];
             String namedriver ="";
             String namenospace="";
              List<String> issueby = [];
              if(user_data !=null)
              {  print('dsjeij');
                 Map<String, dynamic>? user_data_nilai=user_data['driver_id'];
                 print(user_data_nilai?['title']);
                 if(user_data_nilai?['title'] ==null)
                 {
                  namedriver="";
                  namenospace="";
                 }
                 else
                 {
                  namedriver = user_data_nilai?['title'];
                  namenospace=user_data_nilai?['title']?.replaceAll(' ', '');
                 }
                 print('dcsffewe');

                 Map<String, dynamic>? user_data_work;
                 if (user_data['linked_work_orders'] != null && user_data['linked_work_orders'].isNotEmpty) {
                    user_data_work = user_data['linked_work_orders'][0];
                  } else {
                    user_data_work = null;
                  }
                if(user_data_work?['item_id'] ==null)
                 {
                  issueby=["","","",""];
                 }
                 else
                 { 
                  issueby=await createWorkOrder(user_data_work?['item_id']);

                 }
                
              }

              int date = await fList.extractMonth(start_date); 
              int year = await fList.extractYear(start_date);
              print('tergetmonth $targetMonth');
              print('tergetmonth $date');
              print('tergetmonth $year');
              if(status =="")
              {
                status ="All";
              }

              print(issueby[0]);
              print(namadri);
              print('nama driver $namedriver');
              if( issueby[0] !="")
              {
                issueby[0]=issueby[0].replaceAll(' ', '');
                
              }
             
            // if(namadri == namedriver|| (issueby.isNotEmpty && issueby[0] == namadri))
            // namadri.contains(namedriver)||
            // issueby[0].contains(namadri)|| 
            if (namenospace.contains(namadri)||issueby[0].contains(namadri))
             {
              print('lepas');
               String workStatus = issueby.isNotEmpty ? issueby[1] : "";
               String workID= issueby.isNotEmpty ? issueby[2] : "";
               String postatus=issueby.isNotEmpty ? issueby[3] : "";
               print('nilai workID $workID');
      
                if(workStatus == status)
                {
                  items.add(Service_entries(title: title, itemId: itemId, startAt: start_date, work_status: workStatus, driver: namedriver,workID:workID,POState:postatus));
                }
                else if ((date == targetMonth && year == targetYear &&status =="All") || (targetMonth == 0 && targetYear == 0 &&status =="All") ) {  
                    items.add(Service_entries(title: title, itemId: itemId, startAt: start_date, work_status: workStatus, driver: namedriver,workID:workID,POState:postatus));
                } else if (date == targetMonth && targetYear == 0) {
                    items.add(Service_entries(title: title, itemId: itemId, startAt: start_date, work_status: workStatus, driver: namedriver,workID:workID,POState:postatus));
                } else if (year == targetYear && targetMonth == 0) {
                    items.add(Service_entries(title: title, itemId: itemId, startAt: start_date, work_status: workStatus, driver: namedriver,workID:workID,POState:postatus));
                }
                else if((date == targetMonth && year == targetYear &&workStatus == status))
                {
                  items.add(Service_entries(title: title, itemId: itemId, startAt: start_date, work_status: workStatus, driver: namedriver,workID:workID,POState:postatus));
                }

               
             }

          }

          int count = items.length;
          print('Count of results: $count');
          return ItemListWithCountMaint(count: count, items: items);

          

      }
      else
      {
        print('Failed to retrieve data');
      return ItemListWithCountMaint(count: 0, items: []);

      }
    }else
    {
         print('Request failed with status code: ${response.statusCode}');
        return ItemListWithCountMaint(count: 0, items: []);

    }

   }

}

class ItemListWithCountMaint {
  final int count;
  final List<Service_entries> items;

  ItemListWithCountMaint({required this.count, required this.items});
}

class Service_entries {
  final String title;
  final String itemId;
  final String? startAt;
  final String?work_status;
  final String? driver;
  final String? workID;
   final String? POState;


  Service_entries({required this.title, required this.itemId, required this.startAt,required this.work_status,required this.driver,required this.workID,required this.POState});
}