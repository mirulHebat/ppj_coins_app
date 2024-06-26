import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/poParts.dart';
// import 'package:iFleet_app/PurchaseOrder/viewPO.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class viewPartsAppPage extends ConsumerStatefulWidget {
  final String id;
  final List<String> poli;
  // final String poli;
  viewPartsAppPage({Key? key, required this.id, required this.poli}) : super(key: key);
  

  @override
  ConsumerState<viewPartsAppPage> createState() => _viewPartsAppPageState();
  
}

class _viewPartsAppPageState extends ConsumerState<viewPartsAppPage> {
  List<Map<String, dynamic>> myList = [];
  List<Map<String, dynamic>> parts = [];

 List<Map<String, dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  void POLI(){
    final POParts vc = POParts();
     Future.delayed(Duration.zero, () async {
      List<Map<String, dynamic>> result = await vc.findPart(widget.poli);
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
String rec = '';


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    print('di sini lepas approval oleh manager');
    // print(myList.toString());
    print(widget.poli);
    
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
                        rec = item['received'].toString();
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
                                              '$quantity',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Received: ',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              '$rec',
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
                                              'RM $cost',
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
                                              'RM $total',
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
