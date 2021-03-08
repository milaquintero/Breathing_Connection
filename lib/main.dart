import 'package:breathing_connection/models/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/pages/loading.dart';
import 'package:breathing_connection/pages/home.dart';
import 'package:breathing_connection/pages/app_settings.dart';
import 'package:breathing_connection/pages/technique_list.dart';
import 'package:breathing_connection/pages/environment.dart';

import 'models/user.dart';

void main() {
  runApp(BreathingConnection());
}

class BreathingConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User())
      ],
      child: MaterialApp(
        routes: {
          '/': (context)=>Loading(),
          '/home': (context)=>Home(),
          '/settings': (context)=>AppSettings(),
          '/technique-list': (context)=>TechniqueList(),
          '/environment': (context)=>Environment()
        },
      )
    );
  }
}
