import 'dart:async';

import 'package:breathing_connection/pages/authentication_pages/subscription_store.dart';
import 'package:breathing_connection/pages/bottom_nav_accessible_pages/app_settings_page.dart';
import 'package:breathing_connection/pages/bottom_nav_accessible_pages/home_page.dart';
import 'package:breathing_connection/pages/bottom_nav_accessible_pages/pro_license_page.dart';
import 'package:breathing_connection/pages/bottom_nav_accessible_pages/profile_page.dart';
import 'package:breathing_connection/pages/bottom_nav_accessible_pages/technique_list_page.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/pages/top_level_pages/page_not_found.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/utility.dart';
import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin{
  //app main data
  MainData mainData;
  //handler for current page (used by bottom nav)
  CurrentPageHandler curPage;
  //list of links for side nav
  List<NavLink> navLinks = [];
  //app theme data
  AppTheme appTheme;
  //current user
  User curUser;
  //page to display
  Widget _pageToDisplay;
  //animation for pages
  Offset _transitionOffset;
  //in app purchase connection instance
  InAppPurchase _iap = InAppPurchase.instance;
  //list of available products
  List<ProductDetails> _products = [];
  //list of past purchases
  List<PurchaseDetails> _purchases = [];
  //updates to purchases
  StreamSubscription _subscription;
  //subscription store data
  SubscriptionStore subscriptionStore;
  //track if data has already been initialized (init depends on main data available products)
  bool areDependenciesInitialized = false;
  //handle purchase update events
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      //purchase is still pending
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //TODO: show loading page with boolean flag
      } else {
        //subscription has been purchased or restored
        if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          //check if purchase is valid (only one subscription at a time)
          bool valid = await _verifyPurchase(purchaseDetails);
          //purchase is valid so add to purchase array
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            //user tried to purchase a second subscription so show error dialog
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        //subscription is pending purchase so complete it
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  //update purchase array after successful purchase
  void _deliverProduct(PurchaseDetails purchaseDetails) async {
    setState(() {
      _purchases.add(purchaseDetails);
    });
    Provider.of<SubscriptionStore>(context, listen: false).setPurchases(_purchases);
  }

  //show dialog when user tries to purchase a second subscription
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) async{
    await showDialog(
        context: context,
        builder: (context){
          return DialogAlert(
            titlePadding: EdgeInsets.only(top: 12),
            subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
            buttonText: 'Back to Home',
            titleText: 'Error',
            subtitleText: 'Only one subscription plan is allowed at a time. Please go to the Settings page to unsubscribe to your current plan before continuing.',
            headerIcon: Icons.support_agent,
            headerBgColor: appTheme.errorColor,
            buttonColor: appTheme.brandPrimaryColor,
            titleTextColor: appTheme.textAccentColor,
            bgColor: appTheme.bgPrimaryColor,
            subtitleTextColor: appTheme.textAccentColor,
            cbFunction: (){},
          );
        }
    );
  }

  //check if user has purchased the subscription before
  PurchaseDetails _hasPurchased(String productID){
    return _purchases.firstWhere((purchase) => purchase.productID == productID, orElse: null);
  }

  //verify that the user has only one subscription
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async{
    if(_purchases.length != 0){
      for(int i = 0; i < mainData.availableProducts.length; i++){
        PurchaseDetails purchase = _hasPurchased(mainData.availableProducts[i]);
        //user has subscribed to Pro Version
        if(purchase != null && purchase.status == PurchaseStatus.purchased){
          handleSubscriptionUpdate('pro');
          //end loop if user has already purchased a subscription
          return true;
        }
      }
    }
    //user has unsubscribed from Pro Version
    else if(_purchases.length != 0 && curUser.hasFullAccess){
      handleSubscriptionUpdate('free');
      return false;
    }
    return false;
  }

  //handle when a user has subscribed/unsubscribed to Pro Version
  void handleSubscriptionUpdate(String op) async{
    //handle updating user's hasFullAccess flag
    bool wasSuccessful = await UserService().updateAccountType(op);
    if(wasSuccessful){
      await showDialog(
          context: context,
          builder: (context){
            return DialogAlert(
              titlePadding: EdgeInsets.only(top: 12),
              subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
              buttonText: 'Back to Home',
              titleText: op == 'pro' ? mainData.proSubSuccessHead : mainData.proSubEndHead,
              subtitleText: op == 'pro' ? mainData.proSubSuccessBody : mainData.proSubEndBody,
              headerIcon: Icons.support_agent,
              headerBgColor: appTheme.brandPrimaryColor,
              buttonColor: appTheme.brandPrimaryColor,
              titleTextColor: appTheme.textAccentColor,
              bgColor: appTheme.bgPrimaryColor,
              subtitleTextColor: appTheme.textAccentColor,
              cbFunction: (){
                if(op == 'pro'){
                  //if user has full access remove pro license page from nav links
                  if(curUser.hasFullAccess && mainData.pages.isNotEmpty){
                    mainData.pages.removeWhere((page) => page.pageRoute == '/pro');
                  }
                }
                else{
                  //if user is no longer subscribed add pro license page back into nav links
                  mainData.pages.add(
                    NavLink(
                      pageIcon: Icons.add_moderator,
                      pageTitle: 'PRO',
                      pageRoute: '/pro',
                      pageIndex: 3
                    )
                  );
                }
                //update main data in shareable resource
                Provider.of<MainData>(context, listen: false).setMainData(mainData);
                //start bottom nav in home page
                NavLink homePageLink = mainData.pages.firstWhere((link){
                  return link.pageRoute == '/home';
                });
                Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(homePageLink.pageIndex);
                //send back to authentication wrapper
                Navigator.pushReplacementNamed(context, '/root');
              },
            );
          }
      );
    }
  }

  Future<void> initStoreInfo() async {
    Utility.iapIsAvailable = await _iap.isAvailable();
    //handle when iap is not available on the device
    if (!Utility.iapIsAvailable) {
      setState(() {
        _products = [];
        _purchases = [];
      });
      return;
    }
    //get available products if iap is available in the device
    ProductDetailsResponse productDetailResponse =
    await _iap.queryProductDetails(mainData.availableProducts.toSet());
    //update available products received from query
    setState(() {
      _products = productDetailResponse.productDetails;
      _purchases = [];
    });
    //restore previous purchases
    await _iap.restorePurchases();
    //update purchases and products in provider
    Provider.of<SubscriptionStore>(context, listen: false).setPurchases(_purchases);
    Provider.of<SubscriptionStore>(context, listen: false).setProducts(_products);
  }
  Future<void> initWithDependencies() async{
    if(!areDependenciesInitialized){
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _iap.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // handle error here.
      });
      initStoreInfo();
      //cancel all previous alarms
      Utility.cancelAllAlarms();
      //schedule daily reminders if setting is on
      Utility.scheduleDailyReminders(curUser, mainData);
      //if user has full access remove pro license page from nav links
      if(curUser.hasFullAccess && mainData.pages.isNotEmpty){
        mainData.pages.removeWhere((page) => page.pageRoute == '/pro');
      }
      //list of links for side nav
      navLinks = List<NavLink>.from(mainData.pages);
      //update flag
      areDependenciesInitialized = true;
    }
  }
  void updatePageInView(){
    //handler for current page (used by bottom nav)
    curPage = Provider.of<CurrentPageHandler>(context, listen: true);
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
    if(navLinks.isNotEmpty && curPage != null && appTheme != null){
      //handle switching page with animation
      int currentIndex = curPage.pageIndex;
      String currentRoute = navLinks[currentIndex].pageRoute;

      if(currentRoute == '/home'){
        _pageToDisplay = HomePage(rootContext: context,);
        _transitionOffset = Offset(-1.5,0.0);
      }
      else if(currentRoute == '/technique-list'){
        _pageToDisplay = TechniqueListPage(rootContext: context);
        _transitionOffset = Offset(1.5,0.0);
      }
      else if(currentRoute == '/settings'){
        _pageToDisplay = AppSettingsPage(rootContext: context,);
        _transitionOffset = Offset(-1.5,0.0);
      }
      else if(currentRoute == '/pro'){
        _pageToDisplay = ProLicensePage(rootContext: context,);
        _transitionOffset = Offset(1.5,0.0);
      }
      else if(currentRoute == '/profile'){
        _pageToDisplay = ProfilePage(rootContext: context,);
        _transitionOffset = Offset(-1.5,0.0);
      }
      else{
        _pageToDisplay = PageNotFound(rootContext: context, hasBottomNav: true,);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    areDependenciesInitialized = false;
  }
  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserService().userWithData,
        builder: (context, userSnapshot){
          if(userSnapshot.hasData){
            curUser = userSnapshot.data;
            return StreamBuilder(
              stream: MainDataService().mainData,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  //app main data
                  mainData = snapshot.data;


                  initWithDependencies();
                  //update displayed page
                  updatePageInView();
                  return MultiProvider(
                    providers: [
                      StreamProvider<MainData>.value(value: MainDataService().mainData, initialData: mainData),
                      StreamProvider<User>.value(value: UserService().userWithData, initialData: curUser),
                    ],
                    child: Scaffold(
                      backgroundColor: appTheme.brandPrimaryColor,
                      body: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [Colors.blueGrey[400], Color.lerp(appTheme.brandPrimaryColor, Colors.blueGrey[400], 0.1), appTheme.brandPrimaryColor],
                                center: Alignment(-10.5, 0.8),
                                focal: Alignment(0.3, -0.1),
                                focalRadius: 3.5,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return DualTransitionBuilder(
                                animation: animation,
                                forwardBuilder: (BuildContext context, Animation<double> animation, Widget child){
                                  final  customAnimation =
                                  Tween<Offset>(begin: _transitionOffset, end: Offset.zero).animate(
                                      CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)
                                  );
                                  return SlideTransition(position: customAnimation, child: child,);
                                },
                                reverseBuilder: (BuildContext context, Animation<double> animation, Widget child){
                                  final  customAnimation =
                                  Tween<double>(begin: 1.0, end: 1.0).animate(
                                      CurvedAnimation(parent: animation, curve: Curves.easeInSine)
                                  );
                                  return FadeTransition(opacity: customAnimation, child: child,);
                                },
                                child: child,
                              );
                            },
                            duration: Duration(milliseconds: 500),
                            child: _pageToDisplay,
                          ),
                        ],
                      ),
                      bottomNavigationBar: navLinks.isNotEmpty ? BottomNavigationBar(
                        currentIndex: curPage.pageIndex,
                        elevation: 0,
                        backgroundColor: appTheme.bottomNavBgColor,
                        type : BottomNavigationBarType.fixed,
                        selectedItemColor: appTheme.textSecondaryColor,
                        unselectedItemColor: appTheme.disabledCardBorderColor,
                        items: navLinks.map((link)=> BottomNavigationBarItem(
                            icon: Icon(link.pageIcon),
                            label: link.pageTitle
                        )
                        ).toList(),
                        onTap: (index){
                          Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(index);
                        },
                      ) : Container(),
                    ),
                  );
                }
                else{
                  return LoadingPage();
                }
              },
            );
          }
          else{
            return LoadingPage();
          }
        }
    );
  }
}
