
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
// import 'package:hive/hive.dart';
// import 'package:ppj_coins_app/home/homepage.dart';
// import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
// import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'dart:convert';
// import 'package:ppj_coins_app/riverpod/login/userModel.dart';
// import '../riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/addFuel.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'dart:async';
// import 'package:intl/intl.dart';
import 'package:ppj_coins_app/work_entries.dart';

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
                            print('month controller');
                            print(_monthController.text);
                            print(_yearController.text);
                            var filtered = await fList.createList(_monthController.text,_yearController.text);
                            print("filtered");
                            print(filtered.count);
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
                            // Implement search functionality for month here
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: h*0.01,),




                        // PageView
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
                    
                  ),

                  )

                  ]
  
                ),
              ),
            Opacity(
            opacity: item.submit =="true" ? 0.0 : 1.0, // Set the opacity based on the condition
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Submit'),
                    value: 'Submit',
                  ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: 'Delete',
                  ),
                ];
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
              },
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
  String role=userDetails.isNotEmpty ? userDetails[5] : '';

   print('check detail ');
  print(userDetails);
  print(user_session_id);

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isNotEmpty) {
    // Accessing the first element
    print('Data of ifleet-e19ed3688291407ab4da4d50d665769e: $ifleetData');
  } else {
    print('User details list is empty or does not contain the ifleet data.');
    return ItemListWithCount(count: 0, items: []);// Return 0 if userDetails is empty
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
  
  print(usell);
  response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);
  print('response');

  if (response.statusCode == 200) {
    print('welcom');
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
        // Use this property to give focus to the button
        focusNode: FocusNode(skipTraversal: true),
      ),
    );
  }
}