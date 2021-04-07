import 'package:breathing_connection/models/app_theme.dart';
import 'package:flutter/material.dart';

class DialogThemeSelection extends StatelessWidget {
  final Function(AppTheme) cbFunction;
  final String titleText;
  final IconData headerIcon;
  final Color headerBgColor;
  final EdgeInsets titlePadding;
  final List<AppTheme> themeList;
  DialogThemeSelection({this.cbFunction, this.titleText, this.headerIcon,
    this.headerBgColor, this.titlePadding, this.themeList});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)
      ),
      backgroundColor: Colors.grey[50],
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: titlePadding,
                  child: Text(
                    titleText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.lightBlue[900]
                    ),
                  ),
                ),
                ListView.builder(
                  itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        onTap: (){
                          //close dialog
                          Navigator.of(context).pop();
                          //send back selected theme
                          cbFunction(themeList[index]);
                        },
                        title: Text(
                          themeList[index].themeName,
                          style: TextStyle(
                            fontSize: 22,
                            color: themeList[index].textPrimaryColor
                          ),
                        ),
                        tileColor: themeList[index].brandPrimaryColor,
                      ),
                    );
                  },
                  itemCount: themeList.length,
                  shrinkWrap: true,
                )
              ],
            ),
          ),
          Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: headerBgColor,
              radius: 40,
              child: Icon(
                headerIcon,
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
