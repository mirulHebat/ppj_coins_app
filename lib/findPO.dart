import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';

class servicePO{
  Future <List<Map<String, dynamic>>> findPO(String id) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> itemID = [];
      http.Response response;
      print('Here in PO for service');
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"item_id":"'+id+'",' +
      '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",' +
       '"details":["item_id","item_number","title","item_type_id","registered_date","metadata"]'+
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
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        for(var item in parts){
        String dates1 = item['registered_date'];
        DateFormat dates2 = DateFormat('dd/MM/yyyy hh:mm:ss a');
        DateTime dates3 = dates2.parse(dates1);
        String formattedDate = dateFormat.format(dates3);
          itemID.add({
            'item_id' : item['item_id'],
            'item_number' : item['item_number'],
            'status' : item['metadata']['purchase_order_status']['display'],
            'date' : formattedDate,
            'title' : item['title']
          });
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      return itemID;

}
}