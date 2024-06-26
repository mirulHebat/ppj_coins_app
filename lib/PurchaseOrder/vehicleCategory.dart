import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class vehicleCategory{
  Future <List<Map<String, dynamic>>> createList() async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
      List<Map<String, dynamic>> displayValues = [];
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
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        List<dynamic> vcat = result['results'];
        for (var item in vcat) {
          displayValues.add({
            'title': item['display_value'],
            'code': item['value'], 
          });
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      print(displayValues);
      return displayValues;


}

}