import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/vehiclePayment.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../riverpod/utilities/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';



class vehiclePaymentPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> vdet;
  const vehiclePaymentPage({Key? key, required this.vdet}) : super(key: key);
  

  @override
  ConsumerState<vehiclePaymentPage> createState() => _VehiclePaymentPageState();
  
}

class _VehiclePaymentPageState extends ConsumerState<vehiclePaymentPage> {
  List<Map<String,dynamic>> myList = [];
  List<String> filteredItems = [];
  Map<String, dynamic> selectedCategory = {};
  Map<String, dynamic> purchaseDetails = {};
  TextEditingController searchController = TextEditingController();

  String? title;
  double shipping = 0;
  double subTax = 0;
  int tax = 0;
  double subtotal = 0;
  int discount = 0;
  double totAmount = 0;
  double price = 0;

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);
  final TextEditingController discController = TextEditingController(text: "");
  final TextEditingController subController = TextEditingController();
  final TextEditingController taxController = TextEditingController(text: "");
  final TextEditingController stController = TextEditingController();
  final TextEditingController shipController = TextEditingController(text: "");
  final TextEditingController totController = TextEditingController();
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: 'RM ',decimalDigits: 2,);
  // void _showAlertDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Error'),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  @override
  void initState(){
    super.initState();
    final vehiclePayment vc = vehiclePayment();
     Future.delayed(Duration.zero, () async {
      List<Map<String,dynamic>> result = await vc.createList(widget.vdet['item_number']);
      setState(() {
        myList = result; 
        // selectedCategory=myList[0];
      });
    });
  }

    @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    print('haH');
    print(myList.toString());
    title = widget.vdet['title'];
    price = double.parse(widget.vdet['estimated_resale_price']);
    String formattedPrice = currencyFormatter.format(price);

    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(50),
                    color: ref.watch(primaryColor),
                    child: Text(
                      'Vehicle Order Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color:ref.read(truegray).withOpacity(1),
                                              width: h*0.002
                                            ),
                                            color: ref.read(truewhite).withOpacity(0.8),
                                          ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: h * 0.01),
                                                child: Text(
                                                  'Title:',
                                                  style: TextStyle(fontSize: h * 0.02, color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Text(
                                                '$title',
                                                style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: Colors.black),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: h * 0.01),
                                          child: Text(
                                            'Price:',
                                            style: TextStyle(fontSize: h * 0.02, color: Colors.black),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Text(
                                          formattedPrice,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: Colors.black),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                        TextField(
                                          controller: discController,
                                          style: TextStyle(fontSize: h * 0.025, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Discount (%)',
                                            border: InputBorder.none,
                                            hintText: 'Insert Discount',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                                purchaseDetails['discount_percentage'] = value;
                                                double discount = double.parse(value)*0.01;
                                                subtotal = price * (1-discount);
                                                subController.text = currencyFormatter.format(subtotal);

                                            } else {
                                              purchaseDetails['discount_percentage'] = 0; 
                                            }
                                          },
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
                                        TextField(
                                          controller: subController,
                                          readOnly: true,
                                          style: TextStyle(fontSize: h * 0.025, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'After Discount',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                                purchaseDetails['subtotal'] = value;

                                            } else {
                                              purchaseDetails['subtotal'] = 0; 
                                            }
                                          },
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
                                        TextField(
                                          controller: taxController,
                                          style: TextStyle(fontSize: h * 0.025, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Tax',
                                            border: InputBorder.none,
                                            hintText: 'Insert Tax',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                                purchaseDetails['tax_percentage'] = value;
                                                String cleanText = subController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                double price1 = double.parse(cleanText);
                                                double discount = double.parse(value)*0.01;
                                                subTax= price1 * (1-discount);
                                                stController.text = currencyFormatter.format(subTax);
                                            } else {
                                              purchaseDetails['tax_percentage'] = 0; 
                                            }
                                          },
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
                                        TextField(
                                          controller: stController,
                                          readOnly: true,
                                          style: TextStyle(fontSize: h * 0.025, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'After tax',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                                purchaseDetails['subtotal'] = value;

                                            } else {
                                              purchaseDetails['tax_subtotal'] = 0; 
                                            }
                                          },
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
                                        TextField(
                                          controller: shipController,
                                          style: TextStyle(fontSize: h * 0.025, color: Colors.blue),
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
                                            labelText: 'Shipping',
                                            border: InputBorder.none,
                                            hintText: 'Insert Shipping Price in RM',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                              if(value.isNotEmpty){
                                                purchaseDetails['shipping'] = value;
                                                String cleanText = stController.text.replaceAll(RegExp(r'[^\d.]'), '');
                                                print(stController.text);
                                                print(value);
                                                String cleanText2 = value.replaceAll(RegExp(r'[^\d.]'), '');
                                                double price1 = double.parse(cleanText);
                                                double shipCost = double.parse(cleanText2);
                                                totAmount= price1 + shipCost;
                                                totController.text = currencyFormatter.format(totAmount);
                                            
                                              }else{
                                                purchaseDetails['shipping'] = '0.00'; 
                                              }
                                            
                                          },
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
                                        TextField(
                                          controller: totController,
                                          readOnly: true,
                                          style: TextStyle(fontSize: h * 0.025, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Total Amount',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                                purchaseDetails['subtotal'] = value;

                                            } else {
                                              purchaseDetails['total_amount'] = 0; 
                                            }
                                          },
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => profilePage()));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => profilePage()));
                                // Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: Text('Save'),
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
