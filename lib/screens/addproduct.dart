import 'package:easydigitalize/provider/authprovider.dart';
import 'package:easydigitalize/provider/generalprovider.dart';
import 'package:easydigitalize/screens/viewproducts.dart';
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

  final Scaffold scaffold= Scaffold();
  var numofvariants = 0;
  final _formKey = GlobalKey<FormState>();

  bool isUpdateProduct=false;
  bool showOriginalMainImages=false;

  List<Asset> images = [];
  List<Asset> variantsImages = [];
  List<String> variantsNames = [];
  List<String> imageUrls = <String>[];
  List<String> prdtoptions = [];
  int numberofoptionsForProducts = 0;
  String _error;
  //String variantname = '';
  bool hasVariantName = false;
  bool pickedMainImages = false;
  bool uploadedMainImagesSuccessfully = false;

  

  bool entermorethan5options = false;
  bool addVariant1 = false;
  bool addVariant2 = false;
  bool addVariant3 = false;
  bool addVariant4 = false;
  bool addVariant5 = false;
  bool addVariant6 = false;
  bool addVariant7 = false;
  bool addVariant8 = false;
  bool addVariant9 = false;
  bool addVariant10 = false;

  bool isUpdatePageFirstLoadV1Image=false;
  bool isUpdatePageFirstLoadV2Image=false;
  bool isUpdatePageFirstLoadV3Image=false;
  bool isUpdatePageFirstLoadV4Image=false;
  bool isUpdatePageFirstLoadV5Image=false;
  bool isUpdatePageFirstLoadV6Image=false;
  bool isUpdatePageFirstLoadV7Image=false;
  bool isUpdatePageFirstLoadV8Image=false;
  bool isUpdatePageFirstLoadV9Image=false;
  bool isUpdatePageFirstLoadV10Image=false;

  bool variant1imageuploaded = false;
  bool variant2imageuploaded = false;
  bool variant3imageuploaded = false;
  bool variant4imageuploaded = false;
  bool variant5imageuploaded = false;
  bool variant6imageuploaded = false;
  bool variant7imageuploaded = false;
  bool variant8imageuploaded = false;
  bool variant9imageuploaded = false;
  bool variant10imageuploaded = false;

  Asset variant1asset;
  Asset variant2asset;
  Asset variant3asset;
  Asset variant4asset;
  Asset variant5asset;
  Asset variant6asset;
  Asset variant7asset;
  Asset variant8asset;
  Asset variant9asset;
  Asset variant10asset;
  Variant variant1 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant2 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant3 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant4 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant5 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant6 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant7 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant8 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant9 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');
  Variant variant10 =
      Variant(name: ' ', imageUrlfromStorage: ' ', quantity: '', price: ' ');

  //for mini loading
  bool inmidstofuploadingmainimages = false;
  bool stillshowloadinginsubmitbutton = false;

  var _isInit = true;

  var theproductwearemaking = Product(
        name: ' ',
        id: ' ',
        mainProductImages: [],
        mainproductimagesIds: [],
        description: ' ',
        price: ' ',
        brand: ' ',
        type: ' ',
        hasVariation: false,
        variationlabel: ' ',
        quantity: '',
        option1name: ' ',
        option1s: ' ',
        option2name: ' ',
        option2s: ' ',
        option3name: ' ',
        option3s: ' ',
        option4name: ' ',
        option4s: ' ',
        option5name: ' ',
        option5s: ' ',
        
        variants: []);

      void displayInstructionsForOptionBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 0.4,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                            'Example 1:  Product comes in different sizes, it has 1 main option - Size, so enter 1 under Number of main options.\nExample 2: Product comes in different sizes AND different colors, it has 2 main options - Size & Color, so enter 2 under Number of main options \nExample 1:  Product comes in different colors, and each color has their own pricing/image. Use Product Variants instead, so enter 0 under Number of main options. ',
                            style: TextStyle(fontSize: 16)),
              ),
            );
          
        });
  }

  void displayInstructionsForVariantBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 0.4,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                            'Example 1: Jane has a Toy product with 3 variants based on its material - Velvet, Cotton, Silk. She intends to show a different image for each selected variant. So Jane enters "Material" in Variants Label, and pressed the button "Add first variant" to add each of the 3 variants for the Toy product ',
                            style: TextStyle(fontSize: 16)),
              ),
            );
          
        });
  }





  @override
  void initState() {
    super.initState();
    

    configurePublitio();
  }


   @override
  void didChangeDependencies() {
    //this is run when build is executed. we use isinit condition cos we only want to run once
    if (_isInit){
      //ModalRoute which we use to get the setting and argument does not work in initState
      QueryDocumentSnapshot chatDocsIndex=ModalRoute.of(context).settings.arguments;
      List<String> obtainedMainImagesUrls=[];
      List<String> obtainedMainImagesUrlsIds=[];
      List<Variant> obtainedVariants=[];


      
      if(chatDocsIndex!=null){
        print('-----------------------mainProductImages-----------------------------');
        
        print(chatDocsIndex.data()['mainProductImages'],);
        print('-----------------------Options-----------------------------');
        print(chatDocsIndex.data()['options']);
        
        print('-----------------------Variants-----------------------------');
        print(chatDocsIndex.data()['variants']);
        print('-----------------------IS UPDATING PRODUCT-----------------------------');
        print( chatDocsIndex.data());
        print('id is');
        print(chatDocsIndex.id);
        for (var url in chatDocsIndex.data()['mainProductImages']){
          obtainedMainImagesUrls.add(url);
        }
        for (var id in chatDocsIndex.data()['mainproductimagesIds']){
          obtainedMainImagesUrlsIds.add(id);
        }
        print('obtainedMainImagesUrls');
        print(obtainedMainImagesUrls);
        for (var v in chatDocsIndex.data()['variants']){
          print('the variants existing...');
          print(v['variantname']);
          Variant aVariant=Variant(imageUrlfromStorage: v['imageUrlfromStorage'],name: v['variantname'],quantity: v['quantity'],price: v['variantprice'],imageUrlId:v['imageUrlId']);
          obtainedVariants.add(aVariant);
          variantsNames.add(v['name']);
        }

        print('obtainedVariants');
        print(obtainedVariants);
        theproductwearemaking=Product(
        id:chatDocsIndex.id,
        name:chatDocsIndex.data()['name'],
        description:chatDocsIndex.data()['description'],
        price:chatDocsIndex.data()['price'],
        brand: chatDocsIndex.data()['brand'],
        type: chatDocsIndex.data()['type'],
        hasVariation: chatDocsIndex.data()['hasVariation'],
        variationlabel: chatDocsIndex.data()['variationlabel'],
        quantity: chatDocsIndex.data()['quantity'],
        option1name: chatDocsIndex.data()['option1name'],
        option1s: chatDocsIndex.data()['option1s'],
        option2name: chatDocsIndex.data()['option2name'],
        option2s: chatDocsIndex.data()['option2s'],
        option3name: chatDocsIndex.data()['option3name'],
        option3s: chatDocsIndex.data()['option3s'],
        option4name: chatDocsIndex.data()['option4name'],
        option4s:chatDocsIndex.data()['option4s'],
        option5name: chatDocsIndex.data()['option5name'],
        option5s: chatDocsIndex.data()['option5s'],
        mainProductImages: obtainedMainImagesUrls,
        mainproductimagesIds:obtainedMainImagesUrlsIds,
        variants: obtainedVariants


   
      );
      int numofoptions=0;
        if (chatDocsIndex.data()['option1name'].trim().isNotEmpty){
          numofoptions+=1;
        }
        if (chatDocsIndex.data()['option2name'].trim().isNotEmpty){
          numofoptions+=1;
        }
        if (chatDocsIndex.data()['option3name'].trim().isNotEmpty){
          numofoptions+=1;
        }
        if (chatDocsIndex.data()['option4name'].trim().isNotEmpty){
          numofoptions+=1;
        }
        if (chatDocsIndex.data()['option5name'].trim().isNotEmpty){
          numofoptions+=1;
        }


      variant1=obtainedVariants[0];
      print('the obtained variant ONE....');
      print(variant1.name);
      if (variant1.name.trim().isNotEmpty){
        setState(() {
          addVariant1=true;
        });

      }
      variant2=obtainedVariants[1];
      if (variant2.name.trim().isNotEmpty){
        setState(() {
          addVariant2=true;
        });

      }
      variant3=obtainedVariants[2];
      if (variant3.name.trim().isNotEmpty){
        setState(() {
          addVariant3=true;
        });

      }
      variant4=obtainedVariants[3];
      if (variant4.name.trim().isNotEmpty){
        setState(() {
          addVariant4=true;
        });

      }
      variant5=obtainedVariants[4];
      if (variant5.name.trim().isNotEmpty){
        setState(() {
          addVariant5=true;
        });

      }
      variant6=obtainedVariants[5];
      if (variant6.name.trim().isNotEmpty){
        setState(() {
          addVariant6=true;
        });

      }
      variant7=obtainedVariants[6];
      if (variant7.name.trim().isNotEmpty){
        setState(() {
          addVariant7=true;
        });

      }
      variant8=obtainedVariants[7];
      if (variant8.name.trim().isNotEmpty){
        setState(() {
          addVariant8=true;
        });

      }
      variant9=obtainedVariants[8];
      if (variant9.name.trim().isNotEmpty){
        setState(() {
          addVariant9=true;
        });

      }
      variant10=obtainedVariants[9];
      if (variant10.name.trim().isNotEmpty){
        setState(() {
          addVariant10=true;
        });

      }
    

      setState(() {
        isUpdateProduct=true;
        showOriginalMainImages=true;
        numberofoptionsForProducts=numofoptions;
      isUpdatePageFirstLoadV1Image=true;
  isUpdatePageFirstLoadV2Image=true;
   isUpdatePageFirstLoadV3Image=true;
   isUpdatePageFirstLoadV4Image=true;
   isUpdatePageFirstLoadV5Image=true;
  isUpdatePageFirstLoadV6Image=true;
   isUpdatePageFirstLoadV7Image=true;
   isUpdatePageFirstLoadV8Image=true;
  isUpdatePageFirstLoadV9Image=true;
   isUpdatePageFirstLoadV10Image=true;
        
      });
      }
      print(theproductwearemaking.variants);

    }


    _isInit=false;
    super.didChangeDependencies();
  }





  static configurePublitio() async {
    await FlutterPublitio.configure(
        "guxRioSMAnGhw4WaBh4o", "DzltjTnWVLGsASzladHtf5B0nAuSXJDh");
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
    if (theproductwearemaking.option1s.trim().isEmpty) {
      print(
          '---------------------------------------------------------------------');
      print('option1s.isEmpty');
      print(
          '---------------------------------------------------------------------');

      if (variantsNames.length == 1) {
        variantsNames.add('NA');

        variant2.name = 'NA';
        variant2.price = theproductwearemaking.price;
        variant2.imageUrlfromStorage =
            theproductwearemaking.mainProductImages[0];
      }
      theproductwearemaking.option1s = variantsNames.join(',');
      theproductwearemaking.option1name = theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute = 1;
    } else if (theproductwearemaking.option2s.trim().isEmpty) {
      print(
          '---------------------------------------------------------------------');
      print('option2s.isEmpty');
      print(
          '---------------------------------------------------------------------');
      if (variantsNames.length == 1) {
        variantsNames.add('NA');
        variant2.name = 'NA';
        variant2.price = theproductwearemaking.price;
        variant2.imageUrlfromStorage =
            theproductwearemaking.mainProductImages[0];
      }
      theproductwearemaking.option2s = variantsNames.join(',');
      theproductwearemaking.option2name = theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute = 2;
    } else if (theproductwearemaking.option3s.trim().isEmpty) {
      print(
          '---------------------------------------------------------------------');
      print('option3s.isEmpty');
      print(
          '---------------------------------------------------------------------');
      if (variantsNames.length == 1) {
        variantsNames.add('NA');
        variant2.name = 'NA';
        variant2.price = theproductwearemaking.price;
        variant2.imageUrlfromStorage =
            theproductwearemaking.mainProductImages[0];
      }
      theproductwearemaking.option3s = variantsNames.join(',');
      theproductwearemaking.option3name = theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute = 3;
    } else if (theproductwearemaking.option4s.trim().isEmpty) {
      print(
          '---------------------------------------------------------------------');
      print('option4s.isEmpty');
      print(
          '---------------------------------------------------------------------');
      if (variantsNames.length == 1) {
        variantsNames.add('NA');
        variant2.name = 'NA';
        variant2.price = theproductwearemaking.price;
        variant2.imageUrlfromStorage =
            theproductwearemaking.mainProductImages[0];
      }
      theproductwearemaking.option4s = variantsNames.join(',');
      theproductwearemaking.option4name = theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute = 4;
    } else if (theproductwearemaking.option5s.trim().isEmpty) {
      print(
          '---------------------------------------------------------------------');
      print('option5s.isEmpty');
      print(
          '---------------------------------------------------------------------');
      if (variantsNames.length == 1) {
        variantsNames.add('NA');
        variant2.name = 'NA';
        variant2.price = theproductwearemaking.price;
        variant2.imageUrlfromStorage =
            theproductwearemaking.mainProductImages[0];
      }
      theproductwearemaking.option5s = variantsNames.join(',');
      theproductwearemaking.option5name = theproductwearemaking.variationlabel;
      theproductwearemaking.variationputunderwhichattribute = 5;
    }

    User user = Provider.of<User>(context, listen: false);
    print('SAVE FORM!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

    theproductwearemaking.options = prdtoptions;
    
    //to clear variants to prevent duplicates if this is updating an existing pdt

    if (isUpdateProduct){
      theproductwearemaking.variants=[];
    }

    theproductwearemaking.variants.add(variant1);
    theproductwearemaking.variants.add(variant2);
    theproductwearemaking.variants.add(variant3);
    theproductwearemaking.variants.add(variant4);
    theproductwearemaking.variants.add(variant5);
    theproductwearemaking.variants.add(variant6);
    theproductwearemaking.variants.add(variant7);
    theproductwearemaking.variants.add(variant8);
    theproductwearemaking.variants.add(variant9);
    theproductwearemaking.variants.add(variant10);

    print(theproductwearemaking.mainProductImages);
    print(theproductwearemaking.name);
    print(theproductwearemaking.variants);
    print(theproductwearemaking.options);

 if (!isUpdateProduct){
      Provider.of<AuthProvider>(context, listen: false).addProductToCollection(
        theproductwearemaking,
        Provider.of<GeneralProvider>(context, listen: false).currentCollection,
        user.uid,(Provider.of<GeneralProvider>(context, listen: false).localcountnumberOfProductsUploaded+1).toString()).then((_){
          Provider.of<GeneralProvider>(context, listen: false).addoneproduct();
          Navigator.pushReplacementNamed(context, ViewProducts.routeName);

        }).catchError((e){
          print('ERROR');

        });
 }else{

 

      Provider.of<AuthProvider>(context,listen: false).updateProductInCollection(theproductwearemaking, Provider.of<GeneralProvider>(context, listen: false).currentCollection,
        user.uid).then((_){
          Navigator.pushReplacementNamed(context, ViewProducts.routeName);


        }).catchError((e){
          print('ERROR');
        });


 

     


 }
           
  }

  void uploadImages() async {
    setState(() {
      stillshowloadinginsubmitbutton = true;
      inmidstofuploadingmainimages = true;
      uploadedMainImagesSuccessfully = false;
    });
    print('_________________ IN UPLOAD IMAGES _________________________');
    List<String> urls=[];
    List<String> publitoIds=[];
    for (int i = 0; i < images.length; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
   

      final uploadOptions = {
        "privacy": "1", // Marks file as publicly accessible
        "option_download": "1", // Can be downloaded by anyone
        "option_transform": "1" // Url transforms enabled
      };
      final response = await FlutterPublitio.uploadFile(path, uploadOptions);
      print('--------------RESPONSE---------------------');
      print(response);
      print(response['success']);
      if (response['success'] == 'false') {
        //try with firestore
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final reference = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = reference
            .putData((await images[i].getByteData()).buffer.asUint8List());
        String url = 'testt';
        List<String> urls=[];
        uploadTask.whenComplete(() async {
          url = await reference.getDownloadURL();
          print('IN UPLOAD IMAGES');
          print(url);
          url = url + ".jpg";
          urls.add(url);
         
        });
        print('the urls --------------------------');
        print(urls);
        theproductwearemaking.mainProductImages=urls;
      }
      urls.add(response["url_preview"]);
      publitoIds.add(response["id"]);

    }
    print('the urls-------------------');
    print(urls);
    theproductwearemaking.mainProductImages=urls;
    theproductwearemaking.mainproductimagesIds=publitoIds;

    setState(() {
      stillshowloadinginsubmitbutton = false;
      uploadedMainImagesSuccessfully = true;
      inmidstofuploadingmainimages = false;
      pickedMainImages = false;
    });
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
    //      url=url+".jpg";
    //     theproductwearemaking.mainProductImages.add(url);
    //     print('theproductwearemaking........');
    //     print(theproductwearemaking.mainProductImages);
    //   });

    // }
  }

  Future<String> uploadVariantGetImageUrl(int index) async {
    setState(() {
      stillshowloadinginsubmitbutton = true;
    });
    Asset asset;
    if (index == 1) {
      asset = variant1asset;
    } else if (index == 2) {
      asset = variant2asset;
    } else if (index == 3) {
      asset = variant3asset;
    } else if (index == 4) {
      asset = variant4asset;
    } else if (index == 5) {
      asset = variant5asset;
    } else if (index == 6) {
      asset = variant6asset;
    } else if (index == 7) {
      asset = variant7asset;
    } else if (index == 8) {
      asset = variant8asset;
    } else if (index == 9) {
      asset = variant9asset;
    } else if (index == 10) {
      asset = variant10asset;
    }

    var path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
    print(
        '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& VARIANT IMAGE PATH &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(path.toString());
    final uploadOptions = {
      "privacy": "1", // Marks file as publicly accessible
      "option_download": "1", // Can be downloaded by anyone
      "option_transform": "1" // Url transforms enabled
    };
    final response = await FlutterPublitio.uploadFile(path, uploadOptions);

    print('--------------RESPONSE---------------------');
    print(response);
    if (response['success'] == 'false') {
      //try with firestore
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask =
          reference.putData((await asset.getByteData()).buffer.asUint8List());
      String url = '';

      uploadTask.whenComplete(() async {
        url = await reference.getDownloadURL();
        url = url + ".jpg";
        if (index == 1) {
          variant1.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
          setState(() {
            variant1imageuploaded = true;
          });
        } else if (index == 2) {
          variant2.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
          setState(() {
            variant2imageuploaded = true;
          });
        } else if (index == 3) {
          variant3.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant3imageuploaded = true;
          });
        } else if (index == 4) {
          variant4.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant4imageuploaded = true;
          });
        } else if (index == 5) {
          variant5.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant5imageuploaded = true;
          });
        } else if (index == 6) {
          variant6.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant6imageuploaded = true;
          });
        } else if (index == 7) {
          variant7.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant7imageuploaded = true;
          });
        } else if (index == 8) {
          variant8.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant8imageuploaded = true;
          });
        } else if (index == 9) {
          variant9.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant9imageuploaded = true;
          });
        } else if (index == 10) {
          variant10.imageUrlfromStorage = url;
          theproductwearemaking.mainProductImages.add(url);
           setState(() {
            variant10imageuploaded = true;
          });
        }
      });
    } else {
      if (index == 1) {
        variant1.imageUrlfromStorage = response["url_preview"];
        variant1.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
        setState(() {
          variant1imageuploaded = true;
        });
      } else if (index == 2) {
        variant2.imageUrlfromStorage = response["url_preview"];
        variant2.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
        setState(() {
          variant2imageuploaded = true;
        });
      } else if (index == 3) {
        variant3.imageUrlfromStorage = response["url_preview"];
        variant3.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant3imageuploaded = true;
        });
      } else if (index == 4) {
        variant4.imageUrlfromStorage = response["url_preview"];
        variant4.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant4imageuploaded = true;
        });
      } else if (index == 5) {
        variant5.imageUrlfromStorage = response["url_preview"];
        variant5.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant5imageuploaded = true;
        });
      } else if (index == 6) {
        variant6.imageUrlfromStorage = response["url_preview"];
        variant6.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant6imageuploaded = true;
        });
      } else if (index == 7) {
        variant7.imageUrlfromStorage = response["url_preview"];
        variant7.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant7imageuploaded = true;
        });
      } else if (index == 8) {
        variant8.imageUrlfromStorage = response["url_preview"];
        variant8.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant8imageuploaded = true;
        });
      } else if (index == 9) {
        variant9.imageUrlfromStorage = response["url_preview"];
        variant10.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant9imageuploaded = true;
        });
      } else if (index == 10) {
        variant10.imageUrlfromStorage = response["url_preview"];
        variant10.imageUrlId=response["id"];
        theproductwearemaking.mainProductImages.add(response["url_preview"]);
         setState(() {
          variant10imageuploaded = true;
        });
      }
    }

    // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // final reference = FirebaseStorage.instance.ref().child(fileName);
    // UploadTask uploadTask =
    //     reference.putData((await asset.getByteData()).buffer.asUint8List());
    // String url = '';

    // uploadTask.whenComplete(() async {
    //   url = await reference.getDownloadURL();
    // url=url+".jpg";

    setState(() {
      stillshowloadinginsubmitbutton = false;
    });

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
    if (n == 5) {
      Provider.of<GeneralProvider>(context, listen: false)
          .setMainImagesOfProducts(resultList);
      setState(() {
        pickedMainImages = true;
        if(resultList!=null){
          images = resultList;
        }

        if (error == null) _error = 'No Error Dectected';
      });
      print('in set assetss........');
      print(images);
    } else if (n == 1) {
      //Provider.of<GeneralProvider>(context,listen: false).listofcurrentPdtVariantsImages.insert(position,resultList[0]);
      if (position == 1) {
        print("SETTING VARIANT 1 ASSET!!!!");

        setState(() {
          
          //means changing already uploaded variant image
      
            isUpdatePageFirstLoadV1Image=false;

          
          
          variant1asset = resultList[0];
        });
      } else if (position == 2) {
        print("SETTING VARIANT 2 ASSET!!!!");
        print(resultList[0]);
        setState(() {
         
            isUpdatePageFirstLoadV2Image=false;

          
          variant2asset = resultList[0];
        });
      } else if (position == 3) {
        print("SETTING VARIANT 3 ASSET!!!!");
        print(resultList[0]);
        setState(() {

          
            isUpdatePageFirstLoadV3Image=false;

          
          print(isUpdatePageFirstLoadV3Image);
          variant3asset = resultList[0];
        });
      } else if (position == 4) {
        print("SETTING VARIANT 4 ASSET!!!!");
        print(resultList[0]);
        setState(() {
          variant4asset = resultList[0];

       
            isUpdatePageFirstLoadV4Image=false;

          
        });
      } else if (position == 5) {
        print("SETTING VARIANT 5 ASSET!!!!");
        print(resultList[0]);
        setState(() {
        
            isUpdatePageFirstLoadV5Image=false;

          
          variant5asset = resultList[0];
        });
      } else if (position == 6) {
        print("SETTING VARIANT 6 ASSET!!!!");
        print(resultList[0]);
        setState(() {
    
            isUpdatePageFirstLoadV6Image=false;

          
          variant6asset = resultList[0];
        });
      } else if (position == 7) {
        print("SETTING VARIANT 7 ASSET!!!!");
        print(resultList[0]);
        setState(() {
      
            isUpdatePageFirstLoadV7Image=false;

          
          variant7asset = resultList[0];
        });
      } else if (position == 8) {
        print("SETTING VARIANT 8 ASSET!!!!");
        print(resultList[0]);
        setState(() {
        
            isUpdatePageFirstLoadV8Image=false;

          
          variant8asset = resultList[0];
        });
      } else if (position == 9) {
        print("SETTING VARIANT 9 ASSET!!!!");
        print(resultList[0]);
        setState(() {
          variant9asset = resultList[0];
      
            isUpdatePageFirstLoadV9Image=false;

          
        });
      } else if (position == 10) {
        print("SETTING VARIANT 10 ASSET!!!!");
        print(resultList[0]);
        setState(() {
          variant10asset = resultList[0];
         
            isUpdatePageFirstLoadV10Image=false;

          
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalprovider = Provider.of<GeneralProvider>(context);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: isUpdateProduct?Text('Updating product'):Text('Add Product to ' + generalprovider.currentCollection),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /* TITLE OF PRODUCT */

                        Container(
                          
                          padding: EdgeInsets.all(3),
                          child: Text('Title of the product',
                              style: TextStyle(
                                
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                           Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          width: width * 0.7,
                          child: TextFormField(
                            initialValue: theproductwearemaking.name,
                            decoration:
                                InputDecoration(hintText: 'E.g A Bar of Soap'),
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

                        SizedBox(
                          height: 8,
                        ),

                        //* SKU *//
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text(
                              'Product SKU (Optional if product has no product variations)',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                        Text(
                          
                            'Specify a SKU for your product if it has product variants',
                            style: TextStyle(
                              fontSize: 16,
                            )),

                        Container(
                          width: width * 0.7,
                          child: TextFormField(
                            initialValue: theproductwearemaking.sku,
                            decoration: InputDecoration(hintText: 'SKU'),
                            onSaved: (value) {
                              theproductwearemaking.sku = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      

              
                        /* MAIN IMAGES OF PRODUCT */
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text('Product Main Images',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),     Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                        Text(
                            'Select up to 5 MAIN product images. Do not upload Product Variants images here, later you will get to upload variant images',
                            style: TextStyle(
                              fontSize: 16,
                            )),

                        images.length > 0
                            ? SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: images.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                            :
                            showOriginalMainImages?
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                              Container(
                                height: 60,
                                width: 60,
                                child: FittedBox(
                                  child:Image.network(theproductwearemaking.mainProductImages[0], fit:BoxFit.cover,)),
                              ),
                              theproductwearemaking.mainProductImages.length>1?
                              Container(
                                height: 60,
                                width: 60,
                                child: FittedBox(
                                  child:Image.network(theproductwearemaking.mainProductImages[1], fit:BoxFit.cover,)),
                              ):SizedBox(),
                               theproductwearemaking.mainProductImages.length>2?
                              Container(
                                height: 60,
                                width: 60,
                                child: FittedBox(
                                  child:Image.network(theproductwearemaking.mainProductImages[2], fit:BoxFit.cover,)),
                              ):SizedBox(),
                               theproductwearemaking.mainProductImages.length>3?
                              Container(
                                height: 60,
                                width: 60,
                                child: FittedBox(
                                  child:Image.network(theproductwearemaking.mainProductImages[3], fit:BoxFit.cover,)),
                              ):SizedBox(),
                               theproductwearemaking.mainProductImages.length>4?
                              Container(
                                height: 60,
                                width: 60,
                                child: FittedBox(
                                  child:Image.network(theproductwearemaking.mainProductImages[4], fit:BoxFit.cover,)),
                              ):SizedBox(),
                           ],)
                            
                            
                            :
                            
                            
                             Container(
                                alignment: Alignment.center,
                                child: Container(
                                    padding: EdgeInsets.all(50),
                                    child: Icon(Icons.photo)),
                              ),


                        Text(pickedMainImages
                            ? 'Please upload image'
                            : uploadedMainImagesSuccessfully
                                ? 'Upload Successful'
                                : ''),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              child: Text("Pick images"),
                              onPressed: () => loadAssets(5, 0),
                            ),
                            RaisedButton(
                              child: inmidstofuploadingmainimages
                                  ? Text("......")
                                  : Text("Upload images"),
                              onPressed: images.isNotEmpty
                                  ? () {
                                      uploadImages();
                                    }
                                  : null,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 8,
                        ),
                        /* DESCRIPTION OF PRODUCT */
                        Text('Description of the product',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                                     Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                        Container(
                          width: width * 0.7,
                          child: TextFormField(
                            initialValue: theproductwearemaking.description,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: 'Description of product'),
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
                        SizedBox(
                          height: 8,
                        ),

                        /* BRAND */
                        Text('Brand of the product (Optional)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                                     Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                        Container(
                            width: width * 0.7,
                            child: TextFormField(
                                initialValue: theproductwearemaking.brand,
                                decoration: InputDecoration(
                                    hintText: 'Brand of the product'),
                                onSaved: (value) {
                                  theproductwearemaking.brand = value;
                                },
                                validator: (value) {})),

                        SizedBox(
                          height: 8,
                        ),

                        /* BRAND */
                        Text('Category of the product (Optional)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                                     Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                        RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                            children: <TextSpan>[
                              new TextSpan(
                                  text:
                                      'if product category is under a parent category, please enter with this format '),
                              new TextSpan(
                                  text: 'parentcategory>nameofcategory',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ),

                        Container(
                            width: width * 0.7,
                            child: TextFormField(
                                initialValue: theproductwearemaking.category,
                                decoration: InputDecoration(
                                    hintText: 'Clothing>Tshirt'),
                                onSaved: (value) {
                                  theproductwearemaking.category = value;
                                },
                                validator: (value) {})),
                        //null is returned

                        SizedBox(
                          height: 8,
                        ),

                        /* STOCK */
                        Text('Total Available Stock (Optional)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                                     Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:2),

                        TextFormField(
                          initialValue: theproductwearemaking.quantity,
                          onSaved: (value) {
                            theproductwearemaking.quantity = value;
                          },
                          validator: (value) {
                            //null is returned when input is correct, return a text when its wrong
                            // if (value != ' ') {
                            //   if (num.tryParse(value) == null) {
                            //     return 'Please enter a numerical value only';
                            //   }
                            // }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        /* PRICE */
                        Text('Price of Product',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),

                                     Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),

                        Text(
                            'Currency depends on your shop (woocommerce/shopify) configuration',
                            style: TextStyle(fontSize: 16)),
                        TextFormField(
                          initialValue: theproductwearemaking.price,
                    
                          onSaved: (value) {
                            theproductwearemaking.price = value;
                          },
                          validator: (value) {
                            //null is returned when input is correct, return a text when its wrong
                            if (value.isEmpty) {
                              return 'Please provide a value';
                            }
                            if (num.tryParse(value) == null) {
                              return 'Please enter a numerical value only';
                            }

                            return null;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),

                        SizedBox(
                          height: 18,
                        ),

                        Text(
                            'Options (Optional)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                                 Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                        IconButton(
                          onPressed: (){
                            displayInstructionsForOptionBottomSheet(context);
                          },
                          
                          icon: Icon(Icons.info)),
                              
                        Text(
                            'Enter Options if you do not want image/price to change between attributes of products (e.g You want to show the same product image for all sizes)',
                            style: TextStyle(fontSize: 18)),

                        

        
                        /*OPTIONS */
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            'Number of main options (Maximum 4)',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                  
                        TextFormField(
                          initialValue: numberofoptionsForProducts.toString(),
                          decoration: InputDecoration(
                              labelText: 'Number of main options',
                              hintText: 'Number of Options'),
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (valueinputtofield) {
                            if (num.tryParse(valueinputtofield) == null) {
                              return 'Please enter a numerical value only';
                            }
                            if (int.parse(valueinputtofield) > 4) {
                              setState(() {
                                entermorethan5options = true;
                              });
                              return 'Max 5 Option Labels (e.g Size/Shape/Color/Material/Version)';
                            }
                            setState(() {
                              entermorethan5options = false;
                              numberofoptionsForProducts =
                                  int.parse(valueinputtofield);
                            });
                          },
                          validator: (value) {
                            //null is returned when input is correct, return a text when its wrong
                            if (value.isEmpty) {
                              return 'Please provide a value';
                            }

                            if (int.parse(value) > 5) {
                              return 'Maximum attributes is 4';
                            }

                            return null;
                          },
                        ),

                        entermorethan5options ? Text('Max is 4') : Text(''),

                        for (var i = 0; i < numberofoptionsForProducts; i++)
                          (Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                        Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.grey,
                          
                          child: Text('Option '+(i+1).toString(),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),),

                        
                              Container(
                          color: Colors.black,
                          height: 1,
                        ),

                        SizedBox(height:5),

                               Text(
                            'Option Label',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Option Label (E.g Size)',
                                    hintText: 'Size'),
                                initialValue: i==0?theproductwearemaking.option1name:i==1?theproductwearemaking.option2name:i==2?theproductwearemaking.option3name:i==3?theproductwearemaking.option4name:i==4?theproductwearemaking.option5name:'',
                                keyboardType: TextInputType.multiline,
                                onFieldSubmitted: (valueinputtofield) {},
                                onSaved: (value) {
                                  if (i == 0) {
                                    theproductwearemaking.option1name = value;
                                  } else if (i == 1) {
                                    theproductwearemaking.option2name = value;
                                  } else if (i == 2) {
                                    theproductwearemaking.option3name = value;
                                  } else if (i == 3) {
                                    theproductwearemaking.option4name = value;
                                  } else if (i == 4) {
                                    theproductwearemaking.option5name = value;
                                  }
                                },
                              ),
                              
                        SizedBox(
                          height: 8,
                        ),
                        
                             Text(
                            'Option Values',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                                  RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.black87),
                            children: <TextSpan>[
                              new TextSpan(
                                  text:
                                      'Please enter the options separated by a comma. Example: '),
                              new TextSpan(
                                  text: 'Small,Medium,Large,Extra Large',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ),
                             
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Options (E.g Small,Medium)',
                                    hintText: 'Small,Medium,Large,Extra Large'),
                                initialValue:  i==0?theproductwearemaking.option1s:i==1?theproductwearemaking.option2s:i==2?theproductwearemaking.option3s:i==3?theproductwearemaking.option4s:i==4?theproductwearemaking.option5s:'',
                                keyboardType: TextInputType.multiline,
                                onFieldSubmitted: (valueinputtofield) {},
                                onSaved: (value) {
                                  if (i == 0) {
                                    theproductwearemaking.option1s = value;
                                  } else if (i == 1) {
                                    theproductwearemaking.option2s = value;
                                  } else if (i == 2) {
                                    theproductwearemaking.option3s = value;
                                  } else if (i == 3) {
                                    theproductwearemaking.option4s = value;
                                  } else if (i == 4) {
                                    theproductwearemaking.option5s = value;
                                  }
                                },
                              )
                            ],
                          )),

                        Text('Product Variants (Optional)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                                 Container(
                          color: Colors.black,
                          height: 5,
                        ),
                        SizedBox(height:4),
                         IconButton(
                          onPressed: (){
                            displayInstructionsForVariantBottomSheet(context);
                          },
                          
                          icon: Icon(Icons.info)),

                        Text('Variants Label ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Container(
                          width: width * 0.7,
                          child: TextFormField(
                            initialValue: theproductwearemaking.variationlabel,
                            decoration: InputDecoration(
                                hintText: 'E.g Product Version'),
                            onSaved: (value) {
                              theproductwearemaking.variationlabel = value;
                            },
                            validator: (value) {
                            
                            },
                          ),
                        ),

                        /* ADDING PRODUCT VARIANT & VARIANT IMAGE */
                        TextButton(
                            
                            onPressed: () {
                              if (addVariant1 == false) {
                                theproductwearemaking.hasVariation = true;
                                theproductwearemaking.type = 'variable';
                                setState(() {
                                  addVariant1 = true;
                                });
                              } else {
                                theproductwearemaking.hasVariation = false;
                                theproductwearemaking.type = 'simple';
                                setState(() {
                                  addVariant1 = false;
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              child: addVariant1 == false
                                  ? Text(
                                      'Add first variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant(s)',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            )),
                        /* VARIANT 1 */

                        if (addVariant1 == true)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant1.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 1 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant1.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 1 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant1.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant1.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 1 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant1.quantity,
                                      onSaved: (value) {
                                        variant1.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 1 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select  1 variant image'),
                                  SizedBox(height: 4,),
                                  isUpdatePageFirstLoadV1Image?
                                  variant1.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant1.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant1asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant1asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant1asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant1asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 1),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant1asset != null
                                        ? () async {
                                            variant1.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    1);
                                          }
                                        : null,
                                  ),
                                  variant1imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant2 == false) {
                                      addVariant2 = true;
                                    } else {
                                      addVariant2 = false;
                                    }
                                  });
                                },

                              child: Container(

                                 color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant2 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

                        /* VARIANT 2 */
                        if (addVariant2 == true)
                           Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 2 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant2.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 2 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant2.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 2 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant2.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 2 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant2.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 2 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant2.quantity,
                                      onSaved: (value) {
                                        variant2.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 2 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select  1 variant image'),
                                  SizedBox(height: 4,),
                                isUpdatePageFirstLoadV2Image?  variant2.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant2.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant2asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant2asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant2asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant2asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 2),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant2asset != null
                                        ? () async {
                                            variant2.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    2);
                                          }
                                        : null,
                                  ),
                                  variant2imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant3 == false) {
                                      addVariant3 = true;
                                    } else {
                                      addVariant3 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant3 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

                        /* VARIANT 3 */
                        if (addVariant3 == true)
                           Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 3 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant3.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 3 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant3.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 3 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant3.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 3 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant3.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 3 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant3.quantity,
                                      onSaved: (value) {
                                        variant3.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 3 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select  1 variant image'),
                                  SizedBox(height: 4,),
                                  isUpdatePageFirstLoadV3Image? variant3.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant3.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant3asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant3asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)): variant3asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant3asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 3),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant3asset != null
                                        ? () async {
                                            variant3.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    3);
                                          }
                                        : null,
                                  ),
                                  variant3imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant4 == false) {
                                      addVariant4 = true;
                                    } else {
                                      addVariant4 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant4 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),
                        ///*VARIANT 4 *///
                        ///
                        if (addVariant4 == true)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 4 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant4.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 4 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant4.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 4 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant4.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 4 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant4.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 4 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant4.quantity,
                                      onSaved: (value) {
                                        variant4.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 4 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select  1 variant image'),
                                  SizedBox(height: 4,),
                                  isUpdatePageFirstLoadV4Image?variant4.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant4.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant4asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant4asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant4asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant4asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 4),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant4asset != null
                                        ? () async {
                                            variant4.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    4);
                                          }
                                        : null,
                                  ),
                                  variant4imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant5 == false) {
                                      addVariant5 = true;
                                    } else {
                                      addVariant5 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant5 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

                                /*VARIANT 5 */
                                if (addVariant5 == true)
                                  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 5 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant5.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 5 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant5.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 5 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant5.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 5 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant5.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 5 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant5.quantity,
                                      onSaved: (value) {
                                        variant5.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 5 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select  1 variant image'),
                                  SizedBox(height: 4,),
                             isUpdatePageFirstLoadV5Image?    variant5.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant5.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant5asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant5asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)): variant5asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant5asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 5),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant5asset != null
                                        ? () async {
                                            variant5.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    5);
                                          }
                                        : null,
                                  ),
                                  variant5imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant6 == false) {
                                      addVariant6 = true;
                                    } else {
                                      addVariant6 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant6 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),
                                /*VARIANT 6 */
                                if (addVariant6 == true)
                                   Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 6 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant6.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 6 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant6.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 6 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant6.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 6 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant6.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 6 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant6.quantity,
                                      onSaved: (value) {
                                        variant6.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 6 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select 1 variant image'),
                                  SizedBox(height: 4,),
                                  isUpdatePageFirstLoadV6Image? variant6.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant6.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant6asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant6asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant6asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant6asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 6),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant6asset != null
                                        ? () async {
                                            variant6.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    6);
                                          }
                                        : null,
                                  ),
                                  variant6imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant7 == false) {
                                      addVariant7= true;
                                    } else {
                                      addVariant7 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant7 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

/*VARIANT 7 */
                                if (addVariant7 == true)
                                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 7 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant7.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 7 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant7.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 7 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant7.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 7 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant7.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 7 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant7.quantity,
                                      onSaved: (value) {
                                        variant7.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 7 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select 1 variant image'),
                                  SizedBox(height: 4,),
                                  isUpdatePageFirstLoadV7Image? variant7.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant7.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant7asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant7asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant7asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant7asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 7),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant7asset != null
                                        ? () async {
                                            variant7.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    7);
                                          }
                                        : null,
                                  ),
                                  variant7imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant8 == false) {
                                      addVariant8= true;
                                    } else {
                                      addVariant8 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant8 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

                                /*VARIANT 8*/
                                if (addVariant8 == true)
                                                    Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 8 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant8.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 8 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant8.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 8 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant8.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 8 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant8.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 8 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant8.quantity,
                                      onSaved: (value) {
                                        variant8.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 8 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select 1 variant image'),
                                  SizedBox(height: 4,),
                                   isUpdatePageFirstLoadV8Image?variant8.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant8.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant8asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant8asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant8asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant8asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 8),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant8asset != null
                                        ? () async {
                                            variant8.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    8);
                                          }
                                        : null,
                                  ),
                                  variant8imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant9 == false) {
                                      addVariant9= true;
                                    } else {
                                      addVariant9 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant9 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

                                /*VARIANT 9*/
                                if (addVariant9 == true)
                                                    Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 9 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant9.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 9 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant9.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 9 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant9.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 9 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant9.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 9 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant9.quantity,
                                      onSaved: (value) {
                                        variant9.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 9 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select 1 variant image'),
                                  SizedBox(height: 4,),
                                  isUpdatePageFirstLoadV9Image?variant9asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant9asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant9asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant9asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 9),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant9asset != null
                                        ? () async {
                                            variant9.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    9);
                                          }
                                        : null,
                                  ),
                                  variant9imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                              TextButton(
                             
                              onPressed: () {
                                  setState(() {
                                    if (addVariant10 == false) {
                                      addVariant10= true;
                                    } else {
                                      addVariant10 = false;
                                    }
                                  });
                                },

                              child: Container(

                              color: Colors.black,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,

                                child: addVariant10 == false
                                  ? Text(
                                      'Add another variant',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'Remove variant',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              )
                            ),
                            ],
                          ),

                                /*VARIANT 10*/
                                if (addVariant10 == true)
                                                    Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Variant 10 Name',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant10.name,
                                    decoration: InputDecoration(
                                        labelText: 'Variant 10 Name',
                                        hintText: 'E.g Blue Color'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant10.name = value;
                                        variantsNames.add(value);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
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
                                  Text('Variant 10 Price',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                    initialValue: variant10.price,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                        labelText: 'Variant 10 Price',
                                        hintText: 'Price of Variant'),
                                    onSaved: (value) {
                                      if (value.trim().isNotEmpty) {
                                        variant10.price = value;
                                      }
                                    },
                                    onFieldSubmitted: (value) {},
                                    validator: (value) {
                                      //null is returned when input is correct, return a text when its wrong
                                      if (value.isEmpty) {
                                        return 'Please provide a value';
                                      }

                                      if (num.tryParse(value) == null) {
                                        return 'Please enter a numerical value only';
                                      }

                                      return null;
                                    },
                                  ),

                                  /* STOCK */
                                  Text('Variant 10 Available Stock (OPTIONAL)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextFormField(
                                      initialValue: variant10.quantity,
                                      onSaved: (value) {
                                        variant10.quantity = value;
                                      },
                                      validator: (value) {
                                        //null is returned when input is correct, return a text when its wrong
                                        // if (value.isEmpty) {
                                        //   return 'Please provide a value';
                                        // }
                                        // if (value != ' ') {
                                        //   if (num.tryParse(value) == null) {
                                        //     return 'Please enter a numerical value only';
                                        //   }
                                        // }
                                      }),
                                      SizedBox(height: 4,),
                                      Text('Variant 10 Image',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Select 1 variant image'),
                                  SizedBox(height: 4,),
                                isUpdatePageFirstLoadV10Image? variant10.imageUrlfromStorage.trim().isNotEmpty?
                                  
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: FittedBox(
                                    
                                  child:Image.network(variant10.imageUrlfromStorage, fit:BoxFit.cover,)),
                                  )
                                  
                                  :  variant10asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant10asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)):variant10asset != null
                                      ? Container(
                                          height: 100,
                                          child: AssetThumb(
                                            asset: variant10asset,
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                      : Padding(padding: EdgeInsets.all(5),child:Icon(Icons.photo)),
                                  RaisedButton(
                                    child: Text("Pick image"),
                                    onPressed: () => loadAssets(1, 10),
                                  ),
                                  RaisedButton(
                                    child: Text("Upload image"),
                                    onPressed: variant10asset != null
                                        ? () async {
                                            variant10.imageUrlfromStorage =
                                                await uploadVariantGetImageUrl(
                                                    10);
                                          }
                                        : null,
                                  ),
                                  variant10imageuploaded == true
                                      ? Text('Uploaded')
                                      : Text('Please upload image')
                                ],
                              ),

                      
                            ],
                          ),
                          SizedBox(height: 20,),
                          
                          
                          
                          stillshowloadinginsubmitbutton
                            ? CircularProgressIndicator()
                            : TextButton(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:EdgeInsets.all(20),
                                  color: Colors.green,
                                  child: Text("SAVE PRODUCT",style: TextStyle(color: Colors.white,),
                                ),),
                                onPressed: () => _saveForm()),
                              ]),

                        //SAVE FORM BUTTON

                      
                      )),
            ),
          ),
        );
  }
}
