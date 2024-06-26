import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
class PurchaseOrder{
  Future createList() async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      print(userDetails);
      String ifleetData = userDetails[0];
      List<Map<String, dynamic>> displayValues = [];
      // List<Map<String, dynamic>> podetails = [];
      http.Response response;
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"LIST_ITEM",'+
      '"item_type_ids":["ityp-c14e446065e443ecb57b96519322480e"],' +
       '"details":["item_id","item_number","title","registered_date","metadata"]'+
      '}');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        List<dynamic> vehicle = result['results'];
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    for (var item in vehicle) {
      print(item);
      String dates1 = item['registered_date'];
      DateFormat dates2 = DateFormat('dd/MM/yyyy hh:mm:ss a');
      DateTime dates3 = dates2.parse(dates1);
      String formattedDate = dateFormat.format(dates3);
      var itemArray ={
            'title': item['title'],
            'id': item['item_id'], 
            'date' : formattedDate,
            'vehicle' : item['metadata']['vehicle_id']['item_number'],
            'pdid' : item['metadata']['purchase_details']?['item_id']?? '',
            'mechanic' : item['metadata']['notes']??'',
            'item_number' : item['item_number']??'',
            'status' : item['metadata']['purchase_order_status']?['display']??''
          };
          if (item['metadata']['poli'] != null) {
            itemArray['poli_ids'] = item['metadata']['poli']
              .map<String>((poliItem) => poliItem['item_id'] as String)
              .toList();
          } else {
            itemArray['poli_ids'] = [];
          }
          displayValues.add(itemArray);
    }
        
      return displayValues;
    }
}
String buildVehArray(List<Map<String, dynamic>> info) {
  String poliArray = info.map((item) {
    print('here is the amount of ids');
    print(item);
    return 
    '"item_id":"${item['pdid']}",';
  }).join(',');
  return poliArray;
}
Future deleteItems(List<dynamic> ids) async{
  UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      print(userDetails);
      String ifleetData = userDetails[0];
      String idsJson = jsonEncode(ids);
      print(idsJson);
      http.Response response;
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"item_ids":' + idsJson + 
      '}');
      print(Uri.decodeComponent(usell));
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
            }
        response = await http.delete(Uri.parse('https://lawanow.com//bims-web/Item?param='+usell),headers:headersModified);
        if (response.statusCode == 200) {
          print(response.body);
        }else{
          print(response.statusCode);
        }
}
}