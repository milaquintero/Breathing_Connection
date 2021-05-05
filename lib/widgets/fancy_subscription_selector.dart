import 'package:breathing_connection/models/subscription_type.dart';
import 'package:flutter/material.dart';

class FancySubscriptionSelector extends StatefulWidget {
  final List<SubscriptionType> subscriptionSelections;
  final Function(String, bool) callbackFn;
  final Color bgColor;
  final Color textColor;
  final Color bgGradientComparisonColor;
  final Color checkboxColor;
  FancySubscriptionSelector({this.subscriptionSelections, this.callbackFn,
  this.bgColor, this.textColor, this.bgGradientComparisonColor, this.checkboxColor});
  @override
  _FancySubscriptionSelectorState createState() => _FancySubscriptionSelectorState();
}

class _FancySubscriptionSelectorState extends State<FancySubscriptionSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: Border.all(
          color: Colors.black26,
        ),
        borderRadius: BorderRadius.circular(10),
        gradient: RadialGradient(
          colors: [widget.bgGradientComparisonColor, Color.lerp(widget.bgColor, widget.bgGradientComparisonColor, 0.5), widget.bgColor],
          center: Alignment(0.6, -0.3),
          focal: Alignment(0.3, -0.1),
          focalRadius: 3.5,
        )
      ),
      margin: EdgeInsets.only(top: 20, bottom: 12, left: 0, right: 0),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 28),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.subscriptionSelections.length,
        itemBuilder: (context, index){
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  widget.subscriptionSelections[index].name,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 22
                  ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                    activeColor: widget.checkboxColor,
                    value: widget.subscriptionSelections[index].isSelected,
                    onChanged: (newVal){
                      setState(() {
                        widget.subscriptionSelections[index].isSelected = newVal;
                      });
                      widget.callbackFn(widget.subscriptionSelections[index].name, newVal);
                    }
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
