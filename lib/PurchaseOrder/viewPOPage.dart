
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/PODetailsAppPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/PODetailsViewAppPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetailspage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poEditPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poPartsAppPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/purchaseOrder.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPO.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/login/roles.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';

class viewPOPage extends ConsumerStatefulWidget {
  const viewPOPage({Key? key}) : super(key: key);
  @override
  ConsumerState<viewPOPage> createState() => _ViewPOPageState();
  
}

class _ViewPOPageState extends ConsumerState<viewPOPage> {
  List<Map<String, dynamic>> poList1 = [];
  String title = '';
  String id = '';
  String date = '';
  String roleList = '';

 List<Map<String, dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  void _showAlertDialogDelete(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deleted'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialogUpdated(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Updated'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  void POListing(){
    final PurchaseOrder po = PurchaseOrder();
     Future.delayed(Duration.zero, () async {
      List<Map<String, dynamic>> po2 = await po.createList();
      String role = await assignRole();
      setState(() { 
        poList1 = po2;
        roleList = role;
      });
    });

    filteredItems.addAll(poList1);
  }

  @override
  void initState(){
    super.initState();
    POListing();
    
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
    bool isRowVisible = false;
    print(poList1.toString());

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
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => Order()));
                             Navigator.pushNamedAndRemoveUntil(context, '/purchaseOrderHome',(Route<dynamic> route) => false);
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
                        filterList(poList1, filteredItems, query);
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
                                    if(roleList == 'iFMS Manager'){
                                      if(item['status']== "Submitted"){
                                        isRowVisible = true;
                                      }else{
                                        isRowVisible = false;
                                      }
                                    }else{
                                      isRowVisible = true;
                                    }
                                      return Visibility(
                                          visible: isRowVisible,
                                          child: Container(
                                            height: h*0.2,
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
                                                                    builder: (context) => purchaseOrderDetailPage(
                                                                      title: item['title'],
                                                                      id: item['id'],
                                                                    ),
                                                                  ),
                                                                );
                                                                break;
                                                              case 1:
                                                              ref.invalidate(poList);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => purchaseOrderEditPage(
                                                                      title: item['title'],
                                                                      id: item['id'],
                                                                    ),
                                                                  ),
                                                                );
                                                                break;
                                                              // Add more cases if you have more options
                                                              case 2:
                                                              Map<String, dynamic> statusItems = {};
                                                              statusItems['item_id'] = item['id'];
                                                              statusItems['title'] = item['title'];
                                                              statusItems['status_code'] = "02";
                                                              statusItems['status_value'] = "POS02";
                                                              statusItems['status_display'] = "Submitted";
                                                              print('here are status items');
                                                              print(statusItems);
                                                              await findListPO().saveStatus(statusItems);
                                                              _showAlertDialogUpdated('item is updated');
                                                              POListing();
                                                              break;

                                                              case 3:
                                                              List<dynamic> itemIds = [];
                                                              itemIds.add(item['id']);
                                                              itemIds.add(item['pdid']);
                                                              itemIds.addAll(item['poli_ids']);
                                                              print(itemIds);
                                                              await PurchaseOrder().deleteItems(itemIds);
                                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));
                                                              _showAlertDialogDelete("item is deleted");
                                                              POListing();
                                                              break;

                                                              case 4: 
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => POPartsAppPage(id: item['id'], poli: item['poli_ids'])));
                                                                break;

                                                                case 5:
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderDetailViewApprovedPage(title: item['title'], id: item['id'], pd: item['pdid'],)));
                                                                break;

                                                                case 6:
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderDetailApprovedPage(title: item['title'], id: item['id'],)));
                                                            }
                                                          },
                                                           itemBuilder: (BuildContext context){
                                            if (item['status'] == "Submitted" || item['status'] == "Rejected" || item['status'] == "Completed") {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text('View'),
                                                  ),
                                                ];
                                              } 
                                              if (item['status'] == "Approved") {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 5,
                                                    child: Text('View'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 6,
                                                    child: Text('Edit'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Text('Update Quantity'),
                                                  ),
                                                ];
                                              } 
                                              else {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text('View'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 1,
                                                    child: Text('Edit'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 2,
                                                    child: Text('Submit to Manager'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 3,
                                                    child: Text('Delete'),
                                                  ),
                                                ];
                                              }
                                          }
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
                      itemCount: poList1.length, 
                      itemBuilder: (context, index) {
                        if (index < poList1.length) {
                          poList1.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                          var item = poList1[index]; 
                          return Container(
                            height: h*0.2,
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
                                                    builder: (context) => purchaseOrderDetailPage(
                                                      title: item['title'],
                                                      id: item['id'],
                                                    ),
                                                  ),
                                                );
                                                break;
                                              case 1:
                                              ref.invalidate(poList);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => purchaseOrderEditPage(
                                                      title: item['title'],
                                                      id: item['id'],
                                                    ),
                                                  ),
                                                );
                                                break;
                                              // Add more cases if you have more options
                                              case 2:
                                              Map<String, dynamic> statusItems = {};
                                              statusItems['item_id'] = item['id'];
                                              statusItems['title'] = item['title'];
                                              statusItems['status_code'] = "02";
                                              statusItems['status_value'] = "POS02";
                                              statusItems['status_display'] = "Submitted";
                                              print('here are status items');
                                              print(statusItems);
                                              await findListPO().saveStatus(statusItems);
                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));
                                              _showAlertDialogUpdated('item is updated');
                                              POListing();
                                              break;

                                              case 3:
                                                // print(item['id']);
                                                List<dynamic> itemIds = [];
                                                itemIds.add(item['id']);
                                                itemIds.add(item['pdid']);
                                                itemIds.addAll(item['poli_ids']);
                                                print(itemIds);
                                                await PurchaseOrder().deleteItems(itemIds);
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));
                                                _showAlertDialogDelete("item is deleted");
                                                POListing();
                                                break;

                                                case 4: 
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => POPartsAppPage(id: item['id'], poli: item['poli_ids'])));
                                                break;

                                                case 5:
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderDetailViewApprovedPage(title: item['title'], id: item['id'], pd: item['pdid'],)));
                                                break;

                                                case 6:
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderDetailApprovedPage(title: item['title'], id: item['id'],)));
                                            }
                                          },
                                          itemBuilder: (BuildContext context){
                                            if (item['status'] == "Submitted" || item['status'] == "Rejected" || item['status'] == "Completed") {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text('View'),
                                                  ),
                                                ];
                                              } 
                                              if (item['status'] == "Approved") {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 5,
                                                    child: Text('View'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 6,
                                                    child: Text('Edit'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 4,
                                                    child: Text('Update Quantity'),
                                                  ),
                                                ];
                                              } 
                                              else {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text('View'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 1,
                                                    child: Text('Edit'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 2,
                                                    child: Text('Submit to Manager'),
                                                  ),
                                                  PopupMenuItem<int>(
                                                    value: 3,
                                                    child: Text('Delete'),
                                                  ),
                                                ];
                                              }
                                          }
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


