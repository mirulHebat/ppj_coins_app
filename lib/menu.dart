import 'package:flutter/material.dart';
import 'package:ppj_coins_app/Fuel_Entries.dart';
import 'package:ppj_coins_app/PurchaseOrder/pOrder.dart';
import 'package:ppj_coins_app/work_entries.dart';
import 'package:ppj_coins_app/license_entries.dart';
import 'package:ppj_coins_app/list_maintenance.dart';

class NavigationBarExample extends StatelessWidget {
String role_assign="";
bool showFloatingActionButton = false;
bool showFloatingTechnician = true;

     NavigationBarExample({Key? key}) : super(key: key);

    Future<void> getRoleMenu()async
    {
        findListWork assign =findListWork();
        role_assign =await assign.assignRole();
      if(role_assign =="iFMS Manager")
      {
        showFloatingActionButton=true;
      }
       if(role_assign =="iFMS Technician")
      {
        showFloatingTechnician=false;
      }

      
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body:FutureBuilder(
         future:getRoleMenu(),
       builder: (context, snapshot) 
       {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Display a loading indicator while waiting for the future to complete
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Display an error message if the future completes with an error
            );
          } else{
            return Column(
        children: [
          SizedBox(height: 30),
          Visibility(
             visible:showFloatingTechnician, 
             child:Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.local_gas_station,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Fuel Consumption Entries',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderFuel(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

          Visibility(
            visible:showFloatingTechnician, 
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child:Container(
            margin: EdgeInsets.symmetric(horizontal: 24,),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.assignment,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Vehicle Assignment',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderWork(),
                    ),
                  );
                },
              ),
            ),
          ),
          ),
          ),
          Visibility(
            visible: (showFloatingActionButton), 
            child:Padding(
              padding: EdgeInsets.only(top: 10),
              child:Container(
            margin: EdgeInsets.symmetric(horizontal: 24,),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: Colors.white,
                  ), 
                ),
                title: Text(
                  'License',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderLicense(),
                    ),
                  );
                },
              ),
            ),
          ),
          )
          ),
          Visibility(
          visible: (!showFloatingActionButton), 
          child: Padding(
              padding: EdgeInsets.only(top: 10),
              child:Container(
            margin: EdgeInsets.symmetric(horizontal: 24,),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.car_repair,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  (showFloatingTechnician) ? 'Service Report ' : ' Work Order ',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderMaintenance(),
                    ),
                  );
                },
              ),
            ),
          ),
          ),
          ),
          Visibility(
          visible: (!showFloatingTechnician), 
          child: Padding(
              padding: EdgeInsets.only(top: 10),
              child:Container(
            margin: EdgeInsets.symmetric(horizontal: 24,),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.car_repair,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                   ' Purchase Order ',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Order(),
                    ),
                  );
                },
              ),
            ),
          ),
          ),
          ),
        ],
      );
          }
       }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
