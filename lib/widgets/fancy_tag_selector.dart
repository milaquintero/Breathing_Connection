import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';

import 'fancy_tag.dart';

class FancyTagSelector extends StatefulWidget {
  final Function onChange;
  final Color addButtonColor;
  final Color addButtonTextColor;
  final List<String> initValue;
  FancyTagSelector({this.onChange, this.addButtonColor, this.addButtonTextColor,
  this.initValue});
  @override
  _FancyTagSelectorState createState() => _FancyTagSelectorState();
}

class _FancyTagSelectorState extends State<FancyTagSelector> {
  List<String> selectedTags = [];
  String inputText = "";
  @override
  void initState() {
    super.initState();
    if(widget.initValue != null){
      setState(() {
        selectedTags = List.of(widget.initValue);
      });
    }
  }
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
            required: false
          ),
        ),
        TextButton(
            onPressed: (){
              if(inputText.isNotEmpty && inputText.length <= 25){
                setState(() {
                  //add tag
                  selectedTags.add(inputText);
                  //update selected tags in parent
                  widget.onChange(selectedTags);
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Add Tag',
                style: TextStyle(
                  fontSize: 24,
                  color: widget.addButtonTextColor,
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
                  //remove tag
                  selectedTags.removeWhere((tag) => tag == tagToDelete);
                  //update selected tags in parent
                  widget.onChange(selectedTags);
                });
              },
            );
          }
        ),
      ],
    );
  }
}
