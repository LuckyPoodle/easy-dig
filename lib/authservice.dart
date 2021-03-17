import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import './models/user.dart';


class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        UserCredential result = await _auth.signInWithCredential(credential);




        if (result.additionalUserInfo.isNewUser==true){
          addUserData(result);
        }



          // Once signed in, return the UserCredential
          return result;
}

  





  
  void addUserData(UserCredential user) async{


      await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user.uid)
            .set({
        

        });

  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }

  


}
