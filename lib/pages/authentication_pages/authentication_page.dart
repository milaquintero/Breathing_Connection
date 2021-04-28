import 'package:breathing_connection/pages/authentication_pages/registration_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn ? LoginPage(switchViewFn: toggleView,) : RegistrationPage(switchViewFn: toggleView,),
    );
  }
}
