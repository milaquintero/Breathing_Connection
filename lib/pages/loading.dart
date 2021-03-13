import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user_settings.dart';
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

  Future <void> getRequiredResources() async{
    //get current user data
    await getUserData();
    //get available techniques
    await getTechniques();
    Navigator.pushReplacementNamed(context, '/home');
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
