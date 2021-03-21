import 'package:easydigitalize/screens/viewproducts.dart';
import 'package:flutter/material.dart';
import 'package:easydigitalize/models/collection.dart';
import 'package:easydigitalize/provider/provider.dart';
import 'package:easydigitalize/screens/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easydigitalize/authservice.dart';
import '../provider/authprovider.dart';
class ViewCollections extends StatelessWidget {
  static const routeName = '/viewcollections';


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
   // final scaffold = Scaffold.of(context);
    AuthProvider authprovider =
        Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider=Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar:AppBar(title:Text('Your Collectiions')),
      body:Container(
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
                     
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: chatDocs.length,
                            itemBuilder: (ctx, index) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                elevation: 4,
                                margin: EdgeInsets.all(4),
                                child: ListTile(
                                  onTap: (){
                                    generalProvider.setCurrentCollection(chatDocs[index].data()['collectionname']);
                                    Navigator.pushNamed(context, ViewProducts.routeName);

                                  },
                                  title:
                                      Text(chatDocs[index].data()['collectionname']),
                                
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: <Widget>[
                               
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            try {
                                              print('to delete.....');
                                              print(chatDocs[index].id);
                                              authprovider.deleteCollection(
                                                
                                                  chatDocs[index].data()[
                                                      'collectionname'],user.uid);
                                            } catch (error) {
                              
                                            }
                                          },
                                          color: Theme.of(context).errorColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )));
                      },
                    ),), 


    );
  }
}