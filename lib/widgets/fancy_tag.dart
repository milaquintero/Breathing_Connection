import 'package:flutter/material.dart';

class FancyTag extends StatelessWidget {
  final String tagName;
  final String tagFooter;
  final bool hasFooter;
  final double nameFontSize;
  final  double footerFontSize;
  FancyTag({this.tagName, this.hasFooter = false, this.tagFooter,
  this.footerFontSize, this.nameFontSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: hasFooter ? EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 16) : EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            tagName,
            style: TextStyle(
              color: Colors.white,
              fontSize: nameFontSize ?? 18,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
          hasFooter ? Text(
            tagFooter,
            style: TextStyle(
                color: Colors.white,
                fontSize: footerFontSize ?? 18,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ) : null
        ],
      ),
    );
  }
}
