// Future uploadPhoto(bimsAccessID,userID,path)async{
//     print('uploading');
//     // {"bims_access_id":"hip2d-a7c17a64472d407887486b5eaade8d3d","action":"UPLOAD_PHOTO","user_id":"usr-892961e995de4484af1ecdf151f21b6d"}
//     var url='{'+
//       '"bims_access_id": "'+bimsAccessID+'",'+
//       '"action": "UPLOAD_PHOTO",'+
//       '"user_id": "'+userID+'",'+
//     '}';

//     // {
//     //     "bims_access_id": "coin2-f1d1a5c65163494da8799bae331f10db",
//     //     "item_id": "add03-0dd3d89839344aec9fb6ed3eba4fbb64",
//     //     "action": "UPLOAD_CONTENT",
//     //     "checkin_type": "NEW",
//     //     "retain_file_list": ["cntf-01d5a688cf264b05a7ca9c06d2354028", "cntf-4e38593705cb482bb3546692501674c9", "cntf-618ed933d47a4d3686aa096173bac62b", "cntf-9cadcc21cc5e4235b0c4756552ee8bfc", "cntf-d820f95dc1224a5195ab7917569b2a9a"],
//     //     "doc_template_id": "",
//     //     "doc_filename": "",
//     //     "file_type": ""
//     // }
//     var encURL=Uri.encodeQueryComponent(url);

//     var request = new http.MultipartRequest('POST', Uri.parse("https://lawanow.com/bims-web/User?param=")); //http

//     var multipartFile =await http.MultipartFile.fromPath('param',path); 

//     request.files.add(multipartFile);
//     request.fields['param']=encURL;
//     request.headers['cookie']=cleanCookie;
//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       print(responseData);
//       return responseData;
//     } catch (e) {
//       print('something failed while uploading :');
//       print(e);
//       return null;
//     }
    
//     // http.Response response = await http.post("https://lawanow.com/bims-web/ItemSearch?param="+encURL,
//     //   headers: headers
//     //   ).then((value){
//     //     Map result = json.decode(value.body);
//     //     partnersData=result;
//     //     partnersMessage=result['message'];
//     //     if(result['success']==true){
//     //       partnersResult=result['results'];
//     //       amIFulfilled=true;
//     //       for(int i=0 ;i<partnersResult.length;i++){
//     //         partnerlistController.add('Read More');
//     //       }
//     //     }
//     //     return value;        
//     //   }
//     // );
//   }


import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:ppj_coins_app/home/homepage.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'dart:convert';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import '../riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/addFuel.dart';
import 'package:ppj_coins_app/add_vehicle.dart';
import 'package:ppj_coins_app/Assignment.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class picture
{
  Future<void> checkPicture(String user_id,String contact_id,)async
  {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       Map<String, String> headersModified = {};
        if (userDetails.isNotEmpty) {
          headersModified['cookie'] = userDetails[3];
        }
     http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$user_id",'+
        '"action":"CHECK_OUT",'+
        '"item_id":"$contact_id",'+       
      '}');


        response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

        if(response.statusCode == 200)
        {
          Map<String, dynamic> result = json.decode(response.body);
          if (result['success'] == true)
          { 
            print('checkPicture');
            print(result);
          }
        }
  }

  Future <void> savePic (String user_id,String contact_id,String _image)async
  {
    print(user_id);
    print(contact_id);
    print(_image);
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    Map<String, String> headersModified = {};
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];
    }
     http.Response response;
     var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$user_id",'+
        '"action":"UPLOAD_CONTENT",'+
        '"checkin_type":"REPLACE",'+
        '"item_id":"$contact_id",'+ 
        '"retain_file_list":[],'+ 
        '"doc_template_id":"",'+ 
        '"doc_filename":"",'+        
        '"file_type":"",'+ 
      '}');

      // var encURL=Uri.encodeQueryComponent(usell);
      var request = new http.MultipartRequest('POST', Uri.parse("https://lawanow.com/bims-web/Content?param=")); //http
       var multipartFile =await http.MultipartFile.fromPath('param',_image); 
        request.files.add(multipartFile);
   
      
       request.fields['param']=usell;
       request.headers['cookie']=cleanCookie;
      try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('savePicture');
      print(responseData);
      
    } catch (e) {
      print('something failed while uploading :');
      print(e);
      
    }

  }

    Future<void> checkPictureDone(String user_id,String contact_id,)async
  {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
       Map<String, String> headersModified = {};
        if (userDetails.isNotEmpty) {
          headersModified['cookie'] = userDetails[3];
        }
     http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$user_id",'+
        '"action":"CHECK_IN",'+
        '"item_id":"$contact_id",'+ 
        '"type":"REPLACE",'+      
      '}');


        response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

        if(response.statusCode == 200)
        {
          Map<String, dynamic> result = json.decode(response.body);
          if (result['success'] == true)
          {
            print('DonePicture');
            print(result);
          }
        }
  }

  Future<String> findImage(String user_id, String contact_id) async {
    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    Map<String, String> headersModified = {};
    
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];
    }

    var usell = Uri.encodeQueryComponent(
      json.encode({
        "bims_access_id": user_id,
        "action": "ITEM_DETAIL",
        "item_id": contact_id,
        "details": ["item_id", "content_id", "revision", "file_list"],
        "file_details": [
          "file_id", "filename", "original_filename", "file_type", "file_size",
          "modified_date", "created_user_id", "created_user_fullname"
        ]
      })
    );

    try {
      final response = await http.get(
        Uri.parse('https://lawanow.com/bims-web/Content?param=$usell'),
        headers: headersModified
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);

        if (result['success'] == true) {
          if (result['results'] != null && result['results'].isNotEmpty) {
            var fileList = result['results'][0]['file_list'];
            if (fileList != null && fileList.isNotEmpty) {
              var fileId = fileList[0]['file_id'];
              print('File ID: $fileId');
              String picture_path = await image_found(user_id, contact_id, fileId);
              return picture_path;
            } else {
              print('File list is empty or null');
              return "";
            }
          } else {
            print('Results are empty or null');
            return "";
          }
        } else {
          print('Request was not successful');
          return "";
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      print('An error occurred: $e');
      return "";
    }
  }

    Future<String> image_found(String user_id, String contact_id, String fileId) async {
      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      Map<String, String> headersModified = {};

      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];
      }

      var usell = json.encode({
        "bims_access_id": user_id,
        "action": "VIEW_FILE",
        "item_id": contact_id,
        "file_id": fileId
      });

      try {
        final response = await http.post(
          Uri.parse('https://lawanow.com/bims-web/Content'),
          headers: headersModified,
          body: {'param': usell},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> result = json.decode(response.body);

          if (result['success'] == true) {
            if (result.containsKey('file_url')) {
              String fileUrl = result['file_url'];
              
              print('File URL: $fileUrl');
              return fileUrl;
            } else {
              print('file_url key not found in the response');
              return "";
            }
          } else {
            print('Request was not successful');
            return "";
          }
        } else {
          print('Failed to load data, status code: ${response.statusCode}');
          return "";
        }
      } catch (e) {
        print('Error: $e');
        return "";
      }
    }

    // Future <File> image_net(String image_license)async{
    //   File? img =File(image_license);

    //     print('img');
    //     print(img);
    //    return img;
      
                  


    // }
}