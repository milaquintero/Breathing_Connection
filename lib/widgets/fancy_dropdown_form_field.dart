import 'package:flutter/material.dart';

class FancyDropdownFormField extends StatelessWidget {
  final List<DropdownMenuItem<dynamic>> options;
  final String title;
  final Function(dynamic) onChanged;
  final dynamic initValue;
  FancyDropdownFormField({this.options, this.title, this.onChanged,
  this.initValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: title,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12)
        ),
        items: options,
        onChanged: onChanged,
        value: initValue ?? null,
        validator: (value) {
          if(value == null){
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
