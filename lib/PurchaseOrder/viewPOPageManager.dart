
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/pOrder.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetailsMPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPO.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/login/roles.dart';

class viewPOPageM extends ConsumerStatefulWidget {
  const viewPOPageM({Key? key}) : super(key: key);
  @override
  ConsumerState<viewPOPageM> createState() => _ViewPOPageMState();
  
}

class _ViewPOPageMState extends ConsumerState<viewPOPageM> {
  List<Map<String, dynamic>> poList = [];
  String title = '';
  String id = '';
  String date = '';
  String roleList = '';

 List<Map<String, dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    final PurchaseOrder po = PurchaseOrder();
     Future.delayed(Duration.zero, () async {
      List<Map<String, dynamic>> po2 = await po.createList();
      String role = await assignRole();
      setState(() { 
        poList = po2;
        roleList = role;
      });
    });

    filteredItems.addAll(poList);
  }

    @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

void filterList(List<Map<String,dynamic>> poList,List<Map<String,dynamic>>  filteredItems, String query) {
  filteredItems.clear();
  if (query.isEmpty) {
    filteredItems.addAll(poList);
  } else {
    filteredItems.addAll(
      poList.where((item) => item['title'].toLowerCase().contains(query.toLowerCase())),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    print('here is manager');
    bool isRowVisible = false;

    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(top:50, bottom: 50, left: h*0.01),
                    color: ref.watch(primaryColor),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Order()));
                          },
                          icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
                          color: ref.read(truewhite),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: h*0.05),
                          child: Text(
                            'List of Purchase Orders',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterList(poList, filteredItems, query);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Search for items...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),


                  // filteredItems.length == 0  && searchController.text ==''?
                  // Center(
                  //       child: Text(
                  //         'No data found',
                  //         style: TextStyle(fontSize: 20.0),
                  //       ),
                  //     ):
                  filteredItems.length != 0 && searchController.text !=''? 
                  Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: filteredItems.length, 
                                  itemBuilder: (context, index) {
                                    filteredItems.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                                    var item = filteredItems[index]; 
                                      if(item['status']== "Submitted"){
                                        isRowVisible = true;
                                      }else{
                                        isRowVisible = false;
                                      }
                                   
                                      return Visibility(
                                          visible: isRowVisible,
                                          child: Container(
                                            height: h*0.25,
                                            child: ListTile(
                                                title: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        getStatusIcon(item['status']),
                                                        Expanded(
                                                          child: Text(
                                                            Uri.decodeComponent(item['title']),
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ),
                                                        PopupMenuButton<int>(
                                                          icon: Icon(Icons.more_vert, color: Colors.black),
                                                          onSelected: (int result) async {
                                                            switch (result) {
                                                              case 0:
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => purchaseOrderDetailMPage(
                                                                      title: item['title'],
                                                                      id: item['id'],
                                                                    ),
                                                                  ),
                                                                );
                                                                break;
                                                            }
                                                          },
                                                          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                                            PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Text('View'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      Uri.decodeComponent(item['item_number']),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    Text(
                                                      Uri.decodeComponent(item['vehicle']),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    Text(
                                                      Uri.decodeComponent(item['mechanic']),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    Text(
                                                      Uri.decodeComponent(item['status']),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                    Text(
                                                      Uri.decodeComponent(item['date']),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            )         :
                  Expanded(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: poList.length, 
                      itemBuilder: (context, index) {
                        if (index < poList.length) {
                          poList.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                          var item = poList[index]; 
                            if(item['status']== "Submitted"){
                              isRowVisible = true;
                            }else{
                              isRowVisible = false;
                            }
                          return Visibility(
                            visible: isRowVisible,
                            child: Container(
                              height: h*0.25,
                              child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          getStatusIcon(item['status']),
                                          Expanded(
                                            child: Text(
                                              Uri.decodeComponent(item['title']),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          PopupMenuButton<int>(
                                            icon: Icon(Icons.more_vert, color: Colors.black),
                                            onSelected: (int result) async {
                                              switch (result) {
                                                case 0:
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => purchaseOrderDetailMPage(
                                                        title: item['title'],
                                                        id: item['id'],
                                                      ),
                                                    ),
                                                  );
                                                  break;
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Text('View'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                                      Uri.decodeComponent(item['item_number']),
                                                      style: TextStyle(color: Colors.black),
                                                    ),
                                      Text(
                                        Uri.decodeComponent(item['vehicle']),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        Uri.decodeComponent(item['mechanic']),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        Uri.decodeComponent(item['status']),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        Uri.decodeComponent(item['date']),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                          );
                        } else {
                          return Container(); 
                        }
                      },
                    ),
                  ),
                ),
                  
                ],
              ),
            ); 
  }
}

Widget getStatusIcon(String status) {
    switch (status) {
      case 'Draft':
        return Icon(Icons.menu_book, color: Colors.blue, size: 20);
      case 'Submitted':
        return Icon(Icons.email, color: Colors.black, size: 20);
      case 'Approved':
        return Icon(Icons.check, color: Colors.green, size: 20);
      case 'Rejected':
        return Icon(Icons.cancel, color: Colors.red, size: 20);
      case 'Completed' :
      return Icon(Icons.lock, color: Colors.grey, size: 20);
      default:
        return Icon(Icons.help_outline, color: Colors.grey, size: 20);
    }
  }


