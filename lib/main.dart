import 'package:EasyDigitalize/provider/generalprovider.dart';
import 'package:EasyDigitalize/screens/viewcollections.dart';
import 'package:EasyDigitalize/screens/viewproducts.dart';
import './provider/authprovider.dart';
import 'package:EasyDigitalize/screens/addcollection.dart';
import 'package:EasyDigitalize/screens/addproduct.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './helper/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/login.dart';
import './screens/market.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import './screens/aboutscreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
 
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(
              create:(ctx)=>GeneralProvider()
          ),
          ChangeNotifierProvider(
              create:(ctx)=>AuthProvider()
          ),
        StreamProvider<User>.value(value: AuthService().user),
      ],
          child: Consumer<User>(builder: (ctx,auth,_)=>MaterialApp(
            debugShowCheckedModeBanner: false,
        title: 'EasyDigitalize',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          
          canvasColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: auth==null?LoginScreen(): Home()
        
       ,
        routes:{
          AddProduct.routeName:(ctx)=>AddProduct(),
          AddCollection.routeName:(ctx)=>AddCollection(),
          ViewCollections.routeName:(ctx)=>ViewCollections(),
          ViewProducts.routeName:(ctx)=>ViewProducts(),
          MarketScreen.routeName:(ctx)=>MarketScreen(),
          Home.routeName:(ctx)=>Home(),
          AboutScreen.routeName:(ctx)=>AboutScreen()

      
        }
      ),
    ));
  }
}

