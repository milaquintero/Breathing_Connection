import 'package:flutter/material.dart';

class FancyBulletList extends StatelessWidget {
  final IconData bulletIcon;
  final Color bulletIconColor;
  final Color textColor;
  final List<String> listItems;
  FancyBulletList({this.bulletIcon, this.bulletIconColor, this.listItems, this.textColor});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: listItems.map((listItem){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                bulletIcon,
                size: 32,
                color: bulletIconColor,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  listItem,
                  style: TextStyle(
                      fontSize: 18,
                      color: textColor
                  ),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
