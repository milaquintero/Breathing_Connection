import 'package:flutter/material.dart';

class FancyTextFormField extends StatefulWidget {
  final String fieldLabel;
  final String fieldType;
  final TextInputType keyboardType;
  final Function(String) onSaved;
  final bool shouldResetIfNull;
  final bool isGrouped;
  final double maxNum;
  final double minNum;
  final int maxLength;
  final Function(String) onFieldSubmitted;
  FancyTextFormField({this.fieldType, this.fieldLabel, this.keyboardType,
    this.onSaved, this.shouldResetIfNull = false, this.isGrouped = false,
    this.maxNum, this.minNum, this.maxLength, this.onFieldSubmitted});

  @override
  _FancyTextFormFieldState createState() => _FancyTextFormFieldState();
}

class _FancyTextFormFieldState extends State<FancyTextFormField> {
  TextEditingController _fancyTextFormFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: _fancyTextFormFieldController,
        onSaved: widget.onSaved,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: widget.fieldLabel,
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
          errorMaxLines: 2,
          contentPadding: widget.isGrouped ? EdgeInsets.all(8) : EdgeInsets.all(12)
        ),
        onFieldSubmitted: widget.onFieldSubmitted != null ? widget.onFieldSubmitted : (value){
          if(widget.shouldResetIfNull && (value == "" || value == null)){
            print("reseting");
            if(widget.fieldType == "number"){
              _fancyTextFormFieldController.text = "0";
            }
            else{
              _fancyTextFormFieldController.text = "";
            }
          }
        },
        validator: (value) {
          if (value.isEmpty && !widget.isGrouped) {
            return 'This field is required';
          }
          else if (value.isEmpty && widget.isGrouped) {
            return 'Required';
          }
          else if(widget.maxLength != null && value.length > widget.maxLength){
            return 'Input must be less than ${widget.maxLength} characters';
          }
          else if(widget.fieldType == 'email' && !RegExp(r'(?:[a-z0-9!#$%&*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])').hasMatch(value)){
            return 'Invalid email format';
          }
          else if(widget.fieldType == 'date' && !RegExp(r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$').hasMatch(value)){
            return 'Invalid date format';
          }
          else if(widget.fieldType == 'number' && !RegExp(r'^[0-9]+$').hasMatch(value)){
            return 'Invalid numeric input';
          }
          else if(widget.fieldType == 'number' && widget.maxNum != null && int.parse(value) > widget.maxNum){
            return 'Input must be less than or equal to ${widget.maxNum.round()}';
          }
          else if(widget.fieldType == 'number' && widget.minNum != null && int.parse(value) < widget.minNum){
            return 'Input must be greater than or equal to ${widget.minNum.round()}';
          }
          return null;
        },
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
