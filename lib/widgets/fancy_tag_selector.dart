import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';

import 'fancy_tag.dart';

class FancyTagSelector extends StatefulWidget {
  final Function onChange;
  final Color addButtonColor;
  final Color addButtonTextColor;
  FancyTagSelector({this.onChange, this.addButtonColor, this.addButtonTextColor});
  @override
  _FancyTagSelectorState createState() => _FancyTagSelectorState();
}

class _FancyTagSelectorState extends State<FancyTagSelector> {
  List<String> selectedTags = [];
  String inputText = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: FancyTextFormField(
            keyboardType: TextInputType.name,
            fieldType: 'text',
            maxLength: 25,
            onFieldSubmitted: (String selectedTag){
              inputText = selectedTag;
            },
          ),
        ),
        TextButton(
            onPressed: (){
              if(inputText.isNotEmpty && inputText.length < 25){
                setState(() {
                  selectedTags.add(inputText);
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Add Tag',
                style: TextStyle(
                  fontSize: 24,
                  color: widget.addButtonTextColor
                ),
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: widget.addButtonColor,
            ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: selectedTags.length,
          itemBuilder: (context, index){
            return FancyTag(
              tagName: selectedTags[index],
              nameFontSize: 24,
              isDismissible: true,
              dismissCallback: (String tagToDelete){
                setState(() {
                  selectedTags.removeWhere((tag) => tag == tagToDelete);
                });
              },
            );
          }
        ),
      ],
    );
  }
}
