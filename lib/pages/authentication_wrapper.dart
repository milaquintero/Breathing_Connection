import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:flutter/material.dart';

import 'authentication_pages/authentication_page.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: UserService().user,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return LoadingPage(shouldRetrieveMainData: true,);
        }
        else{
          return AuthenticationPage();
        }
      },
    );
  }
}
