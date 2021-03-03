import 'package:flutter/material.dart';
class TechniqueCardHeader extends StatelessWidget {
  final String headerText;
  final Color bgColor;
  TechniqueCardHeader({this.headerText, this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16,4,16,4),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: bgColor
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              headerText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
          ),
        ],
      ),
    );
  }
}
