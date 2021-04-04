import 'dart:async';
import 'dart:io';
import 'package:easydigitalize/helper/authservice.dart';
import 'package:flutter/material.dart';
import '../provider/generalprovider.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_auth/firebase_auth.dart';
final String testID = 'pro_coupon';

class MarketScreen extends StatefulWidget {
  static const routeName = '/market';
  createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {

  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription<List<PurchaseDetails>> _subscription;

  /// Consumable credits the user can buy
  int credits = 0;

  AuthService authservice;

  @override
  void initState() {
    //fetch prdts and purchases
    _initialize();
    super.initState();
  }

  @override
    void dispose() {
      _subscription.cancel();
      super.dispose();
   }

  /// Initialize data
  /// Initialize data 
  void _initialize() async {

    // Check availability of In App Purchases
    available = await _iap.isAvailable();

    if (available) {
//retrieve
      await _getProducts();
      await _getPastPurchases();

//we can use future.wait if u want

      // Verify and deliver a purchase with your own business logic
      _verifyPurchase();

      
      // Listen to new purchases
      _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
        print('NEW PURCHASE');
        _purchases.addAll(data);
        _verifyPurchase();
      }));

    }
  }

  /// Spend credits and consume purchase when they run pit
  void _spendCredits(PurchaseDetails purchase) async {
    
    /// Decrement credits
    setState(() { credits--; });

     
      Provider.of<GeneralProvider>(context,listen:false).setNumberOfProductsUploaded(int.parse(credits.toString()));
      
      int creditcountnow=Provider.of<GeneralProvider>(context,listen:false).localcountmaxnumberofProductsUploaded-1;

      

      String newcount=creditcountnow.toString();
      
      authservice.updateCreditsInAccount(Provider.of<User>(context,listen:false).uid,newcount);

    /// TODO update the state of the consumable to a backend database

    // Mark consumed when credits run out
    if (credits == 0) {
      //tell playstore the purchase is consumed
      var res = await _iap.consumePurchase(purchase);
      await _getPastPurchases();
    }

  }


   /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    //for one time purchase is nonconsumable
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    //autoconsume is false means user can't purchase again until they have consumed
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }



  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([testID]);
    print('in get Products...');
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);



    print('in get Products response is ...'+response.productDetails.toString());

    setState(() { 
      _products = response.productDetails;
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    print('in get Past purchased Products...');
    QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();
        print('in get Past purchased Products response is ...'+response.pastPurchases.toString());
//this does not return consumed pdt so u should save state of consumed pdt in ur database
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS){
        _iap.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(testID);

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      credits = 100;
    
      
      Provider.of<GeneralProvider>(context,listen:false).setlocalcountmaxnumberofProductsUploaded(int.parse(credits.toString()));
      
      authservice.addCreditsToAccount(Provider.of<User>(context,listen:false).uid);
    }
  }
  


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(available ? 'Open for Business' : 'Not Available'),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var prod in _products)

              // UI if already purchased
              if (_hasPurchased(prod.id) != null)
                ...[
                  Text('💎 $credits', style: TextStyle(fontSize: 60)),
                  FlatButton(
                    child: Text('Consume'),
                    color: Colors.green,
                    onPressed: () => _spendCredits(_hasPurchased(prod.id)),
                  )
                ]
              
              // UI if NOT purchased
              else ...[
                Text(prod.title, style: Theme.of(context).textTheme.headline),
                Text(prod.description),
                Text(prod.price,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 60)),
                FlatButton(
                  child: Text('Buy It'),
                  color: Colors.green,
                  onPressed: () => _buyProduct(prod),
                ),
            ]
          ],
        ),
      ),
    );
  }


  // Private methods go here
  

}
