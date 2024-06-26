import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';


class findList2
{
  Future <List<String>> createPD(String title, String id, String profId, String profType, String profName, String today) async {
  print('di sini Purchase Details');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  List<String> PD = [];
  

  http.Response response;
   var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-49630aeb0935456dbbdefe34f6579c8b",' +
          '"item_id":"",' +
          '"item_number":"",' +
          '"title":"Purchase Details for '+title+'",'+

          '"created_by":"'+profId+'",'+
          '"item_type_id_created_by":"'+profType+'",' +
          '"disp_created_by":"'+profName+'",' +

          '"purchase_order_number":"'+id+'",'+
          '"item_type_id_purchase_order_number":"ityp-c14e446065e443ecb57b96519322480e",' +
          '"disp_purchase_order_number":"Purchase Order for '+title+'",' +
          '"submitted_for_approval_at":"",' +

          '"approval_by":"",' +
          '"item_type_id_approval_by":"",' +
          '"disp_approval_by":"",' +
          '"approved_at":"",'+
          '"rejected_at":"",'+

          '"purchased_by":"'+profId+'",'+
          '"item_type_id_purchased_by":"'+profType+'",' +
          '"disp_purchased_by":"'+profName+'",'+
          '"purchased_at":"'+today+'",'+

          '"received_full_by":"",'+
          '"item_type_id_received_full_by":"",'+
          '"disp_received_full_by":"",'+
          '"received_full_at":"",'+

          '"closed_by":"",' +
          '"item_type_id_closed_by":"",' +
          '"disp_closed_by":"",'+
          '"closed_at":""' +
          
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
  // print(usell);
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print('status is 200');
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
        print(response.body);
        print('This is PD: $result');
        if (result.containsKey('item_id')) {
          PD.add(result['item_id']);
          PD.add(result['item_type_id']);
          PD.add(result['title']);
    }
          // findList1().updateItems(POContainer);

        
    } else {

      print(response.body);

    }
  } else {
    print('Request failed with status code: ${response.statusCode}');
    }
    print(PD);
    return PD;
}


Future updateItems2(Map<String, dynamic> info) async {
 print('lets add item to PO');
  print(info);

  String? titlePOLI;
  String? titlePO;
  String? POLIid;
  String? POid;
  String? PONumber;
  String? POLINumber;
  String? POLIcode;
  // String? POLIType;
  String? cost;
  String? partName;
  String? total;
  String? quantity;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  // List<Map<String, dynamic>> POContainer = [];

  info['title'] != null ? titlePO = ''+info['title']+'' : titlePO ='';
  info['item_id'] != null ? POid = ''+info['item_id']+'' : POid ='';
  info['item_number'] != null ? PONumber = ''+info['item_number']+'' : PONumber ='';
  info['title_POLI'] != null ? titlePOLI = ''+info['title_POLI']+'' : titlePOLI ='';
  info['id_POLI'] != null ? POLIid= ''+info['id_POLI']+'' : POLIid ='';
  // info['item_type_POLI'] != null ? POLIType = ''+info['item_type_POLI']+'' : POLIType ='';
  info['item_number_POLI'] != null ? POLINumber = ''+info['item_number_POLI']+'' : POLINumber ='';
  info['item_type_code_POLI'] != null ? POLIcode = ''+info['item_type_code_POLI']+'' : POLIcode ='';
  info['disp_part_id'] != null ? partName = ''+info['disp_part_id']+'' : partName ='';
  info['quantity'] != null ? quantity = ''+info['quantity']+'' : quantity = '0';
  info['unit_cost'] != null ? cost = ''+info['unit_cost']+'' : cost = '0';
  info['subtotal'] != null ? total = ''+info['subtotal']+'' : total = '0';

  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"'+POid+'",'+
          '"item_number":"'+PONumber+'",'+
          '"title":"'+titlePO+'",'+ 
          // '"effective_date":"",'+ 
          // '"notes":"",'+ 
          '"poli":['+
            '{'+
            '"item_type_id":"ityp-f8b2481a6a254a5e952d1da51411533e",' +
            '"item_type_code":"'+POLIcode+'",' +
            '"item_id":"'+POLIid+'",' +
            '"item_number":"'+POLINumber+'",' +
            '"title":"'+titlePOLI+'",' +
            '"part_id":"'+partName+'",' +
            '"quantity":'+quantity+',' +
            '"unit_cost":'+cost+',' +
            '"subtotal":'+total+'' +
            '}' +
          ']' +

      '}'+
  '}';

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  try{
    http.Response response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
    Map result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      print('status is 200');
      Map<String, dynamic> result = json.decode(response.body);
      if (result['success'] == true) {
          Map<String, dynamic> result = json.decode(response.body);
          print('We have add the POLI into PO: $result');
        
      } 
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }catch(e){
    print(e.toString());
  }
}

Future <List<Map<String, dynamic>>> getPD(String id)async{
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  List<Map<String,dynamic>> PD = [];
  

  http.Response response;
   var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"item_id":"'+id+'",' +
      '"item_type_id":"ityp-49630aeb0935456dbbdefe34f6579c8b",' +
      '"details":["item_id","item_number","item_type_id","metadata"]'+
        '}';

    print(payload);

    var usell = Uri.encodeQueryComponent(payload);

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }
  response = await http.get(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print('status is 200');
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
        print(response.body);
        print('This is PD: $result');
        List<dynamic> pds = result['results'];

        for(var item in pds){
          print(item);
          PD.add({
            'recBy' : item['metadata']['received_full_by'],
            'recAt' : item['metadata']['received_full_at'],
            'closeAt' : item['metadata']['closed_at']
          });
        }

        
    } else {

      print(response.body);

    }
  } else {
    print('Request failed with status code: ${response.statusCode}');
    }
    print(PD);
    return PD;
}

Future updateReceived(Map<String,dynamic> info) async {
  String? title;
  String? pdid;
  String? recDate;
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
  info['received_at'] != null ? recDate = ''+info['received_at']+'' : recDate ='';
  // info['closed_at'] != null ? closeDate = ''+info['closed_at']+'' : closeDate ='';
  info['recId'] != null ? profId = ''+info['recId']+'' : profId ='';
  info['recType'] != null ? profType = ''+info['recType']+'' : profType ='';
  info['recName'] != null ? profName = ''+info['recName']+'' : profName ='';
  info['purchase_details_id'] != null ? pdid = ''+info['purchase_details_id']+'' : pdid ='';

  print('received');
  // print(info);
  print(title);
  print(profName);
  

  http.Response response;
   var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-49630aeb0935456dbbdefe34f6579c8b",' +
          '"item_id":"'+pdid+'",' +
          '"item_number":"'+pdNo+'",' +
          '"title":"'+title+'",'+


          '"received_full_by":"'+profId+'",'+
          '"item_type_id_received_full_by":"'+profType+'",'+
          '"disp_received_full_by":"'+profName+'",'+
          '"received_full_at":"'+recDate+'",'+

      '}'+
  '}';

    print(payload);

    var usell = Uri.encodeQueryComponent(payload);


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

Future updateClosed(Map<String,dynamic> info) async {
  String? title;
  String? pdid;
  String? closeDate;
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
  info['closed_at'] != null ? closeDate = ''+info['closed_at']+'' : closeDate ='';
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


          // '"received_full_by":"cn002-f1883bdaf37c4885839f0d7feb2f51dc",'+
          // '"item_type_id_received_full_by":"ityp-11962a26708945e0a67be504cf31def6",'+
          // '"disp_received_full_by":"Nazri Baksis",'+
          // '"received_full_at":"'+recDate+'",'+

          '"closed_by":"'+profId+'",' +
          '"item_type_id_closed_by":"'+profType+'",' +
          '"disp_closed_by":"'+profName+'",'+
          '"closed_at":"'+closeDate+'"' +
      '}'+
  '}';

    print(payload);

    var usell = Uri.encodeQueryComponent(payload);


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
}


