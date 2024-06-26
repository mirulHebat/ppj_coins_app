import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class Vehicles{
  Future <List<Map<String, dynamic>>> createList(String title) async
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
      '"item_type_codes":["vc001"],' +
      '"query":"( vehicle_type_id = &quot;'+title+'&quot; )",' + 
       '"details":["item_id","item_number","title","registered_date","item_type_id","item_type_title","child_count","has_doc_store","has_related_item","field_item_list"]'+
      '}');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        List<dynamic> vehicle = result['results'];
        print('Finding Meter');
        print(vehicle);
        for (var item in vehicle) {
          displayValues.add({
            'title': item['title'],
            'id': item['item_id'], 
          });
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      print(displayValues);
      return displayValues;

}

}