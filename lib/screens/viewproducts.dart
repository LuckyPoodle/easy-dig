import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:easydigitalize/models/collection.dart';
import 'package:easydigitalize/provider/provider.dart';
import 'package:easydigitalize/screens/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easydigitalize/authservice.dart';
import '../provider/authprovider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';

String filePath;
Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.absolute.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  print('in get localfile');

  filePath = '$path/data.csv';
  print('----');
  print(filePath);
  print(path);
  return File('$path/data.csv').create();
}

sendMailAndAttachment() async {
  final Email email = Email(
    body: 'Hey, the CSV made it!',
    subject: 'Datum Entry for ${DateTime.now().toString()}',
    recipients: ['ruiquek11@gmail.com'],
    isHTML: true,
    attachmentPaths: [filePath],
  );

  await FlutterEmailSender.send(email);
}

class ViewProducts extends StatelessWidget {
  static const routeName = '/viewproducts';

  void generateCSV(var docs) async {
    print('saveproductstoprovider');
    print(docs);
    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add([
      "Type",
      "SKU",
      "Name",
      "Brand",
      "Published",
      "images",
      "Price",
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
      "In Stock",
      "Categories"
    ]);
    for (var doc in docs) {
      List<dynamic> row = List<dynamic>();
      row.add(doc.data()['type']);
      row.add(doc.data()['sku']);
      row.add(doc.data()['name']);
      row.add(doc.data()['brand']);
      row.add('1');

      String images = doc.data()['mainProductImages'].join(',');
      row.add(images);
      row.add(doc.data()['price']);
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
        print('()()()()()()()()()');
        print(doc.data()['variants']);

/////////looping through variants
        ////nested loop to present each option
        for (var variant in doc.data()['variants']) {

          if (variant['variantname'].toString().trim().isEmpty){
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
              vrow.add(doc.data()['brand']);
              vrow.add('1');
              vrow.add(variant['imageUrlfromStorage']);
              vrow.add(variant['variantprice']);
              print('*************************');
              print('attribute 1');
              print(doc.data()['variationlabel']);
              print(variant['variantname']);
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
                List<dynamic> vrow = List<dynamic>();
                vrow.add('variation');
                vrow.add(''); //sku
                vrow.add(doc.data()['name'].toString() +
                    ' - ' +
                    variant['variantname'].toString());
                vrow.add(doc.data()['brand']);
                vrow.add('1');
                vrow.add(variant['imageUrlfromStorage']);
                vrow.add(variant['variantprice']);
                print('*************************');
                print('attribute 2');
                print(doc.data()['variationlabel']);
                print(variant['variantname']);
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
                for (var option2 in optionslistofoption2) {
                  List<dynamic> vrow = List<dynamic>();
                  vrow.add('variation');
                  vrow.add(''); //sku
                  vrow.add(doc.data()['name'].toString() +
                      ' - ' +
                      variant['variantname'].toString());
                  vrow.add(doc.data()['brand']);
                  vrow.add('1');
                  vrow.add(variant['imageUrlfromStorage']);
                  vrow.add(variant['variantprice']);

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
                for (var option2 in optionslistofoption2) {
                  for (var option3 in optionslistofoption3) {
                    List<dynamic> vrow = List<dynamic>();
                    vrow.add('variation');
                    vrow.add(''); //sku
                    vrow.add(doc.data()['name'].toString() +
                        ' - ' +
                        variant['variantname'].toString());
                    vrow.add(doc.data()['brand']);
                    vrow.add('1');
                    vrow.add(variant['imageUrlfromStorage']);
                    vrow.add(variant['variantprice']);

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
                for (var option2 in optionslistofoption2) {
                  for (var option3 in optionslistofoption3) {
                    for (var option4 in optionslistofoption4) {
                      List<dynamic> vrow = List<dynamic>();
                      vrow.add('variation');
                      vrow.add(''); //sku
                      vrow.add(doc.data()['name'].toString() +
                          ' - ' +
                          variant['variantname'].toString());
                      vrow.add(doc.data()['brand']);
                      vrow.add('1');
                      vrow.add(variant['imageUrlfromStorage']);
                      vrow.add(variant['price']);
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
      }
    }

    File f = await _localFile;
    print('in generate CSV');
    print(f);
    String csv = const ListToCsvConverter().convert(rows);
    print(csv);
    f.writeAsString(csv);

    sendMailAndAttachment();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    // final scaffold = Scaffold.of(context);
    AuthProvider authprovider = Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider = Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Products in Collection')),
      body: Container(
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

            return Column(
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        elevation: 4,
                        margin: EdgeInsets.all(4),
                        child: ListTile(
                          onTap: () {},
                          title: Text(chatDocs[index].data()['name']),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {},
                                  color: Theme.of(context).errorColor,
                                ),
                              ],
                            ),
                          ),
                        ))),
                IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      generateCSV(chatDocs);
                    })
              ],
            );
          },
        ),
      ),
    );
  }
}
