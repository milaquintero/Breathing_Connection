import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionStore with ChangeNotifier{
  List<ProductDetails> products;
  List<PurchaseDetails> purchases;
  SubscriptionStore({this.purchases, this.products});
  void setPurchases(List<PurchaseDetails> purchases){
    this.purchases = purchases;
    notifyListeners();
  }
  void setProducts(List<ProductDetails> products){
    this.products = products;
    notifyListeners();
  }
}