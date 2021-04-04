import 'package:easydigitalize/models/collection.dart';
import 'package:easydigitalize/provider/generalprovider.dart';
import 'package:easydigitalize/screens/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../helper/authservice.dart';
import '../provider/authprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddCollection extends StatefulWidget {

  static const routeName = '/addcollection';

  @override
  _AddCollectionState createState() => _AddCollectionState();
}




class _AddCollectionState extends State<AddCollection> {

  AuthService authService=AuthService();
  final _formKey = GlobalKey<FormState>();
  Collection newcollection=Collection();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

    Future<void> _saveForm() async {

    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    Provider.of<AuthProvider>(context, listen: false).addCollection(newcollection);


   
    

    // Navigator.of(context).pop();
  }





  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
   // final scaffold = Scaffold.of(context);
    AuthProvider authprovider =
        Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider=Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add/Select your shop'),),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Select an existing shop to add products to',style: TextStyle(fontSize: 20),)),

        
        Container(
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
                                    Navigator.pushNamed(context, AddProduct.routeName);

                                  },
                                  title:
                                      Text(chatDocs[index].data()['collectionname']),
                                
                                  // trailing: Container(
                                  //   width: 100,
                                  //   child: Row(
                                  //     children: <Widget>[
                               
                                  //       IconButton(
                                  //         icon: Icon(Icons.delete),
                                  //         onPressed: () async {
                                  //           try {
                                  //             print('to delete.....');
                                  //             print(chatDocs[index].id);
                                  //             authprovider.deleteCollection(chatDocs[index].data()['collectionname'],user.uid);
                                  //           } catch (error) {
                              
                                  //           }
                                  //         },
                                  //         color: Theme.of(context).errorColor,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                )));
                      },
                    ),), 

                    Padding(
          padding: EdgeInsets.all(10),
          child: Text('OR create a new shop',style: TextStyle(fontSize: 20),)),
                   Container(
                     padding: EdgeInsets.all(30),
                     child:  Form(
                      key: _formKey,
                      child:Column(children: <Widget>[
                           TextFormField(
                    initialValue:'',
                    decoration:InputDecoration(labelText:'New Shop Name',hintText: 'Shop Name'),

                    onSaved: (value){

                      newcollection=Collection(collectionname:value,userId:user.uid,id:null);
                     
                    },
                    validator: (value){
                      //null is returned when input is correct, return a text when its wrong
                      if(value.isEmpty){
                        return 'Please provide a value';
                      }

                      return null;
                    },
                  ),
                      ],) ,),),
                      IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,)
        


      ],),)
      
      
    );
  }
}