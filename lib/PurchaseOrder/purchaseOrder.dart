
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class vehicleOrders{
  Future <List<Map<String, dynamic>>> createList() async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> vehicleType = [];

      http.Response response;
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"LIST_VALUE_ITEMS_ACTIVE",'+
      '"list_of_value_id": "lval-c08a1e7e31df44d7bf6b47b88b8d43f9",'+
       '"details":["code", "value", "display_value"]'+
      '}');
        print('findGap');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.get(Uri.parse('https://lawanow.com//bims-web/ListOfValue?param='+usell),headers:headersModified);
        print(Uri.encodeComponent('https://lawanow.com//bims-web/ListOfValue?param='+usell));
        print('response');
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Response: $result');
        List<dynamic> vcat = result['results'];
        for (var item in vcat) {
          vehicleType.add(item);
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      print(vehicleType);
      return vehicleType;


}
}

class createPO
{
  Future <List<Map<String, dynamic>>> saveList(Map<String, dynamic> info) async {
  print('di sini');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
  List<Map<String, dynamic>> POContainer = [];

  // String title;
  // String id;
  // String itemNum;
  String edate; 
  String? warrDate;
  String? warrMeter;
  String? currMeter;
  String? vid;
  String? vtitle;
  String? price ;
  String? disc ;
  String? subtotal ;
  String? tax ;
  String? taxsub ;
  String? ship ;
  String? totAmount ;
  String profName = '';
  String sCode = '';
  String sValue = '';
  String sDisplay = '';
  String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

  // info['title'] != null ? title = ''+info['title']+'' : title ='';
  // info['item_id'] != null ? id = ''+info['item_id']+'' : id ='';
  // info['item_number'] != null ? itemNum = ''+info['item_number']+'' : itemNum ='';
  info['effective_date'] != null ? edate = ''+info['effective_date']+'' : edate ='';
  info['warranty_expiration_date'] != null ? warrDate = ''+info['warranty_expiration_date']+'' : warrDate ='';
  info['warranty_expiration_meter_value'] != null ? warrMeter = ''+info['warranty_expiration_meter_value']+'' : warrMeter ='';
  info['current_mater_value'] != null ? currMeter = ''+info['current_mater_value']+'' : currMeter ='0';
  info['vehicle_id'] != null ? vid = ''+info['vehicle_id']+'' : vid ='';
  info['disp_vehicle_id'] != null ? vtitle = ''+info['disp_vehicle_id']+'' : vtitle ='';
  info['notes'] != null ? profName = ''+info['notes']+'' : profName ='';
  info['price'] != null ? price = ''+info['price']+'' : price ='0.00';
  info['discount_percentage'] != null ? disc = ''+info['discount_percentage']+'' : disc = '0';
  info['subtotal'] != null ? subtotal = ''+info['subtotal']+'' : subtotal ='0.00';
  info['tax_percentage'] != null ? tax = ''+info['tax_percentage']+'' : tax = '0';
  info['tax_subtotal'] != null ? taxsub = ''+info['tax_subtotal']+'' : taxsub ='0.00';
  info['shipping'] != null ? ship = ''+info['shipping']+'' : ship ='0.00';
  info['total_amount'] != null ? totAmount = ''+info['total_amount']+'' : totAmount ='0.00';
  info['status_code'] != null ? sCode = ''+info['status_code']+'' : sCode ='';
  info['status_value'] != null ? sValue = ''+info['status_value']+'' : sValue ='';
  info['status_display'] != null ? sDisplay = ''+info['status_display']+'' : sDisplay ='';

  
print('here before payload');
  // var payload = '{"bims_access_id":"'+ifleetData+'","action":"SAVE_ITEM","metadata":{"item_type_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","item_id":"","container_id":"","item_type_id_container_id":"","disp_container_id":"","item_number":"7","title":"QWE1","vehicle_type_id":null,"vehicle_status_id":null,"year":2009,"is_out_of_service":{"code":"false","value":"false","display":"No"}}}';
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"",'+
          '"item_number":"",'+
          '"title":"Purchase Order for '+vtitle+'",'+ //isi
          '"effective_date":"'+edate+'",'+ //isi
          '"notes":"'+profName+'",'+//later
          '"warranty_expiration_date":"'+warrDate+'",'+ //isi
          '"warranty_expiration_meter_value":"'+warrMeter+'",'+ //isi
          '"current_mater_value":"'+currMeter+'",'+ //isi
          '"vehicle_id":"'+vid+'",'+ //isi
          '"item_type_id_vehicle_id":"ityp-17b5fbf3478141a397d630178d8dfc1c",'+
          '"disp_vehicle_id":"'+vtitle+'",'+ //isi
          '"price":"'+price+'",'+ //isi
          '"discount_percentage":"'+disc+'",'+ //isi
          '"subtotal":"'+subtotal+'",'+ //isi
          '"tax_percentage":"'+tax+'",'+ //isi
          '"tax_subtotal":"'+taxsub+'",'+ //isi
          '"shipping":"'+ship+'",'+ //isi
          '"total_amount":"'+totAmount+'",'+ //isi
          '"purchase_order_status":  {' +
              '"code": "'+sCode+'",' +
              '"value": "'+sValue+'",' +
              '"display": "'+sDisplay+'"'+
            '}' +
      '}'+
  '}';

  
    

    print(payload);

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);
  print(usell);

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }

  try{
    http.Response response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
    print('https://lawanow.com/bims-web/Item?param=$usell');
    Map result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      print('status is 200');
      Map<String, dynamic> result = json.decode(response.body);
      if (result['success'] == true) {
          // print(response.body);
          Map<String, dynamic> result = json.decode(response.body);
          print('Response: $result');
          if (result['success'] == true) {
          Map<String, dynamic> result = json.decode(response.body);
          print('Response: $result');
             POContainer.add({
                    'title': result['title'],
                    'id': result['item_id'], 
                    'item_type' : result['item_type_id'],
                    'item_number' : result['item_number'],
                    'item_type_code' : result['item_type_code'],
                    'registered_date' : today
                  });
          
      }
          
          
      } 
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }catch(e){
    print(e.toString());
  }
  print('here is the PO Container');
  print(POContainer);
  return POContainer;
  
}

Future  saveEdits(Map<String, dynamic> info) async {
  print('di sini save edit');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  String title;
  String id;
  String itemNum;
  String edate; 
  String? warrDate;
  String? warrMeter;
  String? currMeter;
  String? vid;
  String? vtitle;
  String? price ;
  String? disc ;
  String? subtotal ;
  String? tax ;
  String? taxsub ;
  String? ship ;
  String? totAmount ;
  String profName = '';
  String sCode = '';
  String sValue = '';
  String sDisplay = '';

  info['title'] != null ? title = ''+info['title']+'' : title ='';
  info['item_id'] != null ? id = ''+info['item_id']+'' : id ='';
  info['item_number'] != null ? itemNum = ''+info['item_number']+'' : itemNum ='';
  info['effective_date'] != null ? edate = ''+info['effective_date']+'' : edate ='';
  info['warranty_expiration_date'] != null ? warrDate = ''+info['warranty_expiration_date']+'' : warrDate ='';
  info['warranty_expiration_meter_value'] != null ? warrMeter = ''+info['warranty_expiration_meter_value']+'' : warrMeter ='';
  info['current_mater_value'] != null ? currMeter = ''+info['current_mater_value']+'' : currMeter ='0';
  info['vehicle_id'] != null ? vid = ''+info['vehicle_id']+'' : vid ='';
  info['disp_vehicle_id'] != null ? vtitle = ''+info['disp_vehicle_id']+'' : vtitle ='';
  info['notes'] != null ? profName = ''+info['notes']+'' : profName ='';
  info['price'] != null ? price = ''+info['price']+'' : price ='0.00';
  info['discount_percentage'] != null ? disc = ''+info['discount_percentage']+'' : disc = '0';
  info['subtotal'] != null ? subtotal = ''+info['subtotal']+'' : subtotal ='0.00';
  info['tax_percentage'] != null ? tax = ''+info['tax_percentage']+'' : tax = '0';
  info['tax_subtotal'] != null ? taxsub = ''+info['tax_subtotal']+'' : taxsub ='0.00';
  info['shipping'] != null ? ship = ''+info['shipping']+'' : ship ='0.00';
  info['total_amount'] != null ? totAmount = ''+info['total_amount']+'' : totAmount ='0.00';
  info['status_code'] != null ? sCode = ''+info['status_code']+'' : sCode ='';
  info['status_value'] != null ? sValue = ''+info['status_value']+'' : sValue ='';
  info['status_display'] != null ? sDisplay = ''+info['status_display']+'' : sDisplay ='';
  // String reqArray = buildReqArray(info);
  // print('before req');
  // print(reqArray);

  
print('here before payload');
  // var payload = '{"bims_access_id":"'+ifleetData+'","action":"SAVE_ITEM","metadata":{"item_type_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","item_id":"","container_id":"","item_type_id_container_id":"","disp_container_id":"","item_number":"7","title":"QWE1","vehicle_type_id":null,"vehicle_status_id":null,"year":2009,"is_out_of_service":{"code":"false","value":"false","display":"No"}}}';
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"'+id+'",'+
          '"item_number":"'+itemNum+'",'+
          '"title":"'+title+'",'+ 
          '"effective_date":"'+edate+'",'+ 
          '"notes":"'+profName+'",'+
          '"warranty_expiration_date":"'+warrDate+'",'+ 
          '"warranty_expiration_meter_value":"'+warrMeter+'",'+ 
          '"current_mater_value":"'+currMeter+'",'+ 
          '"vehicle_id":"'+vid+'",'+ 
          '"item_type_id_vehicle_id":"ityp-17b5fbf3478141a397d630178d8dfc1c",'+
          '"disp_vehicle_id":"'+vtitle+'",'+ 
          '"price":"'+price+'",'+ 
          '"discount_percentage":"'+disc+'",'+ 
          '"subtotal":"'+subtotal+'",'+ 
          '"tax_percentage":"'+tax+'",'+ 
          '"tax_subtotal":"'+taxsub+'",'+ 
          '"shipping":"'+ship+'",'+ 
          '"total_amount":"'+totAmount+'",'+ 
          '"purchase_order_status":  {' +
              '"code": "'+sCode+'",' +
              '"value": "'+sValue+'",' +
              '"display": "'+sDisplay+'"'+
            '}' +
      '}'+
  '}';

  
    

    print(payload);

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);
  print(usell);

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }

  try{
    http.Response response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
    print('https://lawanow.com/bims-web/Item?param=$usell');
    Map result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      print('status is 200');
      Map<String, dynamic> result = json.decode(response.body);
      if (result['success'] == true) {
          print(response.body);
      } 
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }catch(e){
    print(e.toString());
  } 
}




String buildReqArray(Map<String, dynamic> info) {
  List<String> items = info.entries.map((entry) {
    var item = entry.value;
    List<String> parts = [];

    if (item.containsKey('warranty_expiration_date')) {
      parts.add('"warranty_expiration_date":${item['warranty_expiration_date']}');
    }
    if (item.containsKey('effective_date')) {
      parts.add('"effective_date":${item['effective_date']}');
    }
    if (item.containsKey('warranty_expiration_meter_value')) {
      parts.add('"warranty_expiration_meter_value":${item['warranty_expiration_meter_value']}');
    }
    if (item.containsKey('price')) {
      parts.add('"price":${item['price']}');
    }
    if (item.containsKey('discount_percentage')) {
      parts.add('"discount_percentage":${item['discount_percentage']}');
    }
    if (item.containsKey('subtotal')) {
      parts.add('"subtotal":${item['subtotal']}');
    }
    if (item.containsKey('tax_percentage')) {
      parts.add('"tax_percentage":${item['tax_percentage']}');
    }
    if (item.containsKey('tax_subtotal')) {
      parts.add('"tax_subtotal":${item['tax_subtotal']}');
    }
    if (item.containsKey('shipping')) {
      parts.add('"shipping":${item['shipping']}');
    }
    if (item.containsKey('total_amount')) {
      parts.add('"total_amount":${item['total_amount']}');
    }


    return '{' + parts.join(',') + '}';
  }).toList();

  return '[${items.join(',')}]';
}



}


class findListPO
{
  Future saveList(Map<String, dynamic> info) async {
  print('di sini');
  print(info);

  String title;
  String id;
  String itemNum;
  String? pdid;
  String? pdname;
  String? pdtype;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  info['title'] != null ? title = ''+info['title']+'' : title ='';
  info['item_id'] != null ? id = ''+info['item_id']+'' : id ='';
  info['item_number'] != null ? itemNum = ''+info['item_number']+'' : itemNum ='';
  info['purchase_details'] != null ? pdid = ''+info['purchase_details']+'' : pdid ='';
  info['item_type_id_purchase_details'] != null ? pdtype = ''+info['item_type_id_purchase_details']+'' : pdtype ='';
  info['disp_purchase_details'] != null ? pdname = ''+info['disp_purchase_details']+'' : pdname ='';
  // info['vehicle_type_id'] != null ? vehicleCategory = ''+info['vehicle_type_id']+'' : vehicleCategory = 'null';
  
print('here before payload2');
  // var payload = '{"bims_access_id":"'+ifleetData+'","action":"SAVE_ITEM","metadata":{"item_type_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","item_id":"","container_id":"","item_type_id_container_id":"","disp_container_id":"","item_number":"7","title":"QWE1","vehicle_type_id":null,"vehicle_status_id":null,"year":2009,"is_out_of_service":{"code":"false","value":"false","display":"No"}}}';
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"'+id+'",'+
          '"item_number":"'+itemNum+'",'+
          '"title":"'+title+'",'+
          '"purchase_details":"'+pdid+'",'+ //later
          '"item_type_id_purchase_details":"'+pdtype+'",'+ //later
          '"disp_purchase_details":"'+pdname+'",'+
      '}'+
  '}';

  
    

    print(payload);

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);
  print(usell);

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }

  try{
    http.Response response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
    Map result = json.decode(response.body);
    print(result);
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
  }catch(e){
    print(e.toString());
  }

  
}

Future saveStatus(Map<String, dynamic> info) async {
  print('di sini');
  print(info);

  String id;
  String sCode = '';
  String sValue = '';
  String sDisplay = '';
  String title ='';
  // Map<String, dynamic> status = {};
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  info['item_id'] != null ? id = ''+info['item_id']+'' : id ='';
  info['title'] != null ? title = ''+info['title']+'' : title ='';
  info['status_code'] != null ? sCode = ''+info['status_code']+'' : sCode ='';
  info['status_value'] != null ? sValue = ''+info['status_value']+'' : sValue ='';
  info['status_display'] != null ? sDisplay = ''+info['status_display']+'' : sDisplay ='';

  
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"'+id+'",'+
          '"title":"'+title+'",'+
          '"purchase_order_status":{' +
              '"code": "'+sCode+'",' +
              '"value": "'+sValue+'",' +
              '"display": "'+sDisplay+'"'+
            '}' +
      '}'+
  '}';

  
    

    print(payload);

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);
  print(usell);

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }

  try{
    http.Response response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
    Map result = json.decode(response.body);
    print(result);
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
  }catch(e){
    print(e.toString());
  }

  
}

}

class savePrices{
  Future  saveChanges(Map<String, dynamic> info) async {
  print('di sini save harga');
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  String title;
  String id;
  String itemNum;
  String? price ;
  String? disc ;
  String? subtotal ;
  String? tax ;
  String? taxsub ;
  String? ship ;
  String? totAmount ;

  info['title'] != null ? title = ''+info['title']+'' : title ='';
  info['item_id'] != null ? id = ''+info['item_id']+'' : id ='';
  info['item_number'] != null ? itemNum = ''+info['item_number']+'' : itemNum ='';
  info['price'] != null ? price = ''+info['price']+'' : price ='0.00';
  info['discount_percentage'] != null ? disc = ''+info['discount_percentage']+'' : disc = '0';
  info['subtotal'] != null ? subtotal = ''+info['subtotal']+'' : subtotal ='0.00';
  info['tax_percentage'] != null ? tax = ''+info['tax_percentage']+'' : tax = '0';
  info['tax_subtotal'] != null ? taxsub = ''+info['tax_subtotal']+'' : taxsub ='0.00';
  info['shipping'] != null ? ship = ''+info['shipping']+'' : ship ='0.00';
  info['total_amount'] != null ? totAmount = ''+info['total_amount']+'' : totAmount ='0.00';
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"'+id+'",'+
          '"item_number":"'+itemNum+'",'+
          '"title":"'+title+'",'+ 
          '"price":"'+price+'",'+ 
          '"discount_percentage":"'+disc+'",'+ 
          '"subtotal":"'+subtotal+'",'+ 
          '"tax_percentage":"'+tax+'",'+ 
          '"tax_subtotal":"'+taxsub+'",'+ 
          '"shipping":"'+ship+'",'+ 
          '"total_amount":"'+totAmount+'",'+ 
      '}'+
  '}';

  
    

    print(payload);

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);
  print(usell);

  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }

  try{
    http.Response response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
    print('https://lawanow.com/bims-web/Item?param=$usell');
    Map result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      print('status is 200');
      Map<String, dynamic> result = json.decode(response.body);
      if (result['success'] == true) {
          print(response.body);
      } 
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  }catch(e){
    print(e.toString());
  } 
}
}