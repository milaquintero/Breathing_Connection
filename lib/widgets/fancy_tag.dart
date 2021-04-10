import 'package:flutter/material.dart';

class FancyTag extends StatelessWidget {
  final String tagName;
  final String tagFooter;
  final bool hasFooter;
  final double nameFontSize;
  final double footerFontSize;
  final bool isDismissible;
  final Function(String) dismissCallback;
  FancyTag({this.tagName, this.hasFooter = false, this.tagFooter,
  this.footerFontSize, this.nameFontSize, this.isDismissible = false,
  this.dismissCallback});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: hasFooter ? EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 16) : EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isDismissible ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
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
              ) : Container()
            ],
          ),
          isDismissible ? IconButton(
              onPressed: (){
                dismissCallback(tagName);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              )
          ) : Container()
        ],
      ),
    );
  }
}
