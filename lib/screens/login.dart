import 'package:flutter/material.dart';
import '../helper/authservice.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

AuthService auth = AuthService();


  @override
  void initState() {
    super.initState();
 
  }


  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }


  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text('Login with  ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
       
          _buildSocialBtn(
                () async{
                 var user= await auth.signInWithGoogle();
                 if (user!=null){
                   
                 }

                },
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      


      body: SingleChildScrollView(
        child: Column(children: <Widget>[
        Container(
      height: 300,
      width: 300,
      child:Image(image: AssetImage("assets/images/Easydigitalize.png")),
    ),
        _buildSocialBtnRow(),

         Container(
      height: 300,
      width: 600,
      child:Image(image: AssetImage("assets/images/productivity.png")),
    ),

    SizedBox(height: 50,)
      ],),
      )
    );
  }
}