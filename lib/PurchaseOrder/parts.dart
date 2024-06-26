import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class Parts{
  Future <List<Map<String, dynamic>>> createList() async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> displayValues = [];
      http.Response response;
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ADVANCED_SEARCH",'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"item_type_codes":["prt01"],' +
      '"query":"( title <> &quot;&quot; )",'+ 
       '"details":["item_id","item_number","title","registered_date","item_type_id","item_type_title","child_count","has_doc_store","has_related_item","field_item_list"]'+
      '}');
     
        print('find parts for PO');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        List<dynamic> parts = result['results'];
        print(parts);
        for (var item in parts) {
          displayValues.add({
            'title': item['title'],
            'id': item['item_id'], 
            'itemNo' : item['item_number']
          });
        }


}
      else {
        print('Request failed with status code: ${response.statusCode}');
      }
      print(displayValues);
      return displayValues;
}

Future <String> findPrice(String id) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       Map <String,String> headersModified={};
       print(id);
       String price = '';
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
          http.Response response;
          var partParam =Uri.encodeQueryComponent('{'+
          '"bims_access_id":"'+ifleetData+'",'+
          '"action":"ITEM_DETAIL",'+
          '"sort_order":"ASC",' +
          '"sort_field":"",' +
          '"item_id":"'+id+'",' +
          '"item_type_id":"ityp-1871f3d837fe4c6491589bad16687506"' +
          '"query":"( title <> &quot;&quot; )",'+ 
          '"details":["item_id","item_number","item_type_id","content_id","metadata"]'+
          '}');

          response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+partParam),headers:headersModified);
          if (response.statusCode == 200) {
          Map<String, dynamic> result = json.decode(response.body);
          List<dynamic> parts3 = result['results'];
          print('here is parts 33');
          print(parts3);
          for (var item in parts3) {
            price = item['metadata']['unit_cost']['display'];
        }
        }
      else {
        print('Request failed with status code: ${response.statusCode}');
      }
      print(price);
      return price;
}

Future <List<Map<String, dynamic>>> findInventory(String ids) async
   {
      print('aku di find inventory');
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails[0];
       List<String> displayValues = [];
      List<Map<String, dynamic>> displayValues2 = [];
      http.Response response;
      print(ids);
      
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ADVANCED_SEARCH",'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"item_type_codes":["pi001"],' +
      '"query":"( part_id = &quot;'+ids+'&quot; )",'+ 
       '"details":["item_id","item_number","title","registered_date","item_type_id","item_type_title"]'+
      '}');
     
        print('findGap');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        // print('Inventory parts response: $result');
        List<dynamic> parts2 = result['results'];
        print(parts2);
        for (var item in parts2) {
          print(item);
          displayValues.add(item['item_id']);
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      if(displayValues.isNotEmpty){
      var usell3 =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"item_id":"'+displayValues[0]+'",' +
      '"item_type_id":"ityp-b50347a8f70a4ee0b1c2299619cc3eff",' +
      '"details":["item_id","item_number","title","item_type_id","metadata"]'+
      '}');

      Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+usell3),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Inventory parts response: $result');
        List<dynamic> parts3 = result['results'];
        for (var item in parts3){
          displayValues2.add({
            'id': item['item_id'],
            'itemNo' : item['item_number'],
            'itemType' : item['item_type_id'],
            'title' : item['title'],
            'quantity' : item['metadata']['available_quantity']
          });
        }
        
      }
    }
      
    print('here');
    print(displayValues2);
      return displayValues2;
}

Future <List<Map<String, dynamic>>> findQty(Map<String,dynamic> partInv) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails[0];
      List<String> displayValues = [];
      List<Map<String, dynamic>> displayValues2 = [];
      http.Response response;
      
      String id= '';
      String partNo = '';
      String partTitle = '';
      String takenQty = '';

      partInv['part_id']['item_id']!= null ? id = ''+partInv['part_id']['item_id']+'' : id ='';
      partInv['part_id']['item_number']!= null ? partNo = ''+partInv['part_id']['item_number']+'' : partNo ='';
      partInv['part_id']['title']!= null ? partTitle = ''+partInv['part_id']['title']+'' : partTitle ='';
      partInv['quantity']!= null ? takenQty = ''+partInv['quantity'].toString()+'' : takenQty ='';
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ADVANCED_SEARCH",'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"item_type_codes":["pi001"],' +
      '"query":"( part_id = &quot;'+id+'&quot; )",'+ 
       '"details":["item_id","item_number","title","registered_date","item_type_id","item_type_title"]'+
      '}');
     
        print('findGap');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        // print('Inventory parts response: $result');
        List<dynamic> parts2 = result['results'];
        // print(parts2);
        for (var item in parts2) {
          displayValues.add(item['item_id']);
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      if(displayValues.isNotEmpty){
      var usell3 =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"item_id":"'+displayValues[0]+'",' +
      '"item_type_id":"ityp-b50347a8f70a4ee0b1c2299619cc3eff",' +
      '"details":["item_id","item_number","title","item_type_id","metadata"]'+
      '}');

      Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+usell3),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Inventory parts response: $result');
        List<dynamic> parts3 = result['results'];
        for (var item in parts3){
          displayValues2.add({
            'contid' : id,
            'partNo' : partNo,
            'partName' : partTitle,
            'taken' : takenQty,
            'id': item['item_id'],
            'itemNo' : item['item_number'],
            'itemType' : item['item_type_id'],
            'title' : item['title'],
            'quantity' : item['metadata']['available_quantity']
          });
        }
        
      }
    }
    print('here');
    print(displayValues2);
      return displayValues2;

}

Future updateInventory(Map<String,dynamic> info) async{
  print('hello');
  print(info);
  String id = '';
  String itemNo = '';
  String type = '';
  String title = '';
  String quantity = '';
  // String container_id = '';
  // String partName = '';
  // String partNo = '';
  String taken = '';
  int left = 0;
  String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails[0];
    // info['contid'] != null ? container_id = ''+info['contid']+'' : container_id ='';
    // info['partName'] != null ? partName = ''+info['partName']+'' : partName ='';
    // info['partNo'] != null ? partNo = ''+info['partNo']+'' : partNo ='';
    info['taken'] != null ? taken = ''+info['taken']+'' : taken ='';
    info['id'] != null ? id = ''+info['id']+'' : id ='';
    info['item_number'] != null ? itemNo = ''+info['item_number']+'' : itemNo ='';
    info['itemType'] != null ? type = ''+info['itemType']+'' : type ='';
    info['title'] != null ? title = ''+info['title']+'' : title ='';
    info['quantity'] != null ? quantity = ''+info['quantity'].toString()+'' : quantity = '0';
    print(quantity);
    print(taken);

    left = int.parse(quantity) - int.parse(taken);
    print(left);
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"'+type+'",'+
          '"item_id":"'+id+'",'+
          '"item_number":"'+itemNo+'",'+
          '"title":"'+title+'",'+ 
          '"available_quantity":'+left.toString()+','+
          '"available_quantity_updated_at":"'+today+'"' +
      '}'+
  '}';

  // var payload2 = '{'+
  //     '"bims_access_id":"'+ifleetData+'",'+
  //     '"action":"SAVE_ITEM",'+
  //     '"metadata":{'+
  //         '"item_type_id":"ityp-1871f3d837fe4c6491589bad16687506",'+
  //         '"item_id":"'+container_id+'",'+
  //         '"item_number":"'+partNo+'",'+
  //         '"title":"'+partName+'",'+ //isi
  //         '"total_quantity":'+left.toString()+','+
  //     '}'+
  // '}';

  
    

    print(payload);
    // print(payload2);

  print(payload.runtimeType);
  var usell = Uri.encodeQueryComponent(payload);
  print(usell);

  // var usell2 = Uri.encodeQueryComponent(payload2);

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
          print(result);
          // http.Response response2 = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell2'), headers: headersModified,);
          // Map result2 = json.decode(response2.body);
          // print(result2);

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


