import 'package:easydigitalize/screens/addcollection.dart';
import 'package:easydigitalize/screens/viewcollections.dart';
import 'package:flutter/material.dart';
import '../screens/addproduct.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final width=MediaQuery.of(context).size.width;
    return Scaffold(
      
      appBar: AppBar(title: Text('EasyDigitalize'),),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Container(
                  width: width*0.5,
                  decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0),),
                  padding: EdgeInsets.all(10),
                  child: FlatButton(child: Text('Add Product',style: TextStyle(color: Colors.white)),onPressed: (){
                      Navigator.pushNamed(context, AddCollection.routeName);
                  },),),
                  SizedBox(height: 5,),
        Container(
                  width: width*0.5,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration( 
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(width: 0),),
                  child: FlatButton(child: Text('View Your Products',style: TextStyle(color: Colors.white)),onPressed: (){
                    Navigator.pushNamed(context,ViewCollections.routeName);
                    
                  },),),
        

      ],),),);
  }
}