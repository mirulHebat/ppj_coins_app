
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/Assignment.dart';
import 'package:ppj_coins_app/vehicle_selection.dart';
import 'dart:async';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';


class LoaderWork extends StatefulWidget {
  LoaderWork({Key? key}) : super(key: key);

  @override
  State<LoaderWork> createState() => _LoaderState();
}

class _LoaderState extends State<LoaderWork>  {
  var shouldPop=false;
  var count;
  final findListWork fList = findListWork();
  late PageController controller;
  String role_assign="";
  bool showFloatingActionButton = true;
  ItemListWithCount itemListWithCount = ItemListWithCount(count: 0, items: []); 
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  late int _selectedIndex;
     Color customColor = Color(0xFF1647AF);
     Color custom = Color(0xFFF2F2F2);
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

Future<void> ListviewWork() async {
  final findListWork fList = findListWork();
  if(itemListWithCount.items.isEmpty)
  {
      itemListWithCount = await fList.createList("","");
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

  void VehshowMonthPicker(BuildContext context) {
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

void VehshowYearPicker(BuildContext context) {
  // Generate a list of years
  int currentYear = DateTime.now().year;
  List<int> years = List.generate(10, (index) => currentYear - 5 + index);

  // Show the bottom sheet with the list of years
  years.insert(0, 0);
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
                                
                                builder: (context) => VehicleSelection(),
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
        future: ListviewWork(),
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
                              // borderRadius: BorderRadius.circular(10),
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
                                    "Vehicle Assignment Entries",
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
                          width: 180,
                          padding: EdgeInsets.only(left: 8.0), // Adjust the width as needed
                          child: TextField(
                            controller: _monthController,
                            readOnly: true,
                            onTap: () {
                              
                               VehshowMonthPicker(context);
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
                                   
                                 VehshowYearPicker(context);
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
                            final findListWork fList = findListWork();
                            var filtered = await fList.createList(_monthController.text,_yearController.text);
                            if (filtered.count != 0) {
                              setState(() {
                                itemListWithCount = filtered;
                                // Update the state with the new itemListWithCount
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
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: h*0.01,),




                        // PageView
                      Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height, // Set height to screen height
                          child: PageView(
                            controller: controller,
                            onPageChanged: onPageChanged,
                            children: <Widget>[
                              buildListTiles(itemListWithCount,showFloatingActionButton),
                              // Add more children if needed
                            ],
                          ),
                        ),
                      ),
                      )
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


  // Generate list tiles based on the items in itemListWithCount
  for (var item in itemListWithCount.items) {
    print('icon checkpoint');
    print(item.submit);
    tiles.add(
  
      Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.symmetric(vertical: 0.5),
        decoration: BoxDecoration(
          color: custom,
          // borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color:const Color.fromARGB(31, 42, 41, 41),
            // width: 2.0,
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'No Plate: ', 
                          style: TextStyle(fontSize: 16.0, color: Colors.grey), // Gray color for the prefix
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${item.title}',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      
                      ],
                      
                    ),
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
                  )
                  )
                  

                  ],
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
                // Handle menu item selection
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
                              final findListWork workSubmit = findListWork();
                              workSubmit.submitwork(item.itemId);
                              print(item.itemId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoaderWork(),
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
                              final findListWork deleteWork = findListWork();
                              deleteWork.Deletework(item.itemId);
                              print(item.itemId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoaderWork(),
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
                else if(value =='View')
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

  // Wrap the list of tiles with a ListView for scrolling
    return Padding(
  padding: EdgeInsets.only(bottom:310),
  child: ListView(
    padding: EdgeInsets.zero, // Remove default padding
    children: tiles,
  ),
);
  // return ListView(
  //   padding: EdgeInsets.zero, // Remove default padding
  //   children: tiles,
  // );
}


        




void _handleItemTap(BuildContext context, String itemId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoaderAssign_detail(itemId: itemId),
    ),
  );
}



  
}

class findListWork
{


  Future<ItemListWithCount> createList(String month,String year) async {
   findList find_L=findList();
   int targetMonth = find_L.parseMonth(month);
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
  String role_assign =await assignRole();
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
  String role=userDetails.isNotEmpty ? userDetails[5] : '';

   print('check detail ');
 print(role_assign);

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isNotEmpty) {

  } else {

     return ItemListWithCount(count: 0, items: []);
   
  }

  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"item_type_ids":["ityp-2662e8be34ca40aba7ad5e3f38c361b0"],'+
    '"action":"LIST_ITEM",'+
    '"details":["item_id","item_number","title","registered_date","finalized_ind","User","content_id","item_type_id","item_type_title","item_type_icon","item_type_icon_color","child_count","has_doc_store","has_related_item","field_item_list","metadata"]'+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];

  }
  
  response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);


  if (response.statusCode == 200) {

    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
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
        String userid="";
        String submit="";
        String user_title="";
        Map<String, dynamic>? user_data=itemData['metadata'];
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
        final findList statef =findList();
         int date = await statef.extractMonth(registered_date); 
        int year = await statef.extractYear(registered_date);
         print('check date');
         print(date);
         print(role);
         if(user_session_id ==userid)
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
      print(items);
      int count = items.length;
      print('Count of results: $count');
      return ItemListWithCount(count: count, items: items);
    } else {
      print('Failed to retrieve data');
      return ItemListWithCount(count: 0, items: []);// Return 0 if success is false
    }
  } else {
    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
    return ItemListWithCount(count: 0, items: []);// Return 0 if request failed
  }
}

   void submitwork(String item_id) async {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isNotEmpty) {
    // Accessing the first element

  } else {


  }

  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-2662e8be34ca40aba7ad5e3f38c361b0","item_id":"'+item_id+'","submit_ind":{"code":"true","value":"true","display":"Yes"}}'+
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
      print('done success submit');
    } else {

      print(response.body);

    }
  } else {

    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
// Return 0 if request failed
  }
}  

 void Deletework(String item_id) async {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isNotEmpty) {
    // Accessing the first element

  } else {

  }

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

  Future<String> assignRole () async
  {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String role_id = userDetails.isNotEmpty ? userDetails[1] : '';
        if (userDetails.isNotEmpty) {
    // Accessing the first element

        } else {

        }

        http.Response response;
        var usell = Uri.encodeQueryComponent('{"bims_access_id":"$ifleetData","action":"LIST_ITEM_GROUP","user_id":"$role_id","details":["full_name"]}');
          Map<String, String> headersModified = {};
          if (userDetails.isNotEmpty) {
            print('nilai cookie');
            print(userDetails[3]);
            headersModified['cookie'] = userDetails[3];
          }

           response = await http.get(Uri.parse('https://lawanow.com/bims-web/User?param=$usell'), headers: headersModified);
             if (response.statusCode == 200) {

    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
      print('done success submit assign role');
      print(result);
      String fullName="";
      fullName = result['results']?[0]['full_name'];
      return fullName;
    } else {

      print(response.body);
      return "";

    }
  } else {
      print('response.body');
      print(response.body);
      return "";

    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
// Return 0 if request failed
  }
   
  }
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
        // Use this property to give focus to the button
        focusNode: FocusNode(skipTraversal: true),
      ),
    );
  }
}