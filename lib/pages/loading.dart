import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> getUserData() async{
    //get user data from backend
    User curUser = await UserService.userData();
    //update shareable resource with user data
    UserService.curUser = curUser;
  }

  Future<void> getTechniques() async{
    //get list of available techniques
    List<Technique> techniques = await TechniqueService.techniqueData();
    //update techniques in shareable resource
    TechniqueService.techniques = techniques;
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
