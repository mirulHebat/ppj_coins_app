
import 'dart:async';
import 'dart:ffi';
import 'package:flutter/services.dart';
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
import 'package:ppj_coins_app/addFuel.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:ppj_coins_app/fuelData.dart';

class LoaderEditFueldata extends StatefulWidget {
 final String fuelEntriesId; // Parameter to be accepted

  LoaderEditFueldata({Key? key, required this.fuelEntriesId}) : super(key: key);

  @override
  State<LoaderEditFueldata> createState() => _LoaderState();
}

class _LoaderState extends State<LoaderEditFueldata>  {
  var shouldPop=false;
  var count;
  final EditFuelData fList = EditFuelData();
  late PageController controller;
  late int _selectedIndex;
  late List<ItemFuel> items;
  late List<Item> itemFT;
   Color customColor = Color(0xFF1647AF);
    bool isLoading = true;
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


Future<void> loadDataEdit() async {
  try {
    final findListFD fList = findListFD();
    // final List<ItemFuel> data = await fList.viewFuel(widget.fuelEntriesId);
      final List<Item> data = await fList.createListFD(widget.fuelEntriesId);
    setState(() {
      itemFT = data;
       for (final dataEntri in data)
       {
        items = dataEntri.price_per_liter;
       }
      
      isLoading = false;
      print(' berjaya');
    });
  } catch (error) {
    setState(() {
      isLoading = false;
      print('x berjaya');
    });
    // Handle error
    print('Error fetching data: $error');
  }
}

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
    loadDataEdit();
    
  }

Widget build(BuildContext context) {
  var w = MediaQuery.of(context).size.width;
  var h = MediaQuery.of(context).size.height;
  print(widget.fuelEntriesId);
  if (isLoading) {
    return Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.05),
                Consumer(builder: (context, ref, child) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: h * 0.0,
                            bottom: h * 0.00,
                            left: w * 0.0,
                            right: w * 0.0,
                          ),
                          child: Container(
                            height: h * 0.12,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ref.read(truewhite).withOpacity(1),
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
                                      padding: EdgeInsets.only(right: w * 0.02),
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
                                      "Edit Fuel Consumption Data",
                                      style: TextStyle(
                                        fontSize: h * 0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
                }),
                // SizedBox(height: h * 0.02),
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: onPageChanged,
                    children: <Widget>[
                      MyTextFieldUIEdit(items: itemFT, item_fuel:items,ftid:widget.fuelEntriesId),
                      // buildListTiles(itemListWithCount),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}        
 }
        



class MyTextFieldUIEdit extends StatefulWidget {
    final List<Item> items;
    final  List<ItemFuel >item_fuel;
    final String ftid;


  const MyTextFieldUIEdit({Key? key, required this.items,required this.item_fuel,required this.ftid}) : super(key: key); 

  @override
  _MyTextFieldUIState createState() => _MyTextFieldUIState();
}

class _MyTextFieldUIState extends State<MyTextFieldUIEdit> {

  TextEditingController _priceLiterController = TextEditingController();
  TextEditingController _liters_per_hr = TextEditingController();
  TextEditingController liters_per_100km = TextEditingController();
  TextEditingController usage_in_1km = TextEditingController();
  TextEditingController usage_in_hr = TextEditingController();
  TextEditingController cost_per_km = TextEditingController();
  TextEditingController cost_per_hr = TextEditingController();
  TextEditingController vehiclefield = TextEditingController();
  TextEditingController  max_capacity = TextEditingController();
  TextEditingController  max_cap = TextEditingController();
  TextEditingController  km_liter = TextEditingController();
  String fuelEntries_ID="";
   String vehicleId="";
  String errorMessage="";
  bool costusageview=true;
  bool fuel_info_view=true;
  String price_per_liter_fe="";
    String liters_per_hr_fe="";
    String liters_per_100km_fe="";
    String usage_in_km_fe="";
    String cost_per_km_fe="";
    String usage_in_hr_fe="";
    String cost_per_hr_fe="";
    String vehicle_title="";
    String ft_title="";
    String fuel_entries_id="";
    String max_Cap="";
    String km_per_liter="";
  
  @override
  void dispose() {
    _priceLiterController.dispose();
    _liters_per_hr.dispose();
    liters_per_100km.dispose();
    usage_in_1km.dispose();
    usage_in_hr.dispose();
    cost_per_km.dispose();
    cost_per_hr.dispose();
    vehiclefield.dispose();
    max_cap.dispose();
    km_liter.dispose();
    super.dispose();
  }

  void initState(){
    
     super.initState();
     List<Item> items = widget.items;
    List<ItemFuel> item_fuel = widget.item_fuel;
    print('sini data yang diperlu');
    item_fuel.forEach((item) {
      price_per_liter_fe=item.price_per_liter?.containsKey('display') ?? false ? item.price_per_liter!['display']! : '';
      liters_per_hr_fe=item.liters_per_hr?.containsKey('display') ?? false ? item.liters_per_hr!['display']! : '';
      liters_per_100km_fe=item.liters_per_100km?.containsKey('display') ?? false ? item.liters_per_100km!['display']! : '';
      usage_in_km_fe= item.usage_in_km?.containsKey('display') ?? false ? item.usage_in_km!['display']! : '';
      cost_per_km_fe=item.cost_per_km?.containsKey('display') ?? false ? item.cost_per_km!['display']! : '';
      usage_in_hr_fe=item.usage_in_hr?.containsKey('display') ?? false ? item.usage_in_hr!['display']! : '';
      cost_per_hr_fe=item.cost_per_hr?.containsKey('display') ?? false ? item.cost_per_hr!['display']! : '';
      max_Cap=item.max_cap?.containsKey('display') ?? false ? item.max_cap!['display']! : '';
      usage_in_1km.text=usage_in_km_fe;
      cost_per_km.text=cost_per_km_fe;
      cost_per_hr.text=cost_per_hr_fe;
      _priceLiterController.text=price_per_liter_fe;
      km_per_liter = item.km_lit.toString();
      _liters_per_hr.text=liters_per_hr_fe;
      
    
    });
    items.forEach((itemfuel){
       vehicle_title=itemfuel.titleVeh;
       ft_title=itemfuel.titleFT;
       fuel_entries_id=itemfuel.fuel_entries_id;
    });

  }

  @override
Widget build(BuildContext context) {
  print(widget.ftid);
    List<Item> items = widget.items;
    List<ItemFuel> item_fuel = widget.item_fuel;

      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
        width: MediaQuery.of(context).size.width,
        height: 60.0,
        color: Color.fromARGB(255, 145, 203, 250),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Enter Fuel Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                fuel_info_view ? Icons.arrow_drop_down : Icons.arrow_right,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  fuel_info_view = !fuel_info_view;
                });
              },
            ),
          ],
        ),
      ),

        for (final itemft in items) ...[
        for (final item in item_fuel) ...[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Visibility(
              visible: fuel_info_view,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  UpperCaseTextFormatter(), // Add this formatter
                                ],
                                initialValue: itemft.titleVeh,
                                onChanged: (value) {
                                  // Update the controller's text when the user types
                                  vehiclefield.text = value;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Num Plate',
                                  border: OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () async {
                                      String vehicletext = vehiclefield.text;
                                      vehicleId = await findListFuel().findVehicle(vehicletext) ?? '';
                                      print(vehicleId);
                                      if (vehicleId.isEmpty) {
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
                                                    vehiclefield.clear(); // Close the dialog
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
                                              title: Text('Successful'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Number plate found.'),
                                                  SizedBox(height: 8.0), // Add some space between the lines if needed
                                                  Text('Please proceed to insert Fuel Information'),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    vehiclefield.clear(); // Close the dialog
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
                              SizedBox(height: 3), // Add some space between the TextField and the message
                              Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              initialValue: item.price_per_liter?.containsKey('display') ?? false
                                  ? item.price_per_liter!['display']!
                                  : '',
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                // Update the controller's text when user types
                                _priceLiterController.text = value;
                                double kmPerLiter = double.tryParse(km_liter.text) ?? 0.0;
                                double pricePerLiter = double.tryParse(_priceLiterController.text) ?? 0.0;
                                // Calculate liters per km
                                double costPerKm = kmPerLiter != 0 ? pricePerLiter / kmPerLiter : 0.0;
                                double litersPerHour = double.tryParse(_liters_per_hr.text) ?? 0.0;
                                double costPerHour = litersPerHour * pricePerLiter;
                                cost_per_hr.text = costPerHour.toStringAsFixed(2);
                                cost_per_km.text = costPerKm.toStringAsFixed(2);
                                print('cost per hr ${ _priceLiterController.text}');
                              },
                              decoration: InputDecoration(
                                labelText: 'Price Per Liter  (RM)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              initialValue: item.km_lit.toString(),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                // Update the controller's text when user types
                                km_liter.text = value;
                                double kmPerLiter = double.tryParse(value) ?? 0.0;
                                double litersPerKm = kmPerLiter != 0 ? 1 / kmPerLiter : 0.0;
                                double pricePerLiter = double.tryParse(_priceLiterController.text) ?? 0.0;
                                print('pricePerLiter');
                                print(pricePerLiter); // Calculate liters per km
                                usage_in_1km.text = litersPerKm.toStringAsFixed(2);
                                double costPerKm = kmPerLiter != 0 ? pricePerLiter / kmPerLiter : 0.0;
                                cost_per_km.text = costPerKm.toStringAsFixed(2);
                              },
                              // keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Mileage (KM/L)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        initialValue: item.liters_per_hr?.containsKey('display') ?? false
                            ? item.liters_per_hr!['display']!
                            : '',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          // Update the controller's text when user types
                          _liters_per_hr.text = value;
                          double pricePerLiter = double.tryParse(_priceLiterController.text) ?? 0.0;
                          double litersPerHour = double.tryParse(_liters_per_hr.text) ?? 0.0;
                          double costPerHour = litersPerHour * pricePerLiter;
                          cost_per_hr.text = costPerHour.toStringAsFixed(2);
                        },
                        decoration: InputDecoration(
                          labelText: 'Liters Per Hour (L)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        initialValue: item.liters_per_100km?.containsKey('display') ?? false
                            ? item.liters_per_100km!['display']!
                            : '',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          // Update the controller's text when user types
                          liters_per_100km.text = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Liters Per 100KM (L)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        initialValue: item.max_cap?.containsKey('display') ?? false ? item.max_cap!['display']! : '',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          max_cap.text = value;
                        },
                        maxLines: null, // Set maxLines to null to allow unlimited lines
                        decoration: InputDecoration(
                          labelText: 'Max Capacity in Liters (L)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

             Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              color: Color.fromARGB(255, 145, 203, 250),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between to push the icon to the end
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Cost and Usage',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      costusageview ? Icons.arrow_drop_down : Icons.arrow_right,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        costusageview = !costusageview;
                      });
                    },
                  ),
                ],
              ),
            ),

                Visibility(
                visible: costusageview,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: usage_in_1km,
                        enabled: false, // Disable the TextField
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Usage in 1KM (L)',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.grey[200], // Set background color to gray
                          filled: true,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: cost_per_km,
                              enabled: false, // Disable the TextField
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Cost per KM (RM)',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                fillColor: Colors.grey[200], // Set background color to gray
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: cost_per_hr,
                              enabled: false, // Disable the TextField
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Cost Per Hour (RM)',
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
                  ],
                ),
              ),
                // Add more text fields here if needed
              ],
            ),
          ),
        ],
      ],
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            EditFuelData fedit =EditFuelData();
              fedit._showLoadingDialogFEdit(context);
              //  if (vehiclefield.text.isEmpty) {
              //   // Show a dialog box indicating that all fields are required
              //   showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return AlertDialog(
              //         title: Text('Missing Information'),
              //         content: Text('Num plate are required.'),
              //         actions: <Widget>[
              //           TextButton(
              //             onPressed: () {
              //               Navigator.of(context).pop(); // Close the dialog
              //             },
              //             child: Text('OK'),
              //           ),
              //         ],
              //       );
              //     },
              //   );
              //   return; // Exit the function early
              // }
              print('nilai');
              print(liters_per_100km.text);
              print(max_cap.text);
              String Title = vehiclefield.text.replaceAll(' ', '');
              String priceLiter = _priceLiterController.text;
              String literHr = _liters_per_hr.text;
              String literKm = liters_per_100km.text;
              String usage_in_1 = usage_in_1km.text;
              String usageinhr = usage_in_hr.text;
              String cost_perkm = cost_per_km.text;
              String cost_perhr = cost_per_hr.text;
              String maximum = max_cap.text;
              String kmlite = km_liter.text;
              print('vehicle no plate');
              print(priceLiter);
              print(literHr);
    
                if(Title =="")
                {
                  Title=vehicle_title;
                  vehicleId= await findListFuel().findVehicle(vehicle_title) ?? '';
                }
                if(priceLiter =="")
                {
                  priceLiter=price_per_liter_fe;
                }
                if(literHr =="")
                {
                  literHr=liters_per_hr_fe;
                }
                if(literKm =="")
                {
                  literKm=liters_per_100km_fe;
                }
                if(usage_in_1 =="")
                {
                  usage_in_1=usage_in_km_fe;
                }
                if(usageinhr =="")
                {
                  usageinhr=cost_per_km_fe;
                }
                if(cost_perkm =="")
                {
                  cost_perkm=usage_in_hr_fe;
                }
                if(cost_perhr =="")
                {
                  cost_perhr=cost_per_hr_fe;
                }
                if(maximum =="")
                {
                  maximum =max_Cap;
                }
                if(kmlite =="")
                {
                  kmlite =km_per_liter;
                }
              print(fuel_entries_id);
              print(Title);
              print(priceLiter);
              print(vehicleId);

               await EditFuelData().createList(Title, priceLiter, literHr, literKm,usage_in_1,usageinhr,cost_perkm,cost_perhr,fuel_entries_id,maximum,kmlite);
               await findListFuelType().createList(Title, fuel_entries_id, vehicleId,widget.ftid);
               Timer(Duration(seconds: 5),(){
                 Navigator.pop(context);
                 Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    
                    builder: (context) => LoaderFDetail(itemId : widget.ftid),
                  ),
                );

               });
            // Your save button logic goes here
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

class EditFuelData
{

Future<void> _showLoadingDialogFEdit(BuildContext context) async {
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

  Future<String> createList(String title,String priceLiter,String literHr,String literKm,String usage_in_1km,String usage_in_hr,String cost_per_km,String cost_per_hr,String fuelEntries_ID,String maximum,String kmlite) async {
    print('First Name: $title');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  // Check if the userDetails list is not empty and has at least one element
  if (userDetails.isNotEmpty) {
    // Accessing the first element
    print('Data of ifleet-e19ed3688291407ab4da4d50d665769e: $ifleetData');
  } else {
    print('User details list is empty or does not contain the ifleet data.');

  }

  http.Response response;
  var usell = Uri.encodeQueryComponent('{'+
    '"bims_access_id":"$ifleetData",'+
    '"action":"SAVE_ITEM",'+
    '"metadata":{"item_type_id":"ityp-e01c1454a6534723b73b71782b321ebc","item_id":"'+fuelEntries_ID+'","title":"'+title+'","price_per_liter":"'+priceLiter+'","liters_per_hr":"'+literHr+'","liters_max_capacity":'+maximum+',"liters_per_100km":"'+literKm+'","km_per_liters":"'+kmlite+'","usage_in_km":'+usage_in_1km+',"cost_per_km":'+cost_per_km+',"usage_in_hr":'+usage_in_hr+',"cost_per_hr":'+cost_per_hr+'""}'+
  '}');

  print('findGap');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  print(usell);
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  // body: usell,
  // ?param=$usell

  if (response.statusCode == 200) {
    print('welcom');
    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
       print(result);
       return (result['item_id']);

    } else {

      return '';


    }
  } else {
    return '';
    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
// Return 0 if request failed
  }
}

}