import 'package:EasyDigitalize/models/collection.dart';
import 'package:EasyDigitalize/provider/generalprovider.dart';
import 'package:EasyDigitalize/screens/addproduct.dart';
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
  AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  Collection newcollection = Collection();

  bool canAdd = true;
  int numofproductsuploadedsofar = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DocumentSnapshot doc = Provider.of<DocumentSnapshot>(context,listen: false);
    print('-------------------in add collection ---------------------');
    print(doc['numberOfProductsUploaded']);
    print(doc['maxNumberOfProductsUserCanCreate']);
  }

  void displayExceedCountBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (ctx) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Uploaded Product Count exceeds Available Credits',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ));
        });
  }

  @override
  void didChangeDependencies() {
    // if (Provider.of<GeneralProvider>(context, listen: false)
    //         .localcountnumberOfProductsUploaded >=
    //     Provider.of<GeneralProvider>(context, listen: false)
    //         .localcountmaxnumberofProductsUploaded) {
    //   setState(() {
    //     canAdd = false;
    //   });
    // }

    // setState(() {
    //   numofproductsuploadedsofar =
    //       Provider.of<GeneralProvider>(context, listen: false)
    //           .localcountnumberOfProductsUploaded;
    // });
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid || !canAdd) {
      return;
    }
    _formKey.currentState.save();
    Provider.of<AuthProvider>(context, listen: false)
        .addCollection(newcollection);

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DocumentSnapshot doc = Provider.of<DocumentSnapshot>(context);
    final width = MediaQuery.of(context).size.width;
    // final scaffold = Scaffold.of(context);
    AuthProvider authprovider = Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            color: Color.fromRGBO(171, 216, 239, 1),
            child: Text(
              'Add/Select Shop',
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: int.parse(doc['numberOfProductsUploaded'])<int.parse(doc['maxNumberOfProductsUserCanCreate'])?
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Select your existing shop/collection to add products to',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                width: width * 0.8,
                child: StreamBuilder(
                  stream: authprovider.getUserCollections(user.uid),
                  builder: (ctx, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                      );
                    }
                    final chatDocs = chatSnapshot.data.docs;

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatDocs.length,
                        itemBuilder: (ctx, index) => Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              elevation: 4,
                              margin: EdgeInsets.all(4),
                              child: ListTile(
                                onTap: () {
                                  print('tapped!!!');
                                  print(doc['numberOfProductsUploaded']);
                                
                                            
                                  generalProvider.setCurrentCollection(
                                      chatDocs[index].data()['collectionname']);
                                  Navigator.pushNamed(
                                      context, AddProduct.routeName);
                                   
                                  

                                },
                                title: Text(
                                    chatDocs[index].data()['collectionname']),
                              ),
                            ));
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'OR create a new shop/collection',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(
                            labelText: 'New Shop Name', hintText: 'Shop Name'),
                        onSaved: (value) {
                          newcollection = Collection(
                              collectionname: value,
                              userId: user.uid,
                              id: null);
                        },
                        validator: (value) {
                          //null is returned when input is correct, return a text when its wrong
                          if (value.trim().length == 0) {
                            return 'Please enter a name';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (int.parse(doc['numberOfProductFFsUploaded']) <=
                            int.parse(
                                doc['maxNumberOfProductsUserCanCreate'])) {
                          _saveForm();
                        } else {
                          displayExceedCountBottomSheet(context);
                          return null;
                        }
                      })),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ):Center(
          
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Text('Product Uploaded Exceeds Available Credits.\nPlease purchase an additional package!',style: Theme.of(context).textTheme.headline6,),
          )
        )
        
        
        );
  }
}
