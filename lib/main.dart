import 'package:flutter/material.dart';
import 'package:breathing_connection/pages/loading.dart';
import 'package:breathing_connection/pages/home.dart';
import 'package:breathing_connection/pages/settings.dart';
import 'package:breathing_connection/pages/technique_list.dart';
import 'package:breathing_connection/pages/environment.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context)=>Loading(),
      '/home': (context)=>Home(),
      '/settings': (context)=>Settings(),
      '/technique-list': (context)=>TechniqueList(),
      '/environment': (context)=>Environment()
    },
  ));
}