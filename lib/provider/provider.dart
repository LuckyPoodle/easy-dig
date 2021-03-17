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