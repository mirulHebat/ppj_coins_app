import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/parts.dart';
import 'package:ppj_coins_app/PurchaseOrder/poLineItems.dart';
import 'package:ppj_coins_app/PurchaseOrder/poParts.dart';
import '../riverpod/utilities/colors.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/numberFormat.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';


final list4build = StateProvider<List>((ref) {
  return [] ;
});

class POPartsAppPage extends ConsumerStatefulWidget {
  final String id;
  final List<String> poli;
  POPartsAppPage({Key? key, required this.id, required this.poli}) : super(key: key);
  

  @override
  ConsumerState<POPartsAppPage> createState() => _POPartsAppPageState();
  
}

class _POPartsAppPageState extends ConsumerState<POPartsAppPage> {
  List<Map<String, dynamic>> parts = [];

 List<Map<String, dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();
  final formatter = NumberFormat('#,###');
final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);

  void POLI(){
    final POParts vc = POParts();
     Future.delayed(Duration.zero, () async {
      List<Map<String, dynamic>> result = await vc.findPart(widget.poli);
      ref.read(list4build.notifier).state = result;
    });

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
                  

                  ref.watch(list4build).isNotEmpty ?
                  Expanded(
                    child: Consumer(builder: ((context, ref, child){
                      var myList =ref.watch(list4build);
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: myList.length, 
                          itemBuilder: (context, index) {
                            
                            if (index < myList.length) {
                              return CardClass(myList, index);
                              
                            } else {
                              return Container(); 
                            }
                          },
                        ),
                      );
                    } ),)
                  
                ) :
                Expanded(child: Text('No Item is Found'))
                
                ],
              ),
            ); 
  }
}



class CardClass extends ConsumerStatefulWidget {
  // const CardClass({super.key});
  final myList;
  final index;
  CardClass(this.myList,this.index);
  
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardClassState();
}

class _CardClassState extends ConsumerState<CardClass> {
  var item = {};
  var title ;
  var id ;
  var part ;
  var quantity ;
  var rec ;
  var cost ;
  var total;
  var textContr = TextEditingController();
  var totalController = TextEditingController();
    final formatter = NumberFormat('#,###');
     bool showWarning = false;
    String warningText = '';
    
final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = widget.myList[widget.index];
    title = item['title'];
    id = item['id'];
    part = item['part'];
    // item['taken']= '0';
    quantity = item['quantity'].toString();
    rec = item['received'].toString();
    cost = item['cost']['display'].toString();
    total = item['total']['display'].toString();
    textContr.text = item['received'].toString();
    totalController.text = currencyFormat.format(double.parse(item['total']['display']));
    // ref.read(list4build.notifier).state = widget.myList;
   
  }
  

  @override
  Widget build(BuildContext context) {

    void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success!'),
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

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
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

    return Card(
      elevation: 10, 
      margin: EdgeInsets.all(2), 
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
                        'Received: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      Expanded(
                        child: TextField(
                          controller: textContr,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero
                          ),
                          maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                textAlign: TextAlign.start,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CommaInputFormatter(),
                                ],
                                onChanged: (value) {
                                  print('here is rec');
                                  print(rec);
                                  if(value.isNotEmpty){
                                    if(int.parse(value) <= int.parse(quantity)){
                                      if(int.parse(value) >= int.parse(rec)){
                                        showWarning = false;
                                        var cost1 = double.parse(cost);
                                        var units = double.parse(value);
                                        var amaun = cost1 * units;
                                        var left = int.parse(value) - int.parse(rec);
                                        var leftString = left.toString();
                                        print(amaun);
                                        totalController.text = currencyFormat.format(amaun);
                                        widget.myList[widget.index]['received']=value.replaceAll(RegExp(r'[^\d.]'), '');
                                        widget.myList[widget.index]['taken']=leftString.replaceAll(RegExp(r'[^\d.]'), '');
                                        widget.myList[widget.index]['total']['value']=amaun.toString();
                                        widget.myList[widget.index]['total']['display']=amaun.toString();
                                        ref.read(list4build.notifier).state = widget.myList;
                                        print('after change');
                                        print(widget.myList);
                                        setState(() {
                                          showWarning = false;
                                        });
                                      }else{
                                        // widget.myList[widget.index]['received']=rec;
                                        // ref.invalidate(list4build);
                                        // ref.read(list4build.notifier).state = widget.myList;
                                        // textContr.text = rec;
                                        setState(() {
                                          showWarning = true;
                                          warningText = 'Received must be more than $rec';
                                        });
                                        // _showAlertDialog('Received must be more than $rec');

                                      }
                                      

                                    }else{
                                      widget.myList[widget.index]['received']=rec;
                                      ref.invalidate(list4build);
                                      ref.read(list4build.notifier).state = widget.myList;
                                      textContr.text = rec;
                                      _showAlertDialog('Received must be less than $quantity');

                                    }
                                  }
                                  
                                }
                            ),
                      ),
                    ],
                  ),
                  showWarning == true ?
                    Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Text(
                        warningText,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ): Text(''),
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
                      Expanded(
                        child: TextField(
                            controller: totalController,
                            readOnly: true,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                decimalDigits: 2,
                                locale: 'ms-my',
                                symbol: "RM "
                              ),
                              FilteringTextInputFormatter.digitsOnly,
                              CommaInputFormatter(),
                            ],
                            onChanged: (value) {},
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                print("here is profName");
                                print(widget.myList);      
                                List<Map<String,dynamic>> recList = widget.myList;
                                if(showWarning == false){
                                   for (var item in recList){
                                  print('here is widget myList');
                                  print(item);
                                  await findList1(). updateReceivedQty(item);
                                  List<Map<String,dynamic>> invList = await Parts().findInventory(item['partId']);
                                  // await Parts().updateInventory(item);
                                  for(var item2 in invList){
                                    item2['taken'] = item['taken'];
                                    print('here is item2');
                                    print(item);
                                    print(item2);
                                  await Parts().updateInventory(item2);
                                  }
                                }
                                _showSuccessDialog('Item saved succesfully!');
                                }else{
                                  _showAlertDialog('Item received is not valid');
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                              child: Text('Update', style: TextStyle(color: Colors.white)),
                            ),

                          ],
                        ),
          ],
        ),
    );
  }
}

