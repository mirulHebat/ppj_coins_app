import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:ppj_coins_app/login/profile.dart';
import 'package:ppj_coins_app/login/profilePage.dart';
import '../riverpod/utilities/colors.dart';



class updateProfilePage extends ConsumerStatefulWidget {
  const updateProfilePage({Key? key}) : super(key: key);
  

  @override
  ConsumerState<updateProfilePage> createState() => _updateProfilePageState();
  
}

class _updateProfilePageState extends ConsumerState<updateProfilePage> {   
  List<dynamic> myList = [];
  List<dynamic> fieldSearch = [];
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
    Map<String, dynamic> saveItems = {};

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
    String? id;
    print('187' + myList.toString());
    print(address);



        if (myList.isNotEmpty) {
          List<dynamic> list1 = myList[0];
          // Access the first element of the list
          Map<String, dynamic> firstItem = list1[0];

          // Now you can access the elements of the map
          id = firstItem['item_id'] ?? '';
          title = firstItem['metadata']?['title'] ?? '';
          email = firstItem['metadata']?['email_addr'] ?? '';
          phone = firstItem['metadata']?['mobile_phone_no'] ?? '';
          emp = firstItem['metadata']?['employee_number'] ?? '';
          job = firstItem['metadata']?['job_title'] ?? '';
          streetAddress = firstItem['metadata']?['Street_Address'] ?? '';
          streetAddressLine2 = firstItem['metadata']?['Street_Address_Line_2'] ?? '';
          postalCode = firstItem['metadata']?['Postal_Code'] ?? '';
          city = firstItem['metadata']?['City'] ?? '';
          state = firstItem['metadata']?['State'] ?? '';
          country = firstItem['metadata']?['Country'] ?? '';

          address = '$streetAddress, $streetAddressLine2, $postalCode, $city, $state, $country';
        } else {
          print('The list is null or empty.');
        }

            final TextEditingController nameController = TextEditingController(text: title);
            final TextEditingController phoneController = TextEditingController(text: phone);
            final TextEditingController empController = TextEditingController(text: emp);
            final TextEditingController jobController = TextEditingController(text: job);
            final TextEditingController mailController = TextEditingController(text: email);
            final TextEditingController st1Controller = TextEditingController(text: streetAddress);
            final TextEditingController st2Controller = TextEditingController(text: streetAddressLine2);
            final TextEditingController pcController = TextEditingController(text: postalCode);
            final TextEditingController cityController = TextEditingController(text: city);
            final TextEditingController stateController = TextEditingController(text: state);
            final TextEditingController countryController = TextEditingController(text: country);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile')
      ),
      // body: SingleChildScrollView(
      body: 
      Column(
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
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FontAwesome5.user,
                                size: 60, // Adjust the size of the icon as needed
                                color: Colors.blue, // Change the color of the icon as needed
                              ),
                    ),
                  ],
                ),
              ),
              
      
                      TextField(
                        controller: nameController,
                        style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(truewhite)),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          saveItems['title'] = value;
                        },
                      ),
      
                        TextField(
                          controller: phoneController,
                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(truewhite)),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onChanged: (value) {
                            saveItems['mobile_phone_no'] = value;
                          },
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: empController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'Employee ID',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['employee_number'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: jobController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'Job Title',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['job_title'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: mailController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'email ID',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['email_addr'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: st1Controller,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'Street Address 1',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['Street_Address'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: st2Controller,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'Street Address 2',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['Street_Address_Line_2'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: pcController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'Postcode',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['Postal_Code'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: cityController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'City',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['City'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: stateController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'State',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['State'] = value;
                                          },
                                        ),
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
                                  padding: EdgeInsets.only(top: h*0.01, bottom: h*0.00, left: w*0.02, right: w*0.02),
                                  child: Container(
                                    height: h*0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:ref.read(truegray).withOpacity(1),
                                        width: h*0.002
                                      ),
                                      color: ref.read(truewhite).withOpacity(0.8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: countryController,
                                          style: TextStyle(fontSize: h * 0.025, fontWeight: FontWeight.bold, color: ref.watch(primaryColor)),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // hintText: 'Country',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) {
                                            saveItems['Country'] = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => profilePage()));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print(saveItems);
                                print(id);
                                saveItems['item_id'] = id;
                                findList().saveList(saveItems);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => profilePage()));
                                // Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: Text('Save'),
                            ),

                          ],
                        ),
                        ],
                    ),
                  ),
                ),
            ),
            //end here
          ],
        ),
      );
    
  }
}

