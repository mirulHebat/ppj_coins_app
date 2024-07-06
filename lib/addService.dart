import 'dart:math';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ppj_coins_app/PurchaseOrder/poDetailspage.dart';
import 'package:ppj_coins_app/PurchaseOrder/purchaseOrderPage.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'dart:convert';
import 'package:ppj_coins_app/fuelData.dart';
import 'package:ppj_coins_app/list_maintenance.dart';
import 'dart:async';
 
class AddService extends StatefulWidget {
  AddService({Key? key}) : super(key: key);

  @override
  State<AddService> createState() => Servicepage();
}

class Servicepage extends State<AddService> {
  var shouldPop=false;
  var count;
  late PageController controller;
  Color customColor = Color(0xFF1647AF);
    late int _selectedIndex;
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

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
    // Listview();
    
  }

  Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  print('rebuilding');
  return WillPopScope(
    onWillPop: () async {
      return shouldPop;
    },
    child: Scaffold(
      extendBody: true,


            // Future completed, proceed to build UI
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
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
                                            
                                            if(ref.read(poDetArray).isEmpty)
                                            {
                                              Navigator.pop(context);
                                              ref.invalidate(Labor_pricing);
                                              ref.invalidate(Part_pricing);
                                              ref.invalidate(tax_pricing);
                                              ref.invalidate(total_pricing);
                                              ref.invalidate(tax_percent);
                                            }  
                                            else
                                            {
                                              showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Save the Work Order'),
                                                  content: Text('Ensure to save the work order.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop(); // Close the dialog
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            }   
                                          },
                                        ),
                                      ),
                                            Text(
                                              "Add Service Data ", // Replace with your actual title text
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
                    // SizedBox(height: h*0.02,),
                    
                    Expanded(
                      child: PageView(
                        controller: controller,
                        onPageChanged: onPageChanged,
                        children: <Widget>[
                          fieldService()
                          // buildListTiles(itemListWithCount),
                        ],
                      ),
                    )
                  ],
                )
                
              ],
            )
    )
  );
          
  }

}


final Labor_pricing = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: '0.00') ;
});


final Part_pricing = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: '0.00') ;
});

final tax_pricing = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: '0.00') ;
});

final total_pricing = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: '0.00') ;
});

final tax_percent = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: '0.00') ;
});


class fieldService extends ConsumerStatefulWidget{
    @override
  ConsumerState<fieldService> createState() => formServiceState();

}

class formServiceState extends ConsumerState<fieldService>
{

  // TextEditingController Labor_pricing = TextEditingController(text: '0.00');
  // TextEditingController  Part_pricing = TextEditingController(text: '0.00');
  // TextEditingController  tax_percent = TextEditingController();
  // TextEditingController  tax_pricing = TextEditingController(text: '0.00');
  // TextEditingController  total_pricing = TextEditingController(text: '0.00');
  TextEditingController  vehiclefield = TextEditingController();
  TextEditingController  driverfield = TextEditingController();
  TextEditingController completeController = TextEditingController();
  TextEditingController IssuedBy = TextEditingController();
  String vehicleId="";
  String driverId="";
  List<Map<String,dynamic>> IssuedId=[];
  String isIssue="";
  String driver_id="";
  Map<String,dynamic> map_driver={};
  String errorMessage = '';
   List<Widget> separators = [];
   int _lineItemNumber = 0;
  String? selectedFaultCategory;
  String? selectedItem;
  String? fault_id;
  late Future<List<String>> _categoriesFuture;
  List<insertworkline> Insertworkline = [];
  List<TextEditingController> startAtControllers = []; 
  List<TextEditingController> laborControllers = []; 
  List<TextEditingController> partControllers = []; 
  List<TextEditingController> subtotalControllers = []; 
  List<TextEditingController> dueControllers = []; 
  List<TextEditingController> summaryControllers = []; 
  List<String?> selectOrder = []; 
  List<String?> selectResolve = []; 
  List<String?> selectInsp_stat=[]; 
  bool indicator_issu=true;
  bool donepurchase=true;
  final focusNode = FocusNode();

  

  
  // List<TableRow> rows = [];

   

  @override
  void dispose() 
  {
    ref.invalidate(Labor_pricing);
    ref.invalidate(Part_pricing);
    ref.invalidate(tax_pricing);
    ref.invalidate(total_pricing);
    ref.invalidate(tax_percent);

    // Labor_pricing.dispose();
    // Part_pricing.dispose();
    // tax_percent.dispose();
    // tax_pricing.dispose();
    // total_pricing.dispose();
    vehiclefield.dispose();
    driverfield.dispose();
    completeController.dispose();
    super.dispose();
  }

    @override
  void initState() {
    super.initState();
     _categoriesFuture = fetchCategories();
    print('come here');
    print('it happen');
    
  }

   Future<List<String>> fetchCategories() async 
   {
   var fuelFinder = f_Service();
  return await fuelFinder.myAsyncFunction();
  }



  // void _addRow() {
  //   setState(() {
  //     rows.add(
  //       TableRow(
  //         decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
  //         children: 
  //               <Widget>[
  //             WorkOrderPage(), // Custom UI component
  //           ],
  //         //   Padding(
  //         //   padding: const EdgeInsets.all(8.0),
  //         //   child:FutureBuilder<List<String>>(
  //         //     future: _categoriesFuture,
  //         //     builder: (context, snapshot){
  //         // if (snapshot.connectionState == ConnectionState.waiting) {
  //         //   return CircularProgressIndicator(); // Loading indicator
  //         // } else if (snapshot.hasError) {
  //         //   return Text('Error: ${snapshot.error}');
  //         // } else{
  //         //   return DropdownButtonFormField<String>(
  //         //         decoration: InputDecoration(
  //         //           border: OutlineInputBorder(),
  //         //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  //         //         ),
  //         //         value: selectedFaultCategory,
  //         //         items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
  //         //           return DropdownMenuItem<String>(
  //         //             value: value,
  //         //             child: Text(value),
  //         //           );
  //         //         }).toList(),
  //         //         onChanged: (String? newValue) {
  //         //           setState(() {
  //         //             selectedFaultCategory = newValue;
  //         //           });
  //         //         },
  //         //       );
  //         // }  
  //         //     }
  //         // ),
  //         // ),
  //         // Padding(
  //         //   padding: const EdgeInsets.all(8.0),
  //         //   child: DropdownButtonFormField<String>(
  //         //         decoration: InputDecoration(
  //         //           border: OutlineInputBorder(),
  //         //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  //         //         ),
  //         //         value: selectedFaultCategory,
  //         //         items: <String>['Category 1', 'Category 2', 'Category 3']
  //         //             .map<DropdownMenuItem<String>>((String value) {
  //         //           return DropdownMenuItem<String>(
  //         //             value: value,
  //         //             child: Text(value),
  //         //           );
  //         //         }).toList(),
  //         //         onChanged: (String? newValue) {
  //         //           setState(() {
  //         //             selectedFaultCategory = newValue;
  //         //           });
  //         //         },
  //         //       ),
  //         // ),

              
  //       ),
  //     );
  //   });
  
  // }

  Future<void> addWorkOrderLine() async{
  setState(() {
    Insertworkline.add(
      insertworkline(
      due_date:'',
      insp_stats:'',
      work_order_status:'',
      start_at: '',
      labor_wol: '0',
      parts_wol: 0,
      subtotal_wol:0,
      resolving: "",
      drop:true,
      summary:'',
      inspIF_edit_id:"",
      inspII_id:"",
      insp_item:"",
      issue_id:"",
      work_id_item:"",
      data_collect:[

      ],

    ));
  });
}

  Future<void> keepFault_id(String id_fault)async
  {
    fault_id=id_fault;
    print('sini rujuk');
    print(fault_id);
  }

  Future<void> calculate_labor_sub()async
  { double total_labor=0;
    for(var i=0;i<separators.length;i++)
    {
      double nilai_labor=double.parse(Insertworkline[i].labor_wol); 
      total_labor=nilai_labor;
    }

     
    ref.read(Labor_pricing).text=total_labor.toString();
    

  }

  Widget  WorkOrderSeparator(index){
    startAtControllers.add(TextEditingController());
    laborControllers.add(TextEditingController()); // Add controllers
    partControllers.add(TextEditingController());
    subtotalControllers.add(TextEditingController());
    dueControllers.add(TextEditingController());
    summaryControllers.add(TextEditingController());
    selectOrder.add(null);
    selectResolve.add(null);
    selectInsp_stat.add(null);
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);
    selectOrder[index] ="New";
     Insertworkline[index].work_order_status=selectOrder[index];
    if(indicator_issu)
    {
      UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
     String Full_name = userDetails.isNotEmpty ? userDetails[6] : '';
     IssuedBy.text=Full_name.toUpperCase();
    }
    print('issuebt${ IssuedBy.text}');
   String state="enter";
    int tajuk=index+1;
    

         return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  color: Colors.blue[900], // Navy blue color
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        'Work Order Line Item ${tajuk}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        icon: Icon(
                           Insertworkline[index].drop ? Icons.arrow_drop_down : Icons.arrow_right,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if( Insertworkline[index].drop)
                            {
                               Insertworkline[index].drop = false;
                            }
                            else
                            {
                              Insertworkline[index].drop = true;
                            }
                                                               
                          });
                          // Handle the dropdown logic here
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible:Insertworkline[index].drop ,
                  child:Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: IssuedBy,
                        decoration: InputDecoration(
                          labelText: 'Issued By',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () async {
                              indicator_issu=false;
                              String issued = IssuedBy.text.toUpperCase();
                              findListFuel listFuel =findListFuel();
                             List<Map<String,dynamic>> relatedNames = await listFuel.findDriver(issued);
                              print('Related names: $relatedNames');

                              if (relatedNames.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Missing Information'),
                                      content: Text('User not found.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select User'),
                                      content: Container(
                                        width: double.minPositive,
                                        height: 200.0,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: relatedNames.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              title: Text(relatedNames[index]['title']),
                                              onTap: () {
                                                setState(() {
                                                  IssuedBy.text = relatedNames[index]['title'];
                                                  isIssue=relatedNames[index]['vehicleId']?? "";

                                                });
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              };

                            },
                          ),
                        ),
                      ),
                    ),
                              

                    
                  
                    SizedBox(height: 10),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      filled: true,
                      fillColor: Colors.grey[200], // Gray background color
                      hintText: 'Work Order Status', // Placeholder text
                      enabled: false, // Disable interaction
                    ),
                    value: selectOrder[index], // Current value
                    items: <String>['Completed', 'New', 'Terminated', 'Work In Progress']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black), // Set text color to black
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                        setState(() {
                            selectOrder[index] = newValue;
                            Insertworkline[index].work_order_status = newValue;
                        });
                      }, // No onChanged callback since it's disabled
                  )



                  ),


                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                            controller: startAtControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Start At',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                  onPressed: () async{

                                  }
                              ),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            readOnly: true, // Make the field read-only
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                   startAtControllers[index].text = DateFormat('dd/MM/yyyy').format(pickedDate);
                                  Insertworkline[index].start_at = startAtControllers[index].text; // Set the selected date to the text field
                                });
                              }
                            },
                          ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      color: const Color.fromARGB(255, 129, 173, 240), // Navy blue color
                      child: Center(
                        child: Text(
                          'Cost Detail',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                            controller: laborControllers[index],
                            onChanged: (text){ 
                              setState(() {
                                String prev_labor=Insertworkline[index].labor_wol;
                                Insertworkline[index].labor_wol = laborControllers[index].text;
                                String nilai_price_labor=ref.read(Labor_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
                                String nilai_price_sub=ref.read(total_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
                                double partsWol = 0.0; // Set default value for partsWol
                                double labor = 0.0; 
                                double prev_lab=0.0;
                                double nilai_price=double.parse(nilai_price_labor);
                                double nilai_sub=double.parse(nilai_price_sub);
                                if( text!="")  
                                {
                                  labor = double.parse(text);
                                } 
                                if(Insertworkline[index].parts_wol !=null)
                                {
                                  partsWol = Insertworkline[index].parts_wol;
                                } 
                                print('nilai prev: $prev_labor');
                                if(prev_labor !="0")   
                                 { 
                                  double previ=0.0;
                                  if(prev_labor !="")
                                 {
                                   previ=double.parse(prev_labor);
                                 }
                                    print('prev :$previ');
                                   nilai_price=nilai_price - previ;
                                   nilai_sub=nilai_sub-previ;
                                   print('nilai_p :$nilai_price');
                                  
                                 }
                                nilai_price=nilai_price +labor;
                                nilai_sub=nilai_sub+labor;

                                print('nilai $nilai_price');
                                print(' partss::$labor');
                                double total = partsWol + labor;
                                Insertworkline[index].subtotal_wol=total;
                                subtotalControllers[index].text=total.toString();
                                ref.read(Labor_pricing).text=nilai_price.toString();
                                ref.read(total_pricing).text=nilai_sub.toString();
                                print(ref.read(Labor_pricing).text);
                                totalCalc();
                              });

                            },
                            decoration: InputDecoration(
                            labelText: 'Labor Cost (RM)',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: partControllers[index],
                              onChanged: (text){
                                print(partControllers[index].text);
                                print(Insertworkline[index].parts_wol);
                              double prev_part=Insertworkline[index].parts_wol;
                              if(partControllers[index].text !="")
                              {
                                print('masuk');
                                Insertworkline[index].parts_wol =double.parse(partControllers[index].text) ;
                              }
                              else
                              {
                                Insertworkline[index].parts_wol=0.0;
                              }
                              String nilai_price_part=ref.read(Part_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
                              String nilai_price_sub=ref.read(total_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
                              print(nilai_price_part);
                              print(nilai_price_sub);
                              double partsWol=Insertworkline[index].parts_wol;
                              double labor=0.0;
                              double nilai_part=double.parse(nilai_price_part);
                              double nilai_sub=double.parse(nilai_price_sub);
                              if(Insertworkline[index].labor_wol !="")
                              {
                                labor=double.parse(Insertworkline[index].labor_wol);
                              }
                              else
                              {
                                labor=0.0;
                              }
                              print('labor $labor');
                              
                                double previ=prev_part;
                                 nilai_part=nilai_part-previ;
                                 nilai_sub=nilai_sub-previ;
                              
                              nilai_part=nilai_part+partsWol;
                              nilai_sub=nilai_sub+partsWol;
                              print('nilai part $nilai_part');
                              print('nilai sub $nilai_sub');
                              double total=partsWol+labor;
                              Insertworkline[index].subtotal_wol=total;
                              subtotalControllers[index].text=total.toString();
                              ref.read(Part_pricing).text=nilai_part.toString();
                              ref.read(total_pricing).text=nilai_sub.toString();
                              totalCalc();
                              },
                              decoration: InputDecoration(
                                labelText: 'Part Cost (RM)',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: subtotalControllers[index],
                         enabled: false,
                          style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Subtotal (RM)',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      color: const Color.fromARGB(255, 129, 173, 240), // Navy blue color
                      child: Center(
                        child: Text(
                          'Issues/Inspection',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                            ),
                            hint: Text('Resolved'),  
                            value: selectResolve[index],
                            items: <String?>['Yes', 'No']
                                .map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value ?? ''), // Handle null value for the initial message
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectResolve[index] = newValue;
                                Insertworkline[index].resolving=newValue;
                              });
                            },
                          ),

                          ),
                        ),
                        Expanded(
                          child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: dueControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Due Date',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                  onPressed: () async{

                                  }
                              ),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            readOnly: true, // Make the field read-only
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  dueControllers[index].text =  DateFormat('dd/MM/yyyy').format(pickedDate);
                                   Insertworkline[index].due_date= dueControllers[index].text;
                                   // Set the selected date to the text field
                                });
                              }
                            },
                          ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: summaryControllers[index],
                        onChanged: (text){
                        Insertworkline[index].summary = summaryControllers[index].text;
                      },
                        decoration: InputDecoration(
                          labelText: 'Issue Summary ',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        minLines: 3,
                         maxLines: null, // Allow for multi-line input
                         keyboardType: TextInputType.multiline, // Set keyboard type to multiline
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                                  ),
                                  hint: Text('Inspection Status'),   
                                  value: selectInsp_stat[index],
                                  items:  <String>['Failed','In Diagnostic','Passed']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                       selectInsp_stat[index]=newValue;
                                       Insertworkline[index].insp_stats=newValue;
                                    });
                                  },
                                ),
                    ),
                    SizedBox(height: 10),
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
                    Container(
                     child: WorkOrderPage(_categoriesFuture,Insertworkline[index].data_collect,index,state), // Custom UI component
                  ), 

                    ],

                  ),


                ),
                ],
              );     
  }

    Future<Map<String,dynamic>> finddriverVehicleMech(String id_vehicle) async
    { String title="" ;
      String  idContact="";
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
      print(user_session_id);
      print(id_vehicle);
      http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
      '"bims_access_id":"$ifleetData",'+
      '"query":"( container_id = &quot;$id_vehicle&quot;)",'+
      '"action":"ADVANCED_SEARCH",'+
      '"item_type_codes":["va001"],'+
      '"sort_field":"",'+
      '"sort_order":"ASC",'+
      '"details":["item_id","metadata"]'+
      '}');

      Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];
        print(headersModified['cookie']);
      }
      response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);
      if (response.statusCode == 200) {
      // Parse the response body as JSON
      Map<String, dynamic> result = json.decode(response.body);

      // Handle the response data
      if (result['success'] == true) {
      print('checkpoint vehicle id');
      List< dynamic>results = result['results'] ?? [];
      print(result);
      print("nilai result semua");
      for (var item in results){
        Map<String, dynamic> metadata = item['metadata'];
        print(metadata);
        print("nnedwdwd");
        String date_end=metadata['ended_at'] ??"";
        List<String> dateParts = date_end.split('/');
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);
        DateTime date = DateTime(year, month, day);
        DateTime currentDate = DateTime.now();
        print(date);
        print(currentDate);
        if(currentDate.isAfter( date))
        {
          print('no $date_end');
        }
        else
        {
          Map<String,dynamic> contact = metadata['contact_name'];
         if(contact !=null)
         {
          title=metadata['contact_name']['title'];
          idContact=metadata['contact_name']['item_id'];
         }

        }

         
         

      }
        Map <String,dynamic> mapping={
          'titlee':title,
          'Contact':idContact
        };
       return mapping;
      
           
    } else {
        print("failed vehicle id");
        return {};


      }
    } else {
      return {};
      // Handle the case where the request failed
  // Return 0 if request failed
    }

    }

    Future<void> _showLoadingDialogAdd(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

  Future<String> findVehicleMech(String vehicletitle) async {
    print('vehicle Name: $vehicletitle');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
   String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
   print(user_session_id);

  // Check if the userDetails list is not empty and has at least one element


  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"query":"( title = &quot;'+vehicletitle+'&quot; )",'+
    '"action":"ADVANCED_SEARCH",'+
    '"item_type_codes":["va001"],'+
    '"sort_field":"",'+
    '"sort_order":"ASC",'+
    '"details":["item_id","metadata"]'+
  '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);


  if (response.statusCode == 200) {
    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
    print('checkpoint vehicle id');
    List< dynamic>results = result['results'] ?? [];
     String vehicleId ="";
    for (var item in results){
      Map<String, dynamic> metadata = item['metadata'];
      String title = metadata['title'];
     
      if (title == vehicletitle)
      {
        Map<String, dynamic> containerId = metadata['container_id'];
         vehicleId =containerId['item_id'];
         return vehicleId;
        
      }
    }
    return vehicleId;
    
   } else {
       print("failed vehicle id");
      return "";


    }
  } else {
    return "";
    // Handle the case where the request failed
// Return 0 if request failed
  }
}

void totalCalc(){
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);
      double taxRate = 0.00;
      double partPrice = 0.00;
      double taxPrice = 0.00;
      double labCost = 0.00;
      double totaling=0.00;
      double partCost=0.00;
      String cleanPart = ref.read(Part_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
      String cleanLab = ref.read(Labor_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
       partCost =double.parse(cleanPart);
      labCost = double.parse(cleanLab);
      totaling=partCost +labCost;
      // ref.read(Labor_pricing).text = currencyFormat.format(labCost);
      //under
      ref.read(Labor_pricing).text = labCost.toString();
      print( ref.read(Labor_pricing).text);
      if(ref.read(tax_percent).text != ''){
        String cleanTax = ref.read(tax_percent).text.replaceAll(RegExp(r'[^\d.]'), '');
        print(cleanTax);
        taxRate = double.parse(cleanTax)*0.01;
      }
      print( ref.read(poDetArray));
      // if (ref.read(poDetArray).isNotEmpty)
      // {
      //     ref.read(Part_pricing).text = ref.read(poDetArray)[0]['total_amount'];
      //     print(ref.read(Part_pricing).text);
      // }
      if(taxRate != 0){
        // taxPrice = labCost * taxRate;
        taxPrice = totaling * taxRate;
        taxPrice = double.parse(taxPrice.toStringAsFixed(2)); 
      }else{
         String cleanTax2 = ref.read(tax_pricing).text.replaceAll(RegExp(r'[^\d.]'), '');
         taxPrice = double.parse(cleanTax2);
         
      }
      partPrice = double.parse(ref.read(Part_pricing).text);
      // ref.read(Part_pricing).text = currencyFormat.format(partPrice);
      // ref.read(tax_pricing).text = currencyFormat.format(taxPrice);
      //under
      ref.read(Part_pricing).text = partPrice.toString();
      //under
      ref.read(tax_pricing).text = taxPrice.toString();
      double totalPrice = labCost + partPrice + taxPrice;
      // ref.read(total_pricing).text = currencyFormat.format(totalPrice);
      //under
      ref.read(total_pricing).text = totalPrice.toString();
}
    @override
    Widget build(BuildContext context) 
    {
         var w = MediaQuery.of(context).size.width;
        var h = MediaQuery.of(context).size.height;
        final isRowVisiblePO = StateProvider<bool>((ref) {
          return false;
        });
        final isRowVisible = ref.watch(isRowVisiblePO);
        List<dynamic> qq  = [];
        Map<String,dynamic> qqw = {};
        final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM', decimalDigits: 2);
        print(donepurchase);
        
        // if(ref.read(poDetArray).isNotEmpty &&donepurchase){
        //   if(ref.read(Part_pricing).text =="0.00")
        //   {
        //     ref.read(Part_pricing).text = ref.read(poDetArray)[0]['total_amount'];
        //     print('ref.read(part_pricing) ${ref.read(Part_pricing).text} ');
            
        //   }
        //   else
        //   {
        //     String nilaiprev= ref.read(Part_pricing).text;
        //     print('nilai prev $nilaiprev');
        //     double nilaiprevdou=double.parse(nilaiprev);
        //     String totalamountpart=ref.read(poDetArray)[0]['total_amount'];
        //     double nilaitotalamountpart=double.parse(totalamountpart);
        //     double jumlah=nilaiprevdou+nilaitotalamountpart;
        //     print('jumlah $jumlah');
        //     ref.read(Part_pricing).text=jumlah.toString();
        //   }

        //   print('ref.read');
        //   print(ref.read(poDetArray)[0]);
          
        //   // double partPrice = double.parse(ref.read(Part_pricing).text);
        //   // print('betul');
        //   // ref.read(Part_pricing).text = currencyFormat.format(partPrice);
        //   donepurchase=false;
        //   totalCalc();
        // }
    return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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

          Padding(
            padding: EdgeInsets.all(10.0),
          child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding (
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                     controller: vehiclefield,
                     inputFormatters: 
                     [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        UpperCaseTextFormatter(), // Add this formatter
                      ],
                    decoration: InputDecoration(
                      labelText: 'Num Plate',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                           String vehicletext = vehiclefield.text;
                          vehicleId = await findVehicleMech(vehicletext) ?? ''; 
                           map_driver=await finddriverVehicleMech(vehicleId) ?? {};
                           driver_id=map_driver['Contact'];
                          driverfield.text= map_driver['titlee']; 
                          print('nilai  dilihat $driver_id');
                         
                          if(vehicleId.isEmpty )
                          {
                            showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Missing Information'),
                                content: Text('Num plate not found.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // vehiclefield.clear(); // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return; 
                          }else
                          {
                             showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Successful'),
                                content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Number plate found.'),
                                  SizedBox(height: 8.0), // Add some space between the lines if needed
                                  Text('Please proceed to insert Service Information'),
                                ],
                              ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;

                          }
                          
                        },
                      ),
                    ),
                  ),

                  ),
                  
                  SizedBox(width: 2),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                     controller: driverfield,
                     readOnly:false,
                    decoration: InputDecoration(
                      labelText: 'Driver',
                       filled: true,
                       fillColor: Colors.grey[300], 
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  TextField(
                controller: completeController,
                decoration: InputDecoration(
                  labelText: 'Completed At',
                  border: OutlineInputBorder(),
                   suffixIcon: IconButton(
                     icon: Icon(Icons.calendar_today),
                      onPressed: () async{

                      }
                   ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                readOnly: true, // Make the field read-only
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      completeController.text = DateFormat('dd/MM/yyyy').format(pickedDate); // Set the selected date to the text field
                    });
                  }
                },
              ),
                ),
                ],
              ),
            ),
          ],
        ),
              
          ),

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
      
          Row(
            children: [
              Expanded(

                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                     controller: ref.read(Labor_pricing),
                    enabled: false,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Labor Subtotal (RM)',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200], // Set background color to gray
                      filled: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 1),
             Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    var poDet=ref.watch(poDetArray);
                    print('nilai podet');
                    print(poDet);
                    // if(poDet.isNotEmpty){
                    //   if(ref.read(Part_pricing).text =="0.00")
                    //   {
                    //     //under
                    //     // ref.read(Part_pricing).text = ref.read(poDetArray)[0]['total_amount'];
                    //     print('ref.read(part_pricing) ${ref.read(Part_pricing).text} ');
                        
                    //   }
                    //   else   
                    //   {
                    //     String nilaiprev= ref.read(Part_pricing).text;
                    //     print('nilai prev $nilaiprev');
                    //     double nilaiprevdou=double.parse(nilaiprev);
                    //     String totalamountpart=ref.read(poDetArray)[0]['total_amount'];
                    //     double nilaitotalamountpart=double.parse(totalamountpart);
                    //     double jumlah=nilaiprevdou+nilaitotalamountpart;
                    //     print('jumlah $jumlah');
                    //     ref.read(Part_pricing).text=jumlah.toString();
                    //     totalCalc();
                    //   }
                    //   donepurchase=false;
                    //   //  totalCalc();
                    // }
                    // Access provider values here
                    

                    // You can use the partPricing variable in the TextField or any other widget
                    return TextField(
                      controller: ref.read(Part_pricing),
                      enabled: false,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Part Subtotal  (RM)',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey[200], // Set background color to gray
                        filled: true,
                      ),
                    );
                   
                  },
                ),
              ),
            ),

            ],
          ),
           Row(
            children: [
              Expanded(

                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                     controller: ref.read(tax_percent),
                     onChanged: (value){
                      double tax_perct=double.tryParse(value)?? 0.0;
                      double labor=double.tryParse(ref.read(Labor_pricing).text)??0.0;
                      double part=double.tryParse(ref.read(Part_pricing).text)??0.0;
                      double total =labor+part;
                      double new_total=(((100+tax_perct)/100)*total);
                      double subtax =new_total- total;
                      ref.read(tax_pricing).text=subtax.toStringAsFixed(2);
                      ref.read(total_pricing).text=new_total.toStringAsFixed(2);
                       totalCalc();
                        
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Tax Percentage (%)',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,// Set background color to gray
                      filled: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: ref.read(tax_pricing),
                    enabled: false,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Tax Subotal (RM)',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[200], // Set background color to gray
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
         Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
             controller: ref.read(total_pricing),
            enabled: false, // Disable the TextField
            style: TextStyle(color: Colors.black), // Set text color to gray
            decoration: InputDecoration(
              labelText: 'Total Amount (RM)',
              labelStyle: TextStyle(color: Colors.black), // Set label color to black
              border: OutlineInputBorder(),
              fillColor: Colors.grey[200], // Set background color to gray
              filled: true,
            ),
          ),
        ),
          Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          color: Color.fromARGB(255, 145, 203, 250),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Work Order',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.blue[900], // Navy blue background
                  //   shape: BoxShape.rectangle, // Ensuring the shape is a rectangle (box)
                  //   borderRadius: BorderRadius.circular(8.0), // Optional: Add some border radius if you want rounded corners
                  // ),
                  padding: EdgeInsets.all(8.0), // Padding inside the container
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white, // White icon
                      size: 32.0, // Larger font size
                    ),
                    onPressed: () async {
                      await addWorkOrderLine();
                      setState(() {
                        print('numberline');
                        print(_lineItemNumber);
                        print('Insertworkline lgth');
                        print(Insertworkline.length);
                        Insertworkline[_lineItemNumber].data_collect.add([
                          '', //GC
                          <Map<String, dynamic>>[], //list 
                          {
                            "list_of_item_id": "", 
                            "display": "", 
                            "code": "", 
                            "value": "", 
                            "ref_code": ""
                          } //data FI
                        ]);
                        print(Insertworkline[_lineItemNumber]);
                        separators.add(WorkOrderSeparator(_lineItemNumber++));
                      });
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
          Visibility(
            visible: separators.length > 0,
            child:SizedBox (
              height: 500,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: separators.length,
                itemBuilder: (context, index) {
                  return WorkOrderSeparator(index);
                },
              ),
            ),
          ),

          Column(
            children: [
              Container(
              width: MediaQuery.of(context).size.width,
              // height: 60.0,
              color: Color.fromARGB(255, 145, 203, 250),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                         IconButton(
                            icon: Icon(
                              Icons.book,
                              color: Colors.red, // White icon
                              size: 32.0, // Larger font size
                            ),
                            onPressed: () {
                              print(ref.read(poDetArray));
                              qq = ref.read(poDetArray);
                              debugPrint(qq.toString());
                              for (var item in qq){
                                qqw.addAll(item);
                              }
                              print(qqw);
                              print(qqw['status_display'] );
                            },
                          ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Purchase Order',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: true,
                            child: ref.read(poDetArray).isNotEmpty ?
                            IconButton(
                              icon: Icon(
                                ref.watch(isRowVisiblePO) ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right_outlined,
                                color: Colors.white, // White icon
                                size: 32.0, // Larger font size
                              ),
                              onPressed: () {
                                print('here is for PO');
                                print(ref.read(isRowVisiblePO));
                                qq = ref.read(poDetArray);
                                // log(qq[0]);
                                for (var item in qq){
                                  qqw.addAll(item);
                                }
                                setState(() {
                                  final isVisible = ref.read(isRowVisiblePO.notifier).state;
                                  ref.read(isRowVisiblePO.notifier).state = !isVisible;
                                });
                                print('anjing');
                                print(ref.read(isRowVisiblePO));
                                
                              },
                            ) :
                             IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white, // White icon
                                size: 32.0, // Larger font size
                              ),
                              onPressed: () {
                                print('here is for PO');
                                print(vehicleId);
                                print(vehiclefield.text);
                                if(vehiclefield.text != ''){
                                  ref.invalidate(poList);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderPage(title: vehiclefield.text, id: vehicleId,)));
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error!'),
                                        content: Text('Please Enter Number Plate first!'),
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
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Consumer(builder: (context, ref, child) {
                    var pdtArr = ref.watch(poDetArray);
                    print('pdtArr');
                    print(pdtArr);
                    
                    return Visibility(
                      visible:pdtArr.isNotEmpty ? true:false,
                      child: Visibility(
                        visible: true,
                        child: Table(
                          border: TableBorder.all(), // Adds border to the table
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context) => purchaseOrderDetailPage(title: ref.read(poDetArray)[0]['title'], id: ref.read(poDetArray)[0]['item_id'],),),);
                                                          
                                        },
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(vehiclefield.text),
                                                

                                                if(ref.read(poDetArray).isNotEmpty)...[
                                                  Text(ref.read(poDetArray)[0]['title'] ),
                                                  Text(ref.read(poDetArray)[0]['status_display']),
                                                  Text(ref.read(poDetArray)[0]['registered_date']),
                                                ]
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.red, 
                                                    size: 32.0, 
                                                  ),
                                                  onPressed: () {
                                                    print(ref.read(poDetArray));
                                                    Navigator.push(context,MaterialPageRoute(builder: (context) => purchaseOrderDetailPage(title: ref.read(poDetArray)[0]['title'], id: ref.read(poDetArray)[0]['item_id'],),),);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
                  ],
                ),
              ),
                          ),
          
            
            ],
          ),
        

          SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: ()async {
               _showLoadingDialogAdd(context);
              print('fuycdcw $driver_id');
              List list_faulty=ref.read(listfault);
              print(list_faulty);
              String inspectionItem="";
              String inspectionform="";
              String inspectionSubmit="";
              String resultIssue="";
              String resultWorkLine="";
              List <String> workLineList=[];
              List <String> issueList=[];
              for(var y=0;y<Insertworkline.length;y++)
              {

                List fault_id=[];

              if(isIssue =="")
              {
                 findListFuel listFuel =findListFuel();
                 List<Map<String,dynamic>> relatedNames = await listFuel.findDriver(IssuedBy.text.toUpperCase());
                 for(var i=0;i<relatedNames.length;i++)
                 {
                  isIssue=relatedNames[i]['vehicleId']?? "";
                 }

              }

                for(var i=0;i<Insertworkline[y].data_collect.length;i++)
                { 
                  
                  String faulty =await faultCreation(). createFaults(vehiclefield.text,Insertworkline[y].data_collect[i][0],Insertworkline[y].data_collect[i][2],ref,"");
                  fault_id.add(faulty);

                }
                                                                  
                   inspectionItem=await inspectCreation().createInspect(Insertworkline[y].insp_stats,fault_id,vehiclefield.text,"");
                   inspectionform=await inspectCreation().createIns_form(inspectionItem,fault_id,vehiclefield.text,isIssue,vehicleId,"");
                   inspectionSubmit=await inspectCreation().createIns_Submit(inspectionform,vehiclefield.text,"");
                   resultIssue=await faultCreation(). createIssues(Insertworkline[y].resolving,Insertworkline[y].due_date,inspectionSubmit,fault_id,vehiclefield.text,isIssue,Insertworkline[y].start_at,Insertworkline[y].summary,"");
                   resultWorkLine=await f_Service(). createWorkLine(Insertworkline[y].start_at,Insertworkline[y].labor_wol,Insertworkline[y].parts_wol,Insertworkline[y].subtotal_wol,resultIssue,vehiclefield.text,Insertworkline[y].work_order_status,"");
                   workLineList.add(resultWorkLine);
                   issueList.add(resultIssue);
              }
                String resultWorkOrder="";
               
                if (ref.read(poDetArray).isNotEmpty)
                {
                     resultWorkOrder=await f_Service(). createWorkOrder("",ref.read(Labor_pricing).text,ref.read(Part_pricing).text,ref.read(tax_percent).text,ref.read(tax_pricing).text,ref.read(total_pricing).text,workLineList,vehiclefield.text,isIssue,driver_id,completeController.text,"",ref.read(poDetArray)[0]['title'], ref.read(poDetArray)[0]['item_id']);

                }
                else
                {
                  resultWorkOrder=await f_Service(). createWorkOrder("",ref.read(Labor_pricing).text,ref.read(Part_pricing).text,ref.read(tax_percent).text,ref.read(tax_pricing).text,ref.read(total_pricing).text,workLineList,vehiclefield.text,isIssue,driver_id,completeController.text,"","", "");

                }
                
                String resultService=await f_Service(). createService(vehicleId,driver_id,completeController.text,issueList,resultWorkOrder,inspectionform,vehiclefield.text,ref.read(Labor_pricing).text,ref.read(Part_pricing).text,ref.read(tax_percent).text,ref.read(tax_pricing).text,ref.read(total_pricing).text,"");
                Navigator.pop(context);
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderMaintenance(),
                    ),
                  );
                 
               
            },
            child: Text('Save'),
              style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
            ),
          ),
        ],
      ),
    ),
  );

    }

}

class WorkOrderPage extends ConsumerStatefulWidget  {
  final Future<List<String>> categoriesFuture;
  final List<dynamic> insertwork;
  final int indx;
  final String state;
  WorkOrderPage(this.categoriesFuture,this.insertwork,this.indx,this.state);
  @override
  ConsumerState<WorkOrderPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<WorkOrderPage> {
 String ? selectedFaultCategory  ; 
    String? selectedFaultItem;
   Future<List<String>>? _Fault_item_list;
   List<TableRow> rows = [];

      @override
  void initState() {
    super.initState();
     //_categoriesFuture =formService().fetchCategories();
    print('come here');
  
    // Add the initial header row

  }

    List<dynamic> data = [];

    List<List<dynamic>> collect_data = [];

    Future<List<Map<String,dynamic>>> fetchItem(String? category) async
    {
    var fuelFinder = faultCreation();
    return await fuelFinder.listing_fault(category);

    }


Future<Map<String, dynamic>?> _showItemSelectionDialog(List<Map<String,dynamic>> items, Map<String,dynamic> data) async {
  return showDialog<Map<String, dynamic>>( // Change return type to Map
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Item'),
        content: SingleChildScrollView(
          child: ListBody(
            children: items.map((item) {
              bool isSelected = item['value'] == data['value']; 
              String decodedDisplayValue = Uri.decodeComponent(item['display_value'] ?? '');// Compare values
              return ListTile(
                tileColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
                title: SizedBox(
                  width: 100, // Limit the width to control overflow
                  child: Text(
                    decodedDisplayValue, // Display "display_value"
                    overflow: TextOverflow.visible, // This will make overflowing text disappear
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(item); // Pop with selected item
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

Future<String?> _showCategorySelectionDialog(List<String> items,int index) async {
  // Define a variable to store the selected item
  String? selectedItem;

  // Show the dialog and await the user's selection
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Item'),
        content: SingleChildScrollView(
          child: ListBody(
            children: items.map((item) {
              String decodedDisplayValue = Uri.decodeComponent(item);
              return ListTile(
                title: SizedBox(
                  width: 100,
                  child: Text(
                    decodedDisplayValue,
                    overflow: TextOverflow.visible,
                  ),
                ),
                onTap: () {
                  // Set the selected item
                 
                  selectedItem=item;
                  
                  Navigator.of(context).pop(selectedItem);
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );

  // Return the selected item
  return selectedItem;
}





  @override
  Widget build(BuildContext context) {
    print('nilai indx${widget.indx}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[900], // Navy blue background
                shape: BoxShape.rectangle, // Ensuring the shape is a rectangle (box)
                borderRadius: BorderRadius.circular(8.0), // Optional: Add some border radius if you want rounded corners
              ),
              padding: EdgeInsets.all(3.0), // Padding inside the container
              child: Center( // Center the IconButton within the container
                child: IconButton(
                  padding: EdgeInsets.zero, // Remove default padding of IconButton
                  icon: Icon(
                    Icons.add,
                    color: Colors.white, // White icon
                    size: 25.0, // Larger font size
                  ),
                  onPressed: () {
                    setState(() {
                      widget.insertwork.add([
                        '', // GC
                        <Map<String, dynamic>>[], // list
                        {
                          "list_of_item_id": "",
                          "display": "",
                          "code": "",
                          "value": "",
                          "ref_code": ""
                        },
                        "",
                         // data FI
                      ]);
                      print(widget.insertwork);
                    });
                  },
                ),
              ),
            ),
             SizedBox(width: 10),
          ],
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
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

              ...List.generate(   widget.insertwork.length, (index) {
                print('nilai ${widget.insertwork.length}');
                String displayValue="";

                  // if (widget.state == "edit") {
                    displayValue = Uri.decodeQueryComponent(widget.insertwork[index][2]['display'] ?? "");
                    if (displayValue.isEmpty) {
                      displayValue = Uri.decodeQueryComponent(widget.insertwork[index][2]['display_value'] ?? "");
                    }
                  // } 
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
                        '${index + 1} .',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          // Add more text styles as needed
                        ),
                      ),
                    ),
                    Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 4.0), 
                    child: FutureBuilder<List<String>>(
                      future: widget.categoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return GestureDetector(
                          onTap: () async {
                            String? selectedItem = await _showCategorySelectionDialog(snapshot.data!,index);
                            if (selectedItem != null) {
                              setState(() {
                                widget.insertwork[index][0] = selectedItem;
                              });

                              widget.insertwork[index][1] = await fetchItem(selectedItem);
                            }
                          },
                          child: AbsorbPointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0), // Optional: For rounded corners
                              ),
                              padding: const EdgeInsets.all(8.0), // Padding inside the border
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Center the Row content
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.insertwork[index][0],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down, // Drop-down icon
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                        }
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 4.0),
                    child: widget.insertwork[index][0] == 'null'
                        ? Container()
                        : GestureDetector(
                          onTap: () async {
                            Map<String, dynamic>? selectedItem = await _showItemSelectionDialog(widget.insertwork[index][1], widget.insertwork[index][2]);
                            if (selectedItem != null) {
                              setState(() {
                                widget.insertwork[index][2] = selectedItem;
                                // if (widget.state == "edit") {
                                  displayValue = Uri.decodeQueryComponent(widget.insertwork[index][2]['display_value'] ?? "");
                                  // displayValue = Uri.decodeQueryComponent(widget.insertwork[index][2]['display'] ?? "");
                                  print('nilai display $displayValue');
                                  if (displayValue=="") {
                                    displayValue = Uri.decodeQueryComponent(widget.insertwork[index][2]['display_value'] ?? "");
                                    print('nilai display $displayValue');
                                  }
                                // } 
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0), // Optional: For rounded corners
                              ),
                              padding: const EdgeInsets.all(8.0), // Padding inside the border
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Center the Row content
                                children: [
                                  Expanded(
                                    child: Text(
                                     displayValue ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down, // Drop-down icon
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                  ),

                    
                  ],
                  
                );
              }),
             

            ],
          ),


          ),
        ),
      ],
    );
  }
}




class f_Service  
{
 Future<List<String>>  myAsyncFunction() async
 {
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

     http.Response response;
     var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"list_of_value_id":"lval-9eec1aa052ea4f82af796309e44af512",'+
    '"action":"LIST_VALUE_ITEMS_ACTIVE",'+
    '"details":["code","value","display_value","ref_code"]'+
  '}');

     Map<String, String> headersModified = {};
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];

    }

     response = await http.get(Uri.parse('https://lawanow.com//bims-web/ListOfValue?param=$usell'), headers: headersModified);

      if (response.statusCode == 200){
         Map<String, dynamic> results = json.decode(response.body);
         List<String> categories = [];
         print('hasil list');
         print(results);
         var result =results['results'];
          for (var item in result) {
          categories.add(item['value']);
        }

         return categories;
      }
      else
      {
        print('unsuccssful');
        throw Exception('Failed to fetch categories');
      }

   

 }

 

  Future<String> createWorkLine(String? startAt,String? labor,double part,double sub,String? id_issue,String? work_title,String? status,String work_id)async
 { 
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'WOL $work_title $currentDate';
   UserDetail userDetail = UserDetail();
   List<String> userDetails = userDetail.getUserDetails();
   String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
   String code="";
   String value="";
   String POid = "";
   String POTitle = "";
   print('status');
   print(status);
   print(startAt);
   print(labor);
   print(part);
   print(sub);
   print(id_issue);
   print(work_title);
   if(status =="Completed")
   {
    code="01";
    value="WOS01";
   }
   else if(status =="Work in Progress")
   {
    code="02";
    value="WOS02";

   }
   else if(status =="New")
   {
    code="03";
    value="WOS03";

   }
   else
   {
    code="04";
    value="WOS04";

   }


    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
'    "metadata":{"item_type_id":"ityp-b9308defe8e64ef3939013fb059fb7f5","item_id":"$work_id","item_number":"","title":"$selectedValueWithDate","notes":"","labor_time":0,"started_at":"$startAt","work_order_status":{"code":"$code","value":"$value","display":"$status"},"labor_cost":$labor,"parts_cost":$part,"subtotal":$sub,"issues":[{"item_type_id":"ityp-b54379e2a45c42c1818576551720422f","item_id":"$id_issue","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","reported_at":"","is_resolved":"","reported_by":""}]}'+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      return "";
    }

 }

 Future<String> createWorkOrder(String? startAt,String? labor_price,String? part_price,String? tax_percent,String? tax_pricing,String? total_pricing,List<String> id_workLine,String? Order_title,String? issue_id,String? driver_id,String? complete ,String work_order_id, String POTitle, String POid)async
 { 
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'WO $Order_title $currentDate';
   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String valuequer = "";  // Initialize an empty string
  List<String> jsonStrings = [];
  String poType = 'ityp-c14e446065e443ecb57b96519322480e';
  if(tax_percent != null){
    tax_percent = tax_percent;
  }else{
    tax_percent = '0';
  }
  if(labor_price != null){
    labor_price  = labor_price.replaceAll(RegExp(r'[^\d.]'), '');
  }
  if(part_price != null){
    part_price = part_price.replaceAll(RegExp(r'[^\d.]'), '');
  }
  if(tax_pricing != null){
    tax_pricing = tax_pricing.replaceAll(RegExp(r'[^\d.]'), '');
  }
  if(total_pricing != null){
    total_pricing = total_pricing.replaceAll(RegExp(r'[^\d.]'), '');
  }
  print(POTitle);
  print(POid);
  print(labor_price);
  print(part_price);
  print(tax_pricing);
  for(var y=0;y<id_workLine.length;y++)
  {
    String jsonString = '{"item_type_id":"ityp-b9308defe8e64ef3939013fb059fb7f5","item_id":"${id_workLine[y]}","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","started_at":"","work_order_status":"","subtotal":""}';
    jsonStrings.add(jsonString);
  }
  valuequer = jsonStrings.join(',');
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-7fd81cb7d5b94374acb37a6ce23f3b41","item_id":"$work_order_id","item_number":"","title":"$selectedValueWithDate","notes":"","issued_by_id":"$issue_id","item_type_id_issued_by_id":"",'+
    '"disp_issued_by_id":"","work_order_status":{"code":"03","value":"WOS03","display":"New"},"started_at":"$startAt","completed_at":"$complete","contact_name":"$driver_id","item_type_id_contact_name":"","disp_contact_name":"","duration_in_hrs":0,"vehicle_id":"","item_type_id_vehicle_id":"","disp_vehicle_id":"",'+
    '"ending_meter_same_as_start":{"code":"true","value":"true","display":"Yes"},"labor_subtotal":$labor_price,"purchase_order_number":"$POid","item_type_id_purchase_order_number":"$poType","disp_purchase_order_number":"$POTitle","discount":$tax_percent,"parts_subtotal":$part_price,"tax_subtotal":$tax_pricing,"total_amount":$total_pricing,"invoice_number":"","work_order_line_items":[$valuequer]}'+

  '}');
  print('here is debug');
  debugPrint(usell.toString());


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      return "";
    }

 }

  Future<String> createWorkOrderEdit(String? startAt,String? labor_price,String? part_price,String? tax_percent,String? tax_pricing,String? total_pricing,List<String> id_workLine,String? Order_title,String? issue_id,String? driver_id,String? complete ,String work_order_id)async
 { 
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'WO $Order_title $currentDate';
   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String valuequer = "";  // Initialize an empty string
  List<String> jsonStrings = [];
  for(var y=0;y<id_workLine.length;y++)
  {
    String jsonString = '{"item_type_id":"ityp-b9308defe8e64ef3939013fb059fb7f5","item_id":"${id_workLine[y]}","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","started_at":"","work_order_status":"","subtotal":""}';
    jsonStrings.add(jsonString);
  }
  valuequer = jsonStrings.join(',');
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-7fd81cb7d5b94374acb37a6ce23f3b41","item_id":"$work_order_id","item_number":"","title":"$selectedValueWithDate","notes":"","issued_by_id":"$issue_id","item_type_id_issued_by_id":"",'+
    '"disp_issued_by_id":"","started_at":"$startAt","completed_at":"$complete","contact_name":"$driver_id","item_type_id_contact_name":"","disp_contact_name":"","duration_in_hrs":0,"vehicle_id":"","item_type_id_vehicle_id":"","disp_vehicle_id":"",'+
    '"ending_meter_same_as_start":{"code":"true","value":"true","display":"Yes"},"labor_subtotal":$labor_price,"parts_subtotal":$part_price,"tax_subtotal":$tax_pricing,"total_amount":$total_pricing,"invoice_number":"","work_order_line_items":[$valuequer]}'+

  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      return "";
    }

 }


  Future<String>  updateWorkOrder(String? work_id,String? status)async
 { 
   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String code="";
  String value="";


    if(status =="Completed")
   {
    code="01";
    value="WOS01";
   }
   else if(status =="Work in Progress")
   {
    code="02";
    value="WOS02";

   }
   else if(status =="New")
   {
    code="03";
    value="WOS03";

   }
   else
   {
    code="04";
    value="WOS04";

   }
  
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-7fd81cb7d5b94374acb37a6ce23f3b41","item_id":"$work_id","work_order_status":{"code":"$code","value":"$value","display":"$status"}}'+


  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      print('bfgdggdr');
      return "";
    }

 }

 Future<bool> WorkValidate(String? itemId) async {
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  bool nilai=true;
  http.Response response;

  var usell = Uri.encodeQueryComponent('{' +
      '"bims_access_id":"$ifleetData",' +
      '"action":"ITEM_DETAIL",' +
      '"item_id":"$itemId",' +
      '"item_type_id":"ityp-7fd81cb7d5b94374acb37a6ce23f3b41",' +
      '"details":["item_id","item_number","item_type_id","content_id","checkout_ind","checkout_id","checkin_ind","access_control","metadata"]' +
      '}');

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param=$usell'), headers: headersModified);

  if (response.statusCode == 200) {
 
    Map<String, dynamic> result = json.decode(response.body);
    print('nilai maintenance');
    print(result);

      if (result['success'] == true) {
    List<dynamic> results = result['results'];
    for (var itemData in results) {
      Map<String, dynamic>? user_data = itemData['metadata'];
      if (user_data != null) {
        print(user_data);
        List<dynamic>? workOrderLineItems = user_data['work_order_line_items'];
        if (workOrderLineItems != null) {
          // Iterate through each work order line item
          for (var item in workOrderLineItems) {
            if (item is Map<String, dynamic>) {
              // Retrieve the work_order_status from the item
              Map<String, dynamic>? workOrderStatus = item['work_order_status'];
              if (workOrderStatus != null) {
                // Retrieve the display value from the work_order_status
                String? displayValue = workOrderStatus['display'];
                if (displayValue != null) {
                  print('Display value: $displayValue');
                if (displayValue != 'Completed' && displayValue != 'Terminated') {
                    print('Status is neither Completed nor Terminated');
                    return false;
                  }
                }
              }
            }
          }
        }
      }
    }
    return nilai;
  }else {
      return nilai;
    }
  } else {
    return nilai;
  }
}


  Future<String> createService(String? vehiclefield,String? driverfield,String? completeController,List<String> resultIssue,String? resultWorkLine,String?inspectionform,String? service_title,String? labor,String? part,String? tax_percent,String? tax_price,String? total,String service_id)async
 { 
   print('total');
    print(total);
    print(service_id);



   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'SV $service_title $currentDate';
   UserDetail userDetail = UserDetail();
   List<String> userDetails = userDetail.getUserDetails();
   String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
   String nilaiIss="";
   List<String> jsonStrings = [];
     if(labor != null){
    labor  = labor.replaceAll(RegExp(r'[^\d.]'), '');
  }
  if(part != null){
    part = part.replaceAll(RegExp(r'[^\d.]'), '');
  }
  if(tax_price != null){
    tax_price = tax_price.replaceAll(RegExp(r'[^\d.]'), '');
  }
  if(total != null){
    total = total.replaceAll(RegExp(r'[^\d.]'), '');
  }
  print(labor);
  print(part);
  print(tax_price);
  for(var y=0;y<resultIssue.length;y++)
  {
    String jsonString = '{"item_type_id":"ityp-b54379e2a45c42c1818576551720422f","item_id":"${resultIssue[y]}","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","reported_at":"","is_resolved":"Yes","reported_by":""}';
    jsonStrings.add(jsonString);
  }

  nilaiIss = jsonStrings.join(',');
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-c4a658cde9394eb5a03e599702e9a351","item_id":"$service_id","item_number":"","title":"$selectedValueWithDate","completed_at":"$completeController","vehicle_id":"$vehiclefield","item_type_id_vehicle_id":"",'+
    '"disp_vehicle_id":"","driver_id":"$driverfield","item_type_id_driver_id":"","disp_driver_id":"","inspection_form":"$inspectionform",'+
    '"item_type_id_inspection_form":"","disp_inspection_form":"","read_ind":{"code":"false","value":"false","display":"No"},"labor_subtotal":$labor,"parts_subtotal":$part,"tax_percentage":$tax_percent,"tax_subtotal":$tax_price,"total_amount":$total,"issues":[$nilaiIss],'+
    '"linked_work_orders":[{"item_type_id":"ityp-7fd81cb7d5b94374acb37a6ce23f3b41",'+
    '"item_id":"$resultWorkLine","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","started_at":"","total_amount":"0.00","work_order_status":"New","completed_at":""}]}'+

  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           return "";
        }
      

    }
    else
    {
      return "";
    }

 }
}

class insertworkline {
   String labor_wol;
   double parts_wol;
   double subtotal_wol;
   String start_at;
   String? resolving;
   String due_date;
   String? work_order_status;
   String? insp_stats;
   bool drop;
   String summary;
   List<dynamic> data_collect;
   String inspIF_edit_id;
   String inspII_id;
   String insp_item;
   String issue_id;
   String work_id_item;

   insertworkline({required this.labor_wol,required this.parts_wol,required this.subtotal_wol,required this.start_at,required this.work_order_status,required this.resolving,required this.drop,required this.due_date,required this.insp_stats,required this.summary,required this.data_collect,required this.inspIF_edit_id,required this.inspII_id,required this.insp_item,required this.issue_id,required this.work_id_item});   

}

class faultCreation{
   Future<List<Map<String,dynamic>>>  listing_fault(String? categories) async
 {  print('data list');
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

     http.Response response;
     var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"list_of_value_id":"lval-bb8524f089084a03859520e38aee6d8f",'+
    '"action":"LIST_VALUE_ITEMS_FILTER_REFCODE",'+
    '"ref_code":"$categories",'+
    '"details":["code","value","display_value","ref_code"]'+
  '}');

     Map<String, String> headersModified = {};
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];

    }

     response = await http.get(Uri.parse('https://lawanow.com//bims-web/ListOfValue?param=$usell'), headers: headersModified);

      if (response.statusCode == 200){
         Map<String, dynamic> results = json.decode(response.body);
         print('result $results');
         List<Map<String,dynamic>> item_faulty = [];
         var result =results['results'];
          for (var item in result) {
          Map<String,dynamic> displayValue = item;
          item_faulty.add(displayValue);
        }
        return item_faulty;
         
      }
      else
      {
        print('unsuccssful');
        throw Exception('Failed to fetch categories');
      }

   

 }

 Future<String> createFaults (String title,String? category,Map <String,dynamic> cate_item , WidgetRef ref,String fault_id)async
 {
   print("cate_item");
   print(cate_item);
   print(category);
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'FT $title $currentDate';
   UserDetail userDetail = UserDetail();
   List<String> userDetails = userDetail.getUserDetails();
   String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-92b0896128b4486a8843960a230e9096","item_id":"$fault_id","title":"'+selectedValueWithDate+'","start_occured_at":"","last_occurred_at":"","notes":"","fault_category":{"code":"$category","value":"$category","display":"$category"},"fault_items":[{"code":"${cate_item['code']}","value":"${cate_item['value']}","display":"${cate_item['display_value']}"}]}'+
  '}');

 print(usell);
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          // await formService().keepFault_id(result['item_id']);
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      print('no save');
      return "";
      
    }

 }

  Future<String> createIssues (String? hasResolve,String dueDate,String submit_form,List fault,String? issue_title,String? issued_id,String? startAt,String? summary,String status)async
 { bool resolve=true;
  if(hasResolve =="No")
  {
    resolve =false;
  }
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'ISU $issue_title $currentDate';
   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

   List faulty_yy=[];

   for (String faul in fault) {
      String adding_fault='{"item_type_id":"ityp-92b0896128b4486a8843960a230e9096","item_id":"$faul","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","start_occured_at":"","fault_category":"","fault_items":[]}';
      faulty_yy.add(adding_fault);

   
  }
  String combinedString = faulty_yy.join(',');
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-b54379e2a45c42c1818576551720422f","item_id":"$status","title":"'+selectedValueWithDate+'","Summary":"$summary","notes":"","is_resolved":{"code":"$resolve","value":"$resolve","display":"$hasResolve"},"reported_at":"$startAt","reported_by":"$issued_id","item_type_id_reported_by":"","disp_reported_by":"","due_meter_value":0,"due_soon_at":"$dueDate","submitted_inspection_form_id":"$submit_form","item_type_id_submitted_inspection_form_id":"ityp-9a8b8e484a2d4527873924bcf95f62cc","disp_submitted_inspection_form_id":"","fault_object":[$combinedString]}'+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      return "";
    }

 }
}

class inspectCreation{
  Future<String> createInspect (String? status,List fault,String? fault_title,String insp_edit_id)async
 { print('insp_edit_id $insp_edit_id');
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'ISP $fault_title $currentDate';
   String code="";
   String value="";
   if(status =="Passed")
   {
    code="01";
    value="IS01";

   }
   else if(status =="Failed")
   { 
    code="02";
    value="IS02";

   }
   else
   {
    code="03";
    value="IS03";
   }


   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

   
   List faulty_yy=[];

    for (String faul in fault) {
      String adding_fault='{"item_type_id":"ityp-92b0896128b4486a8843960a230e9096","item_id":"$faul","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","start_occured_at":"","fault_category":"","fault_items":[],"last_occurred_at":""}';
      faulty_yy.add(adding_fault);

   
  }
  String combinedString = faulty_yy.join(',');
  print(combinedString);
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-f345ae8638284fcb8c0daace82fbb894","item_id":"$insp_edit_id","item_number":"","title":"abc1234","inspection_status":{"code":"$code","value":"$value","display":"$status"},"notes":"","fault_object":[$combinedString]}'+
  '}');
  print('usell');
  print(usell);


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      print('failed');
      return "";
    }

 }

    Future<String> createIns_form(String? id_ins_item,List fault,String? insp_title,String? issue_id,String? vehicle_id,String insp_id)async
 { 
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'ISP_FORM $insp_title $currentDate';
   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

   List faulty_yy=[];

   for (String faul in fault) {
      String adding_fault='{"title":"","item_id":"$faul","fault_items":[],"item_number":"","item_type_id":"ityp-92b0896128b4486a8843960a230e9096","fault_category":{"code":"","value":"","display":""},"item_type_code":"","last_occurred_at":null,"start_occured_at":null}';
      faulty_yy.add(adding_fault);

   
  }
  String combinedString = faulty_yy.join(',');

    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-fea3de650d1b46a7808608ed0c003d62","item_id":"$insp_id","item_number":"","title":"$selectedValueWithDate","notes":"","contact_name":"$issue_id","item_type_id_contact_name":"","disp_contact_name":"","vehicle_id":"$vehicle_id","item_type_id_vehicle_id":"","disp_vehicle_id":"",'+
    '"inspection_items":[{"item_type_id":"ityp-f345ae8638284fcb8c0daace82fbb894","item_id":"$id_ins_item","item_number":"","title":"","inter_related_ind":false,"selected_checkbox":"","inspection_status":"","fault_object":[$combinedString],"notes":""}]}'+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      print('failed insp form');
      return "";
    }

 }

     Future<String> createIns_Submit(String? id_ins_form,String? submit_title,String id_it)async
 { 
   String currentDate = DateFormat('ddMMyy').format(DateTime.now());
   String selectedValueWithDate = 'SUB_ISP $submit_title $currentDate';
   UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-9a8b8e484a2d4527873924bcf95f62cc","item_id":"","item_number":"","title":"$selectedValueWithDate","submitted_at":"","failed_items":0,"duration_in_hrs":0,"longitude":"","latitude":"","submitted_latitude":"","submitted_longitude":"","inspection_form":"$id_ins_form","item_type_id_inspection_form":"ityp-fea3de650d1b46a7808608ed0c003d62","disp_inspection_form":""}'+
  '}');


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

    response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

    if (response.statusCode == 200) {
      
       Map<String, dynamic> result = json.decode(response.body);
        print(result);
        if (result['success'] == true){
          return result['item_id'];

        }
        else
        {
           throw Exception('Error: ${result['message']}');
        }
      

    }
    else
    {
      return "";
    }

 }
}

Widget  POSeparator(){
  bool isRowVisible = false;
    
         return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  width: 500,
                  height: 60.0,
                  color: Colors.blue[900], // Navy blue color
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        'PO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //      isRowVisible ? Icons.arrow_drop_down : Icons.arrow_right,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     setState(() {
                      //       if( isRowVisible == true)
                      //       {
                      //          isRowVisible = false;
                      //       }
                      //       else
                      //       {
                      //         isRowVisible= true;
                      //       }
                                                               
                      //     });
                      //     // Handle the dropdown logic here
                      //   },
                      // ),
                    ],
                  ),
                ),
                Visibility(
                  visible:true,
                  child:Column(
                    children: [
                      SizedBox(height: 10),
                      Text('hhhh'),
                      Text('jjjj')
                    ],

                  ),


                ),
                ],
              );     
  }