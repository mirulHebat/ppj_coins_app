import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/purchaseOrderPage.dart';
import 'package:ppj_coins_app/PurchaseOrder/vehicles.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
// import 'package:iFleet_app/inventory/vehicleDetailsPage.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import '../riverpod/utilities/colors.dart';



class vehiclePage extends ConsumerStatefulWidget {
  const vehiclePage ({super.key, required this.title, required this.code});

  final String title;
  final String code;
  

  @override
  ConsumerState<vehiclePage> createState() => _VehiclePageState();
  
}

class _VehiclePageState extends ConsumerState<vehiclePage> {
  List<Map<String,dynamic>> carList = [];

  List<Map<String,dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    final Vehicles kereta = Vehicles();
     Future.delayed(Duration.zero, () async {
      List<Map<String,dynamic>> cars = await kereta.createList(widget.code);
      setState(() {
        carList = cars;
      });
    });

  }

    @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterList(List<Map<String,dynamic>> carList,List<Map<String,dynamic>>  filteredItems, String query) {
  filteredItems.clear();
  if (query.isEmpty) {
    filteredItems.addAll(carList);
  } else {
    filteredItems.addAll(
      carList.where((item) => item['title'].toLowerCase().contains(query.toLowerCase())),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top:50, bottom: 50, left: h*0.01),
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
                          padding: EdgeInsets.only(left:h*0.14),
                          child: Text(
                            widget.title,
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

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterList(carList, filteredItems, query);
                        setState(() {}); // Update UI when filtered items change
                      },
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Search for items...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  filteredItems.length != 0  && searchController.text !=''? 
                  Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: filteredItems.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: carList.length + 1, // Add one for the loading indicator
                      itemBuilder: (context, index) {
                        if (index < filteredItems.length) {
                          filteredItems.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                          var item = filteredItems[index]; 
                          return  ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(Uri.decodeComponent(item['title']), style: TextStyle(color: Colors.black),),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print(item);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderPage(title: item['title'], id: item['id'])));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8), // Adjust padding as needed
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: h * 0.03,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                        } else{
                          return Container();
                        }

                      },
                    )
                    : Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                  ),
                ):
                  
                 
                  Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: carList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: carList.length + 1, // Add one for the loading indicator
                      itemBuilder: (context, index) {
                        if (index < carList.length) {
                          carList.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                          var item = carList[index];
                          return  ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(Uri.decodeComponent(item['title']), style: TextStyle(color: Colors.black),),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            // print(item);
                                            ref.invalidate(poList);
                                            ref.read(poList);
                                            // ref.read(poList.notifier).state = [a,b,c]; //to add or update data
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => purchaseOrderPage(title: item['title'], id: item['id'])));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8), // Adjust padding as needed
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: h * 0.03,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                        } else{
                          return Container();
                        }
                      },
                    )
                    : Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                  ),
                ),
                  
                ],
              ),
            ); 
  }
}
