import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/bukapeti/buka_baru.dart';

import '../riverpod/utilities/colors.dart';


class BukaPeti extends StatelessWidget {
  const BukaPeti({super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: Consumer(builder: (context, ref, child) => 
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FontAwesome5.arrow_circle_left,size: h*0.03,),
          color: ref.read(trueOrange),
        ),)
      ),
      body: Stack(
        children: [
          background(),
          Column(
            children: [
              SizedBox(height: h*0.1,),
              Consumer(builder: (context, ref, child) => 
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.00 ,left: w*0.04,right: w*0.04),
                        child: InkWell(
                          onTap: (){

                          },
                          child: Container(
                            height: h*0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:ref.read(truewhite).withOpacity(1),
                                width: h*0.002
                              ),
                              color: ref.read(truewhite).withOpacity(0.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                  child: Container(
                                    height: h*0.06,
                                    width: h*0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(200),
                                      border: Border.all(
                                        color:ref.read(trueOrange).withOpacity(0.1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(trueOrange).withOpacity(0.1)
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
                                          child:Center(child:Icon(FontAwesome5.hdd,color: ref.read(truewhite),size: h*0.02))
                                            
                                        ),
                                      ),
                                    ) ,
                                  ),
                                ),
                                SizedBox(width: w*0.02,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: h*0.01,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                      child: Container(
                                        width: w*0.6,
                                        child: Text('Buka Peti',style: TextStyle(fontSize:h*0.03,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                      child: Container(
                                        width: w*0.6,
                                        child: Text('Proses buka peti perolehan',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 1,),
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
                  ],
                ),
              ),
              Expanded(
                child: Consumer(builder: (context, ref, child) => 
                  Padding(
                    padding: EdgeInsets.only(top: h*0.02,bottom: h*0.02 ,left: w*0.04,right: w*0.04),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:ref.read(truewhite).withOpacity(1),
                          width: h*0.002
                        ),
                        color: ref.read(truewhite).withOpacity(0.6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: h*0.04,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: h*0.03,
                                  height: h*0.03,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    // border: Border.all(
                                    //   color:ref.read(truewhite).withOpacity(1),
                                    //   width: h*0.002
                                    // ),
                                    color: ref.read(trueOrange).withOpacity(1),
                                  ),
                                  child: Center(child: Text('1',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                ),
                                SizedBox(width: w*0.02,),
                                Container(
                                  child: Text('Pilih Buka Peti',style: TextStyle(fontSize:h*0.03,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                ),
                                
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => BukapetiBaru()));
                                    },
                                    child: Container(
                                      height: h*0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ref.read(trueOrange).withOpacity(1),
                                      ),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesome5.qrcode,color: ref.read(truewhite),size: h*0.02),
                                          SizedBox(width: w*0.02,),
                                          Center(child: Text('Imbas QR pembida',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: h*0.02,),
                                Text('ATAU',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                SizedBox(height: h*0.02,),
                                Padding(
                                  padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
                                  child: Container(
                                    height: h*0.07,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ref.read(trueOrange).withOpacity(1),
                                    ),
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesome5.folder,color: ref.read(truewhite),size: h*0.02),
                                        SizedBox(width: w*0.02,),
                                        Center(child: Text('Pilih Buka Peti',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  background(){
    return Stack(
      children: [
        Consumer(builder: (context, ref, child) => 
          Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: ref.watch(offwhite),
          // child: Opacity(opacity: 0.2,child: Image.asset("assets/bg3.png",fit: BoxFit.fill,))
          ),
        ),
          
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Consumer(builder: (context, ref, child) => 
                  Opacity(
                    opacity: 1,
                    child: Blob.random(
                      styles:  BlobStyles(
                        color:  ref.watch(secondaryColor).withOpacity(0.1),
                        fillType:  BlobFillType.fill,
                        strokeWidth:3,
                      ),
                      size:800,
                      edgesCount:5,
                      minGrowth:4,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),

        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Consumer(builder: (context, ref, child) => 
                Opacity(
                  opacity: 1,
                  child: Blob.random(
                    styles:  BlobStyles(
                      color:  ref.watch(primaryColor).withOpacity(0.1),
                      fillType:  BlobFillType.fill,
                      strokeWidth:3,
                    ),
                    size:500,
                    edgesCount:4,
                    minGrowth:4,
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }
  
}