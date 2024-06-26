import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/PurchaseOrder/vehicleCategory.dart';
import 'package:ppj_coins_app/PurchaseOrder/vehiclesPage.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import '../riverpod/utilities/colors.dart';



class vehicleCategoryPage extends ConsumerStatefulWidget {
  const vehicleCategoryPage({Key? key}) : super(key: key);
  

  @override
  ConsumerState<vehicleCategoryPage> createState() => _VehicleCategoryPageState();
  
}

class _VehicleCategoryPageState extends ConsumerState<vehicleCategoryPage> {
List<Map<String, dynamic>> myList = [];

 List<Map<String, dynamic>> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    final vehicleCategory vc = vehicleCategory();
     Future.delayed(Duration.zero, () async {
      List<Map<String, dynamic>> result = await vc.createList();
      setState(() {
        myList = result; 
      });
    });

    filteredItems.addAll(myList);
  }

    @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

void filterList(List<Map<String,dynamic>> myList,List<Map<String,dynamic>>  filteredItems, String query) {
  filteredItems.clear();
  if (query.isEmpty) {
    filteredItems.addAll(myList);
  } else {
    filteredItems.addAll(
      myList.where((item) => item['title'].toLowerCase().contains(query.toLowerCase())),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          padding: EdgeInsets.only(left: h*0.1),
                          child: Text(
                            'Vehicle Inventory',
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
                        filterList(myList, filteredItems, query);
                        setState(() {});
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


                  // filteredItems.length == 0?
                  // Center(
                  //       child: Text(
                  //         'No data found',
                  //         style: TextStyle(fontSize: 20.0),
                  //       ),
                  //     ):
                  filteredItems.length != 0 && searchController.text !=''? 
                  Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: filteredItems.length, 
                                  itemBuilder: (context, index) {
                                    filteredItems.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                                    var item = filteredItems[index]; 
                                      return ListTile(
                                                title: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(Uri.decodeComponent(item['title']), style: TextStyle(color: Colors.black),),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => vehiclePage(title:item['title'], code: item['code'])));
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(8), 
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
                                  },
                                ),
                              ),
                            )         :
                  Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myList.length, 
                      itemBuilder: (context, index) {
                        if (index < myList.length) {
                          myList.sort((a, b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase()));
                          var item = myList[index]; 
                          return ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(Uri.decodeComponent(item['title']), style: TextStyle(color: Colors.black),),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => vehiclePage(title:item['title'], code: item['code'])));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8), 
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
                        } else {
                          return Container(); 
                        }
                      },
                    ),
                  ),
                ),
                  
                ],
              ),
            ); 
  }
}
