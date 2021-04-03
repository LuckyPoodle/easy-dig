import '../helper/authservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/collection.dart';
import '../models/Product.dart';

class AuthProvider with ChangeNotifier{



final AuthService authService=AuthService();
final FirebaseFirestore _db = FirebaseFirestore.instance;




  Stream<QuerySnapshot> getUserCollections(String id) {
    print('id is ====>'+id);
  return _db.collection('collections').doc(id).collection('usercollections').snapshots();
  
}

Stream<QuerySnapshot> getCollectionProducts(String collectionname,String userid){
  print('getCollectionProducts!!!!!!!!!!');
  print(collectionname);
  CollectionReference collectionReference=_db.collection('collections');
  return collectionReference.doc(userid).collection('usercollections').doc(collectionname).collection('products').snapshots();
}

Future<bool> addProductToCollection(Product product,String collectionName,String userid) async{

  print('in Add Product To Collection '+collectionName);

  //pinpoint the collection of the user
  CollectionReference collectionReference=_db.collection('collections');
  DocumentReference addcollectiontobucket=collectionReference.doc(userid).collection('usercollections').doc(collectionName);

  addcollectiontobucket.collection('products').add(product.toMap()).whenComplete(() {
    return true;}
    ).catchError((e){
      return false;
    });
}

Future<void> updateProductInCollection(Product product,String collectionName,String userid) async{

  print('in Updating Product');
  print('=============');
   CollectionReference collectionReference=_db.collection('collections');
  DocumentReference addcollectiontobucket=collectionReference.doc(userid).collection('usercollections').doc(collectionName);

  addcollectiontobucket.collection('products').doc(product.id).set(product.toMap()).whenComplete(() {
    return true;}
    ).catchError((e){
      return false;
    });





}




Future<bool> addCollection(Collection collection) async{
  print('in addcollection');
  CollectionReference collectionReference=_db.collection('collections');
  DocumentReference addcollectiontobucket=collectionReference.doc(collection.userId).collection('usercollections').doc(collection.collectionname);
  CollectionReference userReference=_db.collection('users');
  DocumentReference updateusertoincludecollectionname=userReference.doc(collection.userId);


  WriteBatch writeBatch=_db.batch();
  writeBatch.set(addcollectiontobucket, {

      'createdAt': Timestamp.now(),
      'userId': collection.userId,
      'collectionname':collection.collectionname,
    
    });

    //to add to User document's collectionnames
  writeBatch.update(updateusertoincludecollectionname,{
    'collectionnames':FieldValue.arrayUnion([collection.collectionname+collection.userId])
  });

  writeBatch.commit();
  
  
      
    
  }


 Future<void> deleteCollection(String name,String userid) async{
   print('in delete collection');
   print(name);
   print(userid);
    await FirebaseFirestore.instance.collection('collections').doc(userid).collection('usercollections').doc(name).snapshots().forEach((element) {
     
        element.reference.delete();
      
    }); 
  }

  Future<void> deleteProduct(String name,String userid,String collectionname,var mainimagesids,var variants) async{
    print ('in delete product');
    print(variants);
    print(mainimagesids);
    List<String> listofIdsofImagesToDelete=[];
    for (var v in variants){
      print('VARIANT V');
      print(v['imageUrlId']);
      if (v["imageUrlId"]!=null ){
        listofIdsofImagesToDelete.add(v["imageUrlId"]);
      }
      
    }

    for (var id in mainimagesids){
      listofIdsofImagesToDelete.add(id);

    
    }
    print('image ids....');
    print(listofIdsofImagesToDelete);
    for (var idtodelete in listofIdsofImagesToDelete){
      authService.deleteImagePublito(idtodelete);
    }

    await FirebaseFirestore.instance.collection('collections').doc(userid).collection('usercollections').doc(collectionname).collection('products').doc(name).delete();
  }



















}