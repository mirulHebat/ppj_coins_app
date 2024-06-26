import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ppj_coins_app/PurchaseOrder/pOrder.dart';
import 'package:ppj_coins_app/PurchaseOrder/viewPOPage.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'loadscreen/loadscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('lastLogin');
  await Hive.openBox('history');
  HttpOverrides.global = MyHttpOverrides();
  runApp(Phoenix(
    child: const ProviderScope(
      child: MyApp(),
    ),
  ));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends ConsumerWidget  {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/homepage": (context) => Loader(),
        "/purchaseOrderHome" : (context) => Order(),
        "/viewPO" : (context) => viewPOPage(),
      },
      theme: ThemeData(
        primaryColor:ref.watch(primaryColor),
      ),
      home: const  SplashScreen(),
     
    );
  }
}
