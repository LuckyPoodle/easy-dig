import 'package:easydigitalize/authservice.dart';
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

Future<void> addProductToCollection(Product product,String collectionName,String userid) async{

  print('in Add Product To Collection '+collectionName);

  //pinpoint the collection of the user
  CollectionReference collectionReference=_db.collection('collections');
  DocumentReference addcollectiontobucket=collectionReference.doc(userid).collection('usercollections').doc(collectionName);

  addcollectiontobucket.collection('products').add(product.toMap());



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


 Future<void> deleteCollection(String name) async{
    await FirebaseFirestore.instance.collection(name).snapshots().forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs){
        snapshot.reference.delete();
      }
    }); 
  }



















}