import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class Profile {
  Future<List<dynamic>> createList() async {
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String ifleetData = userDetails[0];
    String fName = userDetails[5];
    fName = fName.toUpperCase();
    print(fName);
    List<String> displayValues = [];
    List<dynamic> userProfDet = [];
    List<String> contId = [];
    List<String> filesUrl = [];

    http.Response response;
    var usell = Uri.encodeQueryComponent('{'+
      '"bims_access_id":"'+ifleetData+'",'+
      '"action":"ADVANCED_SEARCH",'+
      '"sort_order":"ASC",' +
      '"sort_field":"",' +
      '"item_type_codes":["cn002"],' +
      '"query":"( title = &quot;'+fName+'&quot;  )",' + 
      '"details":["item_id","item_number","title","registered_date","item_type_id","item_type_title","child_count","has_doc_store","has_related_item","field_item_list"]'+
      '}');

    print('findGap');
    Map<String,String> headersModified = {};
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];
    }
    
    response = await http.post(Uri.parse('https://lawanow.com//bims-web/ItemSearch?param='+usell), headers: headersModified);
    
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      print('qqqoo');
      print(result);
      List<dynamic> parts = result['results'];

      
      for (var item in parts) {
        displayValues.add(item['item_id']);
      }

      if (displayValues.isNotEmpty) {
        http.Response response2;
        http.Response response3;
        var userProfile = Uri.encodeQueryComponent('{'+
          '"bims_access_id":"'+ifleetData+'",'+
          '"action":"ITEM_DETAIL",'+
          '"item_id":"'+displayValues[0]+'",' +
          '"item_type_id":"ityp-11962a26708945e0a67be504cf31def6",' +
          '"query":"( email_addr = &quot;hidayah@hyperanalytics.biz&quot;  )",' + 
          '"details":["item_id","item_number","item_type_id","metadata"]'+
          '}');

          var lesenKete = Uri.encodeQueryComponent('{'+
          '"bims_access_id":"'+ifleetData+'",'+
          '"action":"ITEM_DETAIL",'+
          '"item_id":"'+displayValues[0]+'",' +
          '"details":["item_id","content_id","revision","file_list"],'+
          '"file_details":["file_id","filename","original_filename","file_type","file_size","modified_date","created_user_id","created_user_fullname"]'+
          '}');
      
        response2 = await http.get(Uri.parse('https://lawanow.com//bims-web/Item?param='+userProfile), headers: headersModified);
        response3 = await http.get(Uri.parse('https://lawanow.com//bims-web/Content?param='+lesenKete), headers: headersModified);
        
        if (response2.statusCode == 200) {
          Map<String, dynamic> profile = json.decode(response2.body);
          print('Response44: $profile');
          List<dynamic> profDet = profile['results'];
          userProfDet.add(profDet);
        } else {
          print('Request2 failed with status code: ${response.statusCode}');
        }

        if(response3.statusCode == 200){
          Map<String, dynamic> lesen = json.decode(response3.body);
          List<dynamic> lk = lesen['results'];
          print('333330333');
          print(lk);
          for (var item in lk) {
            List<dynamic> fileList = item['file_list'];
            for (var file in fileList) {
              contId.add(file['file_id']);
            }
          }
        }

        print(contId);


      if (contId.isNotEmpty) {
        http.Response response4;
            var photoLesen = Uri.encodeQueryComponent('{'+
          '"bims_access_id":"'+ifleetData+'",'+
          '"action":"VIEW_FILE",'+
          '"item_id":"'+displayValues[0]+'",' +
          '"file_id":"'+contId[0]+'",' +
          '}');
        response4 = await http.post(Uri.parse('https://lawanow.com//bims-web/Content?param='+photoLesen), headers: headersModified);

        if(response4.statusCode == 200){
          print(Uri.decodeComponent(photoLesen));
          print('331100' + response4.body);
          Map<String, dynamic> photo = json.decode(response4.body);

          String lp = photo['file_url'];
          print(lp);
          Map<String, dynamic> lpMap = {'file_url': lp};
          userProfDet.add(lpMap);

        }
        } else {
          print('Request5 failed with status code: ${response.statusCode}');
        }


      }



      }
    else {
      print('Request failed with status code: ${response.statusCode}');
    }

    print('999');
    print(filesUrl);
    print(userProfDet);

    return userProfDet;
  }
}

class findList
{
  void saveList(Map<String, dynamic> info) async {
  print('di sini');
  print(info);
  print(info['license_number']);
  print(info['license_class']);
  print(info['Street_Address']);
  print(info['item_id']);

  String? title;
  String? email; 
  String? phone;
  // String? address;
  String? emp;
  String? job;
  String? streetAddress;
  String? streetAddressLine2;
  String? postalCode;
  String? city;
  String? state ;
  String? country;
  UserDetail userDetail = UserDetail();
  List<String> userDetails = userDetail.getUserDetails();
  String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';

  title = info['title'] ?? '';
  email = info['email_addr'] ?? '';
  phone = info['mobile_phone_no'] ?? '';
  emp = info['employee_number'] ?? '';
  job = info['job_title'] ?? '';
  streetAddress = info['Street_Address'] ?? '';
  streetAddressLine2 = info['Street_Address_Line_2'] ?? '';
  postalCode = info['Postal_Code'] ?? '';
  city = info['City'] ?? '';
  state = info['State'] ?? '';
  country = info['Country'] ?? '';

  var metadata = {
  "item_type_id": "ityp-11962a26708945e0a67be504cf31def6",
  "item_id": info['item_id'],
  "title": title != null && title.isNotEmpty ? title : null,
  "employee_number" : emp != null && emp.isNotEmpty ? emp : null,
  "email_addr": email != null && email.isNotEmpty ? email : null,
  "home_phone_no":  phone != null && phone.isNotEmpty ? phone : null,
  "mobile_phone_no":  phone != null && phone.isNotEmpty ? phone : null,
  "job_title" : job != null && job.isNotEmpty ? job : null,
  "Street_Address":  streetAddress != null && streetAddress.isNotEmpty ? streetAddress : null,
  "Street_Address_Line_2":  streetAddressLine2 != null && streetAddressLine2.isNotEmpty ? streetAddressLine2 : null,
  "Postal_Code":  postalCode != null && postalCode.isNotEmpty ? postalCode : null,
  "City":  city != null && city.isNotEmpty ? city : null,
  "State":  state != null && state.isNotEmpty ? state : null,
  "Country":  country != null && country.isNotEmpty ? country : null,
};
print('ttt');
print(metadata);

// Remove null values from metadata
metadata.removeWhere((key, value) => value == null);
print('not here');
print(metadata);
  

  http.Response response;
  var payload = {
      "bims_access_id": ifleetData,
      "action": "SAVE_ITEM",
      "metadata": metadata,
    };

    // Convert the payload to JSON string
    var jsonString = json.encode(payload);

    // Encode the JSON string to be used in the URI
    var usell = Uri.encodeQueryComponent(jsonString);

  print('ajax req');
  print(Uri.decodeQueryComponent(usell));

  print('saveds item');
  Map<String, String> headersModified = {};
  if (userDetails.isNotEmpty) {
    headersModified['cookie'] = userDetails[3];
    print(headersModified['cookie']);
  }
  // print(usell);
  response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print('status is 200');
    Map<String, dynamic> result = json.decode(response.body);
    if (result['success'] == true) {
        print(response.body);

    } else {

      print(response.body);

    }
  } else {
    // Handle the case where the request failed
    print('Request failed with status code: ${response.statusCode}');
    }
}

}