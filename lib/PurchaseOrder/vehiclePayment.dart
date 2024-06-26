
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class vehiclePayment{
  Future <List<Map<String, dynamic>>> createList(String itemNo) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<Map<String, dynamic>> vehicleType = [];

      http.Response response;
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ADVANCED_SEARCH",'+
      '"item_type_codes":["vc001"],'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"query":"( item_number = &quot;'+itemNo+'&quot; )",'+
       '"details":[["item_id","item_number","title","item_type_id"]'+
      '}');
        print('after query for vehicle');
        Map <String,String> headersModified={};
            if(userDetails.length>0)
            {
              headersModified['cookie']=userDetails[3];
              print('cookie');
            }
            print('after cookie');
        response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param='+usell),headers:headersModified);
        // print('https://lawanow.com//bims-web/ItemSearch?param='+usell);
        print('response');
        if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);
        print('Response for vehicle details: $result');
        List<dynamic> vcat = result['results'];
        for (var item in vcat) {
          vehicleType.add(item);
        }
      } else {
        print('Request failed with status code: ');
      }
      print(vehicleType);
      return vehicleType;


}
}



class findList
{
  void saveList(Map<String, dynamic> info) async {
  print('di sini');
  print(info);

  String title;
  // String item_number; 
  // String? vehicleCategory;
  // String? roadTaxExpiry;
  // String? make;
  // String? model;
  // String? vin;
  // String? year;
  // String? price ;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  info['title'] != null ? title = ''+info['title']+'' : title ='';
  // info['item_number'] != null ? item_number = ''+info['item_number']+'' : item_number ='';
  // info['registration_expiry_date'] != null ? roadTaxExpiry = ''+info['registration_expiry_date']+'' : roadTaxExpiry ='';
  // info['make'] != null ? make = ''+info['make']+'' : make ='';
  // info['model'] != null ? model = ''+info['model']+'' : model ='';
  // info['vin'] != null ? vin = ''+info['vin']+'' : vin ='';
  // info['year'] != null ? year = ''+info['year']+'' : year = '0';
  // info['estimated_resale_price'] != null ? price = ''+info['estimated_resale_price']+'' : price ='0.00';
  // info['vehicle_type_id'] != null ? vehicleCategory = ''+info['vehicle_type_id']+'' : vehicleCategory = 'null';
  
print('here before payload');
  // var payload = '{"bims_access_id":"'+ifleetData+'","action":"SAVE_ITEM","metadata":{"item_type_id":"ityp-17b5fbf3478141a397d630178d8dfc1c","item_id":"","container_id":"","item_type_id_container_id":"","disp_container_id":"","item_number":"7","title":"QWE1","vehicle_type_id":null,"vehicle_status_id":null,"year":2009,"is_out_of_service":{"code":"false","value":"false","display":"No"}}}';
  var payload = '{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"SAVE_ITEM",'+
      '"metadata":{'+
          '"item_type_id":"ityp-c14e446065e443ecb57b96519322480e",'+
          '"item_id":"",'+
          '"container_id":"",'+
          '"item_type_id_container_id":"",'+
          '"disp_container_id":"",'+
          '"item_number": "",'+
          '"title":"'+title+'",'+
          '"vehicle_id":"",'+
          '"item_type_id_vehicle_id":"",'+
          '"disp_vehicle_id":"",'+
          '"price":0,'+
          '"discount_percentage":0,'+
          '"subtotal":0,'+
          '"tax_percentage":0,'+
          '"tax_subtotal":0,'+
          '"shipping":0,'+
          '"total_amount":0,'+
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
