import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';

class PODetail{
  Future <List<Map<String, dynamic>>> createList(String id) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> itemID = [];
      http.Response response;
      print('Here in Po parts list8ing');
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"item_id":"'+id+'",' +
      '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",' +
       '"details":["item_id","item_number","item_type_id","metadata"]'+
      '}');
     
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Parto Response: $result');
        List<dynamic> parts = result['results'];
        print(parts);
        for(var item in parts){
          itemID.add(item);
        }
        // for (var item in parts) {
        //   itemID.add({
        //     'title': item['metadata']['poli'][0]['title'],
        //     'id': item['metadata']['poli'][0]['item_id'],
        //     'part': item['metadata']['poli'][0]['part_id']['title'],
        //     'quantity': item['metadata']['poli'][0]['quantity'],
        //     'cost': item['metadata']['poli'][0]['unit_cost'],
        //     'total': item['metadata']['poli'][0]['subtotal'],
        //   });
        // }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      return itemID;

}

Future  updatePD(Map<String,dynamic> info) async {
  print('di sini Purchase Details');
  print(info);

  String? title;
  // String? poId;
  String? pdid;
  // String? recDate;
  // String? closeDate;
  String? appDate;
  String? rejDate;
  String? profId;
  String? profName;
  String? profType;
  String? pdNo;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  info['purchase_details_title'] != null ? title = ''+info['purchase_details_title']+'' : title ='';
  info['purchase_details_number'] != null ? pdNo = ''+info['purchase_details_number']+'' : pdNo ='';
  // info['item_number'] != null ? poId = ''+info['item_number']+'' : poId ='';
  // info['received_at'] != null ? recDate = ''+info['received_at']+'' : recDate ='';
  // info['closed_at'] != null ? closeDate = ''+info['closed_at']+'' : closeDate ='';
  info['approved'] != null ? appDate = ''+info['approved']+'' : appDate ='';
  info['rejected'] != null ? rejDate = ''+info['rejected']+'' : rejDate ='';
  info['profId'] != null ? profId = ''+info['profId']+'' : profId ='';
  info['profType'] != null ? profType = ''+info['profType']+'' : profType ='';
  info['profName'] != null ? profName = ''+info['profName']+'' : profName ='';
  info['purchase_details_id'] != null ? pdid = ''+info['purchase_details_id']+'' : pdid ='';
  

  http.Response response;
   var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-49630aeb0935456dbbdefe34f6579c8b",' +
          '"item_id":"'+pdid+'",' +
          '"item_number":"'+pdNo+'",' +
          '"title":"'+title+'",'+

          // '"purchase_order_number":"'+poId+'",'+
          // '"item_type_id_purchase_order_number":"ityp-c14e446065e443ecb57b96519322480e",' +
          // '"disp_purchase_order_number":"Purchase Order for '+title+'",' +
          // '"submitted_for_approval_at":"31/05/2024",' +

          '"approval_by":"'+profId+'",' +
          '"item_type_id_approval_by":"'+profType+'",' +
          '"disp_approval_by":"'+profName+'",' +
          '"approved_at":"'+appDate+'",'+
          '"rejected_at":"'+rejDate+'",'+

          // '"received_full_by":"cn002-f1883bdaf37c4885839f0d7feb2f51dc",'+
          // '"item_type_id_received_full_by":"ityp-11962a26708945e0a67be504cf31def6",'+
          // '"disp_received_full_by":"Nazri Baksis",'+
          // '"received_full_at":"'+recDate+'",'+

          // '"closed_by":"cn002-7e80168623c94821802df354590f448a",' +
          // '"item_type_id_closed_by":"ityp-11962a26708945e0a67be504cf31def6",' +
          // '"disp_closed_by":"Amir Firdaus bin Rosman",'+
          // '"closed_at":"'+closeDate+'"' +
      '}'+
  '}';

    print(payload);

    var usell = Uri.encodeQueryComponent(payload);

  print('ajax req');

  print('saveds item');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }
  print(usell);
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print('status is 200');
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
        print(response.body); 
    } else {

      print(response.body);

    }
  } else {
    print('Request failed with status code: ${response.statusCode}');
    }
}

Future <List<Map<String, dynamic>>> findContacts() async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> contacts = [];
      http.Response response;
      print('Here in to find contacts');
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"LIST_ITEM",'+
      '"item_id":"",' +
      '"item_type_ids":["ityp-11962a26708945e0a67be504cf31def6"],' +
       '"details":["item_id","item_number","item_type_id","title"]'+
      '}');
     
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Parto Response: $result');
        List<dynamic> cn = result['results'];
        print(cn);
        for(var item in cn){
          contacts.add(item);
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      return contacts;

}
}