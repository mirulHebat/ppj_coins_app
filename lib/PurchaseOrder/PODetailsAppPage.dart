import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/partsApprovedPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetails.dart';
// import 'package:iFleet_app/PurchaseOrder/poPartsPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/puchaseDetails.dart';
import 'package:ppj_coins_app/PurchaseOrder/purchaseOrder.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPOPage.dart';
import 'package:intl/intl.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/login/roles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ppj_coins_app/login/profile.dart';




class purchaseOrderDetailApprovedPage extends ConsumerStatefulWidget {
  const purchaseOrderDetailApprovedPage({super.key, required this.title, required this.id});
  final String title;
  final String id;
  

  @override
  ConsumerState<purchaseOrderDetailApprovedPage> createState() => _PurchaseOrderPageApprovedState();
  
}

class _PurchaseOrderPageApprovedState extends ConsumerState<purchaseOrderDetailApprovedPage> {
  List<Map<String,dynamic>> myList = [];
  List<Map<String,dynamic>> contactLists = [];
  Map<String, dynamic> selectedCategory = {};
  Map<String, dynamic> saveItems = {};
  Map<String, dynamic> statusItems = {};
  List<dynamic> profDet = [];
  bool isRowVisible = false;
  bool isRowVisible2 = false;
  bool isRowVisible4 = false;
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
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  String profId = '';
  String profType = '';
  String profName= '';
  String pdid = '';
  String pdNo = '';
  String pdTitle = '';
  String status = '';
  String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String roleList = '';
  List<dynamic> poli = [];
  final formatter = NumberFormat('#,###');
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);

   void _selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000), 
    lastDate: DateTime.now().add(Duration(days: 365)), 
  );

  if (pickedDate != null && pickedDate != _selectedDate) {
    setState(() {
      _selectedDate = pickedDate;
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      saveItems['received_at'] = formattedDate; 
    });
  }
}

  void _selectExpiryDate(BuildContext context) async {
  final DateTime? pickedDate2 = await showDatePicker(
    context: context,
    initialDate: _selectedDate2 ?? DateTime.now(),
    firstDate: DateTime(2000), 
    lastDate: DateTime.now().add(Duration(days: 365)), 
  );

  if (pickedDate2 != null && pickedDate2 != _selectedDate) {
    setState(() {
      _selectedDate2 = pickedDate2;
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate2);
      saveItems['closed_at'] = formattedDate;
    });
  }
}


    @override
  void initState(){
    super.initState();
    final PODetail vc = PODetail();
     Future.delayed(Duration.zero, () async {
      List<Map<String,dynamic>> result = await vc.createList(widget.id);
      String role = await assignRole();
      List<dynamic> profile= await Profile().createList();
      List<Map<String,dynamic>> cn1 = await PODetail().findContacts();
      setState(() {
        myList = result; 
        roleList = role;
        profDet = profile;
        contactLists = cn1;
        selectedCategory=contactLists[0];

      });
    });

  }
  
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    print('amir firdaus');
    print(contactLists.toString());
    print(myList.length);
    print(roleList);
    saveItems['today'] = today;
    // var counter = ref.read(poList).length;
    // var counter2 = counter.toString();
    bool isRowVisible3 = false;
    if(roleList == 'iFMS Manager'){
      isRowVisible3 = false;
    }else{
      isRowVisible3 = true;
    }

    if (status == 'Approved' || status == 'Completed') {
      isRowVisible4 = true;
    }else{
      isRowVisible4 = false;
    }

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
    print(id);
    print(status);
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
                                                'Warranty Expiration Meter Value(KM): ' + formatter.format(expiryMeter)+ ' KM',
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
                                                  'Price:  RM'+price,
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
                                                  'RM $afterDisc',
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
                                                  'RM $afterTax',
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
                                                  'RM $shipping',
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
                                                  'RM $totAmount',
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
                          child: Visibility(
                            // visible: isRowVisible3,
                            child: Visibility(
                              // visible: isRowVisible4,
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
                          ),
                      ), 

                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Visibility(
                              visible: isRowVisible2,
                              child: Center(
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.01, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.13,
                                      width: w*0.94,
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
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.00),
                                                child: Text(
                                                  'Received By:',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                            DropdownButton<Map<String, dynamic>>(
                                              value: selectedCategory,
                                              onChanged: (Map<String, dynamic>? newValue) { 
                                                print(contactLists.toString());
                                                print(selectedCategory);
                                                if (newValue != null) { 
                                                  setState(() {
                                                    selectedCategory = newValue;
                                                      saveItems['recId'] = newValue['item_id'];
                                                      saveItems['recType'] = newValue['item_type_id'];
                                                      saveItems['recName'] = newValue['title'];
                                                    print('before Save items cat');
                                                    print(saveItems);
                                                  });
                                                }
                                              },
                                              items: contactLists.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> map) {
                                                return DropdownMenuItem<Map<String, dynamic>>(
                                                  value: map, 
                                                  child: Text(map['title'].toString()),
                                                );
                                              }).toList(),
                                              hint: Text('Received by'),
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
                                visible: isRowVisible3,
                                child: Visibility(
                                  visible: isRowVisible2,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.02, right: w * 0.01),
                                      child: Container(
                                        height: h * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: ref.read(truegray).withOpacity(1),
                                            width: h * 0.002,
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.03),
                                                child: Text(
                                                  'Received Date',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                              Row(
                                                  children: [
                                                    if (_selectedDate != null)
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 0.05),
                                                        child: Text(
                                                          DateFormat('dd-MM-yyyy').format(_selectedDate!),
                                                          style: TextStyle(fontSize: h * 0.02),
                                                        ),
                                                      )
                                                    else
                                                      InkWell(
                                                        onTap: (){
                                                          _selectDate(context);
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: h*0.05),
                                                          child: Icon(
                                                            Icons.event,
                                                            size: h * 0.025,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Visibility(
                                visible: isRowVisible3,
                                child: Visibility(
                                  visible: isRowVisible2,
                                  child: Consumer(builder: (context, ref, child) =>
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.01, right: w * 0.02),
                                      child: Container(
                                        height: h * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: ref.read(truegray).withOpacity(1),
                                            width: h * 0.002,
                                          ),
                                          color: ref.read(truewhite).withOpacity(0.8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01, bottom: h*0.03),
                                                child: Text(
                                                  'Closed Date',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
                                                ),
                                              ),
                                              Row(
                                                  children: [
                                                    if (_selectedDate2 != null)
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 0.05),
                                                        child: Text(
                                                          DateFormat('dd-MM-yyyy').format(_selectedDate2!),
                                                          style: TextStyle(fontSize: h * 0.02),
                                                        ),
                                                      )
                                                    else
                                                      InkWell(
                                                        onTap: (){
                                                          _selectExpiryDate(context);
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: h*0.05),
                                                          child: Icon(
                                                            Icons.event,
                                                            size: h * 0.025,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Visibility(
                                  visible: isRowVisible3,
                                  child: ElevatedButton(
                                    onPressed: ()  async{
                                      print(saveItems);
                                      await findList2().updateReceived(saveItems);

                                      if(saveItems['closed_at'] != null){
                                        await findList2().updateClosed(saveItems);
                                        statusItems['status_code'] = "05";
                                        statusItems['status_value'] = "POS05";
                                        statusItems['status_display'] = "Completed";
                                        print(saveItems);
                                        await findListPO().saveStatus(statusItems);
                                      }
                                      
                                      // Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.withOpacity(0.8)),
                                    child: Text('Saved', style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ]
                            )

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
