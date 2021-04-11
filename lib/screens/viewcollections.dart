import 'package:EasyDigitalize/screens/viewproducts.dart';
import 'package:flutter/material.dart';
import 'package:EasyDigitalize/models/collection.dart';
import 'package:EasyDigitalize/provider/generalprovider.dart';
import 'package:EasyDigitalize/screens/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../helper/authservice.dart';
import '../provider/authprovider.dart';
class ViewCollections extends StatelessWidget {
  static const routeName = '/viewcollections';


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
   // final scaffold = Scaffold.of(context);
   final width = MediaQuery.of(context).size.width;
    AuthProvider authprovider =
        Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider=Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar:AppBar(

        iconTheme: IconThemeData(
    color: Colors.black, 
  ),
    
    flexibleSpace: Container(
            alignment: Alignment.bottomCenter,

            color: Color.fromRGBO(171,216,239,1),
            child: Text(
              'Your Collections',
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )





      ),
      body:Container(
        alignment: Alignment.center,
        
          child:  StreamBuilder(
                      stream: authprovider.getUserCollections(user.uid),
                      builder:
                          (ctx, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                          );
                        }
                        final  chatDocs = chatSnapshot.data.docs;
                     
                        return Container(
                          width: width*0.8,
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                          
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) => Card(
                               
                                elevation: 4,
                                
                                margin: EdgeInsets.all(7),
                                child: Container(
                                  width: width*0.6,
                                  child: TextButton(
                                  
                                  
                                  onPressed: (){
                                    generalProvider.setCurrentCollection(chatDocs[index].data()['collectionname']);
                                    Navigator.pushNamed(context, ViewProducts.routeName);

                                  },
                                  child:
                                      Text(chatDocs[index].data()['collectionname']),
                              
                                )
                                
                                )
                                
                                
                                ),
                            
                                
                                
                                ),
                        );
                      },
                    ),), 


    );
  }
}