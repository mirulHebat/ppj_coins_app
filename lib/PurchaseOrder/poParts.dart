import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';

class POParts{
  Future <List<Map<String, dynamic>>> createList(String id) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> itemID = [];
      http.Response response;
      print(id);
      print('Here in Po parts list8ingww');
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
        print('finding the poli: $result');
        List<dynamic> parts = result['results'];
        print(parts);

        for (var item in parts) {
          List<dynamic>? poliList = item['metadata']?['poli']; // Use List<dynamic>? to handle null
          if (poliList != null) { // Check if poliList is not null
            for (var poli in poliList) {
              itemID.add({
                'title': poli['title'],
                'id': poli['item_id'],
                'part': poli['part_id']['title'],
                'quantity': poli['quantity'],
                'cost': poli['unit_cost'],
                'total': poli['subtotal'],
              });
            }
          }
        }



      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      print('here is the items');
      print(itemID);
      return itemID;

}

Future <List<Map<String, dynamic>>> findPart(List<String> poliId) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> partsItem = [];
      http.Response response;
      print('Here in find received parts');


      for(var ids in poliId){
        var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"item_id":"'+ids+'",' +
      '"item_type_id":"ityp-f8b2481a6a254a5e952d1da51411533e",' +
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
        print('Parto Find: $result');
        List<dynamic> parts = result['results'];

        for (var item in parts) {
          print(item);
          partsItem.add({
                'title': item['metadata']['title'],
                'id': item['item_id'],
                'part': item['metadata']['part_id']['title'],
                'partId': item['metadata']['part_id']['item_id'],
                'quantity': item['metadata']['quantity'],
                'cost': item['metadata']['unit_cost'],
                'total': item['metadata']['subtotal'],
                'received' : item['metadata']['total_quantity_received'],
                'taken' : '0'
              });
      }
    }
      }

      
    print('here is the poli items');
      print(partsItem);
      return partsItem;
}

}