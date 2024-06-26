import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';

Future<String> assignRole () async
  {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String role_id = userDetails.isNotEmpty ? userDetails[1] : '';
      print(userDetails);
      print(role_id);
        if (userDetails.isNotEmpty) {
    // Accessing the first element

        } else {

        }

        http.Response response;
        var usell = Uri.encodeQueryComponent('{"bims_access_id":"$ifleetData","action":"LIST_ITEM_GROUP","user_id":"$role_id","details":["full_name"]}');
          Map<String, String> headersModified = {};
          if (userDetails.isNotEmpty) {
            headersModified['cookie'] = userDetails[3];
          }

           response = await http.get(Uri.parse('https://lawanow.com/bims-web/User?param=$usell'), headers: headersModified);
             if (response.statusCode == 200) {

    // Parse the response body as JSON
    Map<String, dynamic> result = json.decode(response.body);

    // Handle the response data
    if (result['success'] == true) {
      print('done success submit assign role');
      print(result);
      String fullName="";
      fullName = result['results']?[0]['full_name'];
      return fullName;
    } else {

      print(response.body);
      return "";

    }
  } else {
      print('response.body');
      print(response.body);
      return "";
  }
}
