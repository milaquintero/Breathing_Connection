import 'package:flutter/material.dart';

class FancyTextFormField extends StatelessWidget {
  final String fieldLabel;
  final String fieldType;
  final TextInputType keyboardType;
  final Function(String) onSaved;
  FancyTextFormField({this.fieldType, this.fieldLabel, this.keyboardType, this.onSaved});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: fieldLabel,
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
          else if(fieldType == 'email' && !RegExp(r'(?:[a-z0-9!#$%&*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])').hasMatch(value)){
            return 'Invalid email format';
          }
          else if(fieldType == 'date' && !RegExp(r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$').hasMatch(value)){
            return 'Invalid date format';
          }
          return null;
        },
        keyboardType: keyboardType,
      ),
    );
  }
}
