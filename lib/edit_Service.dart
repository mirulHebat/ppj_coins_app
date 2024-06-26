import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:ppj_coins_app/home/homepage.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'dart:convert';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import '../riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/maintenance_detail.dart';
import 'package:ppj_coins_app/list_maintenance.dart';
import 'package:ppj_coins_app/fuelData.dart';
import 'package:ppj_coins_app/addService.dart';
import 'dart:async';

class EditService extends StatefulWidget {
    final List<Maintenance> maintenace;

  const EditService({Key? key,required this.maintenace}) : super(key: key);

  @override
  editServicepage createState() => editServicepage();
}

class editServicepage extends State<EditService> {
  late List<Maintenance> maintenace;
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
    maintenace = widget.maintenace;
    
  }

  

  Widget build(BuildContext context){
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  
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
                                          Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                            Text(
                                              "Edit Service Data ", // Replace with your actual title text
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
                          editingService(maintenace:maintenace)
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

class editingService extends ConsumerStatefulWidget {
  final List<Maintenance> maintenace;

  const editingService({Key? key, required this.maintenace}) : super(key: key);

  @override
  ConsumerState<editingService> createState() => editionServiceState();

}

class editionServiceState extends ConsumerState<editingService>{
    TextEditingController Labor_pricing = TextEditingController(text: '0.00');
    TextEditingController  Part_pricing = TextEditingController(text: '0.00');
    TextEditingController  tax_percent = TextEditingController();
    TextEditingController  tax_pricing = TextEditingController(text: '0.00');
    TextEditingController  total_pricing = TextEditingController(text: '0.00');
    TextEditingController  vehiclefield = TextEditingController();
    TextEditingController  driverfield = TextEditingController();
    TextEditingController completeController = TextEditingController();
    TextEditingController IssuedBy = TextEditingController();
    String vehicleId="";
    String isIssue="";
    String driverId="";
    String IssuedId="";
    String driver_id="";
    String errorMessage = '';
    List<Widget> separators = [];
    int _lineItemNumber = 0;
    String? selectedFaultCategory;
    String? selectedItem;
    String? fault_id;
    String service_edit_id="";
    String inspsub_edit_id="";
    String insp_id="";
    String work_order_id="";
    String insp_item="";
     Map<String,dynamic> map_driver={};
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
    final focusNode = FocusNode();
    late List<Maintenance> items;
    bool ind_value=true;
     bool _initialized = false;
    formServiceState fService=formServiceState();

     @override
      void dispose() 
      {
        Labor_pricing.dispose();
        Part_pricing.dispose();
        tax_percent.dispose();
        tax_pricing.dispose();
        total_pricing.dispose();
        vehiclefield.dispose();
        driverfield.dispose();
        completeController.dispose();
        IssuedBy.dispose();
        super.dispose();
      }

       @override
    void initState() {
      super.initState();
      _categoriesFuture = fService.fetchCategories();
      print('category$_categoriesFuture');
      // _initializeData();
     // items = widget.maintenace;
    }

     @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeData();
      _initialized = true;
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
      String cleanLab = Labor_pricing.text.replaceAll(RegExp(r'[^\d.]'), '');
      String cleanPart = Part_pricing.text.replaceAll(RegExp(r'[^\d.]'), '');
      partCost =double.parse(cleanPart);
      labCost = double.parse(cleanLab);
      totaling=partCost +labCost;
      // Labor_pricing.text = currencyFormat.format(labCost);
      Labor_pricing.text = labCost.toString();
      print( Labor_pricing.text);
      if(tax_percent.text != ''){
        String cleanTax = tax_percent.text.replaceAll(RegExp(r'[^\d.]'), '');
        print(cleanTax);
        taxRate = double.parse(cleanTax)*0.01;
      }
      print( ref.read(poDetArray));
      // if (ref.read(poDetArray).isNotEmpty)
      // {
      //     Part_pricing.text = ref.read(poDetArray)[0]['total_amount'];
      //     print(Part_pricing.text);
      // }
      if(taxRate != 0){
        taxPrice = totaling * taxRate;
        taxPrice = double.parse(taxPrice.toStringAsFixed(2)); 
      }else{
         String cleanTax2 = tax_pricing.text.replaceAll(RegExp(r'[^\d.]'), '');
         taxPrice = double.parse(cleanTax2);
         
      }
      partPrice = double.parse(Part_pricing.text);
      // Part_pricing.text = currencyFormat.format(partPrice);
      // tax_pricing.text = currencyFormat.format(taxPrice);
      Part_pricing.text = partPrice.toString();
      tax_pricing.text = taxPrice.toString();
      double totalPrice = labCost + partPrice + taxPrice;
      // total_pricing.text = currencyFormat.format(totalPrice);
      total_pricing.text = totalPrice.toString();
}

  void _initializeData() {
     items = widget.maintenace;

    if (items.isNotEmpty && ind_value) {
      var item = items[0]; // Assuming you want to use the first item

      vehiclefield.text = item.vehicle['title'] ?? "";
      driverfield.text = item.driver_title;
      completeController.text = item.complete_date;
      Labor_pricing.text = item.labor;
      Part_pricing.text = item.part;
      tax_percent.text = item.tax_perct.toString();
      tax_pricing.text = item.tax;
      total_pricing.text = item.total;
      service_edit_id = item.service_id;
      work_order_id = item.work_order_id;

      ind_value = false;
      List<dynamic> itemsfaulty = [];

      for (var workObj in item.work_obj) {
        for (var linework in workObj.linework) {
          for (var fault in linework.issuing[0].faulling) {
            itemsfaulty.add([
              fault.fault_Category, // GC
              <Map<String, dynamic>>[], // list
              fault.fault_item, // list
              fault.fault_id, // data FI
            ]);
          }

          Insertworkline.add(
            insertworkline(
              due_date: linework.issuing[0].duesoon,
              insp_stats: linework.issuing[0].list_ting[0].list_[0].status['display'],
              work_order_status: linework.work_order_status['display'],
              start_at: linework.start_at,
              labor_wol: linework.labor_wol,
              parts_wol: double.parse(linework.parts_wol),
              subtotal_wol: double.parse(linework.subtotal_wol),
              resolving: linework.issuing[0].resolve['display'],
              drop: true,
              summary: linework.issuing[0].Summary,
              inspIF_edit_id: linework.issuing[0].list_ting[0].Sub_id,
              inspII_id: linework.issuing[0].list_ting[0].list_[0].Insp_id,
              insp_item: linework.issuing[0].list_ting[0].Subb_big,
              issue_id: linework.issuing[0].Sub,
              work_id_item: linework.workline_id,
              data_collect: itemsfaulty,
            ),
          );

          itemsfaulty = [];
          separators.add(WorkOrderSeparator(_lineItemNumber++));
        }
      }
    }
  }



  Future<void> addWorkOrderLineEdit() async{
  print('hello');
  setState(() {
    Insertworkline.add(
      insertworkline(
      due_date:'',
      insp_stats:'',
      work_order_status:'New',
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

    Future<void> _showLoadingDialogEdit(BuildContext context) async {
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

   Widget  WorkOrderSeparator(index){
    startAtControllers.add(TextEditingController());
    laborControllers.add(TextEditingController()); // Add controllers
    partControllers.add(TextEditingController());
    subtotalControllers.add(TextEditingController());
    dueControllers.add(TextEditingController());
    summaryControllers.add(TextEditingController());
    startAtControllers[index].text=Insertworkline[index].start_at;
    laborControllers[index].text=Insertworkline[index].labor_wol;
    partControllers[index].text=Insertworkline[index].parts_wol.toString();
    subtotalControllers[index].text=Insertworkline[index].subtotal_wol.toString();
    summaryControllers[index].text=Insertworkline[index].summary;
    dueControllers[index].text=Insertworkline[index].due_date;
    selectOrder.add(null);
    selectResolve.add(null);
    selectInsp_stat.add(null);
    selectOrder[index] =Insertworkline[index].work_order_status;  
    print('indser${Insertworkline[index].resolving}');
    print('indser${_categoriesFuture}');
    if(Insertworkline[index].resolving !='')
    {
      selectResolve[index]=Insertworkline[index].resolving;
      
    }
    if(Insertworkline[index].insp_stats !='')
    {
      selectInsp_stat[index]=Insertworkline[index].insp_stats;

    }
    bool indicator_issu=true;
    int tajuk=index+1;
    
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
     String Full_name = userDetails.isNotEmpty ? userDetails[6] : '';
     IssuedBy.text =Full_name.toUpperCase();
     print('sini stop');
     String editing="edit";
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
                                controller:IssuedBy ,
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
                                    // onPressed: () async {
                                    //   String issued = IssuedBy.text.toUpperCase();
                                    //  // IssuedId = await findListFuel().findDriver(issued) ?? ''; 
                                    //   print('nilai issue');
                                    //     print(IssuedId);
                                    //   if(IssuedId.isEmpty )
                                    //   {
                                    //     showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         title: Text('Missing Information'),
                                    //         content: Text('User not found.'),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop();
                                    //               // vehiclefield.clear(); // Close the dialog
                                    //             },
                                    //             child: Text('OK'),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    //   return; 
                                    //   }else
                                    //   { 
                                    //     showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return AlertDialog(
                                    //         title: Text('Successful'),
                                    //         content: Column(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           Text('User found.'),
                                    //           SizedBox(height: 8.0), // Add some space between the lines if needed
                                    //           Text('Please proceed to insert Service Information'),
                                    //         ],
                                    //       ),
                                    //         actions: <Widget>[
                                    //           TextButton(
                                    //             onPressed: () {
                                    //               Navigator.of(context).pop();
                                    //               // Close the dialog
                                    //             },
                                    //             child: Text('OK'),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    //   return;

                                    //   }
                                      
                                    // },
                                  ),
                                ),
                              ),
                    ),

                    
                  
                    SizedBox(height: 10),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                      ),
                      hint: Text('Work Order Status'),  // This text will act as a placeholder
                      value: selectOrder[index],
                      items: <String>['Completed', 'New', 'Terminated', 'Work In Progress']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                            selectOrder[index] = newValue;
                            Insertworkline[index].work_order_status = newValue;
                        });
                      },
                    ),
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
                                String nilai_price_labor=Labor_pricing.text;
                                String nilai_price_sub=total_pricing.text;
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
                                Labor_pricing.text=nilai_price.toString();
                                total_pricing.text=nilai_sub.toString();
                                print(Labor_pricing.text);
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
                              String nilai_price_part=Part_pricing.text;
                              String nilai_price_sub=total_pricing.text;
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
                              
                                double previ=prev_part;
                                 nilai_part=nilai_part-previ;
                                 nilai_sub=nilai_sub-previ;
                              
                              nilai_part=nilai_part+partsWol;
                              nilai_sub=nilai_sub+partsWol;
                              
                              double total=partsWol+labor;
                              Insertworkline[index].subtotal_wol=total;
                              subtotalControllers[index].text=total.toString();
                              Part_pricing.text=nilai_part.toString();
                              total_pricing.text=nilai_sub.toString();
                              print('total $total_pricing.text');
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
                                  items:  <String>['Failed','In Diagnostics','Passed']
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
                     child: WorkOrderPage(_categoriesFuture,Insertworkline[index].data_collect,index,editing), // Custom UI component
                  ), 

                    ],

                  ),


                ),
                ],
              );     
  }

     @override
    Widget build(BuildContext context) 
    {
      return Scaffold(
        body: SingleChildScrollView(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: items.map((item){
                  // if(ind_value)
                  // {
                    
                  //   vehiclefield.text=item.vehicle['title']??"";
                  //   driverfield.text=item.driver_title;
                  //   completeController.text=item.complete_date;
                  //   Labor_pricing.text=item.labor;
                  //   Part_pricing.text=item.part;
                  //   tax_percent.text=item.tax_perct.toString();
                  //   tax_pricing.text=item.tax;
                  //   total_pricing.text=item.total;
                  //   service_edit_id=item.service_id;
                  //   work_order_id=item.work_order_id;
      

                  //   ind_value=false;
                  //   List<dynamic> itemsfaulty = [];
                  //   for(var i=0;i<item.work_obj.length;i++)
                  //   {
                      
                  //     for(var y=0;y<item.work_obj[i].linework.length;y++)
                  //     {
                        
                        
                  //       for(var j=0;j<item.work_obj[i].linework[y].issuing[0].faulling.length;j++)
                  //       {
                  //         print('nnn${item.work_obj[i].linework[y].issuing[0].faulling[j].fault_item}');
                  //         itemsfaulty.add(
                  //         [
                  //         item.work_obj[i].linework[y].issuing[0].faulling[j].fault_Category, // GC
                  //         <Map<String, dynamic>>[],
                  //         item.work_obj[i].linework[y].issuing[0].faulling[j].fault_item, // list
                  //         item.work_obj[i].linework[y].issuing[0].faulling[j].fault_id,
                  //         // data FI
                  //       ]);


                  //       }
                  //       // inspsub_edit_id=item.work_obj[i].linework[y].issuing[0].list_ting[0].Sub_id;
                  //       // insp_id=item.work_obj[i].linework[y].issuing[0].list_ting[0].list_[0].Insp_id;
                  //       print('nilai kess ${item.work_obj[i].linework[y].issuing[0].list_ting[0].Sub_id}'); 
                  //       print('nilai kess ${item.work_obj[i].linework[y].work_order_status['display']}'); 

                  //       Insertworkline.add(
                  //         insertworkline(
                  //         due_date:item.work_obj[i].linework[y].issuing[0].duesoon,
                  //         insp_stats:item.work_obj[i].linework[y].issuing[0].list_ting[0].list_[0].status['display'],
                  //         work_order_status:item.work_obj[i].linework[y].work_order_status['display'],
                  //         start_at: item.work_obj[i].linework[y].start_at,
                  //         labor_wol: item.work_obj[i].linework[y].labor_wol,
                  //         parts_wol: double.parse(item.work_obj[i].linework[y].parts_wol),
                  //         subtotal_wol:double.parse(item.work_obj[i].linework[y].subtotal_wol),
                  //         resolving:  item.work_obj[i].linework[y].issuing[0].resolve['display'],
                  //         drop:true,
                  //         summary:item.work_obj[i].linework[y].issuing[0].Summary,
                  //         inspIF_edit_id:item.work_obj[i].linework[y].issuing[0].list_ting[0].Sub_id,
                  //         inspII_id:item.work_obj[i].linework[y].issuing[0].list_ting[0].list_[0].Insp_id,
                  //         insp_item:item.work_obj[i].linework[y].issuing[0].list_ting[0].Subb_big,
                  //         issue_id:item.work_obj[i].linework[y].issuing[0].Sub,
                  //         work_id_item:item.work_obj[i].linework[y].workline_id,
                  //         data_collect:itemsfaulty,

                  //       ));
                  //       itemsfaulty=[];
                  //       separators.add(WorkOrderSeparator(_lineItemNumber++));
                  //       print('seepearator ${separators.length}');
                  //     }

                  //   }
                  // }
                         
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    padding: EdgeInsets.all(8.0), // Padding for each item container
                    color: Colors.white,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
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
                                      vehicleId = await fService.findVehicleMech(vehicletext) ?? ''; 
                                      formServiceState stateform=formServiceState();
                                       map_driver=await stateform.finddriverVehicleMech(vehicleId) ?? {}; 
                                      driver_id=map_driver['Contact'];
                                      driverfield.text= map_driver['titlee']; 
                                      print(vehicleId);
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
                                decoration: InputDecoration(
                                  labelText: 'Driver',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () async {
                                      String drivertext = driverfield.text.toUpperCase();
                                      //driverId = await findListFuel().findDriver(drivertext) ?? ''; 
                                      print(driverId);
                                      if(driverId.isEmpty )
                                      {
                                        showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Missing Information'),
                                            content: Text('Driver not found.'),
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
                                              Text('Driver found.'),
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
                                      controller: Labor_pricing,
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
                                    child: TextField(
                                      controller: Part_pricing,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: 'Part Subtotal  (RM)',
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
                            Row(
                            children: [
                              Expanded(

                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: TextField(
                                    controller: tax_percent,
                                    onChanged: (value){
                                      double tax_perct=double.tryParse(value)?? 0.0;
                                      double labor=double.tryParse(Labor_pricing.text)??0.0;
                                      double part=double.tryParse(Part_pricing.text)??0.0;
                                      double total =labor+part;
                                      double new_total=(((100+tax_perct)/100)*total);
                                      double subtax =new_total- total;
                                      tax_pricing.text=subtax.toStringAsFixed(2);
                                      total_pricing.text=new_total.toStringAsFixed(2);
                                        
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
                                    controller: tax_pricing,
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
                              controller: total_pricing,
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


                            ],
                          ),
                        ),
                      ],
                    ),
                      ),

                      ]
                    )
                  

                  );

                }).toList(),
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
                  padding: EdgeInsets.all(8.0), // Padding inside the container
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white, // White icon
                      size: 32.0, // Larger font size
                    ),
                    onPressed: () async {
                      await addWorkOrderLineEdit();
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
                            "display_value": "", 
                            "code": "", 
                            "value": "", 
                            "ref_code": ""
                          },
                          "",
                          //data FI
                        ]);
                        print('hello');
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

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: ()async {
               _showLoadingDialogEdit(context);
              print(vehiclefield.text);
              List list_faulty=ref.read(listfault);
              print(list_faulty);
              String inspectionItem="";
              String inspectionform="";
              String inspectionSubmit="";
              String resultIssue="";
              String resultWorkLine="";
              List <String> workLineList=[];
              List <String> issueList=[];
              if(vehicleId =="")
              {
                vehicleId = await fService.findVehicleMech(vehiclefield.text) ?? ''; 
                formServiceState stateform=formServiceState();
                map_driver=await stateform.finddriverVehicleMech(vehicleId) ?? {}; 
                driver_id=map_driver['Contact'];
                driverfield.text= map_driver['titlee']; 

              }

              if(isIssue == "")
              {
                print('is issue');
                 findListFuel listFuel =findListFuel();
                 List<Map<String,dynamic>> relatedNames = await listFuel.findDriver(IssuedBy.text.toUpperCase());
                 for(var i=0;i<relatedNames.length;i++)
                 {
                  isIssue=relatedNames[i]['vehicleId']?? "";
                 }

              }
              
              for(var y=0;y<Insertworkline.length;y++)
              {

                List fault_id=[];

                for(var i=0;i<Insertworkline[y].data_collect.length;i++)
                {  
                  print('nilai fault ${Insertworkline[y].data_collect[i][2]}');
                  
                  String faulty =await f_Service(). createFaults(vehiclefield.text,Insertworkline[y].data_collect[i][0],Insertworkline[y].data_collect[i][2],ref,Insertworkline[y].data_collect[i][3]);
                  fault_id.add(faulty);

                }
                                                                  
                   inspectionItem=await f_Service().createInspect(Insertworkline[y].insp_stats,fault_id,vehiclefield.text,Insertworkline[y].inspII_id);
                   inspectionform=await f_Service().createIns_form(inspectionItem,fault_id,vehiclefield.text,isIssue,vehicleId,Insertworkline[y].inspIF_edit_id);
                   inspectionSubmit=await f_Service().createIns_Submit(inspectionform,vehiclefield.text,Insertworkline[y].insp_item);
                   resultIssue=await f_Service(). createIssues(Insertworkline[y].resolving,Insertworkline[y].due_date,inspectionSubmit,fault_id,vehiclefield.text,isIssue,Insertworkline[y].start_at,Insertworkline[y].summary,Insertworkline[y].issue_id);
                   resultWorkLine=await f_Service(). createWorkLine(Insertworkline[y].start_at,Insertworkline[y].labor_wol,Insertworkline[y].parts_wol,Insertworkline[y].subtotal_wol,resultIssue,vehiclefield.text,Insertworkline[y].work_order_status,Insertworkline[y].work_id_item);
                   workLineList.add(resultWorkLine);
                   issueList.add(resultIssue); 
              }
              //  if(isIssue =="")
              //   {
              //     IssuedId = await findListFuel().findDriver(isIssue) ?? [];
              //   }

              print('vehicle $vehicleId');
              print('vehicle $driver_id');

               String resultWorkOrder=await f_Service(). createWorkOrderEdit("",Labor_pricing.text,Part_pricing.text,tax_percent.text,tax_pricing.text,total_pricing.text,workLineList,vehiclefield.text,isIssue,driver_id,completeController.text,work_order_id);
               String resultService=await f_Service(). createService(vehicleId,driver_id,completeController.text,issueList,resultWorkOrder,inspectionform,vehiclefield.text,Labor_pricing.text,Part_pricing.text,tax_percent.text,tax_pricing.text,total_pricing.text,service_edit_id);
               Navigator.pop(context);
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>LoaderMaintenance(),
                    ),
                  );


              
            },
            child: Text('Save'),
              style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
            ),
          ),
            

            ]
           )

        )

      );

    }

}