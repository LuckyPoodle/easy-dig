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
Future<String> get _localPath async{
    final directory=await getApplicationSupportDirectory();
    return directory.absolute.path;
    
  }

Future<File> get _localFile async {
  
  final path=await _localPath;
  print('in get localfile');

  filePath='$path/data.csv';
  print('----');
    print(filePath);
    print(path);
  return File('$path/data.csv').create();

}
sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Hey, the CSV made it!',
      subject: 'Datum Entry for ${DateTime.now().toString()}',
      recipients: ['ruiquek11@gmail.com'],
      isHTML: true,
      attachmentPaths: [filePath],
    );

    await FlutterEmailSender.send(email);
  }

class ViewProducts extends StatelessWidget {
  static const routeName = '/viewproducts';
  





  void generateCSV(var docs) async{
    print('saveproductstoprovider');
    print(docs);
    List<List<dynamic>> rows=List<List<dynamic>>();
    rows.add(["Type","SKU","Name","Brand",
    "Published","images",
    "Attribute 1 name","Attribute 1 value(s)","Attribute 2 name","Attribute 2 value(s)",
    "Attribute 3 name","Attribute 3 value(s)","Attribute 4 name","Attribute 4 value(s)","Attribute 5 name","Attribute 5 value(s)","Parent"]);
    for (var doc in docs){
      List<dynamic> row=List<dynamic>();
      row.add(doc.data()['type']);
      row.add(doc.data()['sku']);
      row.add(doc.data()['name']);
      row.add(doc.data()['brand']);
      row.add('-1');
      
      String images=doc.data()['mainProductImages'].join(',');
      row.add(images);
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
      row.add(''); //parent
    
    ////FOR EACH VARIANT, has to iterate through each options...
      rows.add(row);
        if (doc.data()['type']=='variable'){
        //iterate through product's variants, make a new row for each
        print('()()()()()()()()()');
        print(doc.data()['variants']);

        ////nested loop to present each option
        for (var variant in doc.data()['variants']){
          
          
       //means no options
          if(doc.data()['variationputunderwhichattribute']==1){
            List<dynamic> vrow=List<dynamic>();
          vrow.add('variation');
          vrow.add('');//sku
          vrow.add(doc.data()['name'].toString()+' - '+variant['variantname'].toString());
          vrow.add(doc.data()['brand']);
          vrow.add('-1');
          vrow.add(variant['imageUrlfromStorage']);
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
          rows.add(vrow);
          }
          
          ///HAVE OPTIONS so we loop through the options 
           if(doc.data()['variationputunderwhichattribute']==2){
             List<String>optionslist=doc.data()['option1s'].split(","); 
            for (var option in optionslist){
               List<dynamic> vrow=List<dynamic>();
              vrow.add('variation');
              vrow.add('');//sku
              vrow.add(doc.data()['name'].toString()+' - '+variant['variantname'].toString());
              vrow.add(doc.data()['brand']);
              vrow.add('-1');
              vrow.add(variant['imageUrlfromStorage']);
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
              rows.add(vrow);
            }
            
          }else if(doc.data()['variationputunderwhichattribute']==3){
            List<dynamic> vrow=List<dynamic>();
          vrow.add('variation');
          vrow.add('');//sku
          vrow.add(doc.data()['name'].toString()+' - '+variant['variantname'].toString());
          vrow.add(doc.data()['brand']);
          vrow.add('-1');
          vrow.add(variant['imageUrlfromStorage']);
               print('*************************');
            print('attribute 3');
            print(doc.data()['variationlabel']);
            print(variant['variantname']);
          vrow.add(doc.data()['option1name']);
          vrow.add(doc.data()['option1s']);
          
          vrow.add(doc.data()['option2name']);
          vrow.add(doc.data()['option2s']);
          vrow.add(doc.data()['variationlabel']);
          vrow.add(variant['variantname']);
          vrow.add('');
          vrow.add('');
          vrow.add('');
          vrow.add('');
          //parent
          vrow.add(doc.data()['sku']);
          rows.add(vrow);
          }else if(doc.data()['variationputunderwhichattribute']==4){
            List<dynamic> vrow=List<dynamic>();
          vrow.add('variation');
          vrow.add('');//sku
          vrow.add(doc.data()['name'].toString()+' - '+variant['variantname'].toString());
          vrow.add(doc.data()['brand']);
          vrow.add('-1');
          vrow.add(variant['imageUrlfromStorage']);
               print('*************************');
            print('attribute 4');
            print(doc.data()['variationlabel']);
            print(variant['variantname']);
          vrow.add(doc.data()['option1name']);
          vrow.add(doc.data()['option1s']);
          
          vrow.add(doc.data()['option2name']);
          vrow.add(doc.data()['option2s']);
         
          vrow.add(doc.data()['option3name']);
          vrow.add(doc.data()['option3s']);
           vrow.add(doc.data()['variationlabel']);
          vrow.add(variant['variantname']);
          vrow.add('');
          vrow.add('');
          //parent
          vrow.add(doc.data()['sku']);
          rows.add(vrow);
          }else if(doc.data()['variationputunderwhichattribute']==5){
            List<dynamic> vrow=List<dynamic>();
          vrow.add('variation');
          vrow.add('');//sku
          vrow.add(doc.data()['name'].toString()+' - '+variant['variantname'].toString());
          vrow.add(doc.data()['brand']);
          vrow.add('-1');
          vrow.add(variant['imageUrlfromStorage']);
          vrow.add(doc.data()['option1name']);
          vrow.add(doc.data()['option1s']);
          
          vrow.add(doc.data()['option2name']);
          vrow.add(doc.data()['option2s']);
         
         vrow.add(doc.data()['option3name']);
          vrow.add(doc.data()['option3s']);
        
          vrow.add(doc.data()['option4name']);
          vrow.add(doc.data()['option4s']);

          vrow.add(doc.data()['variationlabel']);
          vrow.add(variant['variantname']);
          //parent
          vrow.add(doc.data()['sku']);
          rows.add(vrow);
          }
          


          
        }

        
      }

    }

    File f=await _localFile;
    print('in generate CSV');
    print(f);
    String csv=const ListToCsvConverter().convert(rows);
    print(csv);
    f.writeAsString(csv);

    sendMailAndAttachment();

    
  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
   // final scaffold = Scaffold.of(context);
    AuthProvider authprovider =
        Provider.of<AuthProvider>(context);
    GeneralProvider generalProvider=Provider.of<GeneralProvider>(context);
    return Scaffold(
      appBar:AppBar(title:Text('Products in Collection')),
      body:Container(
          child:  StreamBuilder(
                      stream: authprovider.getCollectionProducts(generalProvider.currentCollection,user.uid),
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
                                  onTap: (){
                            

                                  },
                                  title:
                                      Text(chatDocs[index].data()['name']),
                                
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: <Widget>[
                               
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: ()  {
                                 
                              
                                            }
                                          ,
                                          color: Theme.of(context).errorColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ))),
                                IconButton(
            icon: Icon(Icons.save),
            onPressed:(){
               generateCSV(chatDocs);
            })
                          ],
                        );
                      },
                    ),), 


    );
  }
}