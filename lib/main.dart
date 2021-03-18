import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/pages/root_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/pages/loading_page.dart';

import 'models/nav_link.dart';
import 'models/technique.dart';
import 'models/user.dart';

void main() {
  runApp(BreathingConnection());
}

class BreathingConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MainData>(create: (context) => MainData()),
        ChangeNotifierProvider(create: (context) => User()),
        ChangeNotifierProvider(create: (context) => CurrentPageHandler()),
        Provider<List<Technique>>(create: (context) => []),
      ],
      child: MaterialApp(
        routes: {
          '/': (context)=>LoadingPage(),
          '/root': (context)=>RootPage(),
        },
      )
    );
  }
}
