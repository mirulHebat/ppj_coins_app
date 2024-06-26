import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class vehicleDetails{
  Future <List<dynamic>> listVehicleDetails(String id) async
   {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       String ifleetData = userDetails[0];
       List<dynamic> displayValues = [];
       print(id);
      http.Response response;
      var usell =Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ITEM_DETAIL",'+
      '"item_id":"'+id+'",' +
      '"item_type_codes":["vc001"],' +
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
        print('Response for car details:');
        List<dynamic> vehicle = result['results'];
        print(vehicle);
        displayValues.add(vehicle);
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
      return displayValues;

}
}