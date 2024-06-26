import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:iFleet_app/PurchaseOrder/POEditPartsPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetails.dart';
// import 'package:iFleet_app/PurchaseOrder/poPartsPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/poLineItems.dart';
// import 'package:iFleet_app/PurchaseOrder/poParts.dart';
// import 'package:iFleet_app/PurchaseOrder/puchaseDetails.dart';
import 'package:ppj_coins_app/PurchaseOrder/purchaseOrder.dart';
// import 'package:iFleet_app/PurchaseOrder/vehicleCategoryPage.dart';
// import 'package:iFleet_app/PurchaseOrder/vehicleDetails.dart';
import 'package:ppj_coins_app/PurchaseOrder/parts.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPO.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPOPage.dart';
import 'package:ppj_coins_app/numberFormat.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import '../riverpod/utilities/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/login/profile.dart';
// import 'package:iFleet_app/riverpod/login/userFSP.dart';




class purchaseOrderEditPage extends ConsumerStatefulWidget {
  const purchaseOrderEditPage({super.key, required this.title, required this.id});
  final String title;
  final String id;
  

  @override
  ConsumerState<purchaseOrderEditPage> createState() => _PurchaseOrderEditPageState();
  
}

class _PurchaseOrderEditPageState extends ConsumerState<purchaseOrderEditPage> {
  List<Map<String,dynamic>> myList = [];
  List<String> filteredItems = [];
  Map<String, dynamic> selectedCategory = {};
  Map<String, dynamic> saveItems = {};
  Map<String, dynamic> POLineItems = {};
  List<dynamic> ccc = [];
  List<Map<String, dynamic>>partList = [];
  Map<String, dynamic> findparts = {};
  List<Map<String, dynamic>> ppp = [];
  Map<String, dynamic> pq = {};
  List<dynamic> partsCost = [];
  TextEditingController searchController = TextEditingController();
  List<String> PDID = [];
   Map<String, dynamic> partsInfo = {};
  // List<dynamic> totalAmt = [];
  List<dynamic> profDet = [];
  

  String? item_number; 
  int year = 0;
  double price = 0.00;
  int meter = 0;
  String title = '';
  double subtotal = 0.00;
  double shipping = 0;
  double subTax = 0;
  int tax = 0;
  double subtotal1 = 0;
  int discount = 0;
  double totAmount = 0;
  double price2 = 0;
  String id = '';
  String POTitle = '';
  String POid = '';
  String PONum = '';
  int? partsquantity;
  int? partsprevquantity;
  String profId = '';
  String profType = '';
  String profName= '';
  String expiryDate = '';
  int expiryMeter = 0;
  int disc = 0;
  String date = '';
  String plate = '';
  String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  bool isRowVisibleItem = false;
  bool isRowVisiblePrice = false;
  String vehId = '';
  String vehNo = '';
  String pdid = '';
  String pdNo = '';
  String pdTitle = '';
  List<dynamic> poli = [];
  final formatter = NumberFormat('#,###');
  
      
  DateTime? _selectedDate;
  DateTime? _selectedDate2;
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
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

  void _selectDate(BuildContext context, String field) async {
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
      field == 'Effective' && field !=''?
      saveItems['effective_date'] = formattedDate :
      print('None');
    });
  }
}

  void _selectExpiryDate(BuildContext context, String field) async {
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
      field =='Warranty' && field != ''?
      saveItems['warranty_expiration_date'] = formattedDate :
      print('None');
    });
  }
}

            TextEditingController nameController = TextEditingController();
            TextEditingController roadTaxController = TextEditingController();
            TextEditingController compController = TextEditingController();
            TextEditingController quantityController = TextEditingController();
            TextEditingController warrDateController = TextEditingController();
            TextEditingController warrMeterController = TextEditingController();
            TextEditingController costController = TextEditingController();
            TextEditingController totalController = TextEditingController();
             TextEditingController subController = TextEditingController();
            TextEditingController taxController = TextEditingController();
             TextEditingController stController = TextEditingController();
             TextEditingController shipController = TextEditingController();
             TextEditingController totController = TextEditingController();
             TextEditingController discController = TextEditingController();
             TextEditingController priceController = TextEditingController();
            

  void _updateSubtotal() {
    String value = totalController.text;
    if (value.isNotEmpty) {
      print('di sini mempunyai value total');
      String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
      setState(() {
        POLineItems['subtotal'] = numericString;
      });
      print(POLineItems['subtotal']);
    } else {
      print('gak ada nilai');
      setState(() {
        POLineItems['subtotal'] = '0.00';
      });
    }

  }

  void _onPriceChanged() {
    // This function will be called whenever the text in the priceController changes
    print("here in on price change");
    String text = priceController.text;
    // You can perform any actions based on the new value here
    String numericString = text.replaceAll(RegExp(r'[^\d.]'), '');
    numericString != ''? numericString = numericString : numericString = '0';
    saveItems['price'] = numericString; 
    price2 = double.parse(numericString);

    String discString = discController.text.replaceAll(RegExp(r'[^\d.]'), '');
    discString != ''? discString = discString : discString = '0';
    double currPrice = double.parse(numericString);
    double discount = double.parse(discString)*0.01;
    subtotal = currPrice * (discount);
    subController.text = currencyFormat.format(subtotal);
    String cleanTotal = subController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanTotal != ''? cleanTotal = cleanTotal : cleanTotal = '0.00';
    saveItems['subtotal'] = cleanTotal;

    String cleanText = subController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanText != ''? cleanText = cleanText : cleanText = '0';
    double price11 = double.parse(cleanText);
    double price12 = currPrice - price11;
    String taxString = taxController.text.replaceAll(RegExp(r'[^\d.]'), '');
    taxString != ''? taxString = taxString : taxString = '0';
    double tax1 = double.parse(taxString)*0.01;
    subTax= price12 * (tax1);
    stController.text = currencyFormat.format(subTax);
    String cleanerText = stController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanerText != ''? cleanerText = cleanerText : cleanerText = '0.00';
    saveItems['tax_subtotal'] = cleanerText;

    String shipString = shipController.text.replaceAll(RegExp(r'[^\d.]'), '');
    shipString != ''? shipString = shipString : shipString = '0';
    double shipCost = double.parse(shipString);
    totAmount= currPrice - subtotal + subTax + shipCost;
    print('this is total amt');
    print(currPrice);
    print(price11);
    print(price12);
    print(shipCost);
    print(totAmount);
    print('ends here');
    totController.text = currencyFormat.format(totAmount);
    String cleanText3 = totController.text.replaceAll(RegExp(r'[^\d.]'), '');
    cleanText3 != ''? cleanText3 = cleanText3 : cleanText3 = '0.00';
    saveItems['total_amount'] = cleanText3;
}

  @override
  void initState(){
    super.initState();
    // Editing();
    totalController.addListener(_updateSubtotal);
    priceController.addListener(_onPriceChanged);
    final PODetail vc = PODetail();
     Future.delayed(Duration.zero, () async {
      List<Map<String,dynamic>> result = await vc.createList(widget.id);;
      final Parts pt1 = Parts();
      List<Map<String, dynamic>> pt2 = await pt1.createList();
      List<dynamic> profile= await Profile().createList();
      setState(() {
        partList = pt2;
        myList = result; 
        selectedCategory=partList[0];
        profDet = profile;
        Initializer();
      });
    });


  }

  void _onTotalAmtChange(){
  final currentList = ref.read(poList);
  print(currentList);
  List<dynamic> totalAmt = [];

  if(currentList.isNotEmpty){
    for(var item in currentList){
      totalAmt.add(item['subtotal']);
    }
    // totalAmt.add(POLineItems['subtotal']);
  }else{
    totalAmt.add(POLineItems['subtotal']);
  }

print('jj');
print(totalAmt);
      double currAmt = 0.00;
      for (var item in totalAmt) {
        double amount;
        if(item != null){
          if (item is String) {
          amount = double.parse(item);
        } else {
          if(item is double){
            amount = item;
          }else{
          amount = double.parse(item.toString());}
        }
        }else{
          amount = 0.00;
        }
        
        
        print('in calc');
        print(currAmt);
        currAmt += amount;
        priceController.text = currencyFormat.format(currAmt);
      }
      print('here is currAmt');
      print(currAmt);
      saveItems['price'] = currAmt.toString();
      _onPriceChanged();
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(shouldIrb.notifier).state = false;
      });
}
  
  void Initializer(){
    if(myList.isNotEmpty){
      Map<String, dynamic> list1 = myList[0];
      POid = list1['item_id']??'';
      PONum = list1['item_number']??'';
      POTitle = list1['metadata']?['title']??'';
      meter = list1['metadata']?['current_meter_value']??0;
      vehId = list1['metadata']?['vehicle_id']?['item_id']??'';
      vehNo = list1['metadata']?['vehicle_id']?['item_number']??'';
      meter = myList[0]['metadata']?['current_meter_value']??0;
      expiryDate = myList[0]['metadata']?['warranty_expiration_date']??'';
      expiryMeter = myList[0]['metadata']?['warranty_expiration_meter_value']??'';
      disc = myList[0]['metadata']?['discount_percentage']??'0';
      tax = myList[0]['metadata']?['tax_percentage']??'0';
      date = myList[0]['metadata']?['effective_date']??'';
      plate = myList[0]['metadata']?['vehicle_id']?['title']??'';
      price = double.parse(myList[0]['metadata']?['price']?['display']??'0.00');
      subtotal = double.parse(myList[0]['metadata']?['subtotal']?['display']??'0.00');
      subTax = double.parse(myList[0]['metadata']?['tax_subtotal']?['display']??'0.00');
      shipping = double.parse(myList[0]['metadata']?['shipping']?['display']??'0.00');
      totAmount = double.parse(myList[0]['metadata']?['total_amount']?['display']??'0.00');
      title = myList[0]['metadata']?['title']??'';
      pdid = myList[0]['metadata']?['purchase_details']?['item_id']??'';
      pdNo = myList[0]['metadata']?['purchase_details']?['item_number']??'';
      pdTitle = myList[0]['metadata']?['purchase_details']?['title']??'';
      poli = myList[0]['metadata']?['poli']??[];
      saveItems['warranty_expiration_date'] = expiryDate;
      saveItems['warranty_expiration_meter_value'] = expiryMeter.toString();
      saveItems['discount_percentage'] = disc.toString();
      saveItems['effective_date'] = date;
      saveItems['tax_percentage'] = tax.toString();
      saveItems['price'] = price.toString();
      saveItems['subtotal'] = subtotal.toString();
      saveItems['tax_subtotal'] = subTax.toString();
      saveItems['shipping'] = shipping.toString();
      saveItems['total_amount'] = totAmount.toString();

      for(var item in poli){
        item['title_POLI'] = item['title'];
        item['id_POLI'] = item['item_id'];
        item['item_type_POLI'] = item['item_type_id'];
        item['item_number_POLI'] = item['item_number'];
        item['item_type_code_POLI'] = item['item_type_code'];
        item['disp_part_id'] = item['part_id']['title'];
        item['part_id'] = item['part_id']['item_id'];
        item['quantity'] = item['quantity'];
        item['unit_cost'] = item['unit_cost']['value'];
        item['subtotal'] = item['subtotal']['value'];
      }
      // ref.read(poList.notifier).state = poli;
      warrDateController.text = expiryDate;
      warrMeterController.text = formatter.format(expiryMeter);
      subController.text = currencyFormat.format(subtotal);
      taxController.text = tax.toString();
      stController.text =  currencyFormat.format(subTax);
      shipController.text = currencyFormat.format(shipping);
      totController.text = currencyFormat.format(totAmount);
      discController.text = disc.toString();
      priceController.text = currencyFormat.format(price); 
      title = widget.title;
      id = widget.id;
      if (profDet.isNotEmpty) {
        List<dynamic> list1 = profDet[0];
        Map<String, dynamic> firstItem = list1[0];
        profName = firstItem['metadata']?['title']?? '';
        profId = firstItem['item_id']?? '';
        profType = firstItem['item_type_id']?? '';
      } else{}
      findparts['title_PO'] = POTitle;
      findparts['item_id_PO'] = POid;
      findparts['item_number_PO'] = PONum;
      saveItems['notes'] = profName;
      partList.sort((a, b) => a['title'].toString().compareTo(b['title'].toString()));
      POLineItems['title'] = title;
      for (var item in poli){
      item['title_POLI'] = item['title'];
      item['id_POLI']=  item['item_id'];
      item['item_number_POLI']=  item['item_number'];
      item['item_type_POLI']=  item['item_type_id'];
    }
    print('after add');
    print(poli);
    ref.read(poList.notifier).state = poli;
      _onTotalAmtChange();
    }
  }

    @override
  void dispose() {
    searchController.dispose();
    totalController.removeListener(_updateSubtotal);
    priceController.removeListener(_onPriceChanged);
    totalController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    print('yyy12ll');
    print(profName);
    print(poli);
    var counter = ref.read(poList).length;
    var counter2 = counter.toString();
    _onTotalAmtChange();

    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 50, left: h*0.01),
                    color: ref.watch(primaryColor),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));

                          },
                          icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
                          color: ref.read(truewhite),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: h*0.1),
                          child: Text(
                            'Edit Purchase Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                         Padding(
                          padding: EdgeInsets.only(top: h*0.01, bottom: h*0.0, left: w*0.1, right: w*0.0),
                          child: Flexible(
                            child: InkWell(
                              onTap:() {
                                String part = '';
                                String quantity = '';
                                String cost = '';
                                String total = '';
                                final partsList = ref.read(poList);
                                showGeneralDialog<String>(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: '',
                                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                                    return Scaffold(
                                      body: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(50),
                                              color: ref.watch(primaryColor),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: h*0.01),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        ref.read(shouldIrb.notifier).state =true;
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
                                                      color: ref.read(truewhite),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: h*0.1),
                                                    child: Text(
                                                      'Items',
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
                                      
                                            partsList.isNotEmpty ?
                                            Consumer(builder:(context, ref, child) {
                                              var poListWatcher =ref.watch(poList);
                                              return Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: poListWatcher.length, 
                                                    itemBuilder: (context, index) {
                                                      var item =poListWatcher[index];
                                                      print(item);
                                                      id = item['part_id'];
                                                      part = item['disp_part_id'];
                                                      quantity = item['quantity'].toString();
                                                      cost = item['unit_cost'].toString();
                                                      total = item['subtotal'].toString();
                                                      if (index < poListWatcher.length) {
                                                        return Card(
                                                          elevation: 10, 
                                                          margin: EdgeInsets.all(8), 
                                                          child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                ListTile(
                                                                  title: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Part Name: ',
                                                                            style: TextStyle(color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            '$part',
                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                            softWrap: true,
                                                                          ),
                                                                          Spacer(),
                                                                          PopupMenuButton<int>(
                                                                                icon: IconTheme(
                                                                                    data: IconThemeData(
                                                                                      size: h*0.02, // Specify the desired size here
                                                                                    ),
                                                                                    child: Icon(Icons.more_vert, color: Colors.black),
                                                                                  ),
                                                                                onSelected: (int result) async{
                                                                                  // Handle the selection of the menu items here
                                                                                  switch (result) {
                                                                                    case 0:
                                                                                      // Handle option 1
                                                                                      List<dynamic> ids = [];
                                                                                      ids.add(item['item_id']);
                                                                                      await PurchaseOrder().deleteItems(ids);
                                                                                      poListWatcher.removeWhere((item) => ids.contains(item['id_POLI']));
                                                                                      print('here in parts list');
                                                                                      print(poListWatcher);
                                                                                      ref.invalidate(poList);
                                                                                      ref.read(poList.notifier).state = poListWatcher;
                                                                                      setState(() {});
                                                                                      break;
                                                                                  }
                                                                                },
                                                                                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                                                                  PopupMenuItem<int>(
                                                                                    value: 0,
                                                                                    child: Text('Delete'),
                                                                                  ),
                                                                            ],
                                                                          ),
                                                                      
                                                                        ]
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Quantity: ',
                                                                            style: TextStyle(color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            formatter.format(int.parse(quantity)),
                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Unit Cost: ',
                                                                            style: TextStyle(color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            currencyFormat.format(double.parse(cost)),
                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Subtotal: ',
                                                                            style: TextStyle(color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            currencyFormat.format(double.parse(total)),
                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      
                                                                    ],
                                                                  ),
                                                                ),
                                                              
                                                              ],
                                                            ),
                                                        );
                                                      } else {
                                                        return Container(); 
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            },) :
                                          Expanded(child: Text('No Item is Found'))
                                            
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Text('View Items', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                                  badges.Badge(
                                    badgeContent: Text(counter2, style: TextStyle(color: Colors.white),),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.0, left: w*0.02, right: w*0.02),
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
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Effective Date:  ',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black), 
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
                                                          _selectDate(context, 'Effective');
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: h*0.005),
                                                          child: Row(children: [
                                                            date != ''?
                                                            Text(date, style: TextStyle(fontSize: h*0.025),) : Icon(
                                                            Icons.event,
                                                            size: h * 0.025, // Match the icon size with the text size
                                                          ),
                                                          ],)
                                                          
                                                    
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
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
                                  padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.02, right: w * 0.01), // Adjust padding for spacing
                                  child: Container(
                                    height: h * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: ref.read(truegray).withOpacity(1),
                                        width: h * 0.002,
                                      ),
                                      color: ref.read(truegray).withOpacity(0.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: w * 0.03),
                                          child: Text(
                                            'Current Meter Value (KM)',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Padding(
                                          padding: EdgeInsets.only(left: w * 0.03),
                                          child: Text(
                                            formatter.format(meter),
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
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
                                  padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.01, right: w * 0.02), // Adjust padding for spacing
                                  child: Container(
                                    height: h * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: ref.read(truegray).withOpacity(1),
                                        width: h * 0.002,
                                      ),
                                      color: ref.read(truegray).withOpacity(0.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: w * 0.03),
                                          child: Text(
                                            'Plate Number',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Padding(
                                          padding: EdgeInsets.only(left: w * 0.03),
                                          child: Text(
                                            vehNo,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
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
                                  padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.02, right: w * 0.01),
                                  child: Container(
                                    height: h * 0.14,
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
                                              'Warranty Expiration Date',
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
                                                          _selectExpiryDate(context, 'Warranty');
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: h*0.005),
                                                          child: Row(
                                                            children: [
                                                              warrDateController.text != ''?
                                                              Text(
                                                                  warrDateController.text,
                                                                  style: TextStyle(fontSize: h * 0.025),
                                                                ) : Icon(
                                                                    Icons.event,
                                                                    size: h * 0.025, // Match the icon size with the text size
                                                                  )
                                                              ]
                                                          ),
                                                          // child: Icon(
                                                          //   Icons.event,
                                                          //   size: h * 0.025, // Match the icon size with the text size
                                                          // ),
                                                        //   child: Text(
                                                        //   DateFormat('dd-MM-yyyy').format(_selectedDate!),
                                                        //   style: TextStyle(fontSize: h * 0.02),
                                                        // ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                          // InkWell(
                                          //   onTap: (){
                                          //     _selectExpiryDate(context, 'Warranty');
                                          //   },
                                          //   child: Text(
                                          //     '${_selectedDate2 != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!):'Select date'}',
                                          //     style: TextStyle(fontSize: h * 0.025),
                                          //   ),
                                          // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Consumer(builder: (context, ref, child) =>
                                Padding(
                                  padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.01, right: w * 0.02),
                                  child: Container(
                                    height: h * 0.14,
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
                                                  padding: EdgeInsets.only(top: h * 0.01, left: w * 0.01),
                                                  child: Text(
                                                    'Warranty Expiration Meter Value(KM)',
                                                    style: TextStyle(fontSize: h * 0.02, color: Colors.black), // Adjust the style as needed
                                                  ),
                                                ),
                                                  TextField(
                                                    controller: warrMeterController,
                                                    style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                      CommaInputFormatter(),
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    onChanged: (value) {
                                                      String cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                      saveItems['warranty_expiration_meter_value'] = cleanValue;
                                                    },
                                                ),
                                              ],
                                            )

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
                                if(isRowVisibleItem == true){
                                  isRowVisibleItem = false;
                                }else{
                                  isRowVisibleItem = true;
                                }
                              });
                            }),
                            child: Container(
                              height: h*0.08,
                              width: w*1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:ref.read(truegray).withOpacity(1),
                                      width: h*0.002,
                                    ),
                                    color: ref.read(primaryColor).withOpacity(0.25),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.01, left: w*0.01, right: w*0.1),
                                    child: Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('Add Parts', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  isRowVisibleItem ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined,
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
                                visible: isRowVisibleItem,
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.01, left: w*0.02, right: w*0.002),
                                    child: Container(
                                      height: h*0.11,
                                      width: double.infinity,
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
                                            Text(
                                              'Parts Name',
                                              style: TextStyle(fontSize: h * 0.02, color: Colors.black), // Adjust the style as needed
                                            ),
                                            DropdownButton<Map<String, dynamic>>(
                                              value: selectedCategory,
                                              onChanged: (Map<String, dynamic>? newValue)async { 
                                                if (newValue != null) { 
                                                  setState((){
                                                    selectedCategory = newValue;
                                                    POLineItems['disp_part_id'] = newValue['title'];
                                                    POLineItems['part_id'] = newValue['id'];
                                                    POLineItems['part_num'] = newValue['itemNo'];
                                                  });
                                                  String partsPrice = await Parts().findPrice(newValue['id']);
                                                  List<Map<String, dynamic>> pq1 = await Parts().findInventory(newValue['id']);
                                                  print('here is unit cost for ');
                                                  print(partsPrice);
                                                  double partCost = double.parse(partsPrice);
                                                  costController.text = currencyFormat.format(partCost);
                                                  POLineItems['unit_cost'] = partsPrice; 
                                                  totalController.text = '';
                                                  for (var map in pq1){
                                                    map.forEach((key, value) {
                                                      pq[key] = value;  // This will overwrite the value if the key already exists
                                                    });
                                                  }
                                                }
                                              },
                                              items: partList.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> map) {
                                                return DropdownMenuItem<Map<String, dynamic>>(
                                                  value: map, 
                                                  child: Text(map['title'].toString()), 
                                                );
                                              }).toList(),
                                              // isExpanded: true, 
                                              hint: Text('Select Parts'),
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
                                visible: isRowVisibleItem,
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.00, left: w * 0.02, right: w * 0.02),
                                    child: Container(
                                      height: h * 0.11,
                                      width: w*0.01,
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
                                                    padding: EdgeInsets.only(top: h * 0.001, left: w * 0.01),
                                                    child: Text(
                                                      'Quantity',
                                                      style: TextStyle(fontSize: h * 0.02, color: Colors.black), // Adjust the style as needed
                                                    ),
                                                  ),
                                                    TextField(
                                                      controller: quantityController,
                                                      style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                                      textAlign: TextAlign.start,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        // CommaInputFormatter()
                                                      ],
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                      onChanged: (value) async {
                                                        int intValue = int.tryParse(value) ?? 0;
                                                        int maxVal = pq['quantity']??0;
                                                        print(maxVal);
                                                        if(intValue <= maxVal){
                                                          POLineItems['quantity'] = value;
                                                          print(pq);
                                                        }else{
                                                          _showAlertDialog('The item only has $maxVal left. Please enter quantity less or equal to $maxVal');
                                                          quantityController.text = '';
                                                          totalController.text = '';
                                                        }
                                
                                                        if(value.isNotEmpty){
                                                          double q = 0.00;
                                                          q = double.parse(value);
                                                          String cleanCost = costController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                          double cost = double.parse(cleanCost);
                                                          subtotal = q * cost;
                                                          totalController.text = currencyFormat.format(subtotal);
                                                          String cleanTotal = totalController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                          POLineItems['subtotal'] = cleanTotal; 
                                                        }else{
                                                          quantityController.text = '';
                                                          totalController.text = '';
                                                          POLineItems['subtotal'] = 0.00; 
                                                        }
                                
                                                        
                                                      },
                                                  ),
                                                ],
                                              )
                                
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Visibility(
                                visible: isRowVisibleItem,
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.11,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truegray).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: h * 0.001, left: w * 0.01),
                                            child: Text(
                                              'Unit Price(RM)',
                                              style: TextStyle(fontSize: h * 0.02, color: Colors.black), // Adjust the style as needed
                                            ),
                                          ),
                                          TextField(
                                            controller: costController,
                                            readOnly: true,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 2,
                                                locale: 'ms-my',
                                                symbol: "RM "
                                              )
                                            ],
                                            decoration: InputDecoration(
                                              // labelText: 'Unit Cost',
                                              border: InputBorder.none,
                                              // hintText: 'Insert Price in RM',
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                                if(value.isNotEmpty){
                                                  String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                  POLineItems['unit_cost'] = numericString; 
                                                  double cost = double.parse(numericString);
                                                  double q = double.parse(quantityController.text);
                                                  subtotal = q * cost;
                                                  totalController.text = currencyFormat.format(subtotal);
                                                  String cleanTotal = totalController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  POLineItems['subtotal'] = cleanTotal; 
                                                }else{
                                                  POLineItems['unit_cost'] = '0.00'; 
                                                  // totalController.text = currencyFormat.format(0.00);
                                                  totalController.text = '';
                                                }
                                              
                                            },
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
                                visible: isRowVisibleItem,
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                    child: Container(
                                      height: h*0.11,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:ref.read(truegray).withOpacity(1),
                                          width: h*0.002
                                        ),
                                        color: ref.read(truegray).withOpacity(0.5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: h * 0.001, left: w * 0.01),
                                            child: Text(
                                              'Total(RM)',
                                              style: TextStyle(fontSize: h * 0.02, color: Colors.black), // Adjust the style as needed
                                            ),
                                          ),
                                          TextField(
                                            controller: totalController,
                                            readOnly: true,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 2,
                                                locale: 'ms-my',
                                                symbol: "RM "
                                              )
                                            ],
                                            decoration: InputDecoration(
                                              // labelText: 'Subtotal',
                                              border: InputBorder.none,
                                              // hintText: 'Insert Price in RM',
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                                if(value.isNotEmpty){
                                                  print('have value');
                                                  String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                  POLineItems['subtotal'] = numericString; 
                                              
                                                }else{
                                                  print('no value');
                                                  POLineItems['subtotal'] = '0.00'; 
                                                }
                                              
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isRowVisibleItem,
                              child: ElevatedButton(
                                onPressed: () async{
                                  final currentList = ref.read(poList);
                                  print('currentList');
                                  print(currentList);
                                  
                                  POLineItems['title_PO'] = POTitle;
                                  POLineItems['item_id_PO'] = POid;
                                  POLineItems['item_number_PO'] = PONum;
                                  print(POLineItems);
                                  Map<String, dynamic>  detPO = await findList1().saveList(POLineItems);
                                  partsInfo = detPO;
                                  print('here is partsInfo');
                                  print(partsInfo);
                                  var tempObj ={};
                                  tempObj['disp_part_id'] = POLineItems['disp_part_id'];
                                  tempObj['part_id'] = POLineItems['part_id'];
                                  tempObj['part_num'] = POLineItems['part_num'];
                                  tempObj['quantity'] = POLineItems['quantity'];
                                  tempObj['unit_cost'] = POLineItems['unit_cost'];
                                  tempObj['subtotal'] = POLineItems['subtotal'];
                                  tempObj['title_POLI'] = partsInfo['title_POLI'];
                                  tempObj['id_POLI'] = partsInfo['id_POLI'];
                                  tempObj['item_type_POLI'] = partsInfo['item_type_POLI'];
                                  tempObj['item_number_POLI'] = partsInfo['item_number_POLI'];
                                  tempObj['item_type_code_POLI'] = partsInfo['item_type_code_POLI'];
                                  currentList.add(tempObj);
                                  print('Here is updated Loist');
                                  
                                  ref.read(poList.notifier).state = currentList;
                                  print('updatedList');
                                  List<dynamic> newListing = ref.read(poList);
                                  print(newListing);
                                  await findList1().updateItems(newListing, POTitle,POid,PONum);
                                  _onTotalAmtChange();
                                  _showAlertDialog('Item Added Succesfully!');
                                  quantityController.text = '';
                                  costController.text = '';
                                  totalController.text = '';
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: Text('Add to Cart', style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (() {
                              setState(() {
                                if(isRowVisiblePrice == true){
                                  isRowVisiblePrice = false;
                                }else{
                                  isRowVisiblePrice = true;
                                }
                              });
                            }),
                            child: Container(
                              height: h*0.08,
                              width: w*1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:ref.read(truegray).withOpacity(1),
                                      width: h*0.002,
                                    ),
                                    color: ref.read(primaryColor).withOpacity(0.25),
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
                                                  isRowVisiblePrice ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined,
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
                            Expanded(
                              child: Visibility(
                                visible: isRowVisiblePrice,
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
                                        color: ref.read(truegray).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: priceController,
                                            readOnly: true,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 2,
                                                locale: 'ms-my',
                                                symbol: "RM "
                                              )
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Price(RM)',
                                              border: InputBorder.none,
                                              // hintText: 'Insert Price in RM',
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                              print('value has changed');
                                                if(value.isNotEmpty){
                                                  String numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                  numericString != ''? numericString = numericString : numericString = '0';
                                                  saveItems['price'] = numericString; 
                                                  price2 = double.parse(numericString);
                                              
                                                }else{
                                                  print('no value');
                                                  saveItems['price'] = '0.00'; 
                                                }
                                              
                                            },
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
                                visible: isRowVisiblePrice,
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
                                          TextField(
                                            controller: discController,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Discount (%)',
                                              border: InputBorder.none,
                                              // hintText: 'Insert Discount',
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                              _onPriceChanged();
                                              print(value);
                                              if (value.isNotEmpty) {
                                                  saveItems['discount_percentage'] = value;
                                                  String numericString = priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  numericString != '' ? numericString = numericString: numericString = '0';
                                                  double currPrice = double.parse(numericString);
                                                  double discount = double.parse(value)*0.01;
                                                  subtotal = currPrice * (discount);
                                                  subController.text = currencyFormat.format(subtotal);
                                                  String cleanTotal = subController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanTotal != '' ? cleanTotal = cleanTotal: cleanTotal = '0';
                                                  saveItems['subtotal'] = cleanTotal;
                                
                                              } else {
                                                saveItems['discount_percentage'] = 0; 
                                                subController.text = '';
                                              }
                                            },
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
                                visible: isRowVisiblePrice,
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
                                        color: ref.read(truegray).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: subController,
                                            readOnly: true,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Discount Subtotal(RM)',
                                              border: InputBorder.none,
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                  saveItems['subtotal'] = value;
                                
                                              } else {
                                                saveItems['subtotal'] = 0; 
                                              }
                                            },
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
                                visible: isRowVisiblePrice,
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
                                          TextField(
                                            controller: taxController,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Tax(%)',
                                              border: InputBorder.none,
                                              // hintText: 'Insert Tax',
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                              _onPriceChanged();
                                              if (value.isNotEmpty) {
                                                  saveItems['tax_percentage'] = value;
                                                  String numericString = priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  numericString != '' ? numericString = numericString: numericString = '0';
                                                  double currPrice = double.parse(numericString);
                                                  String cleanText = subController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanText != '' ? cleanText = cleanText: cleanText = '0';
                                                  double price11 = double.parse(cleanText);
                                                  double price12 = currPrice - price11;
                                                  double tax1 = double.parse(value)*0.01;
                                                  subTax= price12 * (tax1);
                                                  stController.text = currencyFormat.format(subTax);
                                                  String cleanerText = stController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanerText != '' ? cleanerText = cleanerText: cleanerText = '0';
                                                  saveItems['tax_subtotal'] = cleanerText;
                                              } else {
                                                saveItems['tax_percentage'] = 0; 
                                                stController.text = '';
                                              }
                                            },
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
                                visible: isRowVisiblePrice,
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
                                        color: ref.read(truegray).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: stController,
                                            readOnly: true,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Tax Subtotal(RM)',
                                              border: InputBorder.none,
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                  saveItems['tax_subtotal'] = value;
                                
                                              } else {
                                                saveItems['tax_subtotal'] = 0; 
                                              }
                                            },
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
                                visible: isRowVisiblePrice,
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
                                          TextField(
                                            controller: shipController,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 2,
                                                locale: 'ms-my',
                                                symbol: "RM "
                                              )
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Shipping(RM)',
                                              border: InputBorder.none,
                                              // hintText: 'Insert Shipping Price in RM',
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                                if(value.isNotEmpty){
                                                  String clearText = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                  saveItems['shipping'] = clearText;
                                                  String numericString = priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  numericString != '' ? numericString = numericString: numericString = '0';
                                                  double currPrice = double.parse(numericString);
                                                  String cleanText4 = subController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanText4 != '' ? cleanText4 = cleanText4: cleanText4 = '0';
                                                  double price11 = double.parse(cleanText4);
                                                  String cleanText = stController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanText != '' ? cleanText = cleanText: cleanText = '0';
                                                  String cleanText2 = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanText2 != '' ? cleanText2 = cleanText2: cleanText2 = '0';
                                                  double price12 = double.parse(cleanText);
                                                  double shipCost = double.parse(cleanText2);
                                                  totAmount= currPrice - price11 + price12 + shipCost;
                                                  totController.text = currencyFormat.format(totAmount);
                                                  String cleanText3 = totController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                  cleanText3 != '' ? cleanText3 = cleanText3: cleanText3 = '0';
                                                  saveItems['total_amount'] = cleanText3;
                                                  _onPriceChanged();
                                              
                                                }else{
                                                  saveItems['shipping'] = '0.00'; 
                                                }
                                              
                                            },
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
                                visible: isRowVisiblePrice,
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
                                        color: ref.read(truegray).withOpacity(0.8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: totController,
                                            readOnly: true,
                                            style: TextStyle(fontSize: h * 0.025, color: Colors.black),
                                            textAlign: TextAlign.start,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                              labelText: 'Total Amount(RM)',
                                              border: InputBorder.none,
                                              // hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                  saveItems['total_amount'] = value;
                                
                                              } else {
                                                saveItems['total_amount'] = 0; 
                                              }
                                            },
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                print("here is profName");
                                saveItems['current_mater_value'] = meter.toString();
                                saveItems['vehicle_id'] = vehId;
                                saveItems['disp_vehicle_id'] = vehNo;
                                saveItems['title'] = widget.title;
                                saveItems['item_id'] = widget.id;
                                saveItems['item_number'] = PONum;
                                saveItems["status_code"] = "01";
                                saveItems["status_value"] = "POS01";
                                saveItems["status_display"] = "Draft";
                                print(saveItems);
                                                            
                                await createPO().saveEdits(saveItems);
                                _showAlertDialog('Item saved succesfully!');

                                
                                Navigator.push(context, MaterialPageRoute(builder: (context) => viewPOPage()));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                              child: Text('Update', style: TextStyle(color: Colors.white)),
                            ),

                          ],
                        ),
                        ],
                    ),
                  ),
                ),
            ),
                ],
              ),
            ); 
  }
}
