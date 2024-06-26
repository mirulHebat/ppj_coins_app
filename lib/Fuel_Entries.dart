
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ppj_coins_app/addFuel.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'dart:async';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';

class LoaderFuel extends StatefulWidget {
  LoaderFuel({Key? key}) : super(key: key);

  @override
  State<LoaderFuel> createState() => LoaderStateFuel();
}

class LoaderStateFuel extends State<LoaderFuel>  {
  var shouldPop=false;
  var count;
  final findList fList = findList();
  late PageController controller;
  String role_assign="";
  ItemListWithCount itemListWithCount = ItemListWithCount(count: 0, items: []); 
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
  final findList fList = findList();
  if(itemListWithCount.items.isEmpty)
  {
      itemListWithCount = await fList.createList("","");
  }// Obtain item list with count
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
  if(role_assign =="iFMS Manager")
  {
    showFloatingActionButton=false;
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
                            Navigator.push
                            (
                              context,
                              MaterialPageRoute
                              (       
                                builder: (context) => LoaderAddFueldata(),
                              ),
                            );
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
                                    "Fuel Consumption Entries",
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
                       Row(
                      children: [
                       Container(
                            width: 180, // Adjust the width as needed
                             padding: EdgeInsets.only(left: 8.0), // Add left padding
                            child: TextField(
                              controller: _monthController,
                              readOnly: true,
                              onTap: () {
                                showMonthPicker(context);
                              },
                              decoration: InputDecoration(
                                labelText: 'Select Month',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),

                        SizedBox(width: 8),
                        Container(
                          width: 170, // Adjust the width as needed
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: _yearController,
                                readOnly: true,
                                onTap: () {
                                  showYearPicker(context);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Select Year',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.search), // Search icon
                          onPressed: ()async {
                            final findList fList = findList();
                            var filtered = await fList.createList(_monthController.text,_yearController.text);
                            if (filtered.count != 0) {
                              setState(() {
                                itemListWithCount = filtered;
                              });
                            }else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('No Data'),
                                    content: Text('No data available for the selected month.'),
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
                            // Implement search functionality for month here
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: h*0.01,),

                    Expanded(
                      child: PageView(
                        controller: controller,
                        onPageChanged: onPageChanged,
                        children: <Widget>[
                          buildListTiles(itemListWithCount,showFloatingActionButton),
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


Widget buildListTiles(ItemListWithCount itemListWithCount,bool showFloatingActionButton) {
  List<Widget> tiles = [];
  
  showFloatingActionButton =!showFloatingActionButton;
  for (var item in itemListWithCount.items) {
    tiles.add(
  
      Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.symmetric(vertical: 0.5),
        decoration: BoxDecoration(
          color: custom,
           border: Border.all(
            color:const Color.fromARGB(31, 42, 41, 41),
           ),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left)
            children: [
            Padding(
                padding: EdgeInsets.only(bottom: 10.0), // Add padding to the top
                child: GestureDetector(
                  onTap: () => _handleItemTap(context, item.itemId), // Trigger onTap only for the icon
                   child: item.submit == 'true'
                  ? Icon(Icons.done, size: 30, color: Colors.green) // Display a checkmark icon if submit is 'yes'
                  : Icon(Icons.description, size: 30), // Display a document icon if submit is not 'yes'// Add icon to the left of the title
                ),
              ),
              SizedBox(width: 10), // Add space between the icon and the title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the start (left)
                  children: [
                    Text(
                      '${item.item_number}',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center, // Center the text
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'No Plate: ', // Change "Title" to "Document"
                          style: TextStyle(fontSize: 16.0, color: Colors.grey), // Gray color for the prefix
                          textAlign: TextAlign.center,
                        ),
                        
                        Text(
                          '${item.title}',
                          style: TextStyle(fontSize: 16.0, color: Colors.black), // Black color for the item title
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                    ),
                    SizedBox(height: 10),
                   Row(
                    children: [
                      Text(
                        'Date: ',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text(
                          '${item.registered_date}',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: showFloatingActionButton,
                     child: Row(
                      children: [
                        Text(
                          'Driver: ',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Flexible(
                          child: Text(
                            '${item.user}',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ],               
                  ),

                  )

                  ]
  
                ),
              ),

// Set the opacity based on the condition
            PopupMenuButton(
               itemBuilder: (BuildContext context) {
                List<PopupMenuEntry<String>> menuItems = [
                  PopupMenuItem(
                    child: Text('View Detail'),
                    value: 'View',
                  ),
                ];

                // Conditionally add 'Submit' item based on your opacity condition
                if (item.submit != "true") {
                  menuItems.add(
                    PopupMenuItem(
                      child: Text('Submit'),
                      value: 'Submit',
                    ),
                  );
                }

                // Conditionally add 'Delete' item based on your opacity condition
                if (item.submit != "true") {
                  menuItems.add(
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: 'Delete',
                    ),
                  );
                }

                return menuItems;
              },
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'Submit') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Submit Confirmation'),
                        content: Text('Are you sure you want to submit?'),
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
                              final findListFuelType fuelType = findListFuelType();
                              fuelType.submitfuel(item.itemId);
                              print(item.itemId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoaderFuel(),
                                ),
                              );
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (value == 'Delete') {
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
                              final findListFuelType fuelType = findListFuelType();
                              fuelType.Deletefuel(item.itemId);
                              print(item.itemId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoaderFuel(),
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
                else if( value == 'View')
                {
                  _handleItemTap(context, item.itemId); 
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

void _handleItemTap(BuildContext context, String itemId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoaderFDetail(itemId: itemId),
    ),
  );
}

}

class findList
{
      int parseMonth(String monthName) {
      // Define a mapping from month names to their numerical representations
      final Map<String, int> monthMap = {
        'All':0,
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      // Convert month name to lowercase to handle case-insensitive comparison
      String lowercaseMonthName = monthName;
      print(lowercaseMonthName);
      
      // Check if the month name exists in the mapping
      if (monthMap.containsKey(lowercaseMonthName)) {
        return monthMap[lowercaseMonthName]!;
      } else {
        // If month name is not found, return 0 or handle it as needed
        return 0;
      }
    }

    int extractMonth(String dateString) {
      print(dateString);
  // Split the date string by '/' to get the parts
      List<String> parts = dateString.split('/');
      
      // Check if the parts contain the month part
      if (parts.length >= 2) {
        // Extract the month part and convert it to an integer
        return int.tryParse(parts[1]) ?? 0;
      } else {
        // Return 0 or handle it as needed if month part is not found
        return 0;
      }
    }

    int extractYear(String dateString) {
      print(dateString);
      print('masuk extractYear');
  // Split the date string by '/' to get the parts
  List<String> parts = dateString.split('/');
  
  // Check if the parts contain the year part
  if (parts.length >= 3) {
    // Extract the year part and convert it to an integer
    // Remove any additional characters after the year part
    String yearString = parts[2].split(' ')[0];
    return int.tryParse(yearString) ?? 0;
  } else {
    // Return 0 or handle it as needed if year part is not found
    return 0;
  }
}

  Future<ItemListWithCount> createList(String month,String year) async {
  int targetMonth = parseMonth(month);
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
 
  findListWork assign =findListWork();
  String role_assign =await assign.assignRole();
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
  // String role=userDetails.isNotEmpty ? userDetails[5] : '';

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isEmpty) {
    return ItemListWithCount(count: 0, items: []);
  } 
  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"item_type_ids":["ityp-b19c8b7d68af470ca6ff11eda2fe41ab"],'+
    '"action":"LIST_ITEM",'+
    '"details":["item_id","item_number","title","registered_date","finalized_ind","User","content_id","item_type_id","item_type_title","item_type_icon","item_type_icon_color","child_count","has_doc_store","has_related_item","field_item_list","metadata"]'+
  '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  
  response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);
  if (response.statusCode == 200) {
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
    
      List<dynamic> results = result['results'];
        List<Item_fuel_entries> items = [];
      for (var itemData in results) {
        print('Item: $itemData');
        print(Uri.decodeComponent(itemData['item_number']));
        String title = Uri.decodeComponent(itemData['title']?? '');
        String itemId = Uri.decodeComponent(itemData['item_id']?? '');
        String item_number = Uri.decodeComponent(itemData['item_number']?? '');
        String registered_date=Uri.decodeComponent(itemData['registered_date']?? '');
        String submit="";
        Map<String, dynamic>? user_data=itemData['metadata'];
        String userid="";
        String user_title="";
        if(user_data !=null)
        {  Map<String, dynamic>? user_data_nilai=user_data['user_id'];

            userid = user_data_nilai?['user_id'] ?? '';
            String user_data_title=user_data['user_id']?['full_name']?? '';
            user_title = user_data_title;

          Map<String, dynamic>? submit_obj = user_data['submit_ind'];
          if(submit_obj !=null)
          {
            submit=submit_obj['value']?? '';
          }

        }
         int date = await extractMonth(registered_date); 
         int year = await extractYear(registered_date);

         if(user_session_id ==userid)
         {
           
              if ((date == targetMonth && year ==targetYear)||(targetMonth==0 &&targetYear == 0)) 
              {
                items.add(Item_fuel_entries(title: title, itemId: itemId,item_number: item_number,registered_date:registered_date,submit:submit,user:user_title));
              }
              else if(date == targetMonth && year ==0)
              {
                items.add(Item_fuel_entries(title: title, itemId: itemId,item_number: item_number,registered_date:registered_date,submit:submit,user:user_title));
              }
              else if(year ==targetYear && date ==0)
              {
                items.add(Item_fuel_entries(title: title, itemId: itemId,item_number: item_number,registered_date:registered_date,submit:submit,user:user_title));
              }
           

         }

         if(role_assign=="iFMS Manager")
         {
          if(submit =="true" )
           {

              if ((date == targetMonth && year ==targetYear)||(targetMonth==0 &&targetYear == 0)) 
              {
                items.add(Item_fuel_entries(title: title, itemId: itemId,item_number: item_number,registered_date:registered_date,submit:submit,user:user_title));
              }
              else if(date == targetMonth)
              {
                items.add(Item_fuel_entries(title: title, itemId: itemId,item_number: item_number,registered_date:registered_date,submit:submit,user:user_title));
              }
              else if(year ==targetYear)
              {
                items.add(Item_fuel_entries(title: title, itemId: itemId,item_number: item_number,registered_date:registered_date,submit:submit,user:user_title));
              }

           }

         }

      
      }
      int count = items.length;
      return ItemListWithCount(count: count, items: items);
    } else {
      return ItemListWithCount(count: 0, items: []);// Return 0 if success is false
    }
  } else {
    return ItemListWithCount(count: 0, items: []);// Return 0 if request failed
  }
}

    
}

class Item_fuel_entries {
  final String title;
  final String itemId;
  final String item_number;
  final String registered_date;
  final String? submit;
  final String? user;

  Item_fuel_entries({required this.title, required this.itemId,required this.item_number,required this.registered_date,required this.submit,required this.user});
}

class ItemListWithCount {
  final int count;
  final List<Item_fuel_entries> items;

  ItemListWithCount({required this.count, required this.items});
}

class FilterIconButton extends StatefulWidget {
  @override
  _FilterIconButtonState createState() => _FilterIconButtonState();
}

class _FilterIconButtonState extends State<FilterIconButton> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
      child: IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () {
          setState(() {
            _isMenuOpen = !_isMenuOpen;
          });
        },
      ),
    );
  }
}