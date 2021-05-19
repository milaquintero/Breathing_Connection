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
      padding: hasFooter ? EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 16) : isDismissible ? EdgeInsets.symmetric(horizontal: 46, vertical: 12) : EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: isDismissible ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: isDismissible ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text(
                  tagName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: nameFontSize ?? 24,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                if (hasFooter) Text(
                  tagFooter,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: footerFontSize ?? 18,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ) else Container()
              ],
            ),
          ),
          if (isDismissible) Container(
            width: 36,
            child: IconButton(
                onPressed: (){
                  dismissCallback(tagName);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                )
            ),
          ) else Container()
        ],
      ),
    );
  }
}
