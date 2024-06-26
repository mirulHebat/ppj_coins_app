import 'dart:async';
import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
// import 'package:iFleet_app/riverpod/utilities/strings.dart';



class findList1
{
  Future saveList(Map<String, dynamic> info) async {
  print('di sini');
  print(info);

  String? title;
  String? partId;
  String? cost;
  String? partName;
  String? total;
  String? quantity;
  String? totQuant;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  Map<String, dynamic> POContainer = {};

  info['title'] != null ? title = ''+info['title']+'' : title ='';
  info['part_id'] != null ? partId = ''+info['part_id']+'' : partId ='';
  info['disp_part_id'] != null ? partName = ''+info['disp_part_id']+'' : partName ='';
  info['quantity'] != null ? quantity = ''+info['quantity']+'' : quantity = '0';
  info['total_quantity_received'] != null ? totQuant = ''+info['total_quantity_received']+'' : totQuant = '0';
  info['unit_cost'] != null ? cost = ''+info['unit_cost']+'' : cost = '0';
  info['subtotal'] != null ? total = ''+info['subtotal']+'' : total = '0';
  

  http.Response response;
   var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-f8b2481a6a254a5e952d1da51411533e",'+
          '"item_id":"",'+
          '"item_number":"",'+
          '"title":"POLI '+title+' '+partName+'",'+
          '"part_id":"'+partId+'",'+
          '"item_type_id_part_id":"ityp-1871f3d837fe4c6491589bad16687506",'+
          '"disp_part_id":"'+partName+'",' +
          '"quantity":'+quantity+','+
          '"total_quantity_received":'+totQuant+','+
          '"unit_cost":'+cost+','+
          '"subtotal":'+total+''+
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
  // var cufrentPoli =[];
  if (response.statusCode == 200) {
    print('status is 200');
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
        print(response.body);
        print('This is POLI: $result');
          POContainer.addAll({
            'title_POLI': result['title'],
            'id_POLI': result['item_id'], 
            'item_type_POLI' : result['item_type_id'],
            'item_number_POLI' : result['item_number'],
            'item_type_code_POLI' : result['item_type_code' ],
            // 'title' : info['title_PO'],
            // 'item_id' : info['item_id_PO'],
            // 'item_number' : info['item_number_PO'],
            'part_id' : info['disp_part_id'],
            'quantity' : info['quantity'],
            'unit_cost' : info['unit_cost'],
            'subtotal' : info['subtotal']
          });
        
    } else {

      print(response.body);

    }
  } else {
    print('Request failed with status code: ${response.statusCode}');
    }

    return POContainer;
}


Future updateItems(List<dynamic> info, String title, String id, String itemNum) async {
 print('lets add item to PO');
 print(info);

  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  String poliArray = buildPoliArray(info);

  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"'+id+'",'+
          '"item_number":"'+itemNum+'",'+
          '"title":"'+title+'",'+ 
           poliArray+ 
      '}'+
  '}';

  print(payload);

  // print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);


  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
  }

  try{
    print('kkk');
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

String buildPoliArray(List<dynamic> info) {
  String poliArray = info.map((item) {
    return '{' +
    '"item_type_id":"${item['item_type_POLI']}",'+
    '"item_id":"${item['id_POLI']}",'+
    '"item_number":"${item['item_number_POLI']}",'+
    '"title":"${item['title_POLI']}",'+
  //  ' "inter_related_ind":false,' +
  //   '"selected_checkbox":"",' +
    '"part_id":"${item['disp_part_id']}",'+
    '"quantity":${item['quantity'] ?? 0},'+
    '"unit_cost":"${item['unit_cost'] ?? 0.0}",'+
    '"subtotal":"${item['subtotal'] ?? 0.0}"'+
    '}';
  }).join(',');

  return '"poli":[' + poliArray + ']';
}

  Future updateReceivedQty(Map<String, dynamic> info) async {
  print('di sini');
  print(info);

  String? title;
  // String? partId;
  // String? cost;
  // String? partName;
  String? total;
  // String? quantity;
  String? id;
  String? totQuant;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  Map<String, dynamic> POContainer = {};

  print(info['received'].runtimeType);

  info['id'] != null ? id = ''+info['id']+'' : id =''; 
  info['title'] != null ? title = ''+info['title']+'' : title ='';
  // info['part_id'] != null ? partId = ''+info['part_id']+'' : partId ='';
  // info['disp_part_id'] != null ? partName = ''+info['disp_part_id']+'' : partName ='';
  // info['quantity'] != null ? quantity = ''+info['quantity']+'' : quantity = '0';
  // info['received'] != null ? totQuant = ''+info['received'].toString()+'' : totQuant = '0';
  totQuant = info['received'].toString();
  total = info['total']['value'].toString();
  // info['total']['value'] != null ? total = ''+info['total']['value']+'' : total = '0';
  

  http.Response response;
   var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-f8b2481a6a254a5e952d1da51411533e",'+
          '"item_id":"'+id+'",'+
          // '"item_number":"",'+
          '"title":"'+title+'",'+
          // '"part_id":"'+partId+'",'+
          // '"item_type_id_part_id":"ityp-1871f3d837fe4c6491589bad16687506",'+
          // '"disp_part_id":"'+partName+'",' +
          // '"quantity":'+quantity+','+
          '"total_quantity_received":'+totQuant+','+
          // '"unit_cost":'+cost+','+
          '"subtotal": '+total+''
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
  // var cufrentPoli =[];
  if (response.statusCode == 200) {
    print('status is 200');
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
        print(response.body);
        print('This is POLI: $result');
          POContainer.addAll({
            'title_POLI': result['title'],
            'id_POLI': result['item_id'], 
            'item_type_POLI' : result['item_type_id'],
            'item_number_POLI' : result['item_number'],
            'item_type_code_POLI' : result['item_type_code' ],
            // 'title' : info['title_PO'],
            // 'item_id' : info['item_id_PO'],
            // 'item_number' : info['item_number_PO'],
            'part_id' : info['disp_part_id'],
            'quantity' : info['quantity'],
            'unit_cost' : info['unit_cost'],
            'subtotal' : info['subtotal']
          });
        
    } else {

      print(response.body);

    }
  } else {
    print('Request failed with status code: ${response.statusCode}');
    }

    return POContainer;
}
}


