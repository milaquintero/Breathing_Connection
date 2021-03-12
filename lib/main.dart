import 'package:breathing_connection/pages/root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/pages/loading.dart';

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
          '/home': (context)=>RootPage(),
        },
      )
    );
  }
}
