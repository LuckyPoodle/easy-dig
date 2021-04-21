import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:http/http.dart';
import '../models/user.dart';
import 'package:crypto/crypto.dart';

import 'dart:convert';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
 

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Stream<AppUser> userData(String uid) {
    // return users.doc(uid).snapshots().map((doc) {
    //   return AppUser.fromDocument(doc);
    // });
  }



  // Firebase user a realtime stream

// Firebase user one-time fetch
//bool isLoggedIn(){
//  return _auth.currentUser!=null;
//}

Stream<User> get user => FirebaseAuth.instance.authStateChanges();



  /// Sign in with Google
   Future<UserCredential> signInWithGoogle() async {
            print('sign in with google ----');
          // Trigger the authentication flow
          final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

          // Obtain the auth details from the request
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          // Create a new credential
          final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
        UserCredential result = await auth.signInWithCredential(credential);




        if (result.additionalUserInfo.isNewUser==true){
          addUserData(result);
        }



          // Once signed in, return the UserCredential
          return result;
}

  

Future<bool> deleteUser(){

  auth.currentUser.delete().then((_) {
    print('deleted user');
  }).catchError((error){
    print(error);
  });
  

}



  
  void addUserData(UserCredential user) async{


      await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user.uid)
            .set({

              'emailaddress':user.user.email,
              'accountType':'free',
              'numberOfProductsUploaded':'0',
              'maxNumberOfProductsUserCanCreate':'1'
              
        

        });

  }

  void addCreditsToAccount(String uid, String newcredit) async {
    await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
            'maxNumberOfProductsUserCanCreate':newcredit,
            'accountType':'paid',

          },SetOptions(merge: true));
  }

  void updateCreditsInAccount(String uid,String newvalue) async {
    await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
            'maxNumberOfProductsUserCanCreate':newvalue,
            'accountType':'paid',

          },SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> getUserDataStream() {
    if (auth.currentUser!=null){
      Stream<DocumentSnapshot> q= _db.collection('users').doc(auth.currentUser.uid).snapshots();
    print(q);
    print('==============in getbranddeal=====================');
    return q;
    }
}


Future<AppUser> getUserData(String id) async{

  print('in get user data!!!!!!!!!!');

  var snapshot=await _db.collection('users').doc(id).get();

  var data=snapshot.data();

  print('====================');
  print(data);
       
       String accountType=data['accountType'];
       String numberOfProductsUploaded=data['numberOfProductsUploaded'];
       String maxNumberOfProductsUserCanCreate=data['maxNumberOfProductsUserCanCreate'];
 
    
       AppUser thisuser=AppUser(
           accountType: accountType,
           maxNumberOfProductsUserCanCreate: maxNumberOfProductsUserCanCreate,
           numberOfProductsUploaded:numberOfProductsUploaded
       );
    
       return thisuser;


}
  

  // Sign out
  Future<void> signOut() {
    return auth.signOut();
  }

   Future deleteImagePublito(String id) async {
     String timestamp=DateTime.now().millisecondsSinceEpoch.toString();
     String nonce='12345678';
     var bytes = utf8.encode(timestamp+nonce+'DzltjTnWVLGsASzladHtf5B0nAuSXJDh');
     Digest sha1Result = sha1.convert(bytes);
     String url='https://api.publit.io/v1/files/delete/'+id+'?&api_signature='+sha1Result.toString()+'&api_key=guxRioSMAnGhw4WaBh4o&api_nonce=12345678&api_timestamp='+timestamp;
     Uri uri=Uri.parse(url);
    Response response = await delete(uri);
    if (response.statusCode == 200) {
      String data = response.body;
      print('deleted successfully');
      print(data);
      

    } else {
      print('not deleted successfully');
      print(response.statusCode);
      
    }
  }

  


}
