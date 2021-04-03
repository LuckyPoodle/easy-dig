
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{
  String emailaddress;
  String accountType;
  List<String> collectionnames;
  String numberOfProductsUploaded;
  String maxNumberOfProductsUserCanCreate;

  AppUser({this.accountType,this.numberOfProductsUploaded,this.maxNumberOfProductsUserCanCreate});

    factory AppUser.fromDocument(QueryDocumentSnapshot data) {

    return AppUser(
      accountType: data['accountType'],
      numberOfProductsUploaded: data['numberOfProductsUploaded'],
      maxNumberOfProductsUserCanCreate: data['maxNumberOfProductsUserCanCreate'],
      

    );
  }














}