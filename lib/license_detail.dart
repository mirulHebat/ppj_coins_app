import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:ppj_coins_app/fuel_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:ppj_coins_app/home/homepage.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/utilities/colors.dart';
import 'package:ppj_coins_app/loader/loader.dart';
import 'package:http/http.dart' as http;
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'dart:convert';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import '../riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/addFuel.dart';
import 'package:ppj_coins_app/add_vehicle.dart';
import 'package:ppj_coins_app/Assignment.dart';
import 'package:ppj_coins_app/license_info.dart';
import 'package:ppj_coins_app/sample.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class License_detail extends StatefulWidget {
final  ContactData licenseData;
  License_detail({Key? key,required this.licenseData}) : super(key: key);

  @override
   State<License_detail>  createState() => License_detail_state();

}

class License_detail_state extends  State<License_detail> {
   var shouldPop=false;
   late PageController controller;
  late int _selectedIndex;
    Color customColor = Color(0xFF1647AF);
    void _onItemTapped(int index) {
    setState(() {

      if (controller.hasClients) {
        controller.jumpToPage(
          index,
        );
      }
    });
  
     
  }

   void onPageChanged(int pagenum) {
    setState(() {
      _selectedIndex = pagenum;
    });
  }

    @override
  void initState() {
    controller = PageController(initialPage: 0);
    _selectedIndex=0;
    super.initState();
  
   
  }


   Widget build(BuildContext context){
      var w = MediaQuery.of(context).size.width;
      var h = MediaQuery.of(context).size.height;

       return WillPopScope
       (
            onWillPop: () async {
              return shouldPop;
            },
                child: Scaffold(
                extendBody: true,


            // Future completed, proceed to build UI
            body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: h*0.05,),
                  Consumer(builder: (context, ref, child) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:  EdgeInsets.only(top: h*0.0,bottom: h*0.00 ,left: w*0.0,right: w*0.0),
                            child: Container(
                              height: h*0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:ref.read(truewhite).withOpacity(1),
                                  width: MediaQuery.of(context).size.width * 0.002,
                                ),
                                color: customColor
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                      padding: EdgeInsets.only(right: w * 0.02), // Adjust the right padding as needed
                                      child: IconButton(
                                        icon: Icon(
                                          FontAwesome5.arrow_circle_left,
                                          color: Colors.white,
                                          size: h * 0.02,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);

                                        },
                                      ),
                                    ),
                                          Text(
                                            "Edit License  Information ", // Replace with your actual title text
                                            style: TextStyle(fontSize: h * 0.03, fontWeight: FontWeight.bold, color: Colors.white), // Customize the style as needed
                                          ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  ),
                  // SizedBox(height: h*0.02,),
                  
                  Expanded(
                    child: PageView(
                      controller: controller,
                      onPageChanged: onPageChanged,
                      children: <Widget>[
                        License_page(licenseData: widget.licenseData)

                      ],
                    ),
                  )
                ],
              )
              
            ],
          ),
                                 
    )


       );


   }

}

class License_page extends StatefulWidget{
 final ContactData licenseData;
   License_page({Key? key, required this.licenseData}) : super(key: key);
    @override
  License_page_state createState() => License_page_state();

}

class License_page_state extends State<License_page> {
  File? _image;
  String image_path="";
  TextEditingController expired = TextEditingController();
  TextEditingController lic_class = TextEditingController();
  TextEditingController lic_num = TextEditingController();
  late PageController controller;
  ContactData Contact = ContactData(expired_date: "", license_num: "", license_class: "",image: "",fleetData: "");
  int _selectedIndex = 0;

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    _selectedIndex = 0;

  }

  Future<void> viewContact() async {
  final findContact fContact = findContact();
  Contact=await fContact.createContact("");
  setState(() {
  
  });

}

    @override
  void dispose() 
  {
        super.dispose();
        expired.dispose();
        lic_class.dispose();
        lic_num.dispose();


  }

  

  Future<void> _pickImage() async {
     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        image_path=pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

    @override
    Widget build(BuildContext context) {
      expired.text = widget.licenseData.expired_date;
      return Scaffold(
        body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              color: Color.fromARGB(255, 145, 203, 250),
              child: Center(
                child: Text(
                   'License Information',  
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                children: [
                  Expanded(
                    child: Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: TextFormField(
                      readOnly: true, 
                       controller: expired,
                      decoration: InputDecoration(
                        labelText: 'License Expired Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {

                         DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                       if (selectedDate != null) {
                          expired.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                          return;

                      }
                    },

                    ),
                  ),

                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: TextFormField(
                    
                         initialValue: widget.licenseData.license_class,
                        onChanged: (value) {
                          lic_class.text = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'License Class',
                          border: OutlineInputBorder(),
                          
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ],
            ),
          ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                initialValue: widget.licenseData.license_num,
                onChanged: (value) {
                  // Update the controller's text when user types
                  lic_num.text = value;
                },
                decoration: InputDecoration(
                  labelText: 'License Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),


            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              color: Color.fromARGB(255, 145, 203, 250),
              child: Center(
                child: Text(
                  'License Image',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Column(
            children: <Widget>[
              _image == null
                  ? Text('No image selected.')
                  : SizedBox(
                      width: 200, // Set the desired width
                      height: 200, // Set the desired height
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                    ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
            ],
          ), 
            
            // Add some space between the text fields and the button
            ElevatedButton(
              onPressed: () async{
                if(expired.text =="")
                {
                  expired.text =widget.licenseData.expired_date;
                }

                if(lic_class.text =="")
                {
                  lic_class.text =widget.licenseData.license_class;
                }

                if(lic_num.text =="")
                {
                  lic_num.text =widget.licenseData.license_num;
                }
                findContact fContact =findContact();
                String valuelicense=await fContact.editlicense(expired.text,lic_num.text,lic_class.text,image_path);

                Timer(Duration(seconds: 5),(){
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => License_info(itemId: valuelicense),
                    ),
                  );


                 });
      
                // Add your save logic here
              },
              child: Text('Save'),
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
            ),
            ),
          ],
        ),
      ),

      );

    }

}

class findContact 
{
   Future<ContactData> createContact(String itemId) async {

      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String user_session_id=userDetails.isNotEmpty ? userDetails[1] : '';
      String Full_name = userDetails.isNotEmpty ? userDetails[6] : '';
      Vehicle_Save veh_save =Vehicle_Save();
      String contactId= await veh_save.findContact(Full_name);
      if(itemId !="")
      {
        contactId=itemId;
      }
      picture pictu =picture();
      String image_id=await pictu.findImage(ifleetData,contactId);
      if (userDetails.isNotEmpty) {
      

      } else {
  
     
        return ContactData(expired_date: "", license_num: "", license_class: "",image: "",fleetData:"");
      
      }  
        print(contactId);
        print(ifleetData);

        http.Response response;
        var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"action":"ADVANCED_SEARCH",'+
        '"item_type_codes":["cn002"],'+
        '"query":"( item_id = &quot;'+contactId+'&quot; )",'+
        '"sort_order":"ASC",'+
        '"details":["metadata"]'+
        
      '}');

         Map<String, String> headersModified = {};
        if (userDetails.isNotEmpty) {
          headersModified['cookie'] = userDetails[3];
        }

        response = await http.post(Uri.parse('https://lawanow.com/bims-web/ItemSearch?param=$usell'), headers: headersModified,);

        if (response.statusCode == 200) 
        {
          Map<String, dynamic> result = json.decode(response.body);

          if (result['success'] == true)
          {

            String exp_date="";
            String num_license="";
            String li_class="";
            void parseResult(Map<String, dynamic> result) {
            if (result['results'] != null && result['results'].isNotEmpty) {
              Map<String, dynamic> metadata = result['results'][0]['metadata'];

              exp_date = (metadata['license_expired_date'] ?? "").isNotEmpty ? metadata['license_expired_date'] : "";
              num_license = (metadata['license_number'] ?? "").isNotEmpty ? metadata['license_number'] : "";
              li_class = (metadata['license_class'] ?? "").isNotEmpty ? metadata['license_class'] : "";
            }
          }
            parseResult(result);
            return ContactData(expired_date: exp_date, license_num: num_license, license_class:li_class,image:image_id,fleetData:ifleetData);

          }
          else
          {
            
            throw Exception('Error: ${result['message']}');
          }
          
        }
        else 
        {
          print('xsuccess');
        }

        return ContactData(expired_date: "", license_num: "", license_class: "",image: "",fleetData: "");


   }

   Future<String> editlicense(String exp_date,String num_license,String li_class,String  _image)async
   {

      UserDetail userDetail = UserDetail();
      List<String> userDetails = userDetail.getUserDetails();
      String ifleetData = userDetails.isNotEmpty ? userDetails[0] : '';
      String id_user = userDetails.isNotEmpty ? userDetails[1] : '';
      String Full_name = userDetails.isNotEmpty ? userDetails[6] : '';
      Vehicle_Save veh_save =Vehicle_Save();
      String contactId= await veh_save.findContact(Full_name);
      picture pic =picture();
      if(_image !="")
      {
        await pic.checkPicture(ifleetData,contactId);
        await pic.savePic(ifleetData,contactId,_image);
        await pic.checkPictureDone(ifleetData,contactId);

      }
      
      http.Response response;
      var usell = Uri.encodeQueryComponent('{'+
        '"bims_access_id":"$ifleetData",'+
        '"action":"SAVE_ITEM",'+
        '"metadata":{"item_type_id":"ityp-11962a26708945e0a67be504cf31def6","item_id":"$contactId","license_expired_date":"$exp_date","license_number":"$num_license","license_class":"$li_class"}'+
          
      '}');

      Map<String, String> headersModified = {};
      if (userDetails.isNotEmpty) {
        headersModified['cookie'] = userDetails[3];
      }

      response = await http.post(Uri.parse('https://lawanow.com/bims-web/Item?param=$usell'), headers: headersModified,);

      if (response.statusCode == 200){

        Map<String, dynamic> result = json.decode(response.body);


        if (result['success'] == true){
           return result['item_id'];
        }
        else
        {
          return "";
        }

      }
      else
      {
        return "";
      }


   }


}

   class ContactData {
      final String expired_date;
      final String license_num;
      final String license_class;
      final String image;
      final String fleetData;

      ContactData({required this.expired_date, required this.license_num, required this.license_class,required this.image,required this.fleetData});
    }