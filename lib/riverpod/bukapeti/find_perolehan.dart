// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'package:tuple/tuple.dart';

final pdkDetails = StateProvider((ref) {
  return {};
});

final bukaPetiDet = StateProvider((ref) {
  return {};
});

final companyDet = StateProvider((ref) {
  return {};
});

final createPembida = StateProvider((ref) {
  return {};
});

final updateBPDet = StateProvider((ref) {
  return {};
});

final senaraiPembida = StateProvider((ref) {
  return [];
});

final totalPembida = StateProvider((ref) {
  return 0;
});

final selectedtempoh = StateProvider((ref) {
  return 'Hari';
});

final scannedPDKref = StateProvider((ref) {
  return '';
});

final selectedJDC = StateProvider<List>((ref) {
  return [];
});


final selectedJDCObj = StateProvider((ref) {
  return '';
});

final selectedDiscount = StateProvider((ref) {
  return '';
});

final nilaiBida = StateProvider<double>((ref) {
  return 0;
});

final tempohProjek = StateProvider<int>((ref) {
  return 0;
});

final nilaiDiscount = StateProvider<double>((ref) {
  return 0;
});

final pageindex = StateProvider<int>((ref) {
  return 0;
});

final selectedUlasan = StateProvider<List>((ref) {
  return [];
});

final selectedUlasanObj = StateProvider((ref) {
  return '';
});

final ulasanOthers = StateProvider((ref) {
  return '';
});





final findPDKprov =StateNotifierProvider.autoDispose<GetPerolehanData, AsyncValue>((ref) => GetPerolehanData(ref.read));
class GetPerolehanData extends StateNotifier<AsyncValue>{
  GetPerolehanData(this.read):super(const AsyncData('idle'));
  final read;

  void init() async{
    print('in init');
    state = const AsyncData('idle');
  }

  void addPembidaQR(pdkID,compID,WidgetRef ref) async {
    print('in add QR');
    state = AsyncLoading();
    // });
    


    http.Response response;

    print('begin get BukaPETI'); //first step getbukaptei data
    var url='{'+
      '"bims_access_id": "'+ref.read(bims)+'",'+
      '"action": "ADVANCED_SEARCH",'+
      '"item_type_codes": ["bpp03"],'+
      '"sort_field": "",'+
      '"sort_order": "ASC",'+
      '"details": ["item_id", "item_number", "title","metadata"],'+
      '"metadata_details": ["Jawatankuasa","Senarai_Pembida","Jumlah_Pembida","container_id"],'+
      '"query": "( container_id = &quot;'+pdkID+'&quot; )"'+
      '}'+
    '}';
    var encURL=Uri.encodeQueryComponent(url);
    print("https://"+read(mainURL)+"/bims-web/ItemSearch?param=$encURL");
    print(headers);
    try{
      http.Response response = await http.post(Uri.parse("https://"+read(mainURL)+"/bims-web/ItemSearch?param=$encURL"),
        headers: headers);
      Map result= json.decode(response.body);
      print('got BukaPETI');
      print(result);
      if(result['success']==true && result['code'] == 200 && result['results'].length >0){
        //result > 0 > itemID
        print('BUKAPETI OK');
        ref.read(bukaPetiDet.notifier).state=result['results'][0];
        print('ref.read(bukaPetiDet)');
        print(ref.read(bukaPetiDet));

        if(result['results'][0]['metadata']['Senarai_Pembida']!=null){
          ref.read(senaraiPembida.notifier).state =result['results'][0]['metadata']['Senarai_Pembida'];
        }
        print(ref.read(senaraiPembida));

        ref.read(totalPembida.notifier).state =result['results'][0]['metadata']['Jumlah_Pembida'];
        print(ref.read(totalPembida));

        ref.read(scannedPDKref.notifier).state =result['results'][0]['metadata']['container_id']['item_number'];
        print('ref.read(scannedPDKref).toString()');
        print(ref.read(scannedPDKref).toString());

        var tempList =[];
        ref.read(senaraiPembida).forEach((element) {
          print(element['Syarikat']);
          tempList.add(element['Syarikat']['item_id']);
        });
        var jwtk_id =result['results'][0]['metadata']['Jawatankuasa']['item_id'];
        print('begin get AJK'); //second step check ajk layak
        var url='{'+
          '"bims_access_id": "'+ref.read(bims)+'",'+
          '"action": "ADVANCED_SEARCH",'+
          '"item_type_codes": ["jwtk"],'+
          '"sort_field": "",'+
          '"sort_order": "ASC",'+
          '"details": ["item_id", "item_number", "title","metadata"],'+
          '"metadata_details": ["Senarai_Ahli_Jawatankuasa"],'+
          '"query": "( item_id = &quot;'+jwtk_id+'&quot; )"'+
          '}'+
        '}';
        var encURL=Uri.encodeQueryComponent(url);
        print("https://"+read(mainURL)+"/bims-web/ItemSearch?param=$encURL");
        try{
          http.Response response = await http.post(Uri.parse("https://"+read(mainURL)+"/bims-web/ItemSearch?param=$encURL"),
            headers: headers);
          Map result_ajk= json.decode(response.body);
          print('got AJK');
          print(result_ajk);
          if(result_ajk['success']==true && result_ajk['code'] == 200 && result_ajk['results'].length >0){
            print('AJK OK');
            var result_ahli_ajk = [];
            result_ahli_ajk=result_ajk['results'][0]['metadata']['Senarai_Ahli_Jawatankuasa'];
            var senarai_ahli =[];
            result_ahli_ajk.forEach((element) {
              print(element['user_id']['full_name']);
              senarai_ahli.add(element['user_id']['user_id']);
            });
            print('senarai ahli >>>>>>>>>');
            print(senarai_ahli);
            print('my userid');
            print(ref.read(userID));

            if(senarai_ahli.contains(ref.read(userID))){ // all ok ajk layak
              if(tempList.contains(compID)){
                state = AsyncData('Duplicate '+ (tempList.indexOf(compID).toString()) + ' '+result['results'][0]['metadata']['Jumlah_Pembida'].toString());
              }else{
                print('begin get COMPANY');      
                var url='{'+
                  '"bims_access_id": "'+ref.read(bims)+'",'+
                  '"action": "ADVANCED_SEARCH",'+
                  '"item_type_codes": ["sy001"],'+
                  '"sort_field": "",'+
                  '"sort_order": "ASC",'+
                  '"details": ["item_id", "item_number", "title"],'+
                  '"query": "( item_id = &quot;'+compID+'&quot; )"'+
                  '}'+
                '}';
                var encURL=Uri.encodeQueryComponent(url);
                print("https://"+read(mainURL)+"/bims-web/ItemSearch?param=$encURL");
                try{
                  http.Response response = await http.post(Uri.parse("https://"+read(mainURL)+"/bims-web/ItemSearch?param=$encURL"),
                    headers: headers);
                  Map result_company= json.decode(response.body);
                  print('got COMPANY');
                  print(result_company);
                  if(result_company['success']==true && result_company['code'] == 200 && result_company['results'].length >0){
                    print('COMPANY OK');
                    ref.read(companyDet.notifier).state =result_company['results'][0];
                    print(result_company['results'][0]);

                    if(ref.read(senaraiPembida).isEmpty){
                      state = const AsyncData('First');
                    }else if(ref.read(senaraiPembida).length >=ref.read(totalPembida)){
                      state = const AsyncData('Full');
                    }else{
                      state = const AsyncData('Selesai');
                    }            
                  } else if(result_company['success']==true && result_company['code'] == 200 && result_company['results'].length == 0){
                    print('pdk EMPTY');
                    state = const AsyncData('Syarikat tidak wujud');
                  } else {
                    print(result_company);
                    state = AsyncData(result_company['message']);
                  }
                  
                  
                } on TimeoutException {
                  AsyncError('Timeout',StackTrace.current);
                  return;
                } on SocketException {
                  AsyncError('Socket Exc.',StackTrace.current);
                } on FormatException{
                  AsyncError('Format Exc.',StackTrace.current);
                } on Error catch (e) {
                  AsyncError('Error',StackTrace.current);
                }

                
              }
            }else if(!senarai_ahli.contains(ref.read(userID))){ // ajk tidak layak
              state = const AsyncData('Anda tidak dilantik sebagai ahli jawatankuasa buka peti ini');
            }else{
              state = const AsyncData('Ralat dalam menyemak ahli jawatankuasa'); // error in checking layak
            }             
          } else if(result_ajk['success']==true && result_ajk['code'] == 200 && result_ajk['results'].length == 0){
            print('AJK EMPTY');
            state = const AsyncData('Ahli Jawatankuasa tidak wujud bagi buka peti ini');
          } else {
            print(result_ajk);
            state = AsyncData(result_ajk['message']);
          }
          
        } on TimeoutException {
          AsyncError('Timeout',StackTrace.current);
          return;
        } on SocketException {
          AsyncError('Socket Exc.',StackTrace.current);
        } on FormatException{
          AsyncError('Format Exc.',StackTrace.current);
        } on Error catch (e) {
          AsyncError('Error',StackTrace.current);
        }
        

        
        
        // state = const AsyncData('Selesai');
      } else if(result['success']==true && result['code'] == 200 && result['results'].length == 0){
        print('pdk EMPTY');
        state = const AsyncData('Buka Peti tidak wujud');
      } else {
        print(result);
        state = AsyncData(result['message']);
      }
      
    } on TimeoutException {
      AsyncError('Timeout',StackTrace.current);
      return;
    } on SocketException {
      AsyncError('Socket Exc.',StackTrace.current);
    } on FormatException{
      AsyncError('Format Exc.',StackTrace.current);
    } on Error catch (e) {
      AsyncError('Error',StackTrace.current);
    }
    
  }
}

final crAndUpdBP =StateNotifierProvider.autoDispose<CreateAndUpdateBP, AsyncValue>((ref) => CreateAndUpdateBP(ref.read));
class CreateAndUpdateBP extends StateNotifier<AsyncValue>{
  CreateAndUpdateBP(this.read):super(const AsyncData('idle'));
  final read;


  void init() async{
    print('in init');
    state = const AsyncData('idle');
  }

  void updatePeti(nilai,tempoh,jenis,jdc,WidgetRef ref) async {
    print('in add QR');
    state = AsyncLoading();

    print('begin create PEMBIDA');
    // {
    //     "bims_access_id": "coin2-54a221f3c8a9494093a22f7e558d4947",
    //     "action": "SAVE_ITEM",
    //     "metadata": {
    //         "item_type_id": "ityp-ebbb3cce89f64fa484ad3871cc66397e",
    //         "item_id": "pbida-9d56823110e14038b5d47a861a3b9078",
    //         "item_number": "PEMBIDA/202301/000031",
    //         "title": "Syarikat Ammar",
    //         "container_id": "bpp03-032a0bcbc03440e2b92b2912715dff7d",
    //         "item_type_id_container_id": "ityp-c9aef6ee01534e8989257a58983baf05",
    //         "disp_container_id": "CADANGAN PENYELENGAARAAN DAN PERKHIDMATAN MENAIKTARAF PEMBANGUNAN DAN PELAKSANAAN SISTEM MAKLUMAT PENGURUSAN KONTRAK (COINS) DI PERBADANAN PUTRAJAYA edit",
    //         "Bil_Penyebut_Harga": 1,
    //         "Syarikat": "sy001-a1bdb261ff1347188e7cd22b7f9373f8",
    //         "item_type_id_Syarikat": "ityp-af849b93e5fc4b358874a06973d56c05",
    //         "disp_Syarikat": "Syarikat Ammar",
    //         "Nilai_Bidaan_Projek": 250000,
            // "No_Kod_Petender": "2/2",
    //         "tempoh": 3,
    //         "jenis_tempoh": {
    //             "code": "",
    //             "value": "Tahun",
    //             "display": "Tahun"
    //         }
    //     }
    // }


    var jenistempoh='';
    jenistempoh =
    '{'+
      '"code":"",'+
      '"value":"'+jenis+'",'+
      '"display":"'+jenis+'",'+
    '}';
    
    print('NILAI STR');
    print(nilai.toString());
    var url='{'+
      '"bims_access_id":"'+ref.read(bims)+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_code":"pbida",'+
          '"item_id":"",'+
          '"item_number":"",'+
          '"title":"'+read(companyDet)['title']+'",'+
          '"container_id":"'+read(bukaPetiDet)['item_id']+'",'+
          '"Bil_Penyebut_Harga":'+(read(senaraiPembida).length+1).toString()+','+
          '"Syarikat":"'+read(companyDet)['item_id']+'",'+
          '"disp_Syarikat":"'+read(companyDet)['title']+'",'+
          '"Nilai_Bidaan_Projek":'+nilai.toString()+','+
          '"No_Kod_Petender":"'+(read(senaraiPembida).length+1).toString()+'/'+read(totalPembida).toString()+'",'+
          '"tempoh":'+tempoh.toString()+','+
          '"jenis_tempoh":'+jenistempoh+','+
          '"Jenis_Dok_Cadangan":['+jdc+'],'+
          '"Ulasan_Buka_Peti":['+ref.read(selectedUlasanObj)+'],'+
          '"Ulasan":"'+ref.read(ulasanOthers)+'",'+
          '"Kadar_Diskaun":'+ref.read(nilaiDiscount).toString()+','+
          '"Indikator_Kadar_Diskaun":{"code":"", "value": "'+ref.read(selectedDiscount).toLowerCase()+'", "display":"'+ref.read(selectedDiscount)+'"}'+



        '}'+
    '}';
    var encURL=Uri.encodeQueryComponent(url);
    print('"Jenis_Dok_Cadangan":['+jdc+'],'+
          '"Ulasan_Buka_Peti":['+ref.read(selectedUlasanObj)+'],'+
          '"Ulasan":"'+ref.read(ulasanOthers)+'",'+
          '"Kadar_Diskaun":'+ref.read(nilaiDiscount).toString()+','+
          '"Indikator_Kadar_Diskaun":{"code":"", "value": "'+ref.read(selectedDiscount).toLowerCase()+'", "display":"'+ref.read(selectedDiscount)+'"}'
);
    try{
      print('sending create PEMBIDA');
      http.Response response = await http.post(Uri.parse("https://"+read(mainURL)+"/bims-web/Item?param=$encURL"),
        headers: headers);
      Map result= json.decode(response.body);
      print('got create PEMBIDA');
      print(result);
      if(result['success']==true && result['code'] == 200){
        print('CREATEBIDA OK');
        ref.read(createPembida.notifier).state=result;
        // print(result['results'][0]);
        // state = const AsyncData('Selesai');

        print('begin update BUKAPETI'); 
        print(ref.read(senaraiPembida));
        var senaraipembidaStr ='';
        for(int i = 0 ; i<ref.read(senaraiPembida).length ; i++ ){
          print(ref.read(senaraiPembida)[i]);
          print('senaraipembidaStr');

          senaraipembidaStr =senaraipembidaStr+ 
            '{'+
              '"title": "'+ref.read(senaraiPembida)[i]['title']+'",'+
              '"tempoh": "'+ref.read(senaraiPembida)[i]['tempoh'].toString()+'",'+
              '"item_id": "'+ref.read(senaraiPembida)[i]['item_id']+'",'+
              '"Syarikat": "'+ref.read(senaraiPembida)[i]['Syarikat']['title']+'",'+
              '"item_number": "'+ref.read(senaraiPembida)[i]['item_number']+'",'+
              '"jenis_tempoh": "'+ref.read(senaraiPembida)[i]['jenis_tempoh']['display']+'",'+
              '"item_type_code": "pbida",'+
              '"Bil_Penyebut_Harga": '+ref.read(senaraiPembida)[i]['Bil_Penyebut_Harga'].toString()+','+
              '"Nilai_Bidaan_Projek": '+ref.read(senaraiPembida)[i]['Nilai_Bidaan_Projek']['display'].toString()+','+
            '},';
          print('senaraipembidaStr');
          print(senaraipembidaStr);
        }
        print('senaraipembidaStr');
        print(senaraipembidaStr);

        var url='{'+
          '"bims_access_id": "'+ref.read(bims)+'",'+
          '"action": "SAVE_ITEM",'+
          '"metadata": {'+
            '"item_type_code": "bpp03",'+
            '"item_id": "'+ref.read(bukaPetiDet)['item_id']+'",'+
            '"Senarai_Pembida": ['+
                senaraipembidaStr +
                '{'+
                  '"title": "'+ref.read(bukaPetiDet)['title']+'",'+
                  '"tempoh": '+tempoh.toString()+','+
                  '"item_id": "'+ref.read(createPembida)['item_id']+'",'+
                  '"Syarikat": "'+ref.read(companyDet)['item_id']+'",'+
                  '"item_number": "'+ref.read(createPembida)['item_number']+'",'+
                  '"jenis_tempoh": '+jenistempoh+','+
                  '"item_type_code": "pbida",'+
                  '"Bil_Penyebut_Harga": '+(ref.read(senaraiPembida).length+1).toString()+','+
                  '"Nilai_Bidaan_Projek": "'+nilai.toString()+'",'+
                '}'+
              '],'+
            '"Jumlah_Pembida": "'+ref.read(totalPembida).toString()+'",'+
          '}'+
        '}';
              
          
        
        var encURL=Uri.encodeQueryComponent(url);
        print("https://"+read(mainURL)+"/bims-web/Item?param=$encURL");
        try{
          http.Response response = await http.post(Uri.parse("https://"+read(mainURL)+"/bims-web/Item?param=$encURL"),
            headers: headers);
          Map result= json.decode(response.body);
          print('got update BUKAPETI');
          print(result);
          if(result['success']==true && result['code'] == 200){
            print('update BUKAPETI OK');
            result['nilai']=nilai;
            result['tempoh']=tempoh;
            result['jenis']=jenis;

            ref.read(updateBPDet.notifier).state=result;
            print( ref.read(updateBPDet));
            // print(result['results'][0]);
            var box = Hive.box('lastLogin');
            //print('prepare');
            var userdata = box.get('userFSP');
            //print('prepare 1');

            var userHistory = [];
            //print('prepare 1.1');
            print(userdata);

            userHistory=ref.read(actHistoryProv).getActions(userdata[1]);
            //print('prepare 2');

            var temp =[];
            temp.add('Tambah Pembida'); // Action Title 0
            temp.add( (ref.read(senaraiPembida).length+1).toString()+'/'+ref.read(totalPembida).toString()+' - '+ref.read(companyDet)['title']); // Action Description 1
            var now = DateTime.now();
            var time = DateFormat("h:mma").format(now);
            temp.add(now.day.toString()+'/'+now.month.toString()+'/'+now.year.toString()+' pada '+time.toString()); // Action Time 2
            temp.add(ref.read(scannedPDKref)); // Action Perolehan 3
            //print('prepare 3');
            
            userHistory.add(temp);
            //print('prepare 4');
            ref.invalidate(actHistoryProv);
            ref.read(actHistoryNotifier.notifier).setActions(userdata[1],userHistory );

            state = const AsyncData('Selesai');
          }  else {
            print(result);
            state = AsyncData(result['message']);
          }
          
        } on TimeoutException {
          AsyncError('Timeout',StackTrace.current);
          return;
        } on SocketException {
          AsyncError('Socket Exc.',StackTrace.current);
        } on FormatException{
          AsyncError('Format Exc.',StackTrace.current);
        } on Error catch (e) {
          AsyncError('Error',StackTrace.current);
        }
      } else {
        print(result);
        state = AsyncData(result['message']);
      }
      
    } on TimeoutException {
      AsyncError('Timeout',StackTrace.current);
      return;
    } on SocketException {
      AsyncError('Socket Exc.',StackTrace.current);
    } on FormatException{
      AsyncError('Format Exc.',StackTrace.current);
    } on Error catch (e) {
      AsyncError('Error',StackTrace.current);
    }

    

    
  }
}

//// DATA /////////////
final jenisDokCdg = Provider<JenisDokCadang>((ref) => JenisDokCadang());

final getJenisDok = FutureProvider.family<List , WidgetRef>((ref,widgetref) {
  final jdcProv = ref.watch(jenisDokCdg);
  return jdcProv.getJenisDok(widgetref);
});

final getJenPeroleh = FutureProvider.autoDispose.family<List , Tuple3<String,String,WidgetRef>>((ref,tuple) {
  final jdcProv = ref.watch(jenisDokCdg);
  return jdcProv.getJenisPerolehan(tuple);
});

final getIndDiscount = FutureProvider.family<List , Tuple2<String,WidgetRef>>((ref,str) {
  print('get ind');
  final jdcProv = ref.watch(jenisDokCdg);
  return jdcProv.getIndKadarDiskaun(str);
});

final getUlasan = FutureProvider.family<List , Tuple2<String,WidgetRef>>((ref,str) {
  print('get ind');
  final jdcProv = ref.watch(jenisDokCdg);
  return jdcProv.getUlasanBukaPeti(str);
});

final selected_jenisDC = FutureProvider((ref) {
  final loc_DB = ref.watch(jenisDokCdg);
  return loc_DB.readSelected();
});


class JenisDokCadang {

  List jenisDokCadangan=[];
  List jenisDokPerolehan=[];
  var resultIndDisc =[];
  var resultUlasan=[];

  //page controller
  PageController controller = PageController(initialPage: 0,);
  String selected_JDC='';

  Future<String> readSelected() async {
    if(selected_JDC==''){
      selected_JDC=jenisDokCadangan[0]['display_value'];
      return selected_JDC ;
    }else{
      return selected_JDC ;
    }
  }

  Future<List> getJenisDok(ref) async {
    if(jenisDokCadangan.isEmpty){
      print('begin GET jenisDokCadang'); 
      var url='{'+
        '"bims_access_id": "'+(ref.read(bims))+'",'+
        '"action": "LIST_VALUE_ITEMS_ACTIVE",'+
        '"list_of_value_code": "JenisDokCadangan",'+
        '"details": ["code", "value", "display_value", "ref_code"]'+
      '}';
      var encURL=Uri.encodeQueryComponent(url);
      print("https://"+ref.read(mainURL)+"/bims-web/ListOfValue?param=$encURL");
      try{
        http.Response response = await http.get(Uri.parse("https://"+ref.read(mainURL)+"/bims-web/ListOfValue?param=$encURL"),
          headers: headers);
        Map result= json.decode(response.body);
        print('got jenisDokCadang');
        print(result);
        if(result['success']==true && result['code'] == 200){
          print('jenisDokCadang OK');
          jenisDokCadangan=result['results'];
          // print(result['results'][0]);
          return jenisDokCadangan;
        }  else {
          return jenisDokCadangan;
        }
        
      }on Error catch (e) {
        var errorr = [];
        errorr.add(e);
        return errorr ;
      }
    }else{
      return jenisDokCadangan;
    }
  }

  Future<List> getIndKadarDiskaun(data) async {
    var bims =data.item1;
    WidgetRef ref =data.item2;
    if(resultIndDisc.isEmpty){
      print('begin getIndKadarDiskaun'); 
      var url='{'+
        '"bims_access_id": "'+(bims)+'",'+
        '"action": "LIST_VALUE_ITEMS_ACTIVE",'+
        '"list_of_value_code": "IndKadarDiskaun",'+
        '"details": ["code", "value", "display_value", "ref_code"]'+
      '}';
      var encURL=Uri.encodeQueryComponent(url);
      print("https://"+ref.read(mainURL)+"/bims-web/ListOfValue?param=$encURL");
      
      try{
        http.Response response = await http.get(Uri.parse("https://"+ref.read(mainURL)+"/bims-web/ListOfValue?param=$encURL"),
          headers: headers);
        Map result= json.decode(response.body);
        print('got getIndKadarDiskaun');
        print(result);
        if(result['success']==true && result['code'] == 200){
          print('getIndKadarDiskaun OK');
          resultIndDisc=result['results'];
          ref.read(selectedDiscount.notifier).state=resultIndDisc[0]['display_value'];
          // print(result['results'][0]);
          return resultIndDisc;
        }  else {
          return resultIndDisc;
        }
      }on Error catch (e) {
        var errorr = [];
        errorr.add(e);
        return errorr ;
      }
    }else{
      return resultIndDisc;
    }
    
  }

  Future<List> getUlasanBukaPeti(data) async {
    var bims=data.item1;
    WidgetRef ref = data.item2;
    if(resultUlasan.isEmpty){
      print('begin GET getUlasanBukaPeti'); 
      var url='{'+
        '"bims_access_id": "'+(bims)+'",'+
        '"action": "LIST_VALUE_ITEMS_ACTIVE",'+
        '"list_of_value_code": "UlasanBukaPeti",'+
        '"details": ["code", "value", "display_value", "ref_code"]'+
      '}';
      var encURL=Uri.encodeQueryComponent(url);
      print("https://"+ref.read(mainURL)+"/bims-web/ListOfValue?param=$encURL");
      try{
        http.Response response = await http.get(Uri.parse("https://"+ref.read(mainURL)+"/bims-web/ListOfValue?param=$encURL"),
          headers: headers);
        Map result= json.decode(response.body);
        print('got getUlasanBukaPeti');
        print(result);
        if(result['success']==true && result['code'] == 200){
          print('getUlasanBukaPeti OK');
          resultUlasan=result['results'];
          // ref.read(selectedUlasan.notifier).state=resultUlasan.first['display_value']
          // print(result['results'][0]);
          return resultUlasan;
        }  else {
          return resultUlasan;
        }
      }on Error catch (e) {
        var errorr = [];
        errorr.add(e);
        return errorr ;
      }
    }else{
      return resultUlasan;
    }
  }

  Future<List> getJenisPerolehan(tuple) async {
    var bims = tuple.item1;
    var pdkID = tuple.item2;
    var ref = tuple.item3;
    print('begin GET JenisPerolehan');
    var url='{'+
      '"bims_access_id": "'+bims+'",'+
      '"action": "ADVANCED_SEARCH",'+
      '"item_type_codes": ["pdk01"],'+
      '"sort_field": "",'+
      '"sort_order": "ASC",'+
      '"details": ["item_id", "item_number", "title"],'+
      '"query": "( item_number = &quot;'+pdkID+'&quot; && Jenis_Perolehan = &quot;Sebutharga&quot; || Jenis_Perolehan = &quot;Sebutharga B&quot;)"'+
      '}'+
    '}';
    var encURL=Uri.encodeQueryComponent(url);
    print("https://"+ref.read(mainURL)+"/bims-web/ItemSearch?param=$encURL");
    try{
      http.Response response = await http.post(Uri.parse("https://"+ref.read(mainURL)+"/bims-web/ItemSearch?param=$encURL"),
        headers: headers);
      Map result= json.decode(response.body);
      print('got GET JenisPerolehan');
      print(result);
      if(result['success']==true && result['code'] == 200){
        print('JenisPerolehan OK');
        jenisDokPerolehan=result['results'];
        // print(result['results'][0]);
        return jenisDokPerolehan;
      }  else {
        return jenisDokPerolehan;
      }
    }on Error catch (e) {
      var errorr = [];
      errorr.add(e);
      return errorr ;
    }
  }
}