import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:ppj_coins_app/login/loginpage.dart';
import 'package:ppj_coins_app/login/loginAmir.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/riverpod/utilities/widgets.dart';
import 'package:ppj_coins_app/login.dart';



class SplashScreen extends ConsumerStatefulWidget  {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  // ignore: must_call_super
  void initState() {
    // var box = Hive.box('lastLogin');
    // box.put('userFSP', ['','','','']);
     Future.delayed(const Duration(seconds: 1),(){
      ref.read(heightscr.notifier).state = MediaQuery.of(context).size.height;
      ref.read(widthscr.notifier).state = MediaQuery.of(context).size.height;
     });
    
    Future.delayed(const Duration(seconds: 2),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage())));

  }

  @override
  Widget build(BuildContext context){
    // var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
           Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: ref.watch(offwhite),
            // child: Image.asset("assets/w768.jpg",fit: BoxFit.cover,)
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/pdrm.png",
              height:h*0.15 ,
              // width: w,
              fit: BoxFit.fill,
              ),
              SizedBox(height: 10),
              Text(
                'I-Fleet',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue, // Set the color to light blue
                ),
              ),
               SizedBox(height: 10),
              Text(
                'Empowering Your Fleet,\nElevating Efficiency',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // Set the color to light blue
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: h*0.02,),
              LoadingAnimationWidget.prograssiveDots(
                color: ref.watch(primaryColor),
                size: h*0.05,
              ),
            ],
          ),
          // Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: <Widget>[
          //         CircularProgressIndicator(color: ref.watch(primaryColor) ,),
          //         SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             const Text(
          //               "Powered By  ",
          //               style: TextStyle(color: Colors.black, fontSize: 12.00,)
          //             ),
          //             Image.asset(
          //               "assets/images/energeticpoint.png", 
          //               // height: MediaQuery.of(context).size.width*0.25, 
          //               width: MediaQuery.of(context).size.width*0.2,
          //             ),
          //           ],
          //         ),
          //         SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

          //       ],
          //     )
        ],
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {

//   @override
//   void initState() {
//     // var config = Provider.of<Config>(context, listen: false);

//     // super.initState();

//     // config.analytics = widget.analytics;
//     // config.observer = widget.observer;
    
//     // Future.delayed(Duration(milliseconds: 200),() {
//     //   loadUser(context).then((onValue){
//     //     Future.delayed(Duration(seconds: 2), () {
//     //       Navigator.pushReplacement(
//     //       context,
//     //       MaterialPageRoute(builder: (context) => LoginPage()),
//     //     );
//     //     });
//     //   });
//     // });
      
//   }

//   // Future loadUser(BuildContext context) async{
//   //   List users = [];
//   //   List<String> gmail = [];
//   //   List<String> pass = [];

//   //   var user = Provider.of<UserData>(context, listen: false);

//   //   await DatabaseCreator().initDatabase();
//   //   users = await DatabaseCreator().getAllUsers();
    
//   //   for(var i=0;i<users.length;i++){
//   //     gmail.add(users[i]['email']);
//   //     pass.add(users[i]['password']);
//   //   }
//   //   user.gmail=gmail;
//   //   user.pass=pass;
//   //   // print(user.gmail.toString());
//   //   // print(user.pass.toString());

//   //   return true;
//   // }

  
// }