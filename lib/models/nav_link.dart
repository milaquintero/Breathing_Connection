import 'dart:collection';

import 'package:flutter/material.dart';

class NavLink{
  int pageIndex;
  IconData pageIcon;
  String pageTitle;
  String pageRoute;
  NavLink({this.pageIcon, this.pageTitle, this.pageRoute, this.pageIndex});
  factory NavLink.fromSnapshot(LinkedHashMap json){
    IconData pageIcon;
    switch(json['pageRoute']){
      case '/home':
        pageIcon = Icons.home;
        break;
      case '/technique-list':
        pageIcon = Icons.article_rounded;
        break;
      case '/settings':
        pageIcon = Icons.settings;
        break;
      case '/pro':
        pageIcon = Icons.add_moderator;
        break;
      default:
        pageIcon = Icons.flag;
        break;
    }
    return NavLink(
      pageIcon: pageIcon,
      pageRoute: json['pageRoute'],
      pageTitle: json['pageTitle'],
      pageIndex: json['pageIndex']
    );
  }
}