// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/work_entries.dart';


// final read(repoID) = StateProvider<String>((ref) {
//   return 'coin2'  ;
// });
final idX = StateProvider<String>((ref) {
  return 'coin2'  ;
});
// final userFSP = StateProvider<List>((ref) {
//   return box.get('userFSP')  ;
// });

final bims = StateProvider<String>((ref) {
  return '';
});
final userID = StateProvider<String>((ref) {
  return '';
});
final username = StateProvider<String>((ref) {
  return '';
});
final fullname = StateProvider<String>((ref) {
  return '';
});
final userDetails = StateProvider((ref) {
  return {};
});

final pwduser = StateProvider<String>((ref) {
  return '';
});

var photoURL;
var userProfileData;
var memberTypeData;
var userUSRPFID='';
var hip_member={};
var newRegister;
var isFirstLogin=false;


// final loginProvider = FutureProvider.autoDispose<dynamic>((ref) async {
//   return ref.read(loginUserClass);
// });

final loginProvider =StateNotifierProvider<LoginUser, AsyncValue>((ref) => LoginUser(ref.read));
class LoginUser extends StateNotifier<AsyncValue>{
  LoginUser(this.read):super(const AsyncData('idle'));

  final read;

  void init() async{
    state = AsyncData('idle');
  }

  Future<String> findrole (String fleetdata,String role,String cookie) async
  {
    print(fleetdata);
    print(role);
    print(cookie);
    http.Response response;
    var usell = Uri.encodeQueryComponent('{"bims_access_id":"$fleetdata","action":"LIST_ITEM_GROUP","user_id":"$role","details":["full_name"]}');
    Map<String, String> headersModified = {};
      headersModified['cookie'] =cookie ;
      response = await http.get(Uri.parse('https://lawanow.com/bims-web/User?param=$usell'), headers: headersModified);
        if (response.statusCode == 200) {
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


  void loginUser(userN, pass, userFSP,WidgetRef ref) async {
    print('inlogin');
    state = AsyncLoading();
    // Future.delayed(Duration(seconds: 3), () {
    //   state = AsyncData('Selesai');
    // });
    http.Response response;
    Map <String,String> headersModified={};
    if(userFSP.length>0){
      headersModified['cookie']=userFSP[3];
    }
    List<String> userSharedPref=<String>[];
    try{
      print(Uri.encodeFull('https://'+read(mainURL)+'/'+'/bims-web/Login?param={"action":"LOGIN","username":"'+userN+'","password":"'+pass+'","repository_id":"'+read(repoID)+'"}'));
      var usell =Uri.encodeQueryComponent('{'+
      '"action":"LOGIN",'+
      '"username":"'+userN+'",'+
      '"password":"'+pass+'",'+
      '"repository_id":"'+read(repoID)+'",'+
      '"application_id":"'+read(appID)+'"'+
      '}');
      if(userFSP.length == 0 || userN != Uri.decodeQueryComponent(userFSP[2])){
        print('no last user');
        
        response = await http.get(Uri.parse('https://'+read(mainURL)+'/'+'/bims-web/Login?param='+usell));
      }else{
        print('got last User');
        response = await http.post(Uri.parse('https://'+read(mainURL)+'/'+'/bims-web/Login?param='+usell),
          headers:headersModified
        );
      }
      Map result = json.decode(response.body);
      print(result);
      print(' roole');

      print('hello');
      if(result != null && result['success'] == true)
      {
        
        print('Welcome');
        cookies = response.headers['set-cookie'];
        setCookies(userFSP);
        userResult = result['results'][0];
        print('userResult');
        print(userResult['roles'][0]['title']);
        String nilairole =await findrole(userResult['bims_access_id'],userResult['user_id'],cleanCookie.toString());
        // Map<String,dynamic> fuelfound =await findFuel(userResult['bims_access_id'],cleanCookie.toString(),userResult['user_id']);
        // String fuel_title=fuelfound['fuel_title'];
        // String fuel_id=fuelfound['fuel_id'];
        print(nilairole);
        // userSharedPref.add(result['results'][0]['roles'][0]['title']);
        ref.read(userDetails.notifier).state=userResult;
        /////////////// SHARED PREFERENCES  ///////////////////////////////////////

        userSharedPref.add(userResult['bims_access_id']);  // 0 bims access
        ref.read(bims.notifier).state =userResult['bims_access_id'];
        userSharedPref.add(userResult['user_id']);         // 1 user id
        ref.read(userID.notifier).state =userResult['user_id'];
        userSharedPref.add(userResult['user_name']); // 2 user name
        ref.read(username.notifier).state =userResult['user_name'];
        ref.read(fullname.notifier).state=   userResult['full_name']; 
        userSharedPref.add(cleanCookie.toString());           // 3 cookie
        userSharedPref.add(pass.toString());         // 4 pwd
        // userSharedPref.add(result['results'][0]['roles'][0]['title']);
        userSharedPref.add(nilairole);
        userSharedPref.add(result['results'][0]['full_name']);
        // userSharedPref.add(fuel_title); 
        // userSharedPref.add(fuel_id);        //5 roles    

        print('userSharedPref');
        print(userSharedPref);
        ref.read(userDetailCtrl.notifier).setUserDetails(userSharedPref);
        ref.read(userDetailCtrl.notifier).getUserDetails();
        state = AsyncData('Selesai');
        print('Helo');
        print(state);
      } else {
        print(result);
         state = AsyncData(result['message']);
      }
      
    } on TimeoutException {
      AsyncError('Timeout',StackTrace.current);
      return;
    } on SocketException {
      AsyncError('Socket Exc.',StackTrace.current);
    } on FormatException{
      AsyncError('Format Exc.',StackTrace.current);
    } on Error catch (e) {
      AsyncError('Error',StackTrace.current);
    }
    
  }

  setCookies(userFSP)  {
    if (cookies != null) {
      int index = cookies.indexOf(';');
      headers['cookie'] =
          (index == -1) ? cookies : cookies.substring(0, index);
      cleanCookie =
          (index == -1) ? cookies : cookies.substring(0, index);
    }else{
      headers['cookie'] = userFSP[3];
      cleanCookie=userFSP[3];
    }
  }
}

// final logutUser = Provider<LogoutUser>((ref) => LogoutUser());

// final logOutNow = FutureProvider.family<String , String>((ref,str) {
//   final jdcProv = ref.watch(logutUser);
//   return jdcProv.logout(str);
// });


final logutUser =StateNotifierProvider<LogoutUser, AsyncValue>((ref) => LogoutUser(ref.read));

class LogoutUser extends StateNotifier<AsyncValue>{
  LogoutUser(this.read):super(const AsyncData('idle'));
  final read;

  void logout(bims) async {
    print('begin GET logut'); 

    var url='{'+
      '"bims_access_id": "'+(bims)+'",'+
      '"action": "LOGOUT",'+
    '}';
            
        
      
    var encURL=Uri.encodeQueryComponent(url);
    print("https://"+read(mainURL)+"/bims-web/Logout?param=$encURL");
    try{
      http.Response response = await http.get(Uri.parse("https://"+read(mainURL)+"/bims-web/Logout?param=$encURL"),
        headers: headers);
      Map result= json.decode(response.body);
      print('got jenisDokCadang');
      print(result);
      if(result['success']==true && result['code'] == 200){
        print('jenisDokCadang OK');
        // print(result['results'][0]);
        var temp = result['success'].toString();
        state =AsyncData(temp);
        // if(result['success']==true){
        //   var temp = result['success'];
        //   return temp;
        // }else{
        // }
      }  else {
        state = AsyncData(result['message']);

      }
      
    }on AsyncError catch (e,st) {
      state = AsyncError(e,st);
    }

    
  }
}

