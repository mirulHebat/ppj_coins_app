// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/partsApprovedPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetails.dart';
// import 'package:iFleet_app/PurchaseOrder/poPartsPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/puchaseDetails.dart';
import 'package:intl/intl.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/login/roles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ppj_coins_app/login/profile.dart';



class purchaseOrderDetailViewApprovedPage extends ConsumerStatefulWidget {
  const purchaseOrderDetailViewApprovedPage({super.key, required this.title, required this.id, required this.pd});
  final String title;
  final String id;
  final String pd;
  

  @override
  ConsumerState<purchaseOrderDetailViewApprovedPage> createState() => _PurchaseOrderPageViewApprovedState();
  
}

class _PurchaseOrderPageViewApprovedState extends ConsumerState<purchaseOrderDetailViewApprovedPage> {
  List<Map<String,dynamic>> myList = [];
  List<Map<String,dynamic>> contactLists = [];
  Map<String, dynamic> selectedCategory = {};
  List<Map<String,dynamic>> pdList = [];
  Map<String, dynamic> saveItems = {};
  Map<String, dynamic> statusItems = {};
  List<dynamic> profDet = [];
  bool isRowVisible = false;
  bool isRowVisible2 = false;
  int meter = 0;
  String expiryDate = '';
  int expiryMeter = 0;
  int disc = 0;
  int tax = 0;
  String date = '';
  String plate = '';
  String price = '';
  String afterDisc = '';
  String afterTax = '';
  String shipping = '';
  String totAmount = '';
  String id = '';
  String title = '';
  String profId = '';
  String profType = '';
  String profName= '';
  String pdid = '';
  String pdNo = '';
  String pdTitle = '';
  String status = '';
  String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String roleList = '';
  String recBy = '';
  String recDate = '';
  String closedDate = '';
  List<dynamic> poli = [];
  final formatter = NumberFormat('#,###');
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);

    @override
  void initState(){
    super.initState();
    final PODetail vc = PODetail();
     Future.delayed(Duration.zero, () async {
      List<Map<String,dynamic>> result = await vc.createList(widget.id);
      String role = await assignRole();
      List<dynamic> profile= await Profile().createList();
      List<Map<String,dynamic>> pdItems = await findList2().getPD(widget.pd);
      setState(() {
        myList = result; 
        roleList = role;
        profDet = profile;
        pdList = pdItems;

      });
    });

  }
  
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    print('yyy12ll');
    print(pdList.toString());
    print(roleList);
    saveItems['today'] = today;


    if (profDet.isNotEmpty) {
      List<dynamic> list1 = profDet[0];
      Map<String, dynamic> firstItem = list1[0];
      profName = firstItem['metadata']?['title']?? '';
      profId = firstItem['item_id']?? '';
      profType = firstItem['item_type_id']?? '';
    } else{}
    saveItems['profId'] = profId;
    saveItems['profType'] = profType;
    saveItems['profName'] = profName;
    if(myList.isNotEmpty){
      meter = myList[0]['metadata']?['current_meter_value']??0;
      expiryDate = myList[0]['metadata']?['warranty_expiration_date']??'';
      expiryMeter = myList[0]['metadata']?['warranty_expiration_meter_value']??'';
      disc = myList[0]['metadata']?['discount_percentage']??0;
      tax = myList[0]['metadata']?['tax_percentage']??0;
      date = myList[0]['metadata']?['effective_date']??'';
      plate = myList[0]['metadata']?['vehicle_id']?['title']??'';
      price = myList[0]['metadata']?['price']?['display']??"0.00";
      afterDisc = myList[0]['metadata']?['subtotal']?['display']??"0.00";
      afterTax = myList[0]['metadata']?['tax_subtotal']?['display']??"0.00";
      shipping = myList[0]['metadata']?['shipping']?['display']??"0.00";
      totAmount = myList[0]['metadata']?['total_amount']?['display']??"0.00";
      id = myList[0]['item_id']??'';
      title = myList[0]['metadata']?['title']??'';
      pdid = myList[0]['metadata']?['purchase_details']?['item_id']??'';
      pdNo = myList[0]['metadata']?['purchase_details']?['item_number']??'';
      pdTitle = myList[0]['metadata']?['purchase_details']?['title']??'';
      status = myList[0]['metadata']?['purchase_order_status']?['display']??'';
      poli = myList[0]['metadata']?['poli']??[];
    }

    if(pdList.isNotEmpty){
      Map<String, dynamic> firstItem = pdList[0];
      recBy = firstItem['recBy']?['title']??'';
      recDate = firstItem['recAt']??'';
      closedDate = firstItem['closeAt']??'';
    }
    saveItems['plate'] = plate;
    saveItems['item_number'] = id;
    statusItems['item_id'] = id;
    statusItems['title'] = title;
    saveItems['title'] = title;
    saveItems['purchase_details_id'] = pdid;
    saveItems['purchase_details_number'] = pdNo;
    saveItems['purchase_details_title'] = pdTitle;
    int itemAmt = poli.length;
    String itemAmount = itemAmt.toString();
     return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 50, left: h*0.01),
                    color: ref.watch(primaryColor),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
                          color: ref.read(truewhite),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: h*0.05),
                          child: Text(
                            widget.title,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h*0.01, bottom: h*0.0, left: w*0.1, right: w*0.0),
                          child: Flexible(
                            child: InkWell(
                              onTap:() {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PartsApprovedPage(id: widget.id)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  badges.Badge(
                                    badgeContent: Text(itemAmount),
                                    child: Icon(Icons.shopping_bag_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truewhite).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(top: h * 0.015, left: w * 0.01, bottom: h*0.03),
                                              child: Text(
                                                'Effective Date:  ' + date,
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truewhite).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.01),
                                              child: Text(
                                                'Current Meter Value',
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: w * 0.01),
                                              child: Text(
                                                formatter.format(meter) + ' KM',
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truewhite).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.01),
                                              child: Text(
                                                'Plate Number',
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: w * 0.01),
                                              child: Text(
                                                plate,
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truewhite).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.01),
                                              child: Text(
                                                'Warranty Expiration Date:  ' + expiryDate,
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truewhite).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.01),
                                              child: Text(
                                                'Warranty Expiration Meter Value(KM): ' + formatter.format(expiryMeter) + ' KM',
                                                style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (() {
                              setState(() {
                                if(isRowVisible == true){
                                  isRowVisible = false;
                                }else{
                                  isRowVisible = true;
                                }
                              });
                            }),
                            child: Container(
                              height: h*0.08,
                              width: w*1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:ref.read(primaryColor).withOpacity(1),
                                      width: h*0.002,
                                    ),
                                    color: ref.read(primaryColor).withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.01, left: w*0.02, right: w*0.08),
                                    child: Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Pricing Details', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  isRowVisible ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined,
                                                  size: 24.0, // You can adjust the size here
                                                  color: Colors.black, // You can adjust the color here
                                                ),
                                              ],
                                            ),
                                          )

                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                          ),
                      ), 

                      Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.08,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Price: ' + currencyFormat.format(double.parse(price)),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Discount(%):  '+disc.toString(),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01,),
                                                child: Text(
                                                  'Discount Subtotal(RM)',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  currencyFormat.format(double.parse(afterDisc)),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Tax(%):  '+tax.toString(),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Tax Subtotal(RM)',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  currencyFormat.format(double.parse(afterTax)),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Shipping',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  currencyFormat.format(double.parse(shipping)),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Visibility(
                                  visible: isRowVisible,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Total Amount',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  currencyFormat.format(double.parse(totAmount)),
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (() {
                              setState(() {
                                if(isRowVisible2 == true){
                                  isRowVisible2 = false;
                                }else{
                                  isRowVisible2 = true;
                                }
                              });
                            }),
                            child: Container(
                              height: h*0.08,
                              width: w*1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:ref.read(primaryColor).withOpacity(1),
                                      width: h*0.002,
                                    ),
                                    color: ref.read(primaryColor).withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.01, left: w*0.02, right: w*0.08),
                                    child: Flexible(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Purchase Details', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                isRowVisible2 ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined,
                                                size: 24.0, 
                                                color: Colors.black, 
                                              ),
                                            ],
                                          ),
                                        )
                                        ],
                                      ),
                                    ),
                                  ),
                              ),
                          ),
                      ), 

                      Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                visible: isRowVisible2,
                                child: Expanded(
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Received By: $recBy',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                visible: isRowVisible2,
                                child: Expanded(
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                      child: Container(
                                        height: h*0.1,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:ref.read(truegray).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                child: Text(
                                                  'Received At: $recDate',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                            
                          ]
                        )
                      )
                    )
                  )
                ]
              )
     );
  }
}
