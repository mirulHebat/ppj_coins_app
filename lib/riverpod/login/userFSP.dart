import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('lastLogin');
var actionsHistoryBox = Hive.box('history');


final userDetailProv = Provider<UserDetail>((ref) => UserDetail());
final userDetailCtrl = StateNotifierProvider<UserDetail, List>((ref) => UserDetail());

class UserDetail extends StateNotifier<List> {
  UserDetail() : super(box.get('userFSP') ?? []);

  // bool get isNotEmpty => null;

  setUserDetails(List<String> userSharedPref){
    box.put('userFSP', userSharedPref);
    return state = userSharedPref;
  }
  getUserDetails(){
    var tempfsp = box.get('userFSP');
    if(tempfsp!=null && tempfsp.isNotEmpty){
      print('got prev user data');
      print(tempfsp);
      return state = tempfsp;
    }else{
      return state = [];
    }
  }
  resetUser(){
    box.put('userFSP', []);
    print('cleared prev user data');
    return state = [];
  }

}
final rememberMeProv = Provider<RememberMe>((ref) => RememberMe());
final rememberMeSNP = StateNotifierProvider<RememberMe, bool>((ref) => RememberMe());
class RememberMe extends StateNotifier<bool> {
  RememberMe() : super(box.get('rememberMe') ?? false) ;

  setRememberMe(bool rememberMe){
    box.put('rememberMe',rememberMe);
    return state = rememberMe;
  }
  getRememberMe(){
    var tempRM = box.get('rememberMe');
    if(tempRM!=null){
      return state = tempRM;
    }else{
      return state = false;
    }
  }

}

final actHistoryProv = Provider<ActionsHistory>((ref) => ActionsHistory());
final actHistoryNotifier = StateNotifierProvider<ActionsHistory, List>((ref) => ActionsHistory());
class ActionsHistory extends StateNotifier<List> {
  ActionsHistory() : super([]) ;

  setActions(userName, actionDetails){
    actionsHistoryBox.put(userName , actionDetails);
    return state = actionDetails;
  }
  getActions(userName){
    var tempRM = actionsHistoryBox.get(userName);
    if(tempRM!=null && tempRM.isNotEmpty){
      return state = tempRM;
    }else{
      print('no data getactions');
      return state = [];
    }
  }

}


