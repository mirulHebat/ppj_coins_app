// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:hive/hive.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetailspage.dart';
import 'package:ppj_coins_app/home/homepage.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/list_maintenance.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/findPO.dart';
import 'dart:convert';
import '../riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/edit_Service.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/loader/loader.dart';


class maintainDetail extends StatefulWidget {
  final String itemId;
  final String? status; // Declare itemId as a parameter

  maintainDetail({Key? key, required this.itemId,required this.status}) : super(key: key);

  @override
  State<maintainDetail> createState() => detailState();
}

class detailState extends State<maintainDetail> {
  var shouldPop=false;
  late PageController controller;
  late int _selectedIndex;
    Color customColor = Color(0xFF1647AF);
   late List<Maintenance> items;
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

Future<void> Listmaintain() async
  {
      list_maintenance l_main =list_maintenance();
      items = await l_main.createListMainte(widget.itemId);
      print("checkpoint");
      print(items);
      print("vehicle checkpoint");

 
   }

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
  }

  Widget build(BuildContext context){
    print(widget.itemId);
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
        future: Listmaintain(),
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
                                  // borderRadius: BorderRadius.circular(10),
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
                                              
                                              builder: (context) => LoaderMaintenance(),
                                              
                                            ),
                                          );
                                          },
                                        ),
                                      ),
                                            Text(
                                              " Maintenance Detail ", // Replace with your actual title text
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
                
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: onPageChanged,
                    children: <Widget>[
                     
                     DividerExample(items: items,status:widget.status),


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

class DividerExample extends StatefulWidget {
  final List<Maintenance> items;
  final String? status;
  const DividerExample({Key? key, required this.items,required this.status}) : super(key: key);

  @override
  _DividerExampleState createState() => _DividerExampleState();
}

class _DividerExampleState extends State<DividerExample> {
  late List<Maintenance> items;
  String role_assign="";
  bool showFloatingActionButton=true;

    @override
  void initState() {
    super.initState();
    items = widget.items;
     UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    role_assign  = userDetails.isNotEmpty ? userDetails[5] : '';
    print('role');
    print(role_assign);
    if(role_assign == "iFMS Driver" ||widget.status =="Completed"||widget.status =="Terminated")
    {
      // setState(){
        showFloatingActionButton=false;
        print('nilai floating $showFloatingActionButton');
      // };
      
    }
  }

  @override
  Widget build(BuildContext context){
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
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(8.0), // Padding for each item container
                          color: Colors.white, // Background color for each item container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align data to the left
                            children: [
                             Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Text(
                                    ' Service ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Num Plate: ${item.vehicle['title']}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Driver: ${item.driver_title}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top:10.0),
                              child: Text(
                                'Completed Date: ${item.complete_date}',
                                style: TextStyle(fontSize: 18.0, color: Colors.black),
                              ),
                            ),

                              SizedBox(height: 15),
                               Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                // color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 1.5,
                                          endIndent: 10.0,
                                        ),
                                      ),
                                      Text(
                                        'Pricing Detail',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 1.5,
                                          indent: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  'Labor Subtotal (RM): ${item.labor}',
                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  'Part Subtotal (RM): ${item.part}',
                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  'Tax Percentage (%): ${item.tax_perct}',
                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  'Tax Subtotal (RM): ${item.tax}',
                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                              ),
                               Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Text(
                                  'Total Amount (RM): ${item.total}',
                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 25),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Text(
                                    ' Work Order ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Column(
                               children: item.work_obj.expand((workOrder) {
                                return [
                                  Text(
                                    'Issued By: ${workOrder.issued_by_title['title']}',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 15),
                                  // Loop through each workOrderLine within the current workOrder
                                  ...workOrder.linework.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var workOrderLine = entry.value;
                                    print('List mapping ${workOrderLine.issuing}');
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 50.0,
                                        color: Color.fromARGB(255, 10, 56, 112),
                                        child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                          child: Center(
                                            child: Text(
                                              ' Work Order Line Item ${index + 1} ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                          IconButton(
                                            icon: Icon(
                                              workOrderLine.drop ? Icons.arrow_drop_down : Icons.arrow_right,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                  if(workOrderLine.drop)
                                                  {
                                                    workOrderLine.drop = false;
                                                  }
                                                  else
                                                  {
                                                    workOrderLine.drop = true;
                                                  }
                                                                                    
                                                });
                                            },
                                          ),
                                        ],
                                      ),
                                      ),
                                        Visibility(
                                          visible:workOrderLine.drop ,
                                          child:Column(
                                            children: [
                                             SizedBox(height: 10),

                                                Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                child:Align(
                                                  alignment: Alignment.centerLeft ,
                                                  child: Text(
                                                  'Work Order Item Status: ${workOrderLine.work_order_status['display']}',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                ),
                                              ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                child:Align(
                                                  alignment: Alignment.centerLeft ,
                                                  child: Text(
                                                  'Start At: ${workOrderLine.start_at}',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                ),
                                              ),
                                              ),
                                               SizedBox(height: 15),
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 50.0,
                                                color: Color.fromARGB(255, 120, 172, 236),
                                                child: Center(
                                                  child: Text(
                                                    ' Cost Detail ',
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                child:Align(
                                                  alignment: Alignment.centerLeft ,
                                                  child: Text(
                                                  'Labor Cost (RM): ${workOrderLine.labor_wol}',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                ),
                                              ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                child:Align(
                                                  alignment: Alignment.centerLeft ,
                                                  child: Text(
                                                  'Parts Cost (RM): ${workOrderLine.parts_wol}',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                ),
                                              ),
                                               
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                child:Align(
                                                  alignment: Alignment.centerLeft ,
                                                  child: Text(
                                                  'Subtotal (RM): ${workOrderLine.subtotal_wol}',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                ),
                                              ),
                                                
                                              ),
                                              SizedBox(height: 15),
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 50.0,
                                                color: Color.fromARGB(255, 120, 172, 236),
                                                child: Center(
                                                  child: Text(
                                                    ' Issue/Inspection ',
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                child:Align(
                                                  alignment: Alignment.centerLeft ,
                                                  child: Text(
                                                    'Has Resolve: ${workOrderLine.issuing[0].resolve['display']}',
                                                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                ),
                                              ),
                                                
                                              ),
                                      
                                                Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: workOrderLine.issuing.map((issue) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                        child: Text(
                                                        'Due Soon: ${issue.duesoon}',
                                                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                        child: Text(
                                                        'Summary: ${issue.Summary}',
                                                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                                        child: Text(
                                                        'Inspection Status: ${issue.list_ting[0].list_[0].status['display']}',
                                                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                                                        ),
                                                      ),
                                                      SizedBox(height: 15),
                                                      Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 30.0,
                                                              // color: Color.fromARGB(255, 145, 203, 250),
                                                              child: Center(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Divider(
                                                                        color: Colors.black,
                                                                        thickness: 1.5,
                                                                        endIndent: 10.0,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Faults',
                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                    ),
                                                                    Expanded(
                                                                      child: Divider(
                                                                        color: Colors.black,
                                                                        thickness: 1.5,
                                                                        indent: 10.0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 15),

                                                            Table(
                                                            columnWidths: const {
                                                              0: FlexColumnWidth(0.3),
                                                              1: FlexColumnWidth(1),
                                                              2: FlexColumnWidth(1),
                                                            },
                                                            children: [
                                                              TableRow(
                                                                decoration: BoxDecoration(color: Color.fromARGB(255, 151, 202, 253)),
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      'No.',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      'Fault Category',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      'Fault Item',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              // Add data rows here
                                                              ...issue.faulling.asMap().entries.map((entry) {
                                                                int index = entry.key;
                                                                fault faul = entry.value;
                                                                return TableRow(
                                                                  decoration: BoxDecoration(
                                                                    border: Border(
                                                                      top: BorderSide(
                                                                        color: Colors.grey[300]!, // Add your preferred color here
                                                                        width: 1.0, // Add your preferred width here
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 15.0),
                                                                      child: Text(
                                                                        '${index + 1}.',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontSize: 18.0,
                                                                          // Add more text styles as needed
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        faul.fault_Category,
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(fontSize: 15),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        faul.fault_item['display'],
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(fontSize: 15),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }).toList(),
                                                            ],
                                                          ),
                                                      SizedBox(height: 10),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                                    
                                            ],

                                          ),

                                        ),
                                      

                                      ],
                                    );
                                  }).toList(),
                                  Divider(),
                                ];
                              }).toList(),
                              ),
                               SizedBox(height: 15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Color.fromARGB(255, 145, 203, 250),
                                child: Center(
                                  child: Text(
                                    ' Purchase Order ',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              Column(
                                children: [
                                  Consumer(
                                    builder: (context, ref, child) {
                                      String role = ref.read(userRole);
                                      bool isManager = false;
                                      if(role == 'iFMS Manager'){
                                        isManager = true;
                                      }else{
                                        isManager = false;
                                      }
                                      return Column(
                                        children: item.work_obj.map((workOrder) {
                                          
                                          bool isNull = workOrder.PO.isEmpty;
                                          print('here is PO in WO');
                                          print(workOrder.PO);
                                          print(isNull);
                                           String decodedItemNumber = '';

                                          if(isNull){
                                            print('none');
                                          }else{
                                            decodedItemNumber = Uri.decodeComponent(workOrder.PO['item_number']);
                                          }
                                          
                                          return Visibility(
                                            visible: !isNull,
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      '${workOrder.PO['title']}',
                                                      style: TextStyle(fontSize: 18.0),
                                                    ),
                                                     Text(
                                                      decodedItemNumber,
                                                      style: TextStyle(fontSize: 18.0),
                                                    ),
                                                    Text(
                                                      '${workOrder.PO['status']}',
                                                      style: TextStyle(fontSize: 18.0),
                                                    ),
                                                    Text(
                                                      '${workOrder.PO['date']}',
                                                      style: TextStyle(fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: !isManager,
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.red,
                                                          size: 32.0,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => purchaseOrderDetailPage(
                                                                title: workOrder.PO['title'],
                                                                id: workOrder.PO['item_id'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Visibility(
                                                  visible: isManager && workOrder.PO['status'] == 'Submitted',
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.red,
                                                          size: 32.0,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => purchaseOrderDetailPage(
                                                                title: workOrder.PO['title'],
                                                                id: workOrder.PO['item_id'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        );
                        
                      }).toList(),

                    ),
                    SizedBox(height: 16),
                    //         ],
                    //       ),
                    //     );
                        
                    //   }).toList(),

                    // ),
            
                    // Add some space between the text and the button
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items
                      .map((item) => Visibility(
                            visible: showFloatingActionButton, // Replace with your visibility condition
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditService(maintenace: items),
                                  ),
                                );
                              },
                              child: Text('Edit'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                              ),
                            ),
                          ))
                      .toList(),
                ),

                  ],
                ),
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

class list_maintenance
{
  String poid = '';
  Future<List<Maintenance>> createListMainte(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

       http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["sp001"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date","checkout_ind","checkin_ind","metadata"]'+
      '}');

       Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];

      }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

        if (response.statusCode == 200) {

        Map<String, dynamic> result = json.decode(response.body);
        print('nilai maintenance');
        print(result);

        if (result['success'] == true){
        List<dynamic> results = result['results'];
        List<Maintenance> items = [];
         for(var itemData in results)
         {
          String titlemaint=Uri.decodeComponent(itemData['title']?? '');
          Map<String, dynamic> vehicle = {};
          String driver ="";
          String driver_title="";
          String complete_date="";
         List<Map<String, dynamic>> status_insp=[];
          String part="";
          var tax_perct =0;
          String tax="";
          String total="";
          String labor="";
          List <workOrder> work_line=[];
          Map<String, dynamic>? metadata=itemData['metadata'];
           Map<String, dynamic>? driver_obj={} ;

            if(metadata != null)
            {
              if(metadata['vehicle_id'] !=null)
              {
                vehicle =metadata['vehicle_id'];
              }
              if( metadata['driver_id'] !=null)
              {
                driver_obj=metadata['driver_id'];

              }
              
         
              driver=driver_obj?['item_id']?? '';
              driver_title=driver_obj?['title']?? '';
              complete_date=Uri.decodeComponent(metadata['completed_at']??'');
               labor=Uri.decodeComponent(metadata['labor_subtotal']?['display']??'');
               part=Uri.decodeComponent(metadata['parts_subtotal']?['display']??'');
               tax_perct=metadata['tax_percentage']??0;
               tax=Uri.decodeComponent(metadata['tax_subtotal']?['display']??'');
               total=Uri.decodeComponent(metadata['total_amount']?['display']??'');
              //  status_insp=await createInspMainte(metadata?['inspection_form']?['item_id']);
               work_line=await createWorkMainte(metadata['linked_work_orders']?[0]?['item_id']); 
               print('berjaya');

            }

           Maintenance mainteee=Maintenance(
            titlemaint:titlemaint,
            driver:driver,
            driver_title:driver_title,
            complete_date:complete_date,
            labor:labor,
            part:part,
            tax_perct:tax_perct,
            tax:tax,
            total:total,
            work_obj:work_line,
            insp_stats:{},
            vehicle:vehicle,
            drop:true,
            service_id:itemId,
            insp_id:"",
            insp_item_id:"",
            work_order_id:metadata?['linked_work_orders']?[0]?['item_id']

           );
           items.add(mainteee);
         }
          return items; 

        }
        else
        {
          return [];
        }      
        }
        else
        {
          return [];
        }

        

  }

    Future<List<issueItem>> createIssueMainte(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

       http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["i0001"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date","metadata"]'+
      '}');

       Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];

      }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

        if (response.statusCode == 200) {

        Map<String, dynamic> result = json.decode(response.body);

         print('nilai fault $result');

        if (result['success'] == true){
        List<dynamic> results = result['results'];
        List<fault> items = [];
        List <issueItem> issuing=[];
         for(var itemData in results)
         {
        
          String due_date ="";
          String summary="";
          String nama_sub="";

  
          Map<String, dynamic> resolving={};
           Map<String, dynamic>? metadata=itemData['metadata'];
            if(metadata != null)
            {
              List<Sub_Insp> Inspexrr=[];
              List<dynamic> faulty=metadata['fault_object'];
              due_date=Uri.decodeComponent(metadata['due_soon_at']??"");
              summary=Uri.decodeComponent(metadata['Summary']?? "");
              resolving=metadata['is_resolved']??{};
              nama_sub =metadata?['submitted_inspection_form_id']?['item_id'];
              Inspexrr=await createIns_SubpMainte(metadata?['submitted_inspection_form_id']?['item_id']);
              print('Insp');
              print(faulty);
             
              for(var fault_obj in faulty)
              {
          
                //String fault_id=
                print('nilai fault item ${fault_obj?['fault_items']?[0]}');
                String fault_catgory=Uri.decodeComponent(fault_obj?['fault_category']?['value']??"");
               Map<String,dynamic> fault_item=fault_obj?['fault_items']?[0]??{};
               print(fault_obj['item_id']);
                fault faul =fault(
                  fault_Category:fault_catgory,
                  fault_item:fault_item,
                  fault_id:fault_obj['item_id'],
                
                 
                );
                 print('Insp');
                items.add(faul);
              }
              issueItem iss_Item=issueItem(
                duesoon:due_date,
                faulling:items,
                 Summary:summary,
                 resolve: resolving,
                 issue_id:itemId,
                 Sub:itemId,
                list_ting:Inspexrr
              );
               print('Insp');
              issuing.add(iss_Item);

            }

         }
         return issuing;

        }
        else
        {
          return []; 
        }
    
        }
        else
        {
          return []; 

        }




  }

    Future <List<Sub_Insp>> createIns_SubpMainte(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      List<Sub_Insp> subInc=[];
       http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["is001"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date","metadata"]'+
      '}');

       Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];

      }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

        if (response.statusCode == 200) {

        Map<String, dynamic> result = json.decode(response.body);
        print('nilai sub inspection');
        print(result);

        if (result['success'] == true){
        List<dynamic> results = result['results'];
        List<Insp> list_isp =[];
        Map<String,dynamic> ins_item_id={};

         for(var itemData in results)
         {
                
           Map<String, dynamic>? metadata=itemData['metadata'];
            if(metadata != null)
            {
              Map<String,dynamic> insp_item=metadata['inspection_form'];
            
              String form_id=insp_item['item_id'];
              list_isp=await createInspMainte(form_id);
              print('list_isp');



                 Sub_Insp subbing=Sub_Insp(
                  Subb_big:itemId,
                  Sub_id: form_id,
                  list_:list_isp
                 );
                 subInc.add(subbing);
                
              
              
            }

         }
         return subInc;

        }
        else
        {
          return []; 
        }
    
        }
        else
        {
          return []; 

        }




  }

  Future<List<Insp>> createInspMainte(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

       http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["if001"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date","metadata"]'+
      '}');

       Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];

      }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

        if (response.statusCode == 200) {

        Map<String, dynamic> result = json.decode(response.body);
        print('nilai inspection');
        print(result);

        if (result['success'] == true){
        List<dynamic> results = result['results'];
        List<Insp> list_isp =[];
          Map<String, dynamic> insp_status ={};
          String nilai_id="";
         for(var itemData in results)
         {
                
           Map<String, dynamic>? metadata=itemData['metadata'];
            if(metadata != null)
            {
              List<dynamic> insp_item=metadata['inspection_items'];
              print('insp_item $insp_item');
              for(var item_insp in insp_item)
              {
                  nilai_id=item_insp?['item_id'];
                 
                
                 insp_status=item_insp?['inspection_status'];
              }

              Insp inspect =Insp(
                Insp_id:nilai_id,
                status:insp_status
                );
                list_isp.add(inspect);

            }

         }
         return list_isp;

        }
        else
        {
          return []; 
        }
    
        }
        else
        {
          return []; 

        }




  }

    Future<List<workOrder>> createWorkMainte(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      Map<String,dynamic> poInfo = {};

       http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["wo001"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date","metadata"]'+
      '}');

       Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];

      }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

        if (response.statusCode == 200) {

        Map<String, dynamic> result = json.decode(response.body);
        print('nilai work order');
        print(result);

       if (result['success'] == true) {
      List<dynamic> results = result['results'];
      Map<String, dynamic> issued_by_title = {};
      List<workOrder> working = [];
      print('gggee');
      for (var itemData in results) {
        Map<String, dynamic>? metadata = itemData['metadata'];
        print('ell');
        if (metadata != null) {
           print('ejjll');
           if(metadata['issued_by_id']!=null)
           {
            issued_by_title = metadata['issued_by_id'];
           }
           if(metadata['purchase_order_number']?['item_id']!=null){
            poid = metadata['purchase_order_number']['item_id'];
            print('hello');
            List<Map<String,dynamic>> poInfo1 = await servicePO().findPO(poid);
            poInfo = poInfo1[0];
            print(poInfo);
           }
          // issued_by_title = metadata['issued_by_id'];
        print('ffell');
          List<dynamic> work_lining = metadata['work_order_line_items'];
          List<workOrderLine> lineworking = [];
          for (var work in work_lining) {
            print('hello $work_lining');
            List<workOrderLine> tempLines = await createWorkLineMainte(work['item_id']);
            lineworking.addAll(tempLines);
          }
          
          workOrder WO = workOrder(
            issued_by_title: issued_by_title,
            linework: lineworking,
             PO : poInfo
          );
          working.add(WO);
        }
      }
      return working;
    }

        else
        {
          return []; 
        }
    
        }
        else
        {
           print('Request failed with status code: ${response.statusCode}');
          return []; 

        }
  }

      Future<List<workOrderLine>> createWorkLineMainte(String itemId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

       http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"query":"( item_id = &quot;'+itemId+'&quot; )",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["woli1"],'+
        '"sort_field":"",'+
        '"sort_order":"ASC",'+
        '"details":["item_id","item_number","title","registered_date","metadata"]'+
      '}');

       Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];

      }

      response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param=$usell'), 
      headers: headersModified);

        if (response.statusCode == 200) {

        Map<String, dynamic> result = json.decode(response.body);
        print('nilai work order line');
        print(result);

        if (result['success'] == true){
        List<dynamic> results = result['results'];
         List <workOrderLine> lineworking=[];
         String labor_wol="";
         String parts_wol="";
         String subtotal_wol="";
         String start_at="";
         Map<String, dynamic> work_order_status={};
         Map<String, dynamic> isResolved = {};
         List <issueItem> iss=[];
         for(var itemData in results)
         {
        
           Map<String, dynamic>? metadata=itemData['metadata'];
            if(metadata != null)
            {
                 if ( metadata.containsKey('issues') && metadata['issues'] is List && metadata['issues'].isNotEmpty) {
                  var firstIssue = metadata['issues'][0];
                  if (firstIssue.containsKey('is_resolved') && firstIssue['is_resolved'] is Map) 
                  {
                    isResolved = firstIssue['is_resolved'];
                  }
                  iss=await createIssueMainte(firstIssue?['item_id']);
                  print('iss');
                  //   for (issueItem issue in iss) {
                  //   print('Duesoon: ${issue.duesoon}');
                  // }
                }
                if(metadata['started_at']!=null)
                {
                   start_at=metadata['started_at'];
                }
               
              
                  labor_wol = (metadata['labor_cost'] != null && metadata['labor_cost'] is Map && metadata['labor_cost']['display'] != null) 
                ? Uri.decodeComponent(metadata['labor_cost']['display']) 
                : "";
                 parts_wol = (metadata['parts_cost'] != null && metadata['parts_cost'] is Map && metadata['parts_cost']['display'] != null) 
                    ? Uri.decodeComponent(metadata['parts_cost']['display']) 
                    : "";

                 subtotal_wol = (metadata['subtotal'] != null && metadata['subtotal'] is Map && metadata['subtotal']['display'] != null) 
                    ? Uri.decodeComponent(metadata['subtotal']['display']) 
                    : "";
                 work_order_status=metadata['work_order_status'];
                 print('hello selamat');
                 workOrderLine faul =workOrderLine(
                  labor_wol:labor_wol,
                  parts_wol:parts_wol,
                  subtotal_wol:subtotal_wol,
                  start_at:start_at,
                  work_order_status:work_order_status,
                  issuing:iss,
                  resolving:isResolved,
                  drop:true,
                  workline_id:itemId
                );
                lineworking.add(faul);
            }

         }
         return lineworking;

        }
        else
        {
          return []; 
        }
    
        }
        else
        {
          return []; 
        }

  }

}

class Maintenance{
  final String titlemaint;
  final String driver;
  final String driver_title;
  final String complete_date;
  final String labor;
  final String part;
  final int tax_perct;
  final String tax;
  final String total;
  final  List <workOrder> work_obj;
  final Map<String, dynamic> insp_stats;
  final Map<String, dynamic>  vehicle;
  bool drop;
  final String service_id;
  final String insp_id;
  final String insp_item_id;
  final String work_order_id;

  Maintenance({required this.titlemaint,required this.driver,required this.driver_title,required this.complete_date,required this.labor,required this.part,
  required this.tax_perct,required this.tax,required this.total,required this.work_obj,required this.insp_stats,required this.vehicle,required this.drop,
  required this.service_id,required this.insp_id,required this.insp_item_id,required this.work_order_id});
  

}

class issueItem{

  final String duesoon;
  final String Summary;
  final Map<String,dynamic> resolve;
  final List<fault>faulling;
  final String issue_id;
  final String Sub;
  final List<Sub_Insp> list_ting;

  issueItem({required this.duesoon,required this.faulling,required this.Summary,required this.resolve,required this.issue_id,required this.Sub,required this.list_ting});   

}

class workOrder{

  final Map<String, dynamic> issued_by_title;
  final List<workOrderLine> linework;
  final Map<String,dynamic> PO;

   workOrder({required this.issued_by_title,required this.linework, required this.PO});  

}

class Sub_Insp{
  final String Subb_big;
  final String Sub_id ;
  final List<Insp> list_;

  Sub_Insp({required this.Sub_id,required this.list_,required this.Subb_big});   

}

class Insp{

  final String Insp_id ;
  final Map<String,dynamic> status;

  Insp({required this.Insp_id,required this.status});   

}

class workOrderLine{

   String labor_wol;
   String parts_wol;
   String subtotal_wol;
   String start_at;
   Map<String, dynamic> work_order_status;
   List<issueItem> issuing;
   Map<String, dynamic> resolving;
   bool drop;
   String workline_id;

  workOrderLine({required this.labor_wol,required this.parts_wol,required this.subtotal_wol,required this.start_at,required this.work_order_status,required this.issuing,required this.resolving,required this.drop,required this.workline_id});   

}

class fault{
  final String fault_Category;
  final Map<String,dynamic> fault_item;
  final String fault_id;


  fault({required this.fault_Category,required this.fault_item,required this.fault_id});

}














class Fault {
  final String faultCategory;
  final String faultItem;

  Fault({required this.faultCategory, required this.faultItem});

  String getFaultDetails() {
    return 'Category: $faultCategory, Item: $faultItem';
  }
}

class IssueItem {
  final String dueSoon;
  final String summary;
  final Map<String, dynamic> resolve;
  final List<Fault> faults;

  IssueItem({required this.dueSoon, required this.summary, required this.resolve, required this.faults});

  String getIssueDetails() {
    return 'Summary: $summary, Due Soon: $dueSoon, Resolve: ${resolve['status']}';
  }

  String getFaultDetails() {
    return faults.map((fault) => fault.getFaultDetails()).join('\n');
  }
}

void main() {
  // Create a list of Fault instances
  List<Fault> faults = [
    Fault(faultCategory: 'Engine', faultItem: 'Overheating'),
    Fault(faultCategory: 'Transmission', faultItem: 'Slipping')
  ];

  // Create an IssueItem instance
  IssueItem issue = IssueItem(
    dueSoon: '2023-12-31',
    summary: 'Multiple issues reported',
    resolve: {'status': 'in progress', 'expectedResolution': '2024-01-15'},
    faults: faults
  );

  // Output details
  print(issue.getIssueDetails());
  print('Faults:');
  print(issue.getFaultDetails());
}
