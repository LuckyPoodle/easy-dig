import 'package:easydigitalize/helper/authservice.dart';
import 'package:easydigitalize/screens/addcollection.dart';
import 'package:easydigitalize/screens/viewcollections.dart';
import 'package:flutter/material.dart';
import '../helper/components.dart';
import './market.dart';
import 'package:easydigitalize/provider/generalprovider.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';

import 'dart:async';

import '../provider/generalprovider.dart';

import 'package:in_app_purchase/in_app_purchase.dart';



class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AppUser thiscurrentuserdata;
  AuthService authservice;

  String credits='0';

  //  /// Is the API available on the device
  // bool available = true;

  // /// The In App Purchase plugin
  // InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  // /// Products for sale
  // List<ProductDetails> _products = [];

  // /// Past purchases
  // List<PurchaseDetails> _purchases = [];

  // /// Updates to purchases
  // StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
    //initPlatformState();
    User user = Provider.of<User>(context,listen: false);
    AuthService authservice=AuthService();
    authservice.getUserData(user.uid).then((value){
      print('in init state');
      print(value);
      thiscurrentuserdata=value;
      Provider.of<GeneralProvider>(context,listen:false).setNumberOfProductsUploaded(int.parse(thiscurrentuserdata.numberOfProductsUploaded));
      Provider.of<GeneralProvider>(context,listen:false).setlocalcountmaxnumberofProductsUploaded(int.parse(thiscurrentuserdata.maxNumberOfProductsUserCanCreate));
      setState(
        (){
          credits=thiscurrentuserdata.maxNumberOfProductsUserCanCreate;
        }
      );
    });

  

    //save the user's numberofprdtsuploaded and maxuploadcount to provider
    

  }

//     void _initialize() async {

//     // Check availability of In App Purchases
//     available = await _iap.isAvailable();

//     if (available) {
// //retrieve
//       await _getProducts();
//       await _getPastPurchases();

// //we can use future.wait if u want

//       // Verify and deliver a purchase with your own business logic
//       //_verifyPurchase();

      
//       // Listen to new purchases
//       _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
//         print('NEW PURCHASE');
//         _purchases.addAll(data);
//         print('_purchases...');
//         print(_purchases);
//         //_verifyPurchase();
//       }));

//     }
//   }



  // /// Get all products available for sale
  // Future<void> _getProducts() async {
  //   Set<String> ids = Set.from([testID]);
  //   print('in get Products...');
  //   ProductDetailsResponse response = await _iap.queryProductDetails(ids);



  //   print('in get Products response is ...'+response.productDetails.toString());

  //   setState(() { 
  //     _products = response.productDetails;
  //   });
  // }

//   /// Gets past purchases
//   Future<void> _getPastPurchases() async {
//     print('in get Past purchased Products...');
//     QueryPurchaseDetailsResponse response =
//         await _iap.queryPastPurchases();
//         print('in get Past purchased Products response is ...'+response.pastPurchases.toString());
// //this does not return consumed pdt so u should save state of consumed pdt in ur database
//     for (PurchaseDetails purchase in response.pastPurchases) {
//       // if (Platform.isIOS){
//       //   _iap.completePurchase(purchase);
//       // }
//     }

//     setState(() {
//       _purchases = response.pastPurchases;
//     });
//   }

  // /// Returns purchase of specific product ID
  // PurchaseDetails _hasPurchased(String productID) {
  //   return _purchases.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
  // }

  // /// Your own business logic to setup a consumable
  // void _verifyPurchase() {
  //   PurchaseDetails purchase = _hasPurchased(testID);

  //   // TODO serverside verification & record consumable in the database

  //   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
  //     // credits += 5;
  //     // Provider.of<GeneralProvider>(context,listen:false).setlocalcountmaxnumberofProductsUploaded(int.parse(credits.toString()));
  //     // authservice.addCreditsToAccount(Provider.of<User>(context,listen:false).uid, credits.toString());
  //   }
  // }
  



  Future<void> initPlatformState() async {
  appData.isPro = false;
  
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.setup("BzLmRGiMygeskSFnQiJJqVwXuXblrhgl");

  PurchaserInfo purchaserInfo;
  try {
    purchaserInfo = await Purchases.getPurchaserInfo();
    print('__________________________________PURCHASER INFO______________________________--');
    print(purchaserInfo.toString());
    if (purchaserInfo.entitlements.all['all_features'] != null) {
      appData.isPro = purchaserInfo.entitlements.all['all_features'].isActive;
    } else {
      appData.isPro = false;
    }
  } on PlatformException catch (e) {
    print(e);
  }

  print('#### is user pro? ${appData.isPro}');
}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    User user = Provider.of<User>(context);
    GeneralProvider generalProvider=Provider.of<GeneralProvider>(context);

    AuthService authservice=AuthService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          flexibleSpace: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Text(
          'EasyDigitalize',
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2.0,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80,),

            Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    Column(
              mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

              Text('Credits',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              Text(generalProvider.localcountmaxnumberofProductsUploaded.toString(),style: TextStyle(fontSize: 30))

            ],),

                Column(
              mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

              Text('Upload Count',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              Text(generalProvider.localcountnumberOfProductsUploaded.toString(),style: TextStyle(fontSize: 30))

            ],),
            ]),

            SizedBox(height: 20,),

      
            Container(
              width: width * 0.5,
              decoration: BoxDecoration(
                color:generalProvider.localcountnumberOfProductsUploaded>=generalProvider.localcountmaxnumberofProductsUploaded? Colors.red:Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0),
              ),
              padding: EdgeInsets.all(10),
              
              child: TextButton(
                

                child:
                    Text('Add Product', style: TextStyle(color: Colors.white)),
                onPressed: generalProvider.localcountnumberOfProductsUploaded>=generalProvider.localcountmaxnumberofProductsUploaded?null:() {
                  Navigator.pushNamed(context, AddCollection.routeName);
                },
              ),
            ),
            generalProvider.localcountnumberOfProductsUploaded>=generalProvider.localcountmaxnumberofProductsUploaded?
            Text('You have reached your product count limit, purchase another package to upload more ', textAlign: TextAlign.center, style:TextStyle(color: Colors.redAccent,fontSize: 20, fontStyle: FontStyle.italic),):Text(' '),
            SizedBox(
              height: 20,
            ),
            Container(
              width: width * 0.5,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                border: Border.all(width: 0),
              ),
              child: FlatButton(
                child: Text('Export Your Products',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, ViewCollections.routeName);
                },
              ),
            ),

             SizedBox(
              height: 20,
            ),

             Container(
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0),
              ),
              padding: EdgeInsets.all(10),
              
              child: TextButton(
                child: Text('Purchase Package!', style: TextStyle(color: Colors.white,fontSize: 20), textAlign: TextAlign.center,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MarketScreen()));
                },
              ),
            ),

            SizedBox(height: 20,),

             Container(
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0),
              ),
              padding: EdgeInsets.all(10),
              
              child: TextButton(
                child: Text('Sign Out', style: TextStyle(color: Colors.white,fontSize: 20), textAlign: TextAlign.center,),
                onPressed: () {
                  authservice.signOut();
                },
              ),
            ),



           
          ],
        ),
      ),
    );
  }
}
