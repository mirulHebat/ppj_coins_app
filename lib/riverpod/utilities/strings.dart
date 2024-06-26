import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/maintenance_detail.dart';


final mainURL = StateProvider<String>((ref) {
  return 'lawanow.com' ;
});

final poList = StateProvider<List>((ref) {
  return [] ;
});

final shouldIrb = StateProvider<bool>((ref) {
  return true ;
});

final poDetArray = StateProvider<List>((ref) {
  return [] ;
});


final selectFaultCategory = StateProvider<String?>((ref) {
  return '' ;
});

final labor_subtotal = StateProvider<double>((ref) {
  return 0.0 ;
});

final listfault = StateProvider<List>((ref) {
  return [] ;
});


final secretkey = Provider<String>((ref) {
  return 'UY645ght' ;
});

final repoID = Provider<String>((ref) {
  return 'ifleet' ;
});

final appID = Provider<String>((ref) {
  return 'HypER-admin' ;
});

final userRole = StateProvider<String>((ref) {
  return '' ;
});