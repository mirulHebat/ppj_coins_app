// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ppj_coins_app/bukapeti/buka_baru.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:tuple/tuple.dart';

import '../riverpod/bukapeti/find_perolehan.dart';
import '../riverpod/utilities/colors.dart';


class MaklumatCadangan extends ConsumerStatefulWidget {
  @override
  ConsumerState<MaklumatCadangan> createState() => _MaklumatCadanganState();
}

// 2. extend [ConsumerState]
class _MaklumatCadanganState extends ConsumerState<MaklumatCadangan> {
  // double nilai = 0;
  // double diskaun = 0;
  TextEditingController nilaiCtrl = TextEditingController();
  TextEditingController diskaunCtrl = TextEditingController();
  TextEditingController tempohCtrl = TextEditingController();
  // String _formatNumber(String s) => NumberFormat.decimalPattern('en').format(int.parse(s));

  // var tempoh =0;
  var pdk='';
  var jenisDiskaunstr ='';
  
  var items = [    
    'Hari',
    'Minggu',
    'Bulan',
    'Tahun',
  ];
  
  

  @override
  void initState() {
    super.initState();
  }
  void _onItemTapped(int index) {
    if (ref.read(jenisDokCdg).controller.hasClients) {
        ref.read(jenisDokCdg).controller.jumpToPage(
          index,
          // duration: const Duration(milliseconds: 400),
          // curve: Curves.fastOutSlowIn,
        );
      }
  }
  void onPageChanged(int pagenum) {
    ref.read(pageindex.notifier).state = pagenum;
  }


  

  @override
  Widget build(BuildContext context) {
    print('build');
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    // var dropdownvalue = ref.watch(selectedtempoh);
    return Scaffold(
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
          background(h,w),
          SingleChildScrollView(
            child: SizedBox(
              height: h,
              child: Column(
                children: [
                  SizedBox(height: h*0.05,),
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
                                      child: Center(child: Text('3',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                    ),
                                    
                                    SizedBox(width: w*0.02,),
                                    Container(
                                      child: Text('Maklumat Cadangan',style: TextStyle(fontSize:h*0.03,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                    ),
                                    
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Consumer(builder: (context, ref, child) {
                                  final crNupdBP = ref.watch(crAndUpdBP);
                                  return crNupdBP.when(
                                    data: (state){
                                      print(state.toString());
                                      if(state=='idle'){
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:  EdgeInsets.only(top: h*0.04,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
                                              child: Container(
                                                width: w*0.8,
                                                child: Text('Sila isikan maklumat cadangan bagi dokumen yang diimbas',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,),
                                              ),
                                            ),
                                            SizedBox(height: h*0.03,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width:w* 0.04,),
                                                Expanded(
                                                  child: Container(
                                                    // height: h*0.1,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                        color:ref.read(trueOrange).withOpacity(1),
                                                        width: h*0.002
                                                      ),
                                                      color: ref.read(truewhite).withOpacity(1),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: h*0.02,bottom: h*0.02 ,left: w*0.04,right: w*0.04),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Center(child: Text(Uri.decodeQueryComponent(ref.read(companyDet)['title']),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          SizedBox(height: h*0.005,),
                                                          Center(child: Text(Uri.decodeQueryComponent(ref.read(scannedPDKref)),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          SizedBox(height: h*0.02,),
                                                          Center(child: Text('Bilangan Penyebut Harga : '+(ref.read(senaraiPembida).length+1).toString()+'/'+(ref.read(totalPembida)).toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width:w* 0.04,),
                                              ],
                                            ),
                                            SizedBox(height: h*0.02,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                                                    child: Container(
                                                      height: h*0.04,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(200),
                                                        // border: Border.all(
                                                        //   color:ref.read(truewhite).withOpacity(1),
                                                        //   width: h*0.002
                                                        // ),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.02,right: w*0.02),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: ref.watch(pageindex) ==0? 2:1,
                                                              child: InkWell(
                                                                onTap: (){
                                                                  _onItemTapped(0);
                                                                },
                                                                child: Container(
                                                                  height: h*0.03,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(200),
                                                                    // border: Border.all(
                                                                    //   color:ref.read(truewhite).withOpacity(1),
                                                                    //   width: h*0.002
                                                                    // ),
                                                                    color: ref.watch(pageindex) ==0? ref.read(truewhite).withOpacity(1):ref.read(trueOrange).withOpacity(1),
                                                                  ),
                                                                  child: Center(child: Text('1. Nilai',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color:ref.watch(pageindex) ==0? ref.watch(trueOrange):ref.read(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: ref.watch(pageindex) ==1? 2:1,
                                                              child: InkWell(
                                                                onTap: (){
                                                                  _onItemTapped(1);
                                                                },
                                                                child: Container(
                                                                  height: h*0.03,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(200),
                                                                    // border: Border.all(
                                                                    //   color:ref.read(truewhite).withOpacity(1),
                                                                    //   width: h*0.002
                                                                    // ),
                                                                    color: ref.watch(pageindex) ==1? ref.read(truewhite).withOpacity(1):ref.read(trueOrange).withOpacity(1),
                                                                  ),
                                                                  child: Center(child: Text('2. Masa',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(pageindex) ==1? ref.watch(trueOrange):ref.read(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: ref.watch(pageindex) ==2? 2:1,
                                                              child: InkWell(
                                                                onTap: (){
                                                                  _onItemTapped(2);
                                                                },
                                                                child: Container(
                                                                  height: h*0.03,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(200),
                                                                    // border: Border.all(
                                                                    //   color:ref.read(truewhite).withOpacity(1),
                                                                    //   width: h*0.002
                                                                    // ),
                                                                    color: ref.watch(pageindex) ==2? ref.read(truewhite).withOpacity(1):ref.read(trueOrange).withOpacity(1),
                                                                  ),
                                                                  child: Center(child: Text('3. Dokumen',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(pageindex) ==2? ref.watch(trueOrange):ref.read(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: h*0.02,),
                                            Expanded(
                                              child: PageView(
                                                controller: ref.watch(jenisDokCdg).controller,
                                                onPageChanged: onPageChanged,
                                                children: <Widget>[
                                                  columnNilai(h, w, ref),
                                                  columnTempoh(h, w, ref),
                                                  jenisDokumen(h, w, ref),


                                                ],
                                              ),
                                            ),
                                            
                                            SizedBox(height: h*0.02,),
                                            
                                            Consumer(builder: (context, ref, child) {
                                              var pageNum = ref.read(pageindex);
                                              var pageWatcher = ref.watch(pageindex);

                                              return Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  pageWatcher == 0? 
                                                  Container():
                                                  InkWell(
                                                    onTap: (){
                                                      _onItemTapped(pageNum-1);
                                                    },
                                                    child: Container(
                                                      height: h*0.06,
                                                      width: w*0.3,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        // border: Border.all(
                                                        //   color:ref.read(truewhite).withOpacity(1),
                                                        //   width: h*0.002
                                                        // ),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Icon(FontAwesome5.arrow_circle_left,size: h*0.02,color: ref.read(truewhite),),
                                                          Center(child: Text('Kembali',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  pageWatcher==2 ?
                                                  Container():
                                                  InkWell(
                                                    onTap: (){
                                                      _onItemTapped(pageNum+1);
                                                    },
                                                    child: Container(
                                                      height: h*0.06,
                                                      width: w*0.3,

                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        // border: Border.all(
                                                        //   color:ref.read(truewhite).withOpacity(1),
                                                        //   width: h*0.002
                                                        // ),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Center(child: Text('Seterusnya',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          Icon(FontAwesome5.arrow_circle_right,size: h*0.02,color: ref.read(truewhite),),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                            SizedBox(height: h*0.01,),
                                            InkWell(
                                              onTap: ()  {
                                                if(ref.read(tempohProjek)==0 || ref.read(nilaiBida)==0){
                                                  Fluttertoast.showToast(
                                                      msg: "Sila pastikan Nilai Bidaan dan Jangka Masa telah diisi",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: ref.read(primaryColor),
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }else{
                                                  if(ref.watch(selectedDiscount).isEmpty){
                                                    ref.read(selectedDiscount.notifier).state=jenisDiskaunstr;
                                                  }
                                                  ref.read(crAndUpdBP.notifier).updatePeti(ref.read(nilaiBida).toStringAsFixed(2) ,ref.read(tempohProjek), ref.read(selectedtempoh),ref.read(selectedJDCObj), ref);
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: h*0.06,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        // border: Border.all(
                                                        //   color:ref.read(truewhite).withOpacity(1),
                                                        //   width: h*0.002
                                                        // ),
                                                        color: ref.read(positiveColor).withOpacity(1),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
                                                        child: Center(child: Text('Tambah Pembida',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        
                                        );
                                      }else if(state=='Selesai'){
                                        print("in Selesai");
                                        // Future.delayed(const Duration(milliseconds: 100),()=>
                                        //   showModalBottomSheet<void>(
                                        //     context: context,
                                        //     builder: (BuildContext context) {
                                        //       return MaklumatCadangan();
                                        //     },
                                        //   )
                                        // );
                                        
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.04,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                          child: Column(
                                            children: [
                                              Container(
                                                // height: h*0.2,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  // border: Border.all(
                                                  //   color: ref.read(trueOrange),
                                                  //   width: 2
                                                  // ),
                                                  color: ref.read(positiveColor).withOpacity(1),
                                                ),
                                                child:Padding(
                                                  padding:EdgeInsets.only(top: h*0.02,bottom: h*0.02 ,left: w*0.04,right: w*0.02),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(FontAwesome5.thumbs_up,color: ref.read(truewhite),size: h*0.02),
                                                          SizedBox(width: w*0.04,),
                                                          Center(child: Text('Pembida berjaya ditambah',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          
                                                        ],
                                                      ),
                                                      ref.read(senaraiPembida).length+1 >= ref.read(totalPembida)?
                                                      Padding(
                                                        padding: EdgeInsets.only(top: h*0.01,bottom: h*0.02 ,left: w*0.0,right: w*0.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            // Icon(FontAwesome5.thumbs_up,color: ref.read(truewhite),size: h*0.02),
                                                            // SizedBox(width: w*0.04,),
                                                            Center(child: Container(
                                                              width: w*0.6,
                                                              child: Text('Anda telah menambah kesemua pembida bagi buka peti ini , sila semak semula senarai pembida di laman sesawang COINS ',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 6,)
                                                              )
                                                            ),
                                                            
                                                          ],
                                                        ),
                                                      ):SizedBox(),
                                                      SizedBox(height: h*0.02,),
                                                      Center(child: Text(Uri.decodeQueryComponent(ref.read(companyDet)['title']),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      Center(child: Text(Uri.decodeQueryComponent(ref.read(scannedPDKref)),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      SizedBox(height: h*0.005,),
                                                      Center(child: Text('Bilangan Penyebut Harga : '+(ref.read(senaraiPembida).length+1).toString()+'/'+(ref.read(totalPembida)).toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      // SizedBox(height: h*0.005,),
                                                      Center(child: Text('Nilai Bidaan : RM '+ref.read(updateBPDet)['nilai'].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      // SizedBox(height: h*0.005,),
                                                      Center(child: Text('Tempoh : '+ref.read(updateBPDet)['tempoh'].toString()+' '+ref.read(updateBPDet)['jenis'].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      SizedBox(height: h*0.01,),
                                                      Center(child: Text('Jenis Dokumen : ',style: TextStyle(fontSize:h*0.02 ,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                      
                                                      ListView.builder(
                                                        
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets.zero,
                                                        itemCount: ref.read(selectedJDC).length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          int data = ref.read(selectedJDC)[index];
                                                          print(data.toString());
                                                          return Center(child: Text(ref.read(jenisDokCdg).jenisDokCadangan[data]['display_value'].toString(),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,));

                                                        }
                                                      )
                                                      
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: h*0.02,),
                                              InkWell(
                                                onTap: (){
                                                  print('in Selesai');
                                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BukapetiBaru()));
                                                },
                                                child: Container(
                                                  height: h*0.07,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    // border: Border.all(
                                                    //   color: ref.read(trueOrange),
                                                    //   width: 2
                                                    // ),
                                                    color: ref.read(trueOrange).withOpacity(1),
                                                  ),
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(FontAwesome5.redo,color: ref.read(truewhite),size: h*0.02),
                                                      SizedBox(width: w*0.04,),
                                                      Center(child: Text('Imbas pembida seterusnya',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }else{
                                        print(state);
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              print('in else');
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: h*0.07,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: ref.read(trueOrange),
                                                  width: 2
                                                ),
                                                color: ref.read(truewhite).withOpacity(1),
                                              ),
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
                                                  SizedBox(width: w*0.02,),
                                                  Center(child: Text(state,style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }, 
                                    error: (Object error, StackTrace stackTrace) {
                                      return InkWell(
                                          onTap: (){
                                            // ref.read(loginProvider.notifier).init();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                            child: InkWell(
                                              onTap: (){
                                              },
                                              child: Container(
                                                height: h*0.07,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: ref.read(trueOrange),
                                                    width: 2
                                                  ),
                                                  color: ref.read(truewhite).withOpacity(1),
                                                ),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
                                                    SizedBox(width: w*0.02,),
                                                    Center(child: Text('error',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                    },
                                    loading: () {
                                      return Container(
                                        decoration: BoxDecoration(
                                          // color: ref.watch(truegray),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        height: h*0.06,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            LoadingAnimationWidget.prograssiveDots(
                                              color: ref.watch(trueOrange),
                                              size: h*0.05,
                                            ),
                                          ],
                                        ),
                                        
                                      );
                                    },
                                  );
                                },),
                              )
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      
    );
  }

  background(h,w){
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
          
        // SingleChildScrollView(
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: <Widget>[
        //         Consumer(builder: (context, ref, child) => 
        //           Opacity(
        //             opacity: 1,
        //             child: Blob.random(
        //               styles:  BlobStyles(
        //                 color:  ref.watch(secondaryColor).withOpacity(0.1),
        //                 fillType:  BlobFillType.fill,
        //                 strokeWidth:3,
        //               ),
        //               size:800,
        //               edgesCount:5,
        //               minGrowth:4,
        //             ),
        //           ),
        //         ),
                
        //       ],
        //     ),
        //   ),
        // ),

        // SingleChildScrollView(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: <Widget>[
        //       Consumer(builder: (context, ref, child) => 
        //         Opacity(
        //           opacity: 1,
        //           child: Blob.random(
        //             styles:  BlobStyles(
        //               color:  ref.watch(primaryColor).withOpacity(0.1),
        //               fillType:  BlobFillType.fill,
        //               strokeWidth:3,
        //             ),
        //             size:500,
        //             edgesCount:4,
        //             minGrowth:4,
        //           ),
        //         ),
        //       ),
              
        //     ],
        //   ),
        // ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer(builder: (context, ref, child) => 
                    Opacity(
                      opacity: 0.3,
                      child: Container(
                        height:h*0.3 ,
                        width: h*0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(h),
                          color: ref.watch(truewhite)
                        ),
                        child: Center(
                          child: Image.asset("assets/logo.png",
                          height:h*0.28 ,
                          width: h*0.28,
                          fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: w*0.04,)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  nilaiBidaan(h,w,WidgetRef ref){
    return Padding(
      padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
      child: Container(
        decoration: BoxDecoration(
          color: ref.watch(lightOrange),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: ref.watch(truegray),width:2)
        ),
        height: h*0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: w*0.04,),
            Icon(
              FontAwesome5.dollar_sign,
              color: ref.watch(trueOrange),
              size: h*0.02,
              
            ),
            SizedBox(width: w*0.04,),
            SizedBox(
              height: h*0.06,
              width: w*0.5,
              child: Center(
                child: TextField(
                  obscureText: false,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      decimalDigits: 2,
                      locale: 'ms-my',
                      symbol: "RM "
                    )
                  ],
                  onChanged: (String txt) {
                    
                    if(txt.isNotEmpty){
                      try{
                        print('txt');
                        print(txt);
                        var cleanMYR = txt.replaceAll('RM ', '');
                        var cleanComma = cleanMYR.replaceAll(',', '');
                        print('cleanComma');
                        print(cleanComma);
                        ref.read(nilaiBida.notifier).state=double.parse(cleanComma.trim());
                        print('nilaiBida');
                        print(ref.read(nilaiBida));

                      }catch(e){
                        print('catch');
                        ref.read(nilaiBida.notifier).state=0;
                      }
                    }else{
                      print('MT');
                      ref.read(nilaiBida.notifier).state=0;
                    }
                    // print(ref.read(nilaiBida));
                  },
                  style: TextStyle(
                    fontSize: h*0.015,
                    color: ref.watch(trueOrange)
                  ),
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText:  ref.read(nilaiBida)>0? ref.read(nilaiBida).toString(): 'Nilai Bidaan Projek',
                    hintStyle: TextStyle(color:ref.watch(trueOrange),fontSize: h*0.015),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  jenisDiskaun(h,w,ref){
    return Consumer(builder: (context, ref, child) {
      return ref.watch(getIndDiscount(Tuple2(ref.read(bims), ref))).when(
        data: (data) {
          jenisDiskaunstr=data.first['display_value'];
          return Padding(
            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.01),
            child: Container(
              decoration: BoxDecoration(
                color: ref.watch(lightOrange),
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: ref.watch(truegray),width:2)
              ),
              height: h*0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: w*0.04,),
                  Icon(
                    FontAwesome5.bars,
                    color: ref.watch(trueOrange),
                    size: h*0.02,
                    
                  ),
                  SizedBox(width: w*0.04,),
                  DropdownButton(
                    underline: SizedBox(),
                    value: ref.watch(selectedDiscount).isEmpty ? data.first['display_value']:ref.watch(selectedDiscount),
                    icon: Icon(
                      FontAwesome5.angle_down,
                      color: ref.watch(trueOrange),
                      size: h*0.02,
                    ),
                    dropdownColor: ref.read(truewhite),
                    items: data.map((dynamic items) {
                      return DropdownMenuItem(
                        value: items['display_value'],
                        child: Text(items['display_value'],style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)
                      );
                    }).toList(),
                    onChanged: (dynamic newValue) { 
                      ref.read(selectedDiscount.notifier).state=newValue ?? data.first['display_value'];
                      print(ref.read(selectedDiscount));
                    },
                  ),

                ],
              ),
            ),
          );
        }, 
        error: (e,st){
          return Container();
        }, 
        loading: (){
          return LoadingAnimationWidget.prograssiveDots(
            color: ref.watch(trueOrange),
            size: h*0.05,
          );
        }
      );
    });
    
    
    
    
  }

  nilaiDiskaun(h,w,WidgetRef ref){
    return Padding(
      padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.01,right: w*0.04),
      child: Container(
        decoration: BoxDecoration(
          color: ref.watch(lightOrange),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: ref.watch(truegray),width:2)
        ),
        height: h*0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: w*0.04,),
            Icon(
              FontAwesome5.percentage,
              color: ref.watch(trueOrange),
              size: h*0.02,
              
            ),
            SizedBox(width: w*0.04,),
            Expanded(
              child: Center(
                child: TextField(
                  obscureText: false,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  onChanged: (String txt) {
                    if(txt.isNotEmpty){
                      try{
                        ref.read(nilaiDiscount.notifier).state=double.parse(txt.trim());
                      }catch(e){
                        ref.read(nilaiDiscount.notifier).state=0;
                      }
                    }else{
                       ref.read(nilaiDiscount.notifier).state=0;
                    }
                    print(ref.read(nilaiDiscount));
                  },
                  style: TextStyle(
                    fontSize: h*0.015,
                    color: ref.watch(trueOrange)
                  ),
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText: ref.read(nilaiDiscount)>0? ref.read(nilaiDiscount).toString():'Nilai Diskaun',
                    hintStyle: TextStyle(color:ref.watch(trueOrange),fontSize: h*0.015),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  columnNilai(h,w,ref){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
          child: Container(
            height: h*0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:ref.read(trueOrange).withOpacity(1.0),
                width: h*0.002
              ),
              color: ref.read(truewhite).withOpacity(1.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Center(
                        child: Container(
                          width: h*0.03,
                          height: h*0.03,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            // border: Border.all(
                            //   color:ref.read(truewhite).withOpacity(1),
                            //   width: h*0.002
                            // ),
                            color: ref.read(trueOrange),
                          ),
                          child: Center(child: Text('1.1',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                        ),
                      ),
                    ],
                  ),
                  Center(child: Text('Nilai Bidaan',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: h*0.01,),
        nilaiBidaan(h, w, ref),
        SizedBox(height: h*0.03,),
        Padding(
          padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
          child: Container(
            height: h*0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:ref.read(trueOrange).withOpacity(1.0),
                width: h*0.002
              ),
              color: ref.read(truewhite).withOpacity(1.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Center(
                        child: Container(
                          width: h*0.03,
                          height: h*0.03,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            // border: Border.all(
                            //   color:ref.read(truewhite).withOpacity(1),
                            //   width: h*0.002
                            // ),
                            color: ref.read(trueOrange),
                          ),
                          child: Center(child: Text('1.2',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                        ),
                      ),
                    ],
                  ),
                  Center(child: Text('Kadar Diskaun',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: h*0.01,),

        Row(
          children: [
            Expanded(child: jenisDiskaun(h, w, ref)),
            Expanded(child: nilaiDiskaun(h, w, ref))
          ],
        )
        
      ],
    );
  }

  tempohBidaan(h,w,WidgetRef ref){
    return Padding(
      padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
      child: Container(
        decoration: BoxDecoration(
          color: ref.watch(lightOrange),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: ref.watch(truegray),width:2)
        ),
        height: h*0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: w*0.04,),
            Icon(
              FontAwesome5.sort_numeric_down,
              color: ref.watch(trueOrange),
              size: h*0.02,
              
            ),
            SizedBox(width: w*0.04,),
            SizedBox(
              height: h*0.06,
              width: w*0.5,
              child: Center(
                child: TextField(
                  // maxLength: 2,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  onChanged: (String txt) {
                    // nilaiBida=txt.trim();
                    if(txt.isNotEmpty){
                      ref.read(tempohProjek.notifier).state=int.parse(txt.trim());
                    }else{
                      ref.read(tempohProjek.notifier).state =0;
                    }
                    print(ref.read(tempohProjek));
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                  ],
                  style: TextStyle(
                    fontSize: h*0.015,
                    color: ref.watch(trueOrange)
                  ),
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText:  ref.read(tempohProjek)>0? ref.read(tempohProjek).toString():'Tempoh',
                    hintStyle: TextStyle(color:ref.watch(trueOrange),fontSize: h*0.015),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  jenisTempoh(h,w,ref){
    return Padding(
      padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
      child: Container(
        decoration: BoxDecoration(
          color: ref.watch(lightOrange),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: ref.watch(truegray),width:2)
        ),
        height: h*0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: w*0.04,),
            Icon(
              FontAwesome5.calendar,
              color: ref.watch(trueOrange),
              size: h*0.02,
              
            ),
            SizedBox(width: w*0.04,),
            DropdownButton(
              underline: SizedBox(),
              value: ref.watch(selectedtempoh),
              icon: SizedBox(),
              dropdownColor: ref.read(truewhite),
              items: items.map((String items) {
                
                return DropdownMenuItem(
                  value: items,
                  child: Text(items,style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)
                );
              }).toList(),
              onChanged: (dynamic newValue) { 
                ref.watch(selectedtempoh.notifier).state=newValue ?? "Hari";
                print(ref.read(selectedtempoh));
              },
            ),

          ],
        ),
      ),
    );
  }

  columnTempoh(h,w,ref){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
          child: Container(
            height: h*0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:ref.read(trueOrange).withOpacity(1.0),
                width: h*0.002
              ),
              color: ref.read(truewhite).withOpacity(1.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Center(
                        child: Container(
                          width: h*0.03,
                          height: h*0.03,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            // border: Border.all(
                            //   color:ref.read(truewhite).withOpacity(1),
                            //   width: h*0.002
                            // ),
                            color: ref.read(trueOrange),
                          ),
                          child: Center(child: Text('2',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                        ),
                      ),
                    ],
                  ),
                  Center(child: Text('Jangkamasa Pelaksanaan Projek',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: h*0.02,),
        tempohBidaan(h, w, ref),
        SizedBox(height: h*0.02,),
        jenisTempoh(h, w, ref),
      ],
    );
  }

  ulasanDokumen(h,w,WidgetRef ref){
    return Consumer(builder: (context, ref, child) {
      return ref.watch(getUlasan(Tuple2(ref.read(bims), ref))).when(
        data: (data) {
          return ListView.builder(
            shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.only(top: h*0.005,bottom: h*0.005 ,left: w*0.04,right: w*0.04),
                    child: InkWell(
                      onTap: (){
                        if(!ref.read(selectedUlasan).contains(data[index]['display_value'])){
                          var tempJDC =  ref.read(selectedUlasan);
                          var tempList = [];
                          tempJDC.forEach((element) {
                            tempList.add(element);
                          });
                          tempList.add(data[index]['display_value']);
                          ref.watch(selectedUlasan.notifier).state=tempList;
                          var temp ='';
                          ref.read(selectedUlasan).forEach((element) {
                            var code = '';
                            ref.read(jenisDokCdg).resultUlasan.forEach((item) {
                              if(item['display_value']==element ){
                                code=item['value'];
                                print(item);
                              }
                            });

                            temp +=''+
                            '{'+
                              '"code":"",'+
                              '"value":"'+code+'",'+
                              '"display":"'+element+'"'+
                            '},';
                          });
                          if(temp.isNotEmpty){
                            temp = temp.substring(0, temp.length - 1);
                          }
                          ref.read(selectedUlasanObj.notifier).state= temp;
                          print(ref.read(selectedUlasan));

                        }else{
                          var tempJDC =  ref.read(selectedUlasan);
                          var tempList = [];
                          tempJDC.forEach((element) {
                            tempList.add(element);
                          });
                          tempList.remove(data[index]['display_value']);
                          ref.read(selectedUlasan.notifier).state=tempList;
                          var temp ='';
                          ref.read(selectedUlasan).forEach((element) {
                            var code='';
                            ref.read(jenisDokCdg).resultUlasan.forEach((item) {
                              if(item['display_value']==element ){
                                code=item['value'];
                              }
                            });
                            temp +=''+
                            '{'+
                              '"code":"",'+
                              '"value":"'+code+'",'+
                              '"display":"'+element+'"'+
                            '},';
                          });
                          if(temp.isNotEmpty){
                            temp = temp.substring(0, temp.length - 1);
                          }
                          ref.read(selectedUlasanObj.notifier).state= temp;
                          print(ref.read(selectedUlasan));

                        }
                        
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !ref.watch(selectedUlasan).contains(data[index]['display_value'])?
                          ref.watch(brightGray):ref.read(lightOrange),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            
                            color: !ref.watch(selectedUlasan).contains(data[index]['display_value'])?
                            ref.watch(brightGray):ref.read(trueOrange),
                            width:2
                          )
                        ),
                        height: h*0.04,
                        width: w*0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: w*0.04,),
                            Icon(
                              ref.watch(selectedUlasan).contains(data[index]['display_value'])?
                              FontAwesome5.check_square : FontAwesome5.square,
                              color: !ref.watch(selectedUlasan).contains(data[index]['display_value'])?
                              ref.watch(truegray):ref.read(trueOrange),
                              size: h*0.02,
                              
                            ),
                            SizedBox(width: w*0.04,),
                            Padding(
                              padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                              child: Text(data[index]['display_value'],style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              });
        }, 
        error: (e,st){
          return Container(child: Text(e.toString()),);
        }, 
        loading: (){
          return LoadingAnimationWidget.prograssiveDots(
            color: ref.watch(trueOrange),
            size: h*0.05,
          );
        }
      );
    });
  }

  ulasanLainLain(h,w,WidgetRef ref){
    return Padding(
      padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
      child: Container(
        decoration: BoxDecoration(
          color: ref.watch(lightOrange),
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: ref.watch(truegray),width:2)
        ),
        height: h*0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: w*0.04,),
            Icon(
              FontAwesome5.bars,
              color: ref.watch(trueOrange),
              size: h*0.02,
              
            ),
            SizedBox(width: w*0.04,),
            SizedBox(
              height: h*0.06,
              width: w*0.5,
              child: Center(
                child: TextField(
                  // maxLength: 2,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (String txt) {
                    // nilaiBida=txt.trim();
                    if(txt.isNotEmpty){
                      ref.read(ulasanOthers.notifier).state=txt;
                    }else{
                      ref.read(ulasanOthers.notifier).state ='';
                    }
                    print(ref.read(ulasanOthers));
                  },
                  inputFormatters: [
                    // LengthLimitingTextInputFormatter(2),
                  ],
                  style: TextStyle(
                    fontSize: h*0.015,
                    color: ref.watch(trueOrange)
                  ),
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText: ref.read(ulasanOthers).isEmpty?  'Sila nyatakan ulasan lain-lain':ref.read(ulasanOthers),
                    hintStyle: TextStyle(color:ref.watch(trueOrange),fontSize: h*0.015),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  jenisDokumen(h,w,WidgetRef ref){
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
            child: Container(
              height: h*0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:ref.read(trueOrange).withOpacity(1.0),
                  width: h*0.002
                ),
                color: ref.read(truewhite).withOpacity(1.0),
              ),
              
              child: Padding(
                padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Center(
                          child: Container(
                            width: h*0.03,
                            height: h*0.03,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              // border: Border.all(
                              //   color:ref.read(truewhite).withOpacity(1),
                              //   width: h*0.002
                              // ),
                              color: ref.read(trueOrange),
                            ),
                            child: Center(child: Text('3.1',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                          ),
                        ),
                      ],
                    ),
                    Center(child: Text('Ulasan Dokumen',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: h*0.01,),
          ulasanDokumen(h, w, ref),
          SizedBox(height: h*0.01,),
          ref.watch(selectedUlasan).contains('Lain-lain') ?
          ulasanLainLain(h, w, ref):
          SizedBox(),
          SizedBox(height: h*0.03,),
          Padding(
            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
            child: Container(
              height: h*0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:ref.read(trueOrange).withOpacity(1.0),
                  width: h*0.002
                ),
                color: ref.read(truewhite).withOpacity(1.0),
              ),
              
              child: Padding(
                padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.04),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Center(
                          child: Container(
                            width: h*0.03,
                            height: h*0.03,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              // border: Border.all(
                              //   color:ref.read(truewhite).withOpacity(1),
                              //   width: h*0.002
                              // ),
                              color: ref.read(trueOrange),
                            ),
                            child: Center(child: Text('3.2',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                          ),
                        ),
                      ],
                    ),
                    Center(child: Text('Jenis Dokumen',style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ref.watch(getJenisDok(ref)).when(
              data: (data) {
                
                return ListView.builder(
                  shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(top: h*0.005,bottom: h*0.005 ,left: w*0.04,right: w*0.04),
                          child: InkWell(
                            onTap: (){
                              if(!ref.read(selectedJDC).contains(index)){
                                var tempJDC =  ref.read(selectedJDC);
                                var tempList = [];
                                tempJDC.forEach((element) {
                                  tempList.add(element);
                                });
                                tempList.add(index);
                                ref.watch(selectedJDC.notifier).state=tempList;
                                var temp ='';
                                ref.read(selectedJDC).forEach((element) {
                                  temp +=''+
                                  '{'+
                                    '"code":"",'+
                                    '"value":'+ref.read(jenisDokCdg).jenisDokCadangan[element]['value']+','+
                                    '"display":"'+ref.read(jenisDokCdg).jenisDokCadangan[element]['display_value']+'"'+
                                  '},';
                                });
                                if(temp.isNotEmpty){
                                  temp = temp.substring(0, temp.length - 1);
                                }
                                ref.read(selectedJDCObj.notifier).state= temp;
                                print(ref.read(selectedJDC));

                              }else{
                                var tempJDC =  ref.read(selectedJDC);
                                var tempList = [];
                                tempJDC.forEach((element) {
                                  tempList.add(element);
                                });
                                tempList.remove(index);
                                ref.read(selectedJDC.notifier).state=tempList;
                                var temp ='';
                                ref.read(selectedJDC).forEach((element) {
                                  temp +=''+
                                  '{'+
                                    '"code":"",'+
                                    '"value":'+ref.read(jenisDokCdg).jenisDokCadangan[element]['value']+','+
                                    '"display":"'+ref.read(jenisDokCdg).jenisDokCadangan[element]['display_value']+'"'+
                                  '},';
                                });
                                if(temp.isNotEmpty){
                                  temp = temp.substring(0, temp.length - 1);
                                }
                                ref.read(selectedJDCObj.notifier).state= temp;
                                print(ref.read(selectedJDC));

                              }
                              
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !ref.watch(selectedJDC).contains(index)?
                                ref.watch(brightGray):ref.read(lightOrange),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  
                                  color: !ref.watch(selectedJDC).contains(index)?
                                  ref.watch(brightGray):ref.read(trueOrange),
                                  width:2
                                )
                              ),
                              height: h*0.04,
                              width: w*0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: w*0.04,),
                                  Icon(
                                    ref.watch(selectedJDC).contains(index)?
                                    FontAwesome5.check_square : FontAwesome5.square,
                                    color: !ref.watch(selectedJDC).contains(index)?
                                    ref.watch(truegray):ref.read(trueOrange),
                                    size: h*0.02,
                                    
                                  ),
                                  SizedBox(width: w*0.04,),
                                  Padding(
                                    padding: EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                                    child: Text(data[index]['display_value'],style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                    });
              }, 
              error: (e,st){
                return Container();
              }, 
              loading: (){
                return LoadingAnimationWidget.prograssiveDots(
                  color: ref.watch(trueOrange),
                  size: h*0.05,
                );
              }
            );
          }),
        
        ],
      ),
    );
  }

}