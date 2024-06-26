import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/login/profile.dart';
import 'package:ppj_coins_app/login/updateProfilePage.dart';
import '../riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';



class profilePage extends ConsumerStatefulWidget {
  const profilePage({Key? key}) : super(key: key);
  

  @override
  ConsumerState<profilePage> createState() => _profilePageState();
  
}

class _profilePageState extends ConsumerState<profilePage> {
  List<dynamic> myList = [];
  bool isRowVisible = false;
  @override
  void initState(){
    super.initState();
    final Profile pfp = Profile();
     Future.delayed(Duration.zero, () async {
      List<dynamic> result = await pfp.createList();
      setState(() {
        myList = result; 
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    String? title;
    String? email; 
    String? phone;
    String? address;
    String? emp;
    String? job;
    String? streetAddress;
    String? streetAddressLine2;
    String? postalCode;
    String? city;
    String? state ;
    String? country;
    String? lNum;
    String? lDate;
    String? lClass;
    String? lphoto;

    UserDetail userDetail = UserDetail();
    List<String> userDetails = userDetail.getUserDetails();
    String accessId = userDetails[0];
    print(accessId);
    Map<String,String> headersModified = {};
    if (userDetails.isNotEmpty) {
      headersModified['cookie'] = userDetails[3];
    }
    print(headersModified);
    print('187' + myList.toString());

        // Image.network('url',headers: headers,);url?param={bims}

        if (myList.isNotEmpty) {
          List<dynamic> list1 = myList[0];
          Map<String,dynamic> list2 = myList[1];
          print(myList.length);
          print(list2);
          // Access the first element of the list
          Map<String, dynamic> firstItem = list1[0];
          // Map<String, dynamic> secItem = list1[1];

          // Now you can access the elements of the map
          title = firstItem['metadata']?['title'] ?? 'Unknown';
          email = firstItem['metadata']?['email_addr'] ?? 'Unknown';
          phone = firstItem['metadata']?['mobile_phone_no'] ?? 'Unknown';
          emp = firstItem['metadata']?['employee_number'] ?? 'Unknown';
          job = firstItem['metadata']?['job_title'] ?? 'Unknown';
          streetAddress = firstItem['metadata']?['Street_Address'] ?? '';
          streetAddressLine2 = firstItem['metadata']?['Street_Address_Line_2'] ?? '';
          postalCode = firstItem['metadata']?['Postal_Code'] ?? '';
          city = firstItem['metadata']?['City'] ?? '';
          state = firstItem['metadata']?['State'] ?? '';
          country = firstItem['metadata']?['Country'] ?? '';
          lClass = firstItem['metadata']?['license_class'] ?? '';
          lNum = firstItem['metadata']?['license_number'] ?? '';
          lDate = firstItem['metadata']?['license_expired_date'] ?? '';
          lphoto = list2['file_url'] ?? '';

          address = '$streetAddress, $streetAddressLine2, $postalCode, $city, $state, $country';

          // Access other fields as needed

          print('Title: $title');
          print('Email: $email');
          print('web:  $lphoto');
          print('$lphoto?param={"bims_access_id" : "$accessId"}, headers: $headersModified,');
        } else {
          print('The list is null or empty.');
        }

        return Scaffold(
          appBar: AppBar(
                      leading: InkWell(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.blue,
                        ),
                      ),
                    ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(40),
              color: ref.watch(primaryColor),
              child: Center(
                child: Column(
                  children: [
                    Text(
                        'Profile Page',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  // color: Colors.white,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    // color: Colors.white,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/Royal_Malaysian_Police.png",
                                width: 120,
                                height: 120, 
                                fit: BoxFit.contain, 
                              ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // Add your onTap function here
                          Navigator.push(context, MaterialPageRoute(builder: (context) => updateProfilePage()));
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.red,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

                      Text(
                        '$title',
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          color: ref.watch(truewhite),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        '$phone',
                        style: TextStyle(
                          fontSize: h * 0.02,
                          fontWeight: FontWeight.bold,
                          color: ref.watch(truewhite),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),


                  ],
                  ),
                )
            ),

            
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Consumer(builder: (context, ref, child) =>
                                Padding(
                                padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.0),
                                child: Container(
                                  height: h*0.1,
                                  width: w*1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:ref.read(truegray).withOpacity(1),
                                      width: h*0.002
                                    ),
                                    color: ref.read(primaryColor).withOpacity(0.7),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: w*0.02,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                                  padding: EdgeInsets.only(top: h*0.025, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            'User Details',
                                                            style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.white),
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                   ),
                                ),
                            ),
                            ],
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Consumer(builder: (context, ref, child) =>
                                Padding(
                                padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.0),
                                child: InkWell(
                                  child: Container(
                                    height: h*0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: w*0.02,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                    padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Employee ID: $emp',
                                                            style: TextStyle(fontSize: h*0.025, fontWeight: FontWeight.bold, color: Colors.black),
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                              Padding(
                                                    padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Job Title: $job',
                                                            style: TextStyle(fontSize: h*0.025, fontWeight: FontWeight.bold, color: Colors.black),
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                              Padding(
                                                    padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Email: $email',
                                                            style: TextStyle(fontSize: h*0.025, fontWeight: FontWeight.bold, color: Colors.black),
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            'Address: $address',
                                                            style: TextStyle(fontSize: h*0.025, fontWeight: FontWeight.bold, color: Colors.black),
                                                            textAlign: TextAlign.start,
                                                            // overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                     ),
                                   ),
                                ),
                            ),
                            ],
                          ),           
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Consumer(builder: (context, ref, child) =>
                                Padding(
                                padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if(isRowVisible == true){
                                        isRowVisible = false;
                                      }else{
                                        isRowVisible = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: h*0.15,
                                    width: w*1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(primaryColor).withOpacity(0.7),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: w*0.02,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                    padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'License',
                                                            style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.white),
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        Icon(
                                                          isRowVisible ? Icons.keyboard_arrow_down_outlined: Icons.arrow_forward, 
                                                          size: h * 0.03,
                                                          color: Colors.black, 
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                     ),
                                   ),
                                ),
                            ),
                            ],
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Visibility(
                                visible: isRowVisible,
                                child: Consumer(builder: (context, ref, child) =>
                                  Padding(
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.0),
                                  child: Container(
                                    height: h*0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: w*0.02,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                      padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'License Class : $lClass',
                                                              style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.black),
                                                              textAlign: TextAlign.start,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'License Number : $lNum',
                                                              style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.black),
                                                              textAlign: TextAlign.start,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                      Padding(
                                                      padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'License Expiry Date : $lDate',
                                                              style: TextStyle(fontSize: h*0.03, fontWeight: FontWeight.bold, color: Colors.black),
                                                              textAlign: TextAlign.start,
                                                              // overflow: TextOverflow.ellipsis,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.only(top: h*0.05, bottom: h*0.0, left: w*0.02, right: w*0.08),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Image.network(
                                                              '$lphoto?param= '+Uri.encodeQueryComponent('{"bims_access_id" : "$accessId"}'), headers: headersModified, // Replace this with your image URL              
                                                              fit: BoxFit.cover, // Adjust fit as needed
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                     ),
                                  ),
                              ),
                            ),
                            ],
                          ),

                        ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      );



  }
}

