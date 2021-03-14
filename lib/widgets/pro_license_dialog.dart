import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
class ProLicenseDialog extends StatelessWidget {
  final BuildContext rootContext;
  ProLicenseDialog({this.rootContext});
  @override
  Widget build(BuildContext context) {
    //page links from main data provider
    List<NavLink> availablePages = Provider.of<MainData>(rootContext).pages;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 260,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 4),
                  child: Text(
                    'Show Your Love!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 20, left: 24, right: 24),
                  child: Text(
                    'Kindly consider purchasing a Pro License to contribute to our development efforts to help the world relax.',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: (){
                        //close dialog
                        Navigator.of(context).pop();
                        //find pro page in main data page links
                        NavLink proLicensePage = availablePages.firstWhere((page) => page.pageRoute == '/pro');
                        //send to PRO page
                        Provider.of<CurrentPageHandler>(rootContext, listen: false).setPageIndex(proLicensePage.pageIndex);
                      },
                      child: Text(
                        'Purchase',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: brandPrimary,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        //close dialog
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Not Now',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: brandPrimary,
              radius: 40,
              child: Icon(
                Icons.add_moderator,
                color: Colors.white,
                size: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
