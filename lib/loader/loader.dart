// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/license_info.dart';
import 'package:ppj_coins_app/menu.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';

import '../riverpod/utilities/strings.dart';



class Loader extends StatefulWidget {
  Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  var shouldPop=false;
  late PageController controller;
  late int _selectedIndex;
  String? roleAssign;
  void _onItemTapped(int index) {
    setState(() {
      // selectedIndex = index;
      if (controller.hasClients) {
        controller.jumpToPage(
          index,
          // duration: const Duration(milliseconds: 400),
          // curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void onPageChanged(int pagenum)  {
    setState(() {
      _selectedIndex = pagenum;
      
    });
  }



  @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
     
    
  
  }

  Widget build(BuildContext context){
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    UserDetail userDetail = UserDetail();
     List<String> userDetails = userDetail.getUserDetails();
    String username = userDetails.isNotEmpty ? userDetails[2] : '';
    String role=userDetails.isNotEmpty ? userDetails[5] : '';
    return WillPopScope(
      onWillPop: ()async{
        return shouldPop;
      },
      child: Scaffold(
           drawer: Container(
            width: 300, // Set the width as desired
            child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // Custom Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person),
                      ),
                      SizedBox(height: 8),
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                          // Display the role when it's loaded
                        Text(
                          role,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        
                    ],
                  ),
                ),
                // Drawer items
                ListTile(
                   leading: Icon(Icons.person), // User icon on the left
                  title: Text('License Information'),
                  trailing: Icon(Icons.chevron_right), // Icon on the right side
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => License_info(itemId: ""), // Replace SecondScreen with the destination screen
                      ),
                    );
                  },
                ),
                // Add more list tiles as needed
              ],
            ),
          ),

          ),
        extendBody: true,
              bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   IconButton(
                  icon: Icon(Icons.local_gas_station),
                  onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderFuel(),
                      ),
                    );
                  },
                ),
                  IconButton(
                    icon: Icon( Icons.assignment),
                    onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderWork(),
                      ),
                    );
                  },
                  ),
                  IconButton(
                    icon: Icon(Icons.credit_card),
                    onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderLicense(),
                      ),
                    );
                  },
                  ),
                  IconButton(
                    icon: Icon(Icons.car_repair),
                    onPressed: () {
                     Navigator.push
                    (
                      context,
                      MaterialPageRoute
                      (                              
                        builder: (context) => LoaderMaintenance(),
                      ),
                    );
                  },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (                              
                    builder: (context) => Loader(),
                  ),
                );
              },
              child: Icon(Icons.home),
              backgroundColor: Colors.blue,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // background(h,w),

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
                          padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.00 ,left: w*0.02,right: w*0.0),
                          child: Container(
                            height: h*0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:ref.read(truewhite).withOpacity(1),
                                width: h*0.002
                              ),
                              color: ref.read(primaryLight),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.02,right: w*0.01),
                                      child: Container(
                                        height: h*0.05,
                                        width: h*0.05,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(200),
                                          border: Border.all(
                                            color:ref.read(truewhite).withOpacity(1),
                                            width: h*0.002
                                          ),
                                          color: ref.read(truewhite).withOpacity(1)
                                        ),
                                        child:ClipRRect(
                                          borderRadius: BorderRadius.circular(200),
                                          child: InkWell(
                                            onTap: (){
                                              print('onTap');
                                             Scaffold.of(context).openDrawer();
                                            },
                                            child: Container(
                                              height: h*0.1,
                                              width: h*0.1,
                                              // ignore: prefer_const_constructors
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                              ),
                                              child:Center(child:Icon(FontAwesome5.user,color: ref.read(primaryColor),size: h*0.02))
                                                
                                            ),
                                          ),
                                        ) ,
                                      ),
                                    ),
                                    Padding(
                                    padding: EdgeInsets.only(top: h * 0.0, bottom: h * 0.01, left: w * 0.02, right: w * 0.02),
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        var repoName = ref.watch(mainURL);

                                        return Container(
                                          decoration: BoxDecoration(
                                            // color: repoName == 'perolehan.ppj.gov.my' ? ref.watch(trueOrange) : ref.watch(negativeColor),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          height: h * 0.05,
                                          width: w * 0.6,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "I-Fleet Internal System Management",
                                                  style: TextStyle(
                                                    fontSize: h * 0.02,
                                                    fontWeight: FontWeight.normal,
                                                    color: ref.watch(truewhite),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  ],
                                ),
                                SizedBox(width: w*0.02,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                      child: Container(
                                        width: w*0.3,
                                        child: Text(ref.read(fullname),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(primaryColor)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                    //   child: Container(
                                    //     width: w*0.3,
                                    //     child: Text(ref.read(userDetails)['roles'][0]['title'],style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(primaryColor)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                    //   ),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.00 ,left: w*0.02,right: w*0.02),
                          child: Container(
                            height: h*0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:ref.read(truewhite).withOpacity(1),
                                // width: h*0.001
                              ),
                              color: ref.read(secondaryLight),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),

                                // ),
                                // ref.read(logOutNow(ref.read(bims)));
                                Consumer(builder: (context, ref, child) {
                                // var doLogout = ref.read(logOutNow(ref.read(bims)));
                                  final runLogout = ref.watch(logutUser);
                                  return runLogout.when(
                                    data: (data){
                                      if(data=='idle'){
                                        return Padding(
                                          padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              ref.read(logutUser.notifier).logout(ref.read(bims));
                                            },
                                            child: Container(
                                              height: h*0.05,
                                              width: h*0.05,

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(200),
                                                border: Border.all(
                                                  color:ref.read(truewhite).withOpacity(1),
                                                  width: h*0.002
                                                ),
                                                color: ref.read(truewhite).withOpacity(1)
                                              ),
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(200),
                                                child: Padding(
                                                  padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          
                                                          color: Colors.white
                                                        ),
                                                        child:Center(child:Icon(FontAwesome5.sign_out_alt,color: ref.read(negativeColor),size: h*0.02,))
                                                          
                                                      ),
                                                      // SizedBox(width: w*0.02,),
                                                      // Container(
                                                      //   child: Text('Log Keluar',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(secondaryColor)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ) ,
                                            ),
                                          ),
                                        );
                                      }else{
                                        Future.delayed(const Duration(milliseconds: 100),()=>Phoenix.rebirth(context));
                                        return Padding(
                                          padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              ref.read(logutUser.notifier).logout(ref.read(bims));
                                            },
                                            child: Container(
                                              height: h*0.05,
                                              width: h*0.05,

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(200),
                                                border: Border.all(
                                                  color:ref.read(truewhite).withOpacity(1),
                                                  width: h*0.002
                                                ),
                                                color: ref.read(truewhite).withOpacity(1)
                                              ),
                                              child:ClipRRect(
                                                borderRadius: BorderRadius.circular(200),
                                                child: Padding(
                                                  padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          
                                                          color: Colors.white
                                                        ),
                                                        child:Center(child:Icon(FontAwesome5.check_circle,color: ref.read(negativeColor),size: h*0.02,))
                                                          
                                                      ),
                                                      // SizedBox(width: w*0.02,),
                                                      // Container(
                                                      //   child: Text('Log Keluar',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(secondaryColor)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ) ,
                                            ),
                                          ),
                                        );
                                      }
                                    }, 
                                    error: (e,st){
                                      return SizedBox();
                                    }, 
                                    loading: (){
                                      return SizedBox();
                                    });
                                },),
                                
                                
                                
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },),
                SizedBox(height: h*0.02,),
                
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: onPageChanged,
                    children: <Widget>[
                      // HomePage(),
                  
                      NavigationBarExample(),


                    ],
                  ),
                )
              ],
            )
            
          ],
        ),
      ),
    );
  }
}





