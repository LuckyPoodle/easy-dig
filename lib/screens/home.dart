import 'package:easydigitalize/helper/authservice.dart';
import 'package:easydigitalize/screens/addcollection.dart';
import 'package:easydigitalize/screens/viewcollections.dart';
import 'package:flutter/material.dart';
import '../helper/components.dart';
import './market.dart';
import 'package:easydigitalize/provider/provider.dart';
import 'package:provider/provider.dart';
import './upgrade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();

  }

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
    AuthService authservice=AuthService();
    return Scaffold(
      appBar: AppBar(
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: authservice.getUserData(user.uid),
      builder: (context, thisappuser) {
        if (!thisappuser.hasData) {



        }else{
          Text(" Your credits "+thisappuser.data.maxNumberOfProductsUserCanCreate);
        }
      })
            
        ,
            
            Container(
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0),
              ),
              padding: EdgeInsets.all(10),
              child: FlatButton(
                child:
                    Text('Add Product', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, AddCollection.routeName);
                },
              ),
            ),
            SizedBox(
              height: 5,
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
                child: Text('View Your Products',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, ViewCollections.routeName);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton(
                  color: kColorAccent,
                  textColor: kColorText,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Purchase a package',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  onPressed: () {
                   
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MarketScreen()));
                    
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
