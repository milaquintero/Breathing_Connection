import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/pages/authentication_pages/subscription_store.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/fancy_bullet_list.dart';
import 'package:breathing_connection/widgets/fancy_scrollable_page.dart';
import 'package:breathing_connection/widgets/fancy_tag.dart';
import 'package:breathing_connection/widgets/fancy_text_container.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../utility.dart';

class ProLicensePage extends StatefulWidget {
  final BuildContext rootContext;
  ProLicensePage({this.rootContext});

  @override
  _ProLicensePageState createState() => _ProLicensePageState();
}

class _ProLicensePageState extends State<ProLicensePage> {
  //selected app theme
  AppTheme appTheme;
  //app main data
  MainData mainData;
  //current user data
  User curUser;
  //in app purchase connection instance
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  //subscription store data
  SubscriptionStore subscriptionStore;
  void _purchase(String op){
    if(subscriptionStore.purchases.length != 0){
      String selectedProductID = mainData.availableProducts.firstWhere(
        (availableProduct) => availableProduct.contains(op),
        orElse: null
      );
      ProductDetails selectedProduct = subscriptionStore.products.firstWhere(
        (product) => product.id == selectedProductID,
        orElse: null
      );
      _buyProduct(selectedProduct);
    }
  }
  void _buyProduct(ProductDetails product){
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(widget.rootContext).currentTheme;
    //app main data
    mainData = Provider.of<MainData>(context);
    //subscription store data
    subscriptionStore = Provider.of<SubscriptionStore>(widget.rootContext);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserService().userWithData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          curUser = snapshot.data;
          return FancyScrollablePage(
            withIconHeader: false,
            pageTitle: 'Pro License',
            bgColor: appTheme.bgSecondaryColor,
            appBarColor: appTheme.brandPrimaryColor,
            decorationPrimaryColor: appTheme.decorationPrimaryColor,
            decorationSecondaryColor: appTheme.decorationSecondaryColor,
            appBarHeight: mainData.appBarHeight,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 28, bottom: 8),
                  child: Text(
                    mainData.proPageHeaderText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: appTheme.textSecondaryColor,
                        letterSpacing: -0.75
                    ),
                  ),
                ),
                FancyTextContainer(
                  icon: Icons.add_moderator,
                  iconColor: appTheme.textPrimaryColor,
                  iconBgColor: appTheme.brandAccentColor,
                  title: "Additional Features",
                  textColor: appTheme.textPrimaryColor,
                  bgColor: appTheme.brandPrimaryColor,
                  bgGradientComparisonColor: appTheme.bgAccentColor,
                  margin: EdgeInsets.only(top: 72, bottom: 36),
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10, left: 20, right: 20),
                    child: FancyBulletList(
                      bulletIcon: Icons.check_circle,
                      bulletIconColor: appTheme.bulletListIconColor,
                      textColor: appTheme.textPrimaryColor,
                      listItems: [
                        "Unlock all Breathing Techniques",
                        "Gain ability to create Custom Techniques",
                        "New music, sounds and images every month",
                        "Unlock the Challenge Technique feature"
                      ],
                    ),
                  ),
                ),
                if(Utility.iapIsAvailable) FancyTextContainer(
                  icon: Icons.account_balance,
                  iconColor: appTheme.textPrimaryColor,
                  iconBgColor: appTheme.brandAccentColor,
                  title: "Pricing",
                  textColor: appTheme.textPrimaryColor,
                  bgColor: appTheme.brandPrimaryColor,
                  bgGradientComparisonColor: appTheme.bgAccentColor,
                  margin: EdgeInsets.only(top: 52, bottom: 36),
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 0, left: 20, right: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Select an option below',
                            style: TextStyle(
                              fontSize: 22,
                              color: appTheme.textPrimaryColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            //initiate payment for monthly subscription
                            _purchase('monthly');
                          },
                          child: FancyTag(
                            tagName: "\$1.49",
                            hasFooter: true,
                            tagFooter: "(BILLED MONTHLY)",
                            footerFontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            //initiate payment for annual subscription
                            _purchase('annual');
                          },
                          child: FancyTag(
                            tagName: "\$9.99",
                            hasFooter: true,
                            tagFooter: "(BILLED ANNUALLY)",
                            footerFontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ) else FancyTextContainer(
                  icon: Icons.cancel,
                  iconColor: appTheme.textPrimaryColor,
                  iconBgColor: appTheme.brandAccentColor,
                  title: "Not Available",
                  textColor: appTheme.textPrimaryColor,
                  bgColor: appTheme.brandPrimaryColor,
                  bgGradientComparisonColor: appTheme.bgAccentColor,
                  margin: EdgeInsets.only(top: 52, bottom: 36),
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 16),
                    child: Text(
                      'Your device does not support our purchase management technology. Please update your device or try again on a different device.,',
                      style: TextStyle(
                        fontSize: 22,
                        color: appTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          return LoadingPage();
        }
      },
    );
  }
}
