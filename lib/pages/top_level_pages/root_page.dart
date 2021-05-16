import 'dart:async';
import 'dart:io';

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
  Offset _transitionOffset;
  Future<void> getUserWithData() async{
    curUser = await UserService().userWithData.first;
  }

  //in app purchase connection instance
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
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
  void _initializePurchaseData() async{
    Utility.iapIsAvailable = await _iap.isAvailable();
    if(Utility.iapIsAvailable){
      await _getProducts();
      await _getPastPurchases();
      _verifyPurchase();
      Provider.of<SubscriptionStore>(context, listen: false).setProducts(_products);
      Provider.of<SubscriptionStore>(context, listen: false).setPurchases(_purchases);
      _subscription = _iap.purchaseUpdatedStream.listen((data) => setState((){
        print("NEW PURCHASE");
        _purchases.addAll(data);
        _verifyPurchase();
      }));
    }
  }
  Future<void> _getProducts() async{
    Set<String> productIDs = Set.from(mainData.availableProducts);
    ProductDetailsResponse response = await _iap.queryProductDetails(productIDs);
    setState(() {
      _products = response.productDetails;
    });
  }
  Future<void> _getPastPurchases() async{
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    if(Platform.isIOS){
      response.pastPurchases.forEach((pastPurchase) {
        if(pastPurchase.pendingCompletePurchase){
          _iap.completePurchase(pastPurchase);
        }
      });
    }
    setState(() {
      _purchases = response.pastPurchases;
    });
  }
  PurchaseDetails _hasPurchased(String productID){
    return _purchases.firstWhere((purchase) => purchase.productID == productID, orElse: null);
  }
  void _verifyPurchase() async{
    if(_purchases.length != 0){
      for(int i = 0; i < mainData.availableProducts.length; i++){
        PurchaseDetails purchase = _hasPurchased(mainData.availableProducts[i]);
        //user has subscribed to Pro Version
        if(purchase != null && purchase.status == PurchaseStatus.purchased){
          handleSubscriptionUpdate('pro');
          //end loop if user has already purchased a subscription
          break;
        }
      }
    }
    //user has unsubscribed from Pro Version
    else if(_purchases.length != 0 && curUser.hasFullAccess){
      handleSubscriptionUpdate('free');
    }
  }
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
  Future<void> initWithDependencies() async{
    if(!areDependenciesInitialized){
      //get user's selected theme based on themeID from user settings
      await getUserWithData();
      //cancel all previous alarms
      Utility.cancelAllAlarms();
      //schedule daily reminders if setting is on
      Utility.scheduleDailyReminders(curUser, mainData);
      //initialize purchase data
      _initializePurchaseData();
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
    curPage = Provider.of<CurrentPageHandler>(context);
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
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MainDataService().mainData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          //app main data
          mainData = snapshot.data;
          /*
          initial setup with async dependencies
          flag prevents from running more than once
          depends on main data
          */
          initWithDependencies();
          //update displayed page
          updatePageInView();
          return MultiProvider(
            providers: [
              StreamProvider<MainData>.value(value: MainDataService().mainData, initialData: mainData),
              StreamProvider<User>.value(value: UserService().userWithData, initialData: curUser)
            ],
            child: Scaffold(
              backgroundColor: appTheme.brandPrimaryColor,
              body:
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
}
