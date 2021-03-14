import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
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

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
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
    //update main data in shareable resource
    Provider.of<MainData>(context, listen: false).setMainData(mainData);
    //start bottom nav in home page
    CurrentPageHandler homePage = CurrentPageHandler(pageIndex: 0, pageRoute: '/home');
    Provider.of<CurrentPageHandler>(context, listen: false).setPage(homePage);
  }

  Future <void> getRequiredResources() async{
    //get current user data
    await getUserData();
    //get available techniques
    await getTechniques();
    //get main data
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
