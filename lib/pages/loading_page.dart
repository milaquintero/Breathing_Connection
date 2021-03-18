import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> getUserData() async{
    //get user data from backend and update shareable resource with user data
    User curUser = await UserService.userData(1);
    Provider.of<User>(context, listen: false).setAllProperties(curUser);
  }

  Future<void> getTechniques() async{
    //get list of available techniques
    List<Technique> techniques = await TechniqueService.techniqueData();
    //update techniques in shareable resource
    Provider.of<List<Technique>>(context, listen: false).addAll(techniques);
  }

  Future <void> getMainData() async{
    //get main data
    MainData mainData = await MainDataService.mainData();
    //user data
    User curUser = Provider.of<User>(context, listen: false);
    //if user has full access remove pro license page from nav links
    if(curUser.hasFullAccess){
      mainData.pages.removeWhere((page) => page.pageRoute == '/pro');
    }
    //update main data in shareable resource
    Provider.of<MainData>(context, listen: false).setMainData(mainData);
    //start bottom nav in home page
    Provider.of<CurrentPageHandler>(context, listen: false).setPageIndex(0);
  }

  Future <void> getRequiredResources() async{
    //get current user data
    await getUserData();
    //get available techniques
    await getTechniques();
    //get main data only after user data is present
    await getMainData();
    Navigator.pushReplacementNamed(context, '/root');
  }

  @override
  void initState() {
    getRequiredResources();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loadingBgColor,
      body: Center(
        child: SpinKitDoubleBounce(
          size: spinnerSize,
          color: spinnerColor,
        ),
      ),
    );
  }
}
