import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/poParts.dart';
// import 'package:iFleet_app/PurchaseOrder/viewPO.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';

class POPartsPage extends ConsumerStatefulWidget {
  final String id;
   const POPartsPage({Key? key, required this.id}) : super(key: key);
  

  @override
  ConsumerState<POPartsPage> createState() => _POPartsPageState();
  
}

class _POPartsPageState extends ConsumerState<POPartsPage> {
  List<Map<String, dynamic>> myList = [];
  List<Map<String, dynamic>> parts = [];

 List<Map<String, dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  void POLI(){
    final POParts vc = POParts();
     Future.delayed(Duration.zero, () async {
      List<Map<String, dynamic>> result = await vc.createList(widget.id);
      setState(() {
        myList = result; 
      });
    });

    filteredItems.addAll(myList);
  }

  @override
  void initState(){
    super.initState();
    POLI();
    
  }

    @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

String title = '';
String id = '';
String part = '';
String quantity = '';
String cost = '';
String total = '';
final formatter = NumberFormat('#,###');
final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    print('yehawww');
    
    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(50),
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
                        Text(
                          'Items',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  myList.isNotEmpty ?
                  Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myList.length, 
                      itemBuilder: (context, index) {
                        var item = myList[index];
                        title = item['title'];
                        id = item['id'];
                        part = item['part'];
                        quantity = item['quantity'].toString();
                        cost = item['cost']['display'].toString();
                        total = item['total']['display'].toString();
                        if (index < myList.length) {
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
                ) :
                Expanded(child: Text('No Item is Found'))
                  
                ],
              ),
            ); 
  }
}
