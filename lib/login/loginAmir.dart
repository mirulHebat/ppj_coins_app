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
  Color customColor = Color(0xFF1647AF);

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
            ),
          ),
           
          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, child) => 
                    Container(
                      height: h * 0.3, // Adjust height as needed
                      width: MediaQuery.of(context).size.width,  // Adjust width as needed
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(100),
                        color: customColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/pdrm.png",
                            height: h * 0.15, // Adjust logo height as needed
                            width: h * 0.15, // Adjust logo width as needed
                            fit: BoxFit.fitHeight,
                          ),
                          SizedBox(height: 8), // Adjust spacing between logo and title
                          Text(
                            "I-FLeet",
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(width: w * 0.03),
                ],
              ),
            ],
          ),
        ),

          Padding(
            padding:  EdgeInsets.only(top: h*0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // height: h*0.1,
                  // width: w*0.8,
                  child : Column(
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(fontSize: h * 0.04, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Enter your login details below',
                        style: TextStyle(fontSize: h * 0.02),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
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
                      color: ref.watch(truewhite),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ref.watch(primaryColor),width:2)
                    ),
                    height: h*0.06,
                    width: w*0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: w*0.04,),
                        Icon(
                          FontAwesome5.user,
                          color: ref.watch(primaryColor),
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
                                color: ref.watch(primaryColor)
                              ),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText:  'Username',
                                hintStyle: TextStyle(color:ref.watch(primaryColor),fontSize: h*0.02),
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
                      color: ref.watch(truewhite),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ref.watch(primaryColor),width:2),
                      
                    ),
                    height: h*0.06,
                    width: w*0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: w*0.04,),
                        Icon(
                          FontAwesome5.key,
                          color: ref.watch(primaryColor),
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
                                pwd = txt.trim();
                                if (rmbMewatcher) {
                                  rmbMeupdater.setRememberMe(false);
                                  ref.read(userDetailCtrl.notifier).resetUser();
                                }
                              },
                              style: TextStyle(
                                fontSize: h * 0.02,
                                color: ref.watch(primaryColor)
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: ref.watch(primaryColor), fontSize: h * 0.02),
                              ),
                            ),
                          

                          ),
                          // Text(
                          //   'Forgot Password?',
                          //   style: TextStyle(fontSize: h * 0.02),
                          //   textAlign: TextAlign.end,
                          // )
                            
                          
                        ),
                      ],
                    ),
                  );
                  
                },),
                SizedBox(height: h*0.03,),
                SizedBox(
                  width: w*0.8,
                  child: Row(
                    children: [
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
                                      color: ref.watch(primaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                      
                                    ),
                                    height: h*0.06,
                                    
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Text('Log in',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)),
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
                                    Center(child: Text('Logging in',style: TextStyle(fontSize:h*0.02,fontWeight: FontWeight.normal,color: ref.watch(truewhite)),textAlign: TextAlign.center,)),
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

// ignore_for_file: must_be_immutable


