import 'package:easydigitalize/provider/authprovider.dart';
import 'package:easydigitalize/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../models/Product.dart';
import '../models/collection.dart';
import '../models/variant.dart';
import 'dart:async';
import 'package:flutter_publitio/flutter_publitio.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/add-product';
  final GlobalKey<ScaffoldState> globalKey;
  const AddProduct({Key key, this.globalKey}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var numofvariants = 0;
  final _formKey = GlobalKey<FormState>();

  List<Asset> images = List<Asset>();
  List<Asset> variantsImages = [];
  List<String> variantsNames = [];
  List<String> imageUrls = <String>[];
  List<String> prdtoptions = [];
  int numberofoptionsForProducts = 0;
  String _error;
  String variantname = '';
  bool hasVariantName = false;
  Variant thiscurrentvariant = new Variant();
  bool entermorethan5options=false;
  bool addVariant1 = false;
  bool addVariant2 = false;
  bool addVariant3 = false;
  bool addVariant4 = false;
  bool addVariant5 = false;
  bool addVariant6 = false;
  bool addVariant7 = false;
  bool variant1imageuploaded = false;
  bool variant2imageuploaded = false;
  Asset variant1asset;
  Asset variant2asset;
  Asset variant3asset;
  Asset variant4asset;
  Asset variant5asset;
  Variant variant1;
  Variant variant2;
  Variant variant3;

  var theproductwearemaking = Product(
        name: '',
        mainProductImages: [],
        description: '',
        price: 0,
        brand: '',
        type:'',
        hasVariation: false,
        variationlabel: '',
        quantity: 0,
        option1name: '',
        option1s: '',

         option2name: '',
        option2s: '',
    
         option3name: '',
        option3s: '',
         option4name: '',
        option4s: '',
         option5name: '',
        option5s: '',

        options: [],
        variants: []);

  @override
  void initState() {
    super.initState();
    theproductwearemaking = Product(
        name: '',
        mainProductImages: [],
        description: '',
        price: 0,
        brand: '',
        type:'',
        hasVariation: false,
        variationlabel: '',
        quantity: 0,
        option1name: '',
        option1s: '',

         option2name: '',
        option2s: '',
    
         option3name: '',
        option3s: '',
         option4name: '',
        option4s: '',
         option5name: '',
        option5s: '',

        options: [],
        variants: []);
    variant1 = Variant();
    variant2 = Variant();
    variant3 = Variant();
     configurePublitio();
  } 
  
   static configurePublitio() async {
    await FlutterPublitio.configure("guxRioSMAnGhw4WaBh4o", "DzltjTnWVLGsASzladHtf5B0nAuSXJDh");
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    print('in SAVE FORM..');
    print(theproductwearemaking);
    //save the variant names into a string in the first empty Attribute column
    if (theproductwearemaking.option1s.isEmpty){
      print('---------------------------------------------------------------------');
      print('option1s.isEmpty');
      print('---------------------------------------------------------------------');
      
      if (variantsNames.length==1){
        variantsNames.add('NA');

      }
      theproductwearemaking.option1s=variantsNames.join(',');
      theproductwearemaking.option1name=theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute=1;

    }else if (theproductwearemaking.option2s.isEmpty){
      print('---------------------------------------------------------------------');
      print('option2s.isEmpty');
      print('---------------------------------------------------------------------');
      if (variantsNames.length==1){
        variantsNames.add('NA');

      }
      theproductwearemaking.option2s=variantsNames.join(',');
      theproductwearemaking.option2name=theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute=2;
    }else if  (theproductwearemaking.option3s.isEmpty){
      print('---------------------------------------------------------------------');
      print('option3s.isEmpty');
      print('---------------------------------------------------------------------');
      if (variantsNames.length==1){
        variantsNames.add('NA');

      }
      theproductwearemaking.option3s=variantsNames.join(',');
      theproductwearemaking.option3name=theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute=3;
    }else if  (theproductwearemaking.option4s.isEmpty){
      print('---------------------------------------------------------------------');
      print('option4s.isEmpty');
      print('---------------------------------------------------------------------');
      if (variantsNames.length==1){
        variantsNames.add('NA');

      }
      theproductwearemaking.option4s=variantsNames.join(',');
      theproductwearemaking.option4name=theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute=4;
    }else if  (theproductwearemaking.option5s.isEmpty){
      print('---------------------------------------------------------------------');
      print('option5s.isEmpty');
      print('---------------------------------------------------------------------');
      if (variantsNames.length==1){
        variantsNames.add('NA');

      }
      theproductwearemaking.option5s=variantsNames.join(',');
      theproductwearemaking.option5name=theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute=5;
    }

    User user = Provider.of<User>(context, listen: false);
    print('SAVE FORM!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
   
    theproductwearemaking.options = prdtoptions;
    theproductwearemaking.variants.add(variant1);
    theproductwearemaking.variants.add(variant2);
    theproductwearemaking.variants.add(variant3);
    print(theproductwearemaking.mainProductImages);
    print(theproductwearemaking.name);
    print(theproductwearemaking.variants);
    print(theproductwearemaking.options);

    Provider.of<AuthProvider>(context, listen: false).addProductToCollection(
        theproductwearemaking,
        Provider.of<GeneralProvider>(context, listen: false).currentCollection,
        user.uid);
  }

  void uploadImages() async { 

    print('_________________ IN UPLOAD IMAGES _________________________');
    for (int i = 0; i < images.length; i++) {
                  var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
                  print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& PATH &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                  print(path.toString());
                  final uploadOptions = {
                "privacy": "1", // Marks file as publicly accessible
                "option_download": "1", // Can be downloaded by anyone
                "option_transform": "1" // Url transforms enabled
            };
                final response = await FlutterPublitio.uploadFile(path, uploadOptions);
                print('--------------RESPONSE---------------------');
                print(response);
                theproductwearemaking.mainProductImages.add(response["url_preview"]);
                }  



    // for (var imageFile in images) {
    //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    //   final reference = FirebaseStorage.instance.ref().child(fileName);
    //   UploadTask uploadTask = reference
    //       .putData((await imageFile.getByteData()).buffer.asUint8List());
    //   String url = 'testt';

    //   uploadTask.whenComplete(() async {
    //     url = await reference.getDownloadURL();
    //     print('IN UPLOAD IMAGES');
    //     print(url);
    //     theproductwearemaking.mainProductImages.add(url);
    //     print('theproductwearemaking........');
    //     print(theproductwearemaking.mainProductImages);
    //   });







    // }
  }

  Future<String> uploadVariantGetImageUrl(int index) async {
    Asset asset;
    if (index == 1) {
      asset = variant1asset;
    } else if (index == 2) {
      asset = variant2asset;
    } else if (index == 3) {
      asset = variant3asset;
    }


                  var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
                  print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& VARIANT IMAGE PATH &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                  print(path.toString());
                  final uploadOptions = {
                "privacy": "1", // Marks file as publicly accessible
                "option_download": "1", // Can be downloaded by anyone
                "option_transform": "1" // Url transforms enabled
            };
                final response = await FlutterPublitio.uploadFile(path, uploadOptions);
                print('--------------RESPONSE---------------------');
                print(response);
               

    // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // final reference = FirebaseStorage.instance.ref().child(fileName);
    // UploadTask uploadTask =
    //     reference.putData((await asset.getByteData()).buffer.asUint8List());
    // String url = '';

    // uploadTask.whenComplete(() async {
    //   url = await reference.getDownloadURL();
      if (index == 1) {
        variant1.imageUrlfromStorage = response["url_preview"];
        setState(() {
          variant1imageuploaded = true;
        });
      } else if (index == 2) {
        variant2.imageUrlfromStorage = response["url_preview"];
        setState(() {
          variant2imageuploaded = true;
        });
      } else if (index == 3) {
        variant3.imageUrlfromStorage = response["url_preview"];
      }

      return response["url_preview"];
    
  }

  Future<void> loadAssets(int n, int position) async {
    print('IN LOAD ASSETS!!!!!!!!!!!!!!!!!!!!!!!!');
    print('position is==');
    print(position);
    List<Asset> resultList;

    String error;
    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: n,
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print('RESULT LIST!!!!!!!!!!!!!!!!!!!');
    print(resultList);
    if (n == 3) {
      Provider.of<GeneralProvider>(context, listen: false)
          .setMainImagesOfProducts(resultList);
      setState(() {
        images = resultList;

        if (error == null) _error = 'No Error Dectected';
      });
    } else if (n == 1) {
      //Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsImages.insert(position,resultList[0]);
      if (position == 0) {
        print("SETTING VARIANT 1 ASSET!!!!");

        setState(() {
          variant1asset = resultList[0];
        });
      } else if (position == 1) {
        print("SETTING VARIANT 2 ASSET!!!!");
        print(resultList[0]);
        setState(() {
          variant2asset = resultList[0];
        });
      } else if (position == 2) {
        print("SETTING VARIANT 3 ASSET!!!!");
        print(resultList[0]);
        setState(() {
          variant3asset = resultList[0];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalprovider = Provider.of<GeneralProvider>(context);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /* TITLE OF PRODUCT */

                    Text('Title of the product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                      width: width * 0.7,
                      child: TextFormField(
                        initialValue: '',
                        decoration:
                            InputDecoration(hintText: 'Title of the product'),
                        onSaved: (value) {
                          theproductwearemaking.name = value;
                        },
                        validator: (value) {
                          //null is returned when input is correct, return a text when its wrong
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }

                          return null;
                        },
                      ),
                    ),

                    //* SKU *//
                           Text('Product SKU (Optional if product has no product variations)',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Container(
                      width: width * 0.7,
                      child: TextFormField(
                        initialValue: '',
                        decoration:
                            InputDecoration(hintText: 'SKU'),
                        onSaved: (value) {
                          theproductwearemaking.sku = value;
                        },
                 
                      ),
                    ),

                    /* MAIN IMAGES OF PRODUCT */

                    Text(
                      'Select up to 3 main product images',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    images.length > 0
                        ? SizedBox(
                            height: 150,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(8),
                                itemCount: images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 100,
                                    child: AssetThumb(
                                      asset: images[index],
                                      width: 100,
                                      height: 100,
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            child: Text('NO IMAGES YET'),
                          ),
                    RaisedButton(
                      child: Text("Pick images"),
                      onPressed: () => loadAssets(3, 0),
                    ),
                    RaisedButton(
                      child: Text("Upload images"),
                      onPressed: () => uploadImages(),
                    ),
                    /* DESCRIPTION OF PRODUCT */
                    Text('Description of the product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                      width: width * 0.7,
                      child: TextFormField(
                        initialValue: '',
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 5,
                        decoration:
                            InputDecoration(hintText: 'Description of product'),
                        onSaved: (value) {
                          theproductwearemaking.description = value;
                        },
                        validator: (value) {
                          //null is returned when input is correct, return a text when its wrong
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }

                          return null;
                        },
                      ),
                    ),

                    /* BRAND */
                    Text('Brand of the product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                      width: width * 0.7,
                      child: TextFormField(
                        initialValue: '',
                        decoration:
                            InputDecoration(hintText: 'Brand of the product'),
                        onSaved: (value) {
                          theproductwearemaking.brand = value;
                        },
                        validator: (value) {}))
                  ,
                          //null is returned 

                    /* PRICE */
                    Text('Price of Product',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      onSaved: (value) {
                        theproductwearemaking.price = double.parse(value);
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),

                    Text('Enter Options if you do not want image/price to change between attributes of products (e.g Same product image for all colors)'),


                  Text('Number of main options, e.g Size/Free Addon. MAXIMUM 4',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    /*OPTIONS */
                    TextFormField(
                      initialValue: '0',
                      decoration: InputDecoration(
                          labelText: 'Number of main options. (e.g Size/Free Addon)',
                          hintText: 'Number of Options'),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (valueinputtofield) {
                        if (int.parse(valueinputtofield)>4){
                          setState(() {
                            entermorethan5options=true;
                          });
                          return;
                        }
                        setState(() {
                          entermorethan5options=false;
                          numberofoptionsForProducts =
                              int.parse(valueinputtofield);
                        });
                      },
                      validator: (value) {
                        //null is returned when input is correct, return a text when its wrong
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }

                        if(int.parse(value)>5){
                          return 'Maximum attributes is 4';
                        }

                        return null;
                      },
                    ),

                    entermorethan5options?Text('Max is 5'):Text(''),

                    for (var i = 0; i < numberofoptionsForProducts; i++)
                      (Column(
                        children: <Widget>[
                          TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Option Label (E.g Size)',
                            hintText: 'Size'),
                        initialValue: '',
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (valueinputtofield) {},
                        onSaved: (value) {
                          if (i==0){
                            theproductwearemaking.option1name=value;
                          }else if (i==1){
                            theproductwearemaking.option2name=value;
                          }else if (i==2){
                            theproductwearemaking.option3name=value;
                          }else if (i==3){
                            theproductwearemaking.option4name=value;
                          }else if (i==4){
                            theproductwearemaking.option5name=value;
                          }
                         
                        },
                      ),
                      Text('Please enter the options separated by a comma. E.g Small,Medium,Large,Extra Large'),
                          TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Option (E.g Small/Medium)',
                            hintText: 'Small,Medium,Large,Extra Large'),
                        initialValue: '',
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (valueinputtofield) {},
                        onSaved: (value) {
                             
                          if (i==0){
                            theproductwearemaking.option1s=value;
                          }else if (i==1){
                            theproductwearemaking.option2s=value;
                          }else if (i==2){
                            theproductwearemaking.option3s=value;
                          }else if (i==3){
                            theproductwearemaking.option4s=value;
                          }else if (i==4){
                            theproductwearemaking.option5s=value;
                          }
                         
                        
                        },
                      )
                        ],
                      )),


                          Text('Product Variants (Optional)',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),

                                 Text('Variants Label ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                      width: width * 0.7,
                      child: TextFormField(
                        initialValue: '',
                        decoration:
                            InputDecoration(hintText: 'E.g Product Version'),
                        onSaved: (value) {
                          theproductwearemaking.variationlabel = value;
                        },
                        validator: (value) {
                          //null is returned when input is correct, return a text when its wrong
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }

                          return null;
                        },
                      ),
                    ),




                    /* ADDING PRODUCT VARIANT & VARIANT IMAGE */
                    FlatButton(
                        onPressed: () {
                          if (addVariant1 == false) {
                            theproductwearemaking.hasVariation = true;
                            theproductwearemaking.type='variable';
                            setState(() {
                              addVariant1 = true;
                             
                            });
                          }else{
                                  theproductwearemaking.hasVariation = false;
                                  theproductwearemaking.type='simple';
                            setState(() {
                              addVariant1 = false;
                             
                            });
                          }
                        },
                        child: Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(6),
                          child: addVariant1==false?Text(
                            'Add up to 7 product variants',
                            style: TextStyle(color: Colors.white),
                          ):Text(
                            'No product variants',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    /* VARIANT 1 */
                    if (addVariant1 == true)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Variant Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Column(
                            children: <Widget>[
                              TextFormField(
                                initialValue: '',
                                decoration: InputDecoration(
                                    labelText: 'Variant Name',
                                    hintText: 'Name of Variant'),
                                onSaved: (value) {
                                  variant1.name = value;
                                  variantsNames.add(value);
                                },
                                onFieldSubmitted: (value) {
                                  // Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsNames.add(value);
                                  // print('on variant name fieldsubmitted----');
                                  // print(Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsNames);
                                  setState(() {
                                    hasVariantName = true;
                                    // variantsNames.add(value);
                                  });
                                },
                                validator: (value) {
                                  //null is returned when input is correct, return a text when its wrong
                                  if (value.isEmpty) {
                                    return 'Please provide a value';
                                  }

                                  return null;
                                },
                              ),
                              Text('Select up to 1 variant image'),
                              variant1asset != null
                                  ? Container(
                                      height: 50,
                                      child: AssetThumb(
                                        asset: variant1asset,
                                        width: 50,
                                        height: 50,
                                      ),
                                    )
                                  : Text('No Image Selected'),
                              RaisedButton(
                                child: Text("Pick image"),
                                onPressed: hasVariantName
                                    ? () => loadAssets(1, 0)
                                    : null,
                              ),
                              RaisedButton(
                                child: Text("Upload image"),
                                onPressed: variant1asset != null
                                    ? () async {
                                        variant1.imageUrlfromStorage =
                                            await uploadVariantGetImageUrl(1);
                                      }
                                    : null,
                              ),
                              variant1imageuploaded == true
                                  ? Text('uploaded')
                                  : Text('Upload image')
                            ],
                          ),
                          IconButton(
                            icon: addVariant2 == false
                                ? Icon(Icons.add)
                                : Icon(Icons.minimize),
                            onPressed: () {
                              setState(() {
                                if (addVariant2 == false) {
                                  addVariant2 = true;
                                } else {
                                  addVariant2 = false;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    /* VARIANT 2 */
                    if (addVariant2 == true)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Variant Name',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: '',
                                  decoration: InputDecoration(
                                      labelText: 'Variant Name',
                                      hintText: 'Name of Variant'),
                                  onSaved: (value) {
                                    variant2.name = value;
                                    variantsNames.add(value);
                                  },
                                  onFieldSubmitted: (value) {
                                    // Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsNames.add(value);
                                    // print('on variant name fieldsubmitted----');
                                    // print(Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsNames);
                                    setState(() {
                                      hasVariantName = true;
                                      // variantsNames.add(value);
                                    });
                                  },
                                  validator: (value) {
                                    //null is returned when input is correct, return a text when its wrong
                                    if (value.isEmpty) {
                                      return 'Please provide a value';
                                    }

                                    return null;
                                  },
                                ),
                                Text('Select up to 1 variant image'),
                                variant2asset != null
                                    ? Container(
                                        height: 50,
                                        child: AssetThumb(
                                          asset: variant2asset,
                                          width: 50,
                                          height: 50,
                                        ),
                                      )
                                    : Text('No image yet'),
                                RaisedButton(
                                  child: Text("Pick image"),
                                  onPressed: hasVariantName
                                      ? () => loadAssets(1, 1)
                                      : null,
                                ),
                                RaisedButton(
                                  child: Text("Upload image"),
                                  onPressed: variant2asset != null
                                      ? () async {
                                          variant2.imageUrlfromStorage =
                                              await uploadVariantGetImageUrl(2);
                                        }
                                      : null,
                                ),
                                variant2imageuploaded == true
                                    ? Text('uploaded')
                                    : Text('Upload image')
                              ],
                            ),
                            IconButton(
                              icon: addVariant3 == false
                                  ? Icon(Icons.add)
                                  : Icon(Icons.minimize),
                              onPressed: () {
                                setState(() {
                                  if (addVariant3 == false) {
                                    addVariant3 = true;
                                  } else {
                                    addVariant3 = false;
                                  }
                                });
                              },
                            ),

                            /* VARIANT 3 */
                            if (addVariant3 == true)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Column(
                                    children: <Widget>[
                                      TextFormField(
                                        initialValue: '',
                                        decoration: InputDecoration(
                                            labelText: 'Variant Name',
                                            hintText: 'Name of Variant'),
                                        onSaved: (value) {
                                          variant3.name = value;
                                          variantsNames.add(value);
                                        },
                                        onFieldSubmitted: (value) {
                                          // Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsNames.add(value);
                                          // print('on variant name fieldsubmitted----');
                                          // print(Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsNames);
                                          setState(() {
                                            hasVariantName = true;
                                            // variantsNames.add(value);
                                          });
                                        },
                                        validator: (value) {
                                          //null is returned when input is correct, return a text when its wrong
                                          if (value.isEmpty) {
                                            return 'Please provide a value';
                                          }

                                          return null;
                                        },
                                      ),
                                      Text('Select up to 1 variant image'),
                                      variant2asset != null
                                          ? Container(
                                              height: 50,
                                              child: AssetThumb(
                                                asset: variant3asset,
                                                width: 50,
                                                height: 50,
                                              ),
                                            )
                                          : Text('No image yet'),
                                      RaisedButton(
                                        child: Text("Pick image"),
                                        onPressed: hasVariantName
                                            ? () => loadAssets(1, 2)
                                            : null,
                                      ),
                                      RaisedButton(
                                        child: Text("Upload image"),
                                        onPressed: variant3asset != null
                                            ? () async {
                                                await uploadVariantGetImageUrl(
                                                    3);
                                              }
                                            : null,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                          ]),
                    //SAVE FORM BUTTON
                    RaisedButton(
                        child: Text("SAVE PRODUCT"),
                        onPressed: () => _saveForm()),
                  ]),
            )),
      ),
    );
  }
}
