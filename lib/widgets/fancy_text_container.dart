import 'package:flutter/material.dart';

class FancyTextContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color iconBgColor;
  final String title;
  final Widget child;
  final Color textColor;
  final EdgeInsets margin;
  final TextAlign subtitleAlignment;
  final Color bgGradientComparisonColor;
  FancyTextContainer({this.iconColor, this.icon, this.bgColor, this.iconBgColor,
    this.title, this.child, this.textColor, this.margin, this.subtitleAlignment,
    this.bgGradientComparisonColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 92, bottom: 8),
      padding: EdgeInsets.only(top: 28, bottom: 40, left: 24, right: 24),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          gradient: RadialGradient(
            colors: [bgGradientComparisonColor, Color.lerp(bgColor, bgGradientComparisonColor, 0.5), bgColor],
            center: Alignment(0.6, -0.3),
            focal: Alignment(0.3, -0.1),
            focalRadius: 3.5,
          )
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -76,
            child: CircleAvatar(
              backgroundColor: iconBgColor,
              radius: 50,
              child: Icon(
                icon,
                color: iconColor,
                size: 50,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 44),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor
                  ),
                ),
              ),
              child
            ],
          ),
        ],
      ),
    );
  }
}
