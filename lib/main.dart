import 'package:easydigitalize/provider/provider.dart';
import 'package:easydigitalize/screens/viewcollections.dart';
import 'package:easydigitalize/screens/viewproducts.dart';
import './provider/authprovider.dart';
import 'package:easydigitalize/screens/addcollection.dart';
import 'package:easydigitalize/screens/addproduct.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        title: 'EasyDigitalize',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: auth==null?LoginScreen(): Home()
        
       ,
        routes:{
          AddProduct.routeName:(ctx)=>AddProduct(),
          AddCollection.routeName:(ctx)=>AddCollection(),
          ViewCollections.routeName:(ctx)=>ViewCollections(),
          ViewProducts.routeName:(ctx)=>ViewProducts()
      
        }
      ),
    ));
  }
}
