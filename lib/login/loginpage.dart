// ignore_for_file: must_be_immutable

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';

import '../loader/loader.dart';
import '../riverpod/utilities/strings.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController emailTC = TextEditingController();
  TextEditingController pwdTC = TextEditingController();
  String email = '';
  String pwd = '';
  bool isDynamicRepo = true;

  Widget build(BuildContext context){
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    print('build login');
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Consumer(builder: (context, ref, child) => 
            Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ref.watch(offwhite),
            // child: Opacity(opacity: 0.2,child: Image.asset("assets/bg3.png",fit: BoxFit.fill,))
            ),
          ),
           
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Consumer(builder: (context, ref, child) => 
                  Opacity(
                    opacity: 1,
                    child: Blob.animatedRandom(
                      styles:  BlobStyles(
                        color:  ref.watch(secondaryColor),
                        fillType:  BlobFillType.fill,
                        strokeWidth:3,
                      ),
                      size:800,
                      edgesCount:5,
                      minGrowth:4,
                      duration:  const Duration(seconds:5),
                      loop: true,
                    ),
                  ),
                ),
                
              ],
            ),
          ),

          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Consumer(builder: (context, ref, child) => 
                  Opacity(
                    opacity: 1,
                    child: Blob.animatedRandom(
                      styles:  BlobStyles(
                        color:  ref.watch(primaryColor),
                        fillType:  BlobFillType.fill,
                        strokeWidth:3,
                      ),
                      size:500,
                      edgesCount:4,
                      minGrowth:4,
                      duration:  const Duration(seconds:5),
                      loop: true,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer(builder: (context, ref, child) => 
                      Container(
                        height:h*0.17 ,
                        width: h*0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: ref.watch(truewhite)
                        ),
                        child: Center(
                          child: Image.asset("assets/logo.png",
                          height:h*0.15 ,
                          width: h*0.15,
                          fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: w*0.04,)
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(bottom: h*0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // height: h*0.1,
                  width: w*0.8,
                  child:  Text('Log\nMasuk',style: TextStyle(fontSize:h*0.07,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)
                  
                ),
                SizedBox(height: h*0.01,),
                Consumer(builder: (context, ref, child) {
                  var usrDetView = ref.read(userDetailProv).getUserDetails(); //////

                  var rmbMe = ref.read(rememberMeProv).getRememberMe();
                  var rmbMewatcher = ref.watch(rememberMeSNP);
                  var rmbMeupdater = ref.watch(rememberMeSNP.notifier);

                  if(usrDetView.isNotEmpty && rmbMe){
                    emailTC.text=usrDetView[2];
                    email = emailTC.text;
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: ref.watch(primaryColor),
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: ref.watch(truegray),width:2)
                    ),
                    height: h*0.06,
                    width: w*0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: w*0.04,),
                        Icon(
                          FontAwesome5.user,
                          color: ref.watch(truewhite),
                          size: h*0.02,
                          
                        ),
                        SizedBox(width: w*0.04,),
                        SizedBox(
                          height: h*0.06,
                          width: w*0.5,
                          child: Center(
                            child: TextField(
                              obscureText: false,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              controller: emailTC,
                              onChanged: (String txt) {
                                email=txt.trim();
                                if(rmbMewatcher){
                                  rmbMeupdater.setRememberMe(false);
                                  ref.read(userDetailCtrl.notifier).resetUser();
                                }
                              },
                              style: TextStyle(
                                fontSize: h*0.02,
                                color: ref.watch(truewhite)
                              ),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText:  'Nama pengguna',
                                hintStyle: TextStyle(color:ref.watch(truewhite),fontSize: h*0.02),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },),
                SizedBox(height: h*0.01,),
                Consumer(builder: (context, ref, child) {
                  var usrDetView = ref.read(userDetailProv).getUserDetails();

                  var rmbMe = ref.read(rememberMeProv).getRememberMe();
                  var rmbMewatcher = ref.watch(rememberMeSNP);
                  var rmbMeupdater = ref.watch(rememberMeSNP.notifier);

                  if(usrDetView.isNotEmpty && rmbMe){
                    pwdTC.text=usrDetView[4];
                    pwd = pwdTC.text;


                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: ref.watch(primaryColor),
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                    height: h*0.06,
                    width: w*0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: w*0.04,),
                        Icon(
                          FontAwesome5.key,
                          color: ref.watch(truewhite),
                          size: h*0.02,
                          
                        ),
                        SizedBox(width: w*0.04,),
                        SizedBox(
                          height: h*0.06,
                          width: w*0.5,
                          child: Center(
                            child: TextField(
                              obscureText: true,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              controller: pwdTC,
                              onChanged: (String txt) {
                                pwd=txt.trim();
                                if(rmbMewatcher){
                                  rmbMeupdater.setRememberMe(false);
                                  ref.read(userDetailCtrl.notifier).resetUser();
                                }
                              },
                              style: TextStyle(
                                fontSize: h*0.02,
                                color: ref.watch(truewhite)
                              ),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Katalaluan',
                                // hintText: ref.watch(userDetailCtrl).isNotEmpty ? ref.watch(userDetailCtrl)[1] :'Katalaluan',
                                hintStyle: TextStyle(color:ref.watch(truewhite),fontSize: h*0.02),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },),
                SizedBox(height: h*0.01,),
                isDynamicRepo ?
                Consumer(builder: (context, ref, child) {
                  var repoName = ref.watch(mainURL);
                  var repoNoti = ref.read(mainURL.notifier);

                  return InkWell(
                    onTap: (){
                      if(repoName == 'perolehan.ppj.gov.my'){
                        repoNoti.state = 'devperolehan.ppj.gov.my';
                      }else{
                        repoNoti.state = 'perolehan.ppj.gov.my';

                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: repoName =='perolehan.ppj.gov.my'? ref.watch(trueOrange):ref.watch(negativeColor),
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      height: h*0.06,
                      width: w*0.8,
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  Text("Basic: " + ref.watch(counterController).toString())
                          Text(repoName== 'perolehan.ppj.gov.my'?
                            "Production Mode":"Development Mode",
                            style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                  );
                },)
                :Container(),
                SizedBox(height: h*0.01,),
                SizedBox(
                  width: w*0.8,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Consumer(builder: (context, ref, child) {
                          var rmbMe = ref.watch(rememberMeSNP);
                          var rmbMeNoti = ref.watch(rememberMeSNP.notifier);

                          return InkWell(
                            onTap: (){
                              if(rmbMe){
                                rmbMeNoti.setRememberMe(false);
                                ref.read(userDetailCtrl.notifier).resetUser();
                              }else{
                                rmbMeNoti.setRememberMe(true);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: rmbMe ? ref.watch(positiveColor):ref.watch(negativeColor),
                                borderRadius: BorderRadius.circular(10),
                                
                              ),
                              height: h*0.06,
                              
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //  Text("Basic: " + ref.watch(counterController).toString())
                                  Icon(
                                    rmbMe ?
                                    FontAwesome5.user_check:FontAwesome5.user_times,
                                    color: ref.watch(truewhite),
                                    size: h*0.02,
                                  )
                                ],
                              ),
                            ),
                          );
                        },),
                      ),
                      SizedBox(width: w*0.02,),
                      Expanded(
                        flex: 4,
                        child: Consumer(builder: (context, ref, child) {
                          final runLogin = ref.watch(loginProvider);
                          return runLogin.when(
                            data: (state){
                              print(state.toString());
                              if(state=='idle'){
                                return InkWell(
                                  onTap: (){
                                    if(email.isNotEmpty && pwd.isNotEmpty){
                                      ref.read(loginProvider.notifier).loginUser(email, pwd, ref.read(userDetailCtrl.notifier).getUserDetails(),ref);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ref.watch(secondaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                      
                                    ),
                                    height: h*0.06,
                                    
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Text('Seterusnya',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)),
                                        SizedBox(width: w*0.04,),
                                        Icon(
                                          FontAwesome5.arrow_circle_right,
                                          color: ref.watch(truewhite),
                                          size: h*0.02,
                                          
                                        ),
                                      ],
                                    ),
                                    
                                  ),
                                );
                              }else if(state=='Selesai'){
                                print("in Selesai");
                                Future.delayed(const Duration(milliseconds: 100),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Loader())));
                                return Container(
                                  decoration: BoxDecoration(
                                    color: ref.watch(secondaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: h*0.06,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Text(state,style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)),
                                    ],
                                  ),
                                  
                                );
                              }else{
                                return InkWell(
                                  onTap: (){
                                    ref.read(loginProvider.notifier).init();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ref.watch(secondaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: h*0.06,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: w*0.5,
                                          child: Center(child: Text(state,style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,maxLines: 2))),
                                      ],
                                    ),
                                    
                                  ),
                                );
                              }
                            }, 
                            error: (Object error, StackTrace stackTrace) {
                              return InkWell(
                                  onTap: (){
                                    ref.read(loginProvider.notifier).init();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ref.watch(secondaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: h*0.06,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Text(error.toString(),style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)),
                                      ],
                                    ),
                                    
                                  ),
                                );
                            },
                            loading: () {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ref.watch(truegray),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: h*0.06,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: Text('Sedang log masuk',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)),
                                  ],
                                ),
                                
                              );
                            },
                          );
                        },),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

