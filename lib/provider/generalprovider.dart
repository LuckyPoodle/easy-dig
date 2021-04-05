import 'package:flutter/cupertino.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import '../models/variant.dart';
import '../models/Product.dart';
import '../models/collection.dart';

class GeneralProvider with ChangeNotifier{

  String currentCollection='';
  List<Asset> mainImagesOfProducts=[];
  List<Variant> listofVariantsOfCurrentProduct=[];
  List<String> listofcurrentPdtVariantsNames=[];
  List<Asset> listofcurrentPdtVariantsImages=[];
  int currentProductHowManyVariants=0;

  int localcountnumberOfProductsUploaded=0;
  int localcountmaxnumberofProductsUploaded=0;
  

  void setNumberOfProductsUploaded(int number){
    localcountnumberOfProductsUploaded=number;
    print('localcountnumberOfProductsUploaded = '+number.toString());

    notifyListeners();

  }

   void setlocalcountmaxnumberofProductsUploaded(int number){
    localcountmaxnumberofProductsUploaded=number;
    print('localcountmaxnumberofProductsUploaded = '+number.toString());
    notifyListeners();
  }




  void addoneproduct(){
    localcountnumberOfProductsUploaded+=1;
    

    notifyListeners();
  }

  void removeoneproduct(){
    localcountnumberOfProductsUploaded-=1;

    notifyListeners();
  }


  void setCurrentCollection(String name){
    currentCollection=name;
    print('setCollection to be '+name);
    notifyListeners();
  }
  
  void clearVariants(){
    listofVariantsOfCurrentProduct=[];
    listofcurrentPdtVariantsNames=[];
    listofcurrentPdtVariantsImages=[];
    notifyListeners();
  }

  void setMainImagesOfProducts (List<Asset> images){
    mainImagesOfProducts=images;
    notifyListeners();
  }

  

  void setCurrentProductHowManyVariants(int n){
    currentProductHowManyVariants=n;
    notifyListeners();
  }

  void addtoListOfVariants(Variant v){
    listofVariantsOfCurrentProduct.add(v);
    notifyListeners();
  }

  

  













}