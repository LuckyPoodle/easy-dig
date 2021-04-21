import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EasyDigitalize/provider/generalprovider.dart';
import 'package:EasyDigitalize/screens/addproduct.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../screens/home.dart';
import '../provider/authprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ViewProducts extends StatelessWidget {
  static const routeName = '/viewproducts';

  String filePath;
  String collectionname;

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('in get localfile');
    print(collectionname);
    collectionname = collectionname.trim();
    collectionname = collectionname.replaceAll(' ', '');
    print('collection name ');
    print(collectionname);

    filePath = '$path/$collectionname-data.csv';

    return File('$path/$collectionname-data.csv').create();
  }

  sendMailAndAttachment(String collection, String platform) async {
    final Email email = Email(
      body: 'Hi, \n Please find the attached product CSV file. ',
      subject:
          '${platform} Product CSV ${DateTime.now().toString()} for ${collection}',
      recipients: [''],
      isHTML: true,
      attachmentPaths: [filePath],
    );

    await FlutterEmailSender.send(email);
  }

  void generateShopifyCSV(var docs, String collection) async {
    collectionname = collection;
    List<List<dynamic>> rows = [];
    rows.add([
      'Handle',
      'Title',
      'Body (HTML)',
      'Vendor',
      'Type',
      'Tags',
      'Published',
      'Option1 Name',
      'Option2 Name',
      'Option3 Name',
      'Option4 Name',
      'Option5 Name',
      'Option1 Value',
      'Option2 Value',
      'Option3 Value',
      'Option4 Value',
      'Option5 Value',
      'Variant Inventory Tracker',
      'Variant Inventory Qty',
      'Variant Price',
      'Image Src',
      'Variant Image',
    ]);

    for (var doc in docs) {
      List<dynamic> mainproductimages = doc.data()['mainProductImages'];
      print('mainproductimages..');
      print(mainproductimages);

      ///ACCOUNT FOR PRODUCT VARIANTS THAT HAVE OWN IMAGE/PRICE
      if (doc.data()['type'] == 'variable') {
        for (var variant in doc.data()['variants']) {
          if (variant['variantname'].toString().trim().isEmpty) {
            print("NO MORE VARIANT");
            print("____________________");
            break;
          }

          if (variant != null && variant.toString().isNotEmpty) {
            //means no other options
            if (doc.data()['variationputunderwhichattribute'] == 1) {
              print('variation under 1');
              List<dynamic> vrow = [];
              //means product with its own image/price is option1
              vrow.add(doc.data()['handle']);
              vrow.add(doc.data()['name']);
              vrow.add(doc.data()['description']);
              vrow.add(doc.data()['brand']);
              vrow.add('');
              vrow.add(doc.data()['tags']);
              vrow.add('FALSE');
              vrow.add(doc.data()['variationlabel']);
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add(variant['variantname']);
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              if (variant['quantity'] != '') {
                vrow.add('shopify');
              } else {
                vrow.add('');
              }

              vrow.add(variant['quantity']);
              vrow.add(variant['variantprice']);
              if (mainproductimages.length > 0) {
                vrow.add(mainproductimages[
                    0]); //later then add more blank rows with other images in this list if any
              }

              vrow.add(variant['imageUrlfromStorage']);

              rows.add(vrow);
            } else if (doc.data()['variationputunderwhichattribute'] == 2) {
              //have normal option 1 , now iterate through each value of option 1 for each variant

              List<String> optionslist = doc.data()['option1s'].split(",");
              for (String option in optionslist) {
                List<dynamic> vrow = [];
                vrow.add(doc.data()['handle']);
                vrow.add(doc.data()['name']);
                vrow.add(doc.data()['description']);
                vrow.add(doc.data()['brand']);
                vrow.add('');
                vrow.add(doc.data()['tags']);
                vrow.add('FALSE');
                vrow.add(doc.data()['option1name']);
                vrow.add(doc.data()['variationlabel']);
                vrow.add('');
                vrow.add('');
                vrow.add('');
                vrow.add(option);
                vrow.add(variant['variantname']);

                vrow.add('');
                vrow.add('');
                vrow.add('');
                if (variant['quantity'] != '') {
                  vrow.add('shopify');
                } else {
                  vrow.add('');
                }

                vrow.add(variant['quantity']);
                vrow.add(variant['variantprice']);
                if (mainproductimages.length > 0) {
                  vrow.add(mainproductimages[
                      0]); //later then add more blank rows with other images in this list if any
                }

                vrow.add(variant['imageUrlfromStorage']);

                rows.add(vrow);
              }
            } else if (doc.data()['variationputunderwhichattribute'] == 3) {
              List<String> optionslistofoption1 =
                  doc.data()['option1s'].split(",");
              List<String> optionslistofoption2 =
                  doc.data()['option2s'].split(",");
              for (var option in optionslistofoption1) {
                for (var option2 in optionslistofoption2) {
                  List<dynamic> vrow = [];

                  vrow.add(doc.data()['handle']);
                  vrow.add(doc.data()['name']);
                  vrow.add(doc.data()['description']);
                  vrow.add(doc.data()['brand']);
                  vrow.add('');
                  vrow.add(doc.data()['tags']);
                  vrow.add('FALSE');
                  vrow.add(doc.data()['option1name']);
                  vrow.add(doc.data()['option2name']);
                  vrow.add(doc.data()['variationlabel']);

                  vrow.add('');
                  vrow.add('');
                  vrow.add(option);
                  vrow.add(option2);
                  vrow.add(variant['variantname']);
                  vrow.add('');
                  vrow.add('');
                  if (variant['quantity'] != '') {
                    vrow.add('shopify');
                  } else {
                    vrow.add('');
                  }

                  vrow.add(variant['quantity']);
                  vrow.add(variant['variantprice']);
                  if (mainproductimages.length > 0) {
                    vrow.add(mainproductimages[
                        0]); //later then add more blank rows with other images in this list if any
                  }

                  vrow.add(variant['imageUrlfromStorage']);

                  rows.add(vrow);
                }
              }
            } else if (doc.data()['variationputunderwhichattribute'] == 4) {
              List<String> optionslistofoption1 =
                  doc.data()['option1s'].split(",");
              List<String> optionslistofoption2 =
                  doc.data()['option2s'].split(",");
              List<String> optionslistofoption3 =
                  doc.data()['option3s'].split(",");

              for (var option in optionslistofoption1) {
                for (var option2 in optionslistofoption2) {
                  for (var option3 in optionslistofoption3) {
                    List<dynamic> vrow = [];
                    vrow.add(doc.data()['handle']);
                    vrow.add(doc.data()['name']);
                    vrow.add(doc.data()['description']);
                    vrow.add(doc.data()['brand']);
                    vrow.add('');
                    vrow.add(doc.data()['tags']);
                    vrow.add('FALSE');
                    vrow.add(doc.data()['option1name']);
                    vrow.add(doc.data()['option2name']);
                    vrow.add(doc.data()['option3name']);
                    vrow.add(doc.data()['variationlabel']);
                    vrow.add('');
                    vrow.add(option);
                    vrow.add(option2);
                    vrow.add(option3);
                    vrow.add(variant['variantname']);

                    vrow.add('');
                    if (variant['quantity'] != '') {
                      vrow.add('shopify');
                    } else {
                      vrow.add('');
                    }

                    vrow.add(variant['quantity']);
                    vrow.add(variant['variantprice']);
                    if (mainproductimages.length > 0) {
                      vrow.add(mainproductimages[
                          0]); //later then add more blank rows with other images in this list if any
                    }

                    vrow.add(variant['imageUrlfromStorage']);

                    rows.add(vrow);
                  }
                }
              }
            } else if (doc.data()['variationputunderwhichattribute'] == 5) {
              List<String> optionslistofoption1 =
                  doc.data()['option1s'].split(",");
              List<String> optionslistofoption2 =
                  doc.data()['option2s'].split(",");
              List<String> optionslistofoption3 =
                  doc.data()['option3s'].split(",");
              List<String> optionslistofoption4 =
                  doc.data()['option4s'].split(",");

              for (var option in optionslistofoption1) {
                for (var option2 in optionslistofoption2) {
                  for (var option3 in optionslistofoption3) {
                    for (var option4 in optionslistofoption4) {
                      List<dynamic> vrow = [];

                      vrow.add(doc.data()['handle']);
                      vrow.add(doc.data()['name']);
                      vrow.add(doc.data()['description']);
                      vrow.add(doc.data()['brand']);
                      vrow.add('');
                      vrow.add(doc.data()['tags']);
                      vrow.add('FALSE');
                      vrow.add(doc.data()['option1name']);
                      vrow.add(doc.data()['option2name']);
                      vrow.add(doc.data()['option3name']);
                      vrow.add(doc.data()['option4name']);
                      vrow.add(doc.data()['variationlabel']);
                      vrow.add(option);
                      vrow.add(option2);
                      vrow.add(option3);
                      vrow.add(option4);
                      vrow.add(variant['variantname']);
                      if (variant['quantity'] != '') {
                        vrow.add('shopify');
                      } else {
                        vrow.add('');
                      }

                      vrow.add(variant['quantity']);
                      vrow.add(variant['variantprice']);
                      if (mainproductimages.length > 0) {
                        vrow.add(mainproductimages[
                            0]); //later then add more blank rows with other images in this list if any
                      }

                      vrow.add(variant['imageUrlfromStorage']);

                      rows.add(vrow);
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        //NO variants that hav its own price/image etc, so now just do for plain options, which for shopify, require
        //a row for each option just like variants though this time round u put the BASE price

        //for if have 0 option
        if (doc.data()['numberofoptions'] == '0') {
          List<dynamic> vrow = [];

          vrow.add(doc.data()['handle']);
          vrow.add(doc.data()['name']);
          vrow.add(doc.data()['description']);
          vrow.add(doc.data()['brand']);
          vrow.add('');
          vrow.add(doc.data()['tags']);
          vrow.add('FALSE');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          if (doc.data()['quantity'] != '') {
            vrow.add('shopify');
          } else {
            vrow.add('');
          }

          vrow.add(doc.data()['quantity']);
          vrow.add(doc.data()['price']);
          if (mainproductimages.length > 0) {
            vrow.add(mainproductimages[
                0]); //later then add more blank rows with other images in this list if any
          }

          vrow.add('');

          rows.add(vrow);
        } else if (doc.data()['numberofoptions'] == '1') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          for (var option in optionslistofoption1) {
            List<dynamic> vrow = [];
            //means product with its own image/price is option1
            vrow.add(doc.data()['handle']);
            vrow.add(doc.data()['name']);
            vrow.add(doc.data()['description']);
            vrow.add(doc.data()['brand']);
            vrow.add('');
            vrow.add(doc.data()['tags']);
            vrow.add('FALSE');
            vrow.add(doc.data()['option1name']);
            vrow.add('');
            vrow.add('');
            vrow.add('');
            vrow.add('');
            vrow.add(option);
            vrow.add('');
            vrow.add('');
            vrow.add('');
            vrow.add('');
            if (doc.data()['quantity'] != '') {
              vrow.add('shopify');
            } else {
              vrow.add('');
            }

            vrow.add(doc.data()['quantity']);
            vrow.add(doc.data()['price']);
            if (mainproductimages.length > 0) {
              vrow.add(mainproductimages[
                  0]); //later then add more blank rows with other images in this list if any
            }

            vrow.add('');

            rows.add(vrow);
          }
        } else if (doc.data()['numberofoptions'] == '2') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          List<String> optionslistofoption2 = doc.data()['option2s'].split(",");
          for (var option in optionslistofoption1) {
            for (var option2 in optionslistofoption2) {
              List<dynamic> vrow = [];

              vrow.add(doc.data()['handle']);
              vrow.add(doc.data()['name']);
              vrow.add(doc.data()['description']);
              vrow.add(doc.data()['brand']);
              vrow.add('');
              vrow.add(doc.data()['tags']);
              vrow.add('FALSE');
              vrow.add(doc.data()['option1name']);
              vrow.add(doc.data()['option2name']);
              vrow.add('');

              vrow.add('');
              vrow.add('');
              vrow.add(option);
              vrow.add(option2);
              vrow.add('');
              vrow.add('');
              vrow.add('');
              if (doc.data()['quantity'] != '') {
                vrow.add('shopify');
              } else {
                vrow.add('');
              }

              vrow.add(doc.data()['quantity']);
              vrow.add(doc.data()['price']);
              if (mainproductimages.length > 0) {
                vrow.add(mainproductimages[
                    0]); //later then add more blank rows with other images in this list if any
              }

              vrow.add('');

              rows.add(vrow);
            }
          }
        } else if (doc.data()['numberofoptions'] == '3') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          List<String> optionslistofoption2 = doc.data()['option2s'].split(",");
          List<String> optionslistofoption3 = doc.data()['option3s'].split(",");

          for (var option in optionslistofoption1) {
            for (var option2 in optionslistofoption2) {
              for (var option3 in optionslistofoption3) {
                List<dynamic> vrow = [];
                vrow.add(doc.data()['handle']);
                vrow.add(doc.data()['name']);
                vrow.add(doc.data()['description']);
                vrow.add(doc.data()['brand']);
                vrow.add('');
                vrow.add(doc.data()['tags']);
                vrow.add('FALSE');
                vrow.add(doc.data()['option1name']);
                vrow.add(doc.data()['option2name']);
                vrow.add(doc.data()['option3name']);

                vrow.add('');
                vrow.add('');
                vrow.add(option);
                vrow.add(option2);
                vrow.add(option3);
                vrow.add('');
                vrow.add('');
                if (doc.data()['quantity'] != '') {
                  vrow.add('shopify');
                } else {
                  vrow.add('');
                }

                vrow.add(doc.data()['quantity']);
                vrow.add(doc.data()['price']);
                if (mainproductimages.length > 0) {
                  vrow.add(mainproductimages[
                      0]); //later then add more blank rows with other images in this list if any
                }

                vrow.add('');

                rows.add(vrow);
              }
            }
          }
        } else if (doc.data()['numberofoptions'] == '4') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          List<String> optionslistofoption2 = doc.data()['option2s'].split(",");
          List<String> optionslistofoption3 = doc.data()['option3s'].split(",");
          List<String> optionslistofoption4 = doc.data()['option4s'].split(",");

          for (var option in optionslistofoption1) {
            for (var option2 in optionslistofoption2) {
              for (var option3 in optionslistofoption3) {
                for (var option4 in optionslistofoption4) {
                  List<dynamic> vrow = [];
                  vrow.add(doc.data()['handle']);
                  vrow.add(doc.data()['name']);
                  vrow.add(doc.data()['description']);
                  vrow.add(doc.data()['brand']);
                  vrow.add('');
                  vrow.add(doc.data()['tags']);
                  vrow.add('FALSE');
                  vrow.add(doc.data()['option1name']);
                  vrow.add(doc.data()['option2name']);
                  vrow.add(doc.data()['option3name']);

                  vrow.add(doc.data()['option4name']);
                  vrow.add('');
                  vrow.add(option);
                  vrow.add(option2);
                  vrow.add(option3);
                  vrow.add(option4);
                  vrow.add('');
                  if (doc.data()['quantity'] != '') {
                    vrow.add('shopify');
                  } else {
                    vrow.add('');
                  }

                  vrow.add(doc.data()['quantity']);
                  vrow.add(doc.data()['price']);
                  if (mainproductimages.length > 0) {
                    vrow.add(mainproductimages[
                        0]); //later then add more blank rows with other images in this list if any
                  }

                  vrow.add('');

                  rows.add(vrow);
                }
              }
            }
          }
        }

        //end of the ELSE (no variants)
      }

      //now generate new rows for mainimages
      if (mainproductimages.length > 1) {
        for (String imageurl in mainproductimages) {
          List<dynamic> vrow = [];
          vrow.add(doc.data()['handle']);
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('FALSE');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add(imageurl);
          vrow.add('');

          rows.add(vrow);
        }
      }
    }

    File f = await _localFile;

    String csv = const ListToCsvConverter().convert(rows);
    print(csv);
    f.writeAsString(csv);

    sendMailAndAttachment(collection, 'Shopify');
  }

  void generateCSV(var docs, String collection) async {
    collectionname = collection;
    print('saveproductstoprovider');
    print(docs);
    List<List<dynamic>> rows = [];
    rows.add([
      "Type",
      "SKU",
      "Name",
      "Description",
      "Published",
      "images",
      "Price",
      "Tags",
      "Attribute 1 name",
      "Attribute 1 value(s)",
      "Attribute 2 name",
      "Attribute 2 value(s)",
      "Attribute 3 name",
      "Attribute 3 value(s)",
      "Attribute 4 name",
      "Attribute 4 value(s)",
      "Attribute 5 name",
      "Attribute 5 value(s)",
      "Parent",
      "Stock",
      "In Stock?",
      "Categories"
    ]);
    for (var doc in docs) {
      List<dynamic> row = [];

      if (doc.data()['numberofoptions'] != '0') {
        row.add('variable');
      } else {
        row.add(doc.data()['type']);
      }
      row.add(doc.data()['sku']);
      row.add(doc.data()['name']);

      row.add(doc.data()['description']);
      row.add('FALSE');

      String images = doc.data()['mainProductImages'].join(',');
      row.add(images);
      row.add(doc.data()['price']);
      row.add(doc.data()['tags']);
      row.add(doc.data()['option1name']);
      row.add(doc.data()['option1s']);
      row.add(doc.data()['option2name']);
      row.add(doc.data()['option2s']);
      row.add(doc.data()['option3name']);
      row.add(doc.data()['option3s']);
      row.add(doc.data()['option4name']);
      row.add(doc.data()['option4s']);
      row.add(doc.data()['option5name']);
      row.add(doc.data()['option5s']);
      row.add('');
      row.add(doc.data()['quantity']);
      row.add('1');
      row.add(doc.data()['category']); //parent

      ////FOR EACH VARIANT, has to iterate through each options...
      rows.add(row);
      if (doc.data()['type'] == 'variable') {
        //iterate through product's variants, make a new row for each

        int count = 0;

/////////looping through variants
        ////nested loop to present each option
        for (var variant in doc.data()['variants']) {
          print(variant);
          print('__________variantprice____________');
          print((variant['variantprice']));
          count += 1;

          if (variant['variantname'].toString().trim().isEmpty) {
            print("NO MORE VARIANT");
            print("____________________");
            break;
          }

          print('VARIANT =================>');
          print('LOPPING THROU VARIANT');
          print(variant);
          if (variant != null && variant.toString().isNotEmpty) {
            //means no options
            if (doc.data()['variationputunderwhichattribute'] == 1) {
              print('variation under 1');
              List<dynamic> vrow = List<dynamic>();

              vrow.add('variation');
              vrow.add(''); //sku
              vrow.add(doc.data()['name'].toString() +
                  ' - ' +
                  variant['variantname'].toString());

              vrow.add(doc.data()['description']);
              vrow.add('FALSE');
              vrow.add(variant['imageUrlfromStorage']);
              vrow.add(variant['variantprice']);
              vrow.add(doc.data()['tags']);

              vrow.add(doc.data()['variationlabel']);
              vrow.add(variant['variantname']);
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              vrow.add('');
              //parent
              vrow.add(doc.data()['sku']);
              vrow.add(variant['quantity']);
              vrow.add('1');
              vrow.add('');
              rows.add(vrow);
            }

            ///HAVE OPTIONS so we loop through the options
            if (doc.data()['variationputunderwhichattribute'] == 2) {
              print('variation under 2');
              //variation is put under option2name and option2s
              List<String> optionslist = doc.data()['option1s'].split(",");
              for (var option in optionslist) {
                count += 1;
                List<dynamic> vrow = List<dynamic>();

                vrow.add('variation');
                vrow.add(''); //sku
                vrow.add(doc.data()['name'].toString() +
                    ' - ' +
                    variant['variantname'].toString());

                vrow.add(doc.data()['description']);
                vrow.add('FALSE');
                vrow.add(variant['imageUrlfromStorage']);
                vrow.add(variant['variantprice']);
                vrow.add(doc.data()['tags']);

                vrow.add(doc.data()['option1name']);
                vrow.add(option);
                vrow.add(doc.data()['variationlabel']);
                vrow.add(variant['variantname']);
                vrow.add('');
                vrow.add('');
                vrow.add('');
                vrow.add('');
                vrow.add('');
                vrow.add('');
                //parent
                vrow.add(doc.data()['sku']);
                vrow.add(variant['quantity']);
                vrow.add('1');
                vrow.add('');
                rows.add(vrow);
              }
            } else if (doc.data()['variationputunderwhichattribute'] == 3) {
              print('variation under 3');
              //variation is put under option3name and option3s
              List<String> optionslistofoption1 =
                  doc.data()['option1s'].split(",");
              List<String> optionslistofoption2 =
                  doc.data()['option2s'].split(",");
              for (var option in optionslistofoption1) {
                count += 1;
                for (var option2 in optionslistofoption2) {
                  count += 1;
                  List<dynamic> vrow = List<dynamic>();

                  vrow.add('variation');
                  vrow.add(''); //sku
                  vrow.add(doc.data()['name'].toString() +
                      ' - ' +
                      variant['variantname'].toString());

                  vrow.add(doc.data()['description']);
                  vrow.add('FALSE');
                  vrow.add(variant['imageUrlfromStorage']);
                  vrow.add(variant['variantprice']);
                  vrow.add(doc.data()['tags']);

                  vrow.add(doc.data()['option1name']);
                  vrow.add(option);

                  vrow.add(doc.data()['option2name']);
                  vrow.add(option2);

                  vrow.add(doc.data()['variationlabel']);
                  vrow.add(variant['variantname']);
                  vrow.add('');
                  vrow.add('');
                  vrow.add('');
                  vrow.add('');
                  //parent
                  vrow.add(doc.data()['sku']);
                  vrow.add(variant['quantity']);
                  vrow.add('1');
                  vrow.add('');
                  rows.add(vrow);
                }
              }
            } else if (doc.data()['variationputunderwhichattribute'] == 4) {
              print('variation under 4');
              //variation is put under option4name and option3s
              List<String> optionslistofoption1 =
                  doc.data()['option1s'].split(",");
              List<String> optionslistofoption2 =
                  doc.data()['option2s'].split(",");
              List<String> optionslistofoption3 =
                  doc.data()['option3s'].split(",");

              for (var option in optionslistofoption1) {
                count += 1;
                for (var option2 in optionslistofoption2) {
                  count += 1;
                  for (var option3 in optionslistofoption3) {
                    count += 1;
                    List<dynamic> vrow = List<dynamic>();

                    vrow.add('variation');
                    vrow.add(''); //sku
                    vrow.add(doc.data()['name'].toString() +
                        ' - ' +
                        variant['variantname'].toString());

                    vrow.add(doc.data()['description']);
                    vrow.add('FALSE');
                    vrow.add(variant['imageUrlfromStorage']);
                    vrow.add(variant['variantprice']);
                    vrow.add(doc.data()['tags']);

                    vrow.add(doc.data()['option1name']);
                    vrow.add(option);

                    vrow.add(doc.data()['option2name']);
                    vrow.add(option2);

                    vrow.add(doc.data()['option3name']);
                    vrow.add(option3);
                    vrow.add(doc.data()['variationlabel']);
                    vrow.add(variant['variantname']);
                    vrow.add('');
                    vrow.add('');
                    //parent
                    vrow.add(doc.data()['sku']);
                    vrow.add(variant['quantity']);
                    vrow.add('1');
                    vrow.add('');
                    rows.add(vrow);
                  }
                }
              }
            } else if (doc.data()['variationputunderwhichattribute'] == 5) {
              print('variation under 5');
              //variation is put under option5name and option3s
              List<String> optionslistofoption1 =
                  doc.data()['option1s'].split(",");
              List<String> optionslistofoption2 =
                  doc.data()['option2s'].split(",");
              List<String> optionslistofoption3 =
                  doc.data()['option3s'].split(",");
              List<String> optionslistofoption4 =
                  doc.data()['option4s'].split(",");

              for (var option in optionslistofoption1) {
                count += 1;
                for (var option2 in optionslistofoption2) {
                  count += 1;
                  for (var option3 in optionslistofoption3) {
                    count += 1;
                    for (var option4 in optionslistofoption4) {
                      count += 1;
                      List<dynamic> vrow = List<dynamic>();

                      vrow.add('variation');
                      vrow.add(''); //sku
                      vrow.add(doc.data()['name'].toString() +
                          ' - ' +
                          variant['variantname'].toString());

                      vrow.add(doc.data()['description']);
                      vrow.add('FALSE');
                      vrow.add(variant['imageUrlfromStorage']);
                      vrow.add(variant['variantprice']);
                      vrow.add(doc.data()['tags']);
                      vrow.add(doc.data()['option1name']);
                      vrow.add(option);

                      vrow.add(doc.data()['option2name']);
                      vrow.add(option2);

                      vrow.add(doc.data()['option3name']);
                      vrow.add(option3);

                      vrow.add(doc.data()['option4name']);
                      vrow.add(option4);

                      //option 5
                      vrow.add(doc.data()['variationlabel']);
                      vrow.add(variant['variantname']);

                      //parent
                      vrow.add(doc.data()['sku']);
                      vrow.add(variant['quantity']);
                      vrow.add('1');
                      vrow.add('');
                      rows.add(vrow);
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        //no variants, so now check if have options instead
        if (doc.data()['numberofoptions'] == '1') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          for (var option in optionslistofoption1) {
            List<dynamic> vrow = List<dynamic>();

            vrow.add('variation');
            vrow.add(''); //sku
            vrow.add(doc.data()['name']);

            vrow.add(doc.data()['description']);
            vrow.add('FALSE');
            vrow.add('');
            vrow.add(doc.data()['price']);
            vrow.add(doc.data()['tags']);
            vrow.add(doc.data()['option1name']);
            vrow.add(option);

            vrow.add('');
            vrow.add('');

            vrow.add('');
            vrow.add('');

            vrow.add('');
            vrow.add('');

            //option 5
            vrow.add('');
            vrow.add('');

            //parent
            vrow.add(doc.data()['sku']);
            vrow.add(doc.data()['quantity']);
            vrow.add('1');
            vrow.add('');
            rows.add(vrow);
          }
        } else if (doc.data()['numberofoptions'] == '2') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          List<String> optionslistofoption2 = doc.data()['option2s'].split(",");
          for (var option in optionslistofoption1) {
            for (var option2 in optionslistofoption2) {
              List<dynamic> vrow = [];

              vrow.add('variation');
              vrow.add(''); //sku
              vrow.add(doc.data()['name']);

              vrow.add(doc.data()['description']);
              vrow.add('FALSE');
              vrow.add('');
              vrow.add(doc.data()['price']);
              vrow.add(doc.data()['tags']);
              vrow.add(doc.data()['option1name']);
              vrow.add(option);

              vrow.add(doc.data()['option2name']);
              vrow.add(option2);

              vrow.add('');
              vrow.add('');

              vrow.add('');
              vrow.add('');

              //option 5
              vrow.add('');
              vrow.add('');

              //parent
              vrow.add(doc.data()['sku']);
              vrow.add(doc.data()['quantity']);
              vrow.add('1');
              vrow.add('');
              rows.add(vrow);
            }
          }
        } else if (doc.data()['numberofoptions'] == '3') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          List<String> optionslistofoption2 = doc.data()['option2s'].split(",");
          List<String> optionslistofoption3 = doc.data()['option3s'].split(",");

          for (var option in optionslistofoption1) {
            for (var option2 in optionslistofoption2) {
              for (var option3 in optionslistofoption3) {
                List<dynamic> vrow = [];
                vrow.add('variation');
                vrow.add(''); //sku
                vrow.add(doc.data()['name']);

                vrow.add(doc.data()['description']);
                vrow.add('FALSE');
                vrow.add('');
                vrow.add(doc.data()['price']);
                vrow.add(doc.data()['tags']);
                vrow.add(doc.data()['option1name']);
                vrow.add(option);

                vrow.add(doc.data()['option2name']);
                vrow.add(option2);

                vrow.add(doc.data()['option3name']);
                vrow.add(option3);

                vrow.add('');
                vrow.add('');

                vrow.add('');
                vrow.add('');

                //parent
                vrow.add(doc.data()['sku']);
                vrow.add(doc.data()['quantity']);
                vrow.add('1');
                vrow.add('');
                rows.add(vrow);
              }
            }
          }
        } else if (doc.data()['numberofoptions'] == '4') {
          List<String> optionslistofoption1 = doc.data()['option1s'].split(",");
          List<String> optionslistofoption2 = doc.data()['option2s'].split(",");
          List<String> optionslistofoption3 = doc.data()['option3s'].split(",");
          List<String> optionslistofoption4 = doc.data()['option4s'].split(",");

          for (var option in optionslistofoption1) {
            for (var option2 in optionslistofoption2) {
              for (var option3 in optionslistofoption3) {
                for (var option4 in optionslistofoption4) {
                  List<dynamic> vrow = [];
                               vrow.add('variation');
                vrow.add(''); //sku
                vrow.add(doc.data()['name']);

                vrow.add(doc.data()['description']);
                vrow.add('FALSE');
                vrow.add('');
                vrow.add(doc.data()['price']);
                vrow.add(doc.data()['tags']);
                vrow.add(doc.data()['option1name']);
                vrow.add(option);

                vrow.add(doc.data()['option2name']);
                vrow.add(option2);

                vrow.add(doc.data()['option3name']);
                vrow.add(option3);

                  vrow.add(doc.data()['option4name']);
                vrow.add(option4);

                vrow.add('');
                vrow.add('');

                //parent
                vrow.add(doc.data()['sku']);
                vrow.add(doc.data()['quantity']);
                vrow.add('1');
                vrow.add('');
                rows.add(vrow);

                }
              }
            }
          }
        }
      }

      //end of the iteration of docs
    }

    File f = await _localFile;

    String csv = const ListToCsvConverter().convert(rows);
    print(csv);
    f.writeAsString(csv);

    sendMailAndAttachment(collection, 'Woocommerce');
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
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DocumentSnapshot doc = Provider.of<DocumentSnapshot>(context);

    final width = MediaQuery.of(context).size.width;
    // final scaffold = Scaffold.of(context);
    AuthProvider authprovider = Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              print('DOC');
              print(doc);
              print(doc['maxNumberOfProductsUserCanCreate']);
              print(doc['numberOfProductsUploaded']);
              if (int.parse(doc['numberOfProductsUploaded']) <
                  int.parse(doc['maxNumberOfProductsUserCanCreate'])) {
                Navigator.pushNamed(context, AddProduct.routeName);
              } else {
                displayExceedCountBottomSheet(context);
                return null;
              }
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(5),
            color: Color.fromRGBO(171, 216, 239, 1),
            child: FittedBox(
              child: Text(
                'Products in \n' + generalProvider.currentCollection,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            )),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: authprovider.getCollectionProducts(
              generalProvider.currentCollection, user.uid),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            }
            final chatDocs = chatSnapshot.data.docs;

            return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 0),
                          ),
                          padding: EdgeInsets.all(10),
                          child: TextButton(
                            child: Text('Generate CSV file for Woocommerce',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              generateCSV(
                                  chatDocs, generalProvider.currentCollection);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 0),
                          ),
                          padding: EdgeInsets.all(10),
                          child: TextButton(
                            child: Text('Generate CSV file for Shopify',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              generateShopifyCSV(
                                  chatDocs, generalProvider.currentCollection);
                            },
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: chatDocs.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) => Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              elevation: 4,
                              margin: EdgeInsets.all(6),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 1.0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Product",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          chatDocs[index].data()['name'],
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            print(chatDocs[index].id);
                                            await authprovider.deleteProduct(
                                                chatDocs[index].id,
                                                user.uid,
                                                generalProvider
                                                    .currentCollection,
                                                chatDocs[index].data()[
                                                    'mainproductimagesIds'],
                                                chatDocs[index]
                                                    .data()['variants']);
                                          },
                                          color: Theme.of(context).errorColor,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                AddProduct.routeName,
                                                arguments: chatDocs[index]);
                                          },
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                    Text("Description",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        chatDocs[index].data()['description'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text("Price/Base Price",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(chatDocs[index].data()['price']),
                                    Text("Category",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    if (chatDocs[index]
                                        .data()['category']
                                        .isEmpty)
                                      Text('No Applicable'),
                                    if (chatDocs[index]
                                        .data()['category']
                                        .isNotEmpty)
                                      Text(chatDocs[index].data()['category']),
                                    Text("Options",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    if (chatDocs[index].data()['option1name'] ==
                                        '')
                                      Text(
                                        'no options',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          if (chatDocs[index]
                                              .data()['option1name']
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(chatDocs[index]
                                                .data()['option1name']),
                                          if (chatDocs[index]
                                              .data()['option2name']
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(chatDocs[index]
                                                .data()['option2name']),
                                          if (chatDocs[index]
                                              .data()['option3name']
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(chatDocs[index]
                                                .data()['option3name']),
                                          if (chatDocs[index]
                                              .data()['option4name']
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(chatDocs[index]
                                                .data()['option4name']),
                                          if (chatDocs[index]
                                              .data()['option5name']
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(chatDocs[index]
                                                .data()['option5name']),
                                        ]),
                                    Text("Variants' names",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    if (chatDocs[index]
                                            .data()['variants']
                                            .length ==
                                        0)
                                      Text(
                                        'no variants',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        for (var v in chatDocs[index]
                                            .data()['variants'])
                                          if (v['variantname']
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(v['variantname'])
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ))),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }
}
