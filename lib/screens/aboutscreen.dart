import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';


sendMail() async {
  final Email email = Email(
    body: '',
    subject: 'EasyDigitalize Contact',
    recipients: ['contact@easydigitalize.com'],
    isHTML: true,
  );

  await FlutterEmailSender.send(email);
}

class AboutScreen extends StatelessWidget {
  static const routeName = '/help';




  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: 
    
    AppBar(
      automaticallyImplyLeading: true,
    iconTheme: IconThemeData(
    color: Colors.black, 
  ),
    
    flexibleSpace: Container(
            alignment: Alignment.bottomCenter,

            color: Color.fromRGBO(171,216,239,1),
            child: Text(
              'About App',
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )
          ,),
    body: SingleChildScrollView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        Text('How to use this app',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        Container(
          padding:EdgeInsets.all(9),
          child: Text('This app helps you quickly generate Woocommerce or Shopify-specified CSV files for your products. You can then use those specially tailored CSV files to mass import products in your Woocommerce or Shopify stores'),
        ),

        Container(
          padding:EdgeInsets.all(9),
          child: Text('1. In the home page, click on Add Product. This brings you to a page where you can create/select your own personal collections under which you can add a product to.'),
        ),
         Container(
          padding:EdgeInsets.all(9),
          child: Text('2. Select a collection. This brings you to a form where you can enter your product details and upload product images. Save the form'),
        ),
        Container(
          padding:EdgeInsets.all(9),
          child: Text('3. Save your product. In the View Products page, you can update or delete a product, and export your collection as a CSV file '),
        ),

         Container(
          padding:EdgeInsets.all(9),
          child: Text('You can upload and export 1 product for free. A single Pro Coupon (stackable) let you upload 100 products.'),
        ),

              Container(
          padding:EdgeInsets.all(9),
          child: Text('If you have any enquiries or suggestions, please feel free to contact EasyDigitalize: '),
        ),
        SizedBox(height: 5,),
        Container(
                          width: width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 0),
                          ),
                          padding: EdgeInsets.all(10),
                          child: TextButton(
                            child: Text(
                              'Contact',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              
                             sendMail();
                            },
                          ),
                        ),
        


        


      ],

      
    ),));
  }
}