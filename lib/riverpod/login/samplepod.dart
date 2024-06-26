// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;

// var userDetails;
// var bims;
// var userID;
// var username;
// var fullname;
// var photoURL;
// var userProfileData;
// var memberTypeData;
// var userUSRPFID='';
// var hip_member={};
// var newRegister;
// var isFirstLogin=false;

// final repoID = StateProvider<String>((ref) {
//   return 'coin2'  ;
// });
// final idX = StateProvider<String>((ref) {
//   return 'coin2'  ;
// });
// final userFSP = StateProvider<List>((ref) {
//   return []  ;
// });

// var box = Hive.box('myBox');
// var name = box.get('name');
// print('Name: $name');


// class UserDetail extends StateNotifier<List> {
//   UserDetail() : super([]) ;
//   void setUserDetails(List<String> userSharedPref) => box.put('userFSP', userSharedPref);
//   void getUserDetails() => box.get('userFSP');


//   //  getUserDetails() async {
//   // }
// }

// final userProvider = StateNotifierProvider<UserDetail, List>((ref) {
//   return UserDetail();
// });

// // class Counter extends StateNotifier<int> {
// //   Counter() : super(0);
// //   void increment() => state++;
// // }




