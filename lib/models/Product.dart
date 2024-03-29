
import 'variant.dart';

class Product{

  String name;
  String handle;
  String id;
  String description;
  String quantity;
  String price;
  String brand;
  String category;
  String variationlabel;
  bool hasVariation;
  String imagesStoreLocation;
  int variationputunderwhichattribute=0;
  String sku;
  String type;
  String tags;
  String option1name='';
  String option1s='';
  String option2name='';
  String option2s='';
  String option3name='';
  String option3s='';
  String option4name='';
  String option4s='';
  String option5name='';
  String option5s='';
  String numberofoptions;



  List<String> mainProductImages;
  List<String>mainproductimagesIds;


  //List<String> options;
  List<Variant> variants;

  Product({this.id,this.name,this.handle,this.tags,this.variationlabel,this.numberofoptions,this.imagesStoreLocation,this.category,this.variationputunderwhichattribute,this.option1name,this.option1s,this.option2name,this.option2s,this.option3name,this.option3s,this.option4name,this.option4s,this.option5name,this.option5s,this.type,this.sku,this.description,this.quantity,this.price,this.brand,this.hasVariation,this.mainProductImages,this.mainproductimagesIds,this.variants});

   static List<Map> ConvertCustomStepsToMap(List<Variant> customSteps) {
    List<Map> steps = [];
    customSteps.forEach((Variant customStep) {
      Map step = customStep.toMap();
      steps.add(step);
    });
    return steps;
  }

  //  String option1name='';
  // String option1s='';
  // String option2name='';
  // String option2s='';
  // String option3name='';
  // String option3s='';
  // String option4name='';
  // String option4s='';
  // String option5name='';
  // String option5s='';


//TO DO --- add those options fields in this toMap()
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id':id,
      'description': description,
      'price':price,
      'brand':brand,
      'handle':handle,
      'tags':tags,
      'numberofoptions':numberofoptions,
      
      'hasVariation':hasVariation,
      'sku':sku,
      'type':type,
      'category':category,
      'option1name':option1name,
      'option1s':option1s,
      'option2name':option2name,
      'option2s':option2s,
      'option3name':option3name,
      'option3s':option3s,
      'option4name':option4name,
      'option4s':option4s,
      'option5name':option5name,
      'option5s':option5s,
      'variationlabel':variationlabel,
      'variationputunderwhichattribute':variationputunderwhichattribute,
      
      'quantity':quantity,
      'mainProductImages':mainProductImages,
      'mainproductimagesIds':mainproductimagesIds,
     
      'variants':ConvertCustomStepsToMap(variants),
     
    };
  }





}