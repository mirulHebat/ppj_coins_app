import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/bukapeti/buka_baru.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import '../riverpod/login/userFSP.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(builder: (context, ref, child) => 
            Padding(
              padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
              child: Container(
                width: w*0.8,
                child: Text('Menu Aplikasi',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(darkGray)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Consumer(builder: (context, ref, child) => 
                    Padding(
                      padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.00 ,left: w*0.02,right: w*0.0),
                      child: InkWell(
                        onTap: (){
                          print('Hello');
                          Navigator.push(context,MaterialPageRoute(builder: (context) => BukapetiBaru()));
                        },
                        child: Container(
                          height: h*0.15,
                          width: w*0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:ref.read(truewhite).withOpacity(1),
                              width: h*0.002
                            ),
                            color: ref.read(truewhite).withOpacity(0.8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                child: Container(
                                  height: h*0.06,
                                  width: h*0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    border: Border.all(
                                      color:ref.read(trueOrange).withOpacity(1),
                                      width: h*0.002
                                    ),
                                    color: ref.read(trueOrange).withOpacity(1)
                                  ),
                                  child:ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: InkWell(
                                      onTap: (){
                                        // Navigator.push(context, PageTransition(duration: Duration(milliseconds: 200),type: PageTransitionType.topToBottom, child: Profile()));
                                      },
                                      child: Container(
                                        height: h*0.1,
                                        width: h*0.1,
                                        // ignore: prefer_const_constructors
                                        decoration: BoxDecoration(
                                          color: ref.read(trueOrange)
                                        ),
                                        child:Center(child:Icon(FontAwesome5.qrcode,color: ref.read(truewhite),size: h*0.02))
                                          
                                      ),
                                    ),
                                  ) ,
                                ),
                              ),
                              SizedBox(width: w*0.02,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(top: h*0.02,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                    child: Container(
                                      width: w*0.6,
                                      child: Text('Buka Peti',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                    child: Container(
                                      width: w*0.6,
                                      child: Text('Tambah pembida bagi buka peti',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  Consumer(builder: (context, ref, child) => 
                    Padding(
                      padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.00 ,left: w*0.02,right: w*0.0),
                      child: Container(
                        height: h*0.15,
                        width: w*0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:ref.read(truewhite).withOpacity(1),
                            width: h*0.002
                          ),
                          color: ref.read(truewhite).withOpacity(0.8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                              child: Container(
                                height: h*0.06,
                                width: h*0.06,
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
                                      // Navigator.push(context, PageTransition(duration: Duration(milliseconds: 200),type: PageTransitionType.topToBottom, child: Profile()));
                                    },
                                    child: Container(
                                      height: h*0.1,
                                      width: h*0.1,
                                      // ignore: prefer_const_constructors
                                      decoration: BoxDecoration(
                                        color: ref.read(darkyellow)
                                      ),
                                      child:Center(child:Icon(FontAwesome5.bars,color: ref.read(truewhite),size: h*0.02))
                                        
                                    ),
                                  ),
                                ) ,
                              ),
                            ),
                            SizedBox(width: w*0.02,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(top: h*0.02,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                  child: Container(
                                    width: w*0.6,
                                    child: Text('Menu Tambahan',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(darkyellow)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                  child: Container(
                                    width: w*0.6,
                                    child: Text('Menu Aplikasi',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(darkyellow)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          Consumer(builder: (context, ref, child) => 
            Padding(
              padding:  EdgeInsets.only(top: h*0.02,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
              child: Container(
                width: w*0.8,
                child: Text('Log Aktiviti',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(darkGray)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
              ),
            ),
          ),
          Expanded(
            child: Consumer(builder: (context, ref, child){
              var usrDetView = ref.read(userDetailProv).getUserDetails(); //////
              var boxHistory =[];
              boxHistory = ref.watch(actHistoryProv).getActions(usrDetView[1]).reversed.toList();
              return boxHistory.length > 0?
              ListView.builder(
                padding:  EdgeInsets.zero,
                itemCount: boxHistory.length>5? 5:boxHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: h*0.01,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                    child: Container(
                      // height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(
                        //   color:ref.read(truewhite).withOpacity(1),
                        //   width: h*0.002
                        // ),
                        color: ref.read(primaryColor).withOpacity(01),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.02,right: w*0.02),
                            child: Container(
                              width: w*0.8,
                              child: Text(boxHistory[index][0].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.005 ,left: w*0.02,right: w*0.0),
                            child: Container(
                              width: w*0.8,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5.folder,color: ref.read(truewhite),size: h*0.015),
                                  SizedBox(width: w*0.02,),
                                  Text(boxHistory[index][3].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.005 ,left: w*0.02,right: w*0.0),
                            child: Container(
                              width: w*0.8,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5.plus_circle,color: ref.read(truewhite),size: h*0.015),
                                  SizedBox(width: w*0.02,),
                                  Text(boxHistory[index][1].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.02,right: w*0.0),
                            child: Container(
                              width: w*0.8,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5.clock,color: ref.read(truewhite),size: h*0.015),
                                  SizedBox(width: w*0.02,),
                                  Text(boxHistory[index][2].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ):
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.2,right: w*0.2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // border: Border.all(
                      //   color:ref.read(truewhite).withOpacity(1),
                      //   width: h*0.002
                      // ),
                      color: ref.read(primaryColor).withOpacity(01),
                    ),
                    width: w,
                    child: Padding(
                      padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.0,right: w*0.0),
                      child: Text('Tiada aktiviti buat masa ini',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                ),
              );
            }
        ),
          )
      ]),
    );
  }
}