// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ppj_coins_app/bukapeti/maklumat_cadanganModal.dart';
import 'package:ppj_coins_app/riverpod/bukapeti/find_perolehan.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class BukapetiBaru extends ConsumerStatefulWidget {
  const BukapetiBaru({Key? key}) : super(key: key);
  

  @override
  ConsumerState<BukapetiBaru> createState() => _BukapetiBaruState();
}

class _BukapetiBaruState extends ConsumerState<BukapetiBaru> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  late var barcodeData ={};

  var jumlahPembida = 0;
  // String tempoh = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    print('starting camera');
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
        controller.pauseCamera();
        result = scanData;
        print('result?.code');
        print(result?.code);
        // barcodeData=json.decode(result!.code ?? '');
        try{
          barcodeData=json.decode(result!.code ?? '');
          print('barcodeData');
          print(barcodeData);
          ref.invalidate(selectedJDC);
          ref.watch(findPDKprov.notifier).addPembidaQR(barcodeData['idpk'],barcodeData['idcmp'],ref);
        }catch(e){
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Kod QR Tidak Sah'),
                content: const Text('Sila semak semula Kod QR'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      // primary: ref.read(trueOrange)
                    ),
                    child: const Text('Imbas Seterusnya'),
                    onPressed: () {
                      controller.resumeCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        

      // });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
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
                    flex: 1,
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
                                      child: Center(child: Text('2',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                    ),
                                    
                                    SizedBox(width: w*0.02,),
                                    Container(
                                      child: Text('Imbas QR',style: TextStyle(fontSize:h*0.03,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                    ),
                                    
                                  ],
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(top: h*0.04,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
                                child: Container(
                                  width: w*0.8,
                                  child: Text('Sila imbas QR perolehan untuk menambah pembida kedalam buka peti',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,),
                                ),
                              ),
                              SizedBox(height: h*0.05,),
                              Container(
                                height: h*0.3,
                                width: h*0.3,

                                child: QRView(
                                  key: qrKey,
                                  onQRViewCreated: _onQRViewCreated,
                                ),
                              ),

                              

                              // (result != null) ?

                              Expanded(
                                flex: 4,
                                child: Consumer(builder: (context, ref, child) {
                                  final runGetPDK = ref.watch(findPDKprov);
                                  return runGetPDK.when(
                                    data: (state){
                                      print(state.toString());
                                      if(state=='idle'){
                                        return Container();
                                      }else if(state=='Selesai'){
                                        print("in Selesai");
                                        ref.invalidate(pageindex);
                                        ref.invalidate(selectedUlasan);
                                        ref.invalidate(selectedDiscount);
                                        ref.invalidate(nilaiBida);
                                        ref.invalidate(tempohProjek);
                                        ref.invalidate(nilaiDiscount);
                                        ref.invalidate(ulasanOthers);

                                        Future.delayed(const Duration(milliseconds: 10),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MaklumatCadangan())));
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              print('in Selesai');
                                              // ref.read(findPDKprov.notifier).init();
                                              // setState(() {
                                              //   controller!.resumeCamera();
                                              //   result=null;
                                              // });
                                            },
                                            child: Container(
                                              height: h*0.07,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                // border: Border.all(
                                                //   color: ref.read(trueOrange),
                                                //   width: 2
                                                // ),
                                                color: ref.read(truewhite).withOpacity(1),
                                              ),
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesome5.redo,color: ref.read(trueOrange),size: h*0.02),
                                                  SizedBox(width: w*0.04,),
                                                  Center(child: Text('Sila tunggu sebentar',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }else if(state.contains('Duplicate')){
                                        print(state);
                                        var splitted = state.split(' ');
                                        var indexDuplicate = int.parse(splitted[1]);
                                        var duplicateData = ref.read(senaraiPembida)[indexDuplicate];
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.02,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              print('in duplicate');
                                              ref.read(findPDKprov.notifier).init();
                                              setState(() {
                                                controller!.resumeCamera();
                                                result=null;
                                              });
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
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
                                                  // SizedBox(width: w*0.02,),
                                                  Center(child: Text("MAKLUMAT SEDIA ADA",style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  Center(child: Text("Pembida ini pernah ditambah sebelum ini ",style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  SizedBox(height: h*0.02,),
                                                  Center(child: Text("" + duplicateData['Syarikat']['title'].toString(),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  Center(child: Text("Bilangan Penyebut Harga : " + duplicateData['Bil_Penyebut_Harga'].toString()+'/'+splitted[2],style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  Center(child: Text("No. Rujukan : " + ref.read(scannedPDKref),style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),

                                                  SizedBox(height: h*0.04,),
                                                  Padding(
                                                    padding:EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        // border: Border.all(
                                                        //   color: ref.read(trueOrange),
                                                        //   width: 2
                                                        // ),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.0,right: w*0.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(FontAwesome5.redo,color: ref.read(truewhite),size: h*0.02),
                                                            SizedBox(width: w*0.02,),
                                                            Center(child: Text('Imbas QR seterusnya',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }else if(state=='Full'){
                                        print(state);
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.02,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              print('in full');
                                              ref.read(findPDKprov.notifier).init();
                                              setState(() {
                                                controller!.resumeCamera();
                                                result=null;
                                              });
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
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
                                                  // SizedBox(width: w*0.02,),
                                                  Center(child: Text("JUMLAH PEMBIDA MAKSIMA",style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  SizedBox(height: h*0.01,),
                                                  Center(child: Container(
                                                    width: w*0.7,
                                                    child: Text("Bilangan pembida sudah mencecah bilangan maksima, sila semak maklumat pembida di laman sesawang COINS",
                                                      style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),
                                                      textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,))),

                                                  SizedBox(height: h*0.04,),
                                                  Padding(
                                                    padding:EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        // border: Border.all(
                                                        //   color: ref.read(trueOrange),
                                                        //   width: 2
                                                        // ),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.0,right: w*0.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(FontAwesome5.redo,color: ref.read(truewhite),size: h*0.02),
                                                            SizedBox(width: w*0.02,),
                                                            Center(child: Text('Imbas QR seterusnya',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }else if(state=='First'){
                                        ref.invalidate(pageindex);
                                        ref.invalidate(selectedUlasan);
                                        ref.invalidate(selectedDiscount);
                                        ref.invalidate(nilaiBida);
                                        ref.invalidate(tempohProjek);
                                        ref.invalidate(nilaiDiscount);
                                        ref.invalidate(ulasanOthers);
                                        print(state);
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.02,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
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
                                            child:Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                // Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
                                                // SizedBox(width: w*0.02,),
                                                Center(child: Text("JUMLAH BILANGAN PEMBIDA",style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                Center(child: Text("Sila isikan jumlah bilangan pembida bagi buka peti ini ",style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                SizedBox(height: h*0.02,),
                                                Padding(
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
                                                              obscureText: false,
                                                              textAlign: TextAlign.start,
                                                              keyboardType: TextInputType.number,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.deny(RegExp("[.]")),
                                                              ],
                                                              maxLines: 1,
                                                              onChanged: (String txt) {
                                                                if(txt.isNotEmpty){
                                                                  jumlahPembida=int.parse(txt.trim());
                                                                  ref.read(totalPembida.notifier).state=jumlahPembida;
                                                                }else{
                                                                  jumlahPembida=0;
                                                                  ref.read(totalPembida.notifier).state=jumlahPembida;
                                                                }
                                                              },
                                                              style: TextStyle(
                                                                fontSize: h*0.02,
                                                                color: ref.watch(trueOrange)
                                                              ),
                                                              decoration:  InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText:  'Jumlah Pembida',
                                                                hintStyle: TextStyle(color:ref.watch(trueOrange),fontSize: h*0.015),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: h*0.04,),
                                                Padding(
                                                  padding:EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                                                  child: InkWell(
                                                    onTap: (){
                                                      if(jumlahPembida>0){
                                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MaklumatCadangan()));
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.0,right: w*0.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Center(child: Text('Seterusnya',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                            SizedBox(width: w*0.02,),
                                                            Icon(FontAwesome5.arrow_right,color: ref.read(truewhite),size: h*0.02),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }else{
                                        print(state);
                                        return Padding(
                                          padding: EdgeInsets.only(top: h*0.02,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                          child: InkWell(
                                            onTap: (){
                                              print('in full');
                                              ref.read(findPDKprov.notifier).init();
                                              setState(() {
                                                controller!.resumeCamera();
                                                result=null;
                                              });
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
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
                                                  // SizedBox(width: w*0.02,),
                                                  Center(child: Text("RALAT",style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                  SizedBox(height: h*0.01,),
                                                  Center(child: Container(
                                                    width: w*0.7,
                                                    child: Text(state,
                                                      style: TextStyle(fontSize:h*0.015,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),
                                                      textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,))),

                                                  SizedBox(height: h*0.04,),
                                                  Padding(
                                                    padding:EdgeInsets.only(top: h*0.0,bottom: h*0.0 ,left: w*0.04,right: w*0.04),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        // border: Border.all(
                                                        //   color: ref.read(trueOrange),
                                                        //   width: 2
                                                        // ),
                                                        color: ref.read(trueOrange).withOpacity(1),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.0,right: w*0.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(FontAwesome5.redo,color: ref.read(truewhite),size: h*0.02),
                                                            SizedBox(width: w*0.02,),
                                                            Center(child: Text('Imbas QR seterusnya',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                            print('in else');
                                            ref.read(findPDKprov.notifier).init();
                                            setState(() {
                                              controller!.resumeCamera();
                                              result=null;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  result=null;
                                                  
                                                });
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
                                                    Center(child: Text('error',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
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
}

// return Column(
//   children: [
//     Padding(
//       padding:  EdgeInsets.only(top: h*0.04,bottom: h*0.0 ,left: w*0.04,right: w*0.02),
//       child: Container(
//         width: w*0.8,
//         child: (result != null) ?
//           Text('Adakah anda ingin buka peti baru bagi perolehan ini ?',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.bold,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,)
//           :
//           Text('',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,)
//       ),
//     ),

//     Padding(
//       padding:  EdgeInsets.only(top: h*0.04,bottom: h*0.04 ,left: w*0.04,right: w*0.02),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: ref.read(trueOrange),
//             width: 2
//           ),
//           // color: ref.read(trueOrange).withOpacity(1),
//         ),
//         width: w*0.9,
//         child: (result != null) ?
//           Padding(
//             padding: EdgeInsets.only(top: h*0.01,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Icon(FontAwesome5.file_contract,color: ref.read(trueOrange),size: h*0.02),
//                 // SizedBox(width: w*0.02,),
//                 Container(
//                   // width: w*0.5,
//                   // height: h*0.05,
//                   child: Text(Uri.decodeQueryComponent(ref.read(pdkDetails)['item_number']),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,)
//                 ),
//                 SizedBox(width: w*0.04,),
//                 Icon(FontAwesome5.eye,color: ref.read(trueOrange),size: h*0.02),
//               ],
//             ),
//           )
//           :
//           Text('',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,)
//       ),
//     ),

//     Padding(
//       padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
//       child: Container(
//         height: h*0.05,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: ref.read(trueOrange).withOpacity(1),
//         ),
//         child:Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(FontAwesome5.check,color: ref.read(truewhite),size: h*0.02),
//             SizedBox(width: w*0.02,),
//             Center(child: Text('Ya , buka peti baru',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
//           ],
//         ),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.only(top: h*0.0,bottom: h*0.01 ,left: w*0.04,right: w*0.02),
//       child: InkWell(
//         onTap: (){
//           print('in else');
//           ref.read(findPDKprov.notifier).init();
//           setState(() {
//             controller!.resumeCamera();
//             result=null;
//           });
//         },
//         child: Container(
//           height: h*0.05,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: ref.read(trueOrange),
//               width: 2
//             ),
//             color: ref.read(truewhite).withOpacity(1),
//           ),
//           child:Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(FontAwesome5.times,color: ref.read(trueOrange),size: h*0.02),
//               SizedBox(width: w*0.02,),
//               Center(child: Text('Tidak , imbas semula',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(trueOrange)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
//             ],
//           ),
//         ),
//       ),
//     ),
//   ],
// );
