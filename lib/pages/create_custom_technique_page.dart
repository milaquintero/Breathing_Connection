import 'package:breathing_connection/models/custom_technique_form_model.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class CreateCustomTechniquePage extends StatefulWidget {
  @override
  _CreateCustomTechniquePageState createState() => _CreateCustomTechniquePageState();
}

class _CreateCustomTechniquePageState extends State<CreateCustomTechniquePage> {
  final _formKey = GlobalKey<FormState>();
  final CustomTechniqueFormModel customTechniqueFormModel = CustomTechniqueFormModel();
  final bool isBreathingRythmValid = false;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double rowFieldWidth = screenWidth / 5.5;
    return FancyFormPage(
      pageTitle: 'Custom Technique',
      headerIcon: Icons.add_to_photos,
      headerColor: brandPrimary,
      headerIconColor: Colors.grey[50],
      form: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FancyTextFormField(
              fieldLabel: 'Title',
              fieldType: 'text',
              keyboardType: TextInputType.name,
              onSaved: (title){
                customTechniqueFormModel.title = title;
              },
            ),
            FancyTextFormField(
                fieldLabel: 'Description',
                fieldType: 'text',
                keyboardType: TextInputType.emailAddress,
                onSaved: (description){
                  customTechniqueFormModel.description = description;
                }
            ),
            //Breathing Rhythm
            Container(
              margin: EdgeInsets.only(top: 45),
              padding: EdgeInsets.only(top: 24, bottom: 36, left: 28, right: 28),
              decoration: BoxDecoration(
                  color: brandPrimary,
                  border: Border.all(
                      color: Colors.grey[700]
                  ),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    radius: 46,
                    child: Icon(
                      Icons.nature,
                      color: brandPrimary,
                      size: 46,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'Breathing Rhythm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Enter the Breathing Rhythm for your custom technique. In order, a Breathing Rhythm is the inhale duration, first hold duration, exhale duration, and second hold duration. Each duration must be a valid whole number between 0 and 9.',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: rowFieldWidth,
                  child: FancyTextFormField(
                      fieldType: 'number',
                      keyboardType: TextInputType.number,
                      shouldResetIfNull: true,
                      isGrouped: true,
                      onSaved: (inhaleDuration){
                        customTechniqueFormModel.inhaleDuration = int.parse(inhaleDuration);
                      }
                  ),
                ),
                Container(
                  width: rowFieldWidth,
                  child: FancyTextFormField(
                      fieldType: 'number',
                      keyboardType: TextInputType.number,
                      shouldResetIfNull: true,
                      isGrouped: true,
                      onSaved: (firstHoldDuration){
                        customTechniqueFormModel.firstHoldDuration = int.parse(firstHoldDuration);
                      }
                  ),
                ),
                Container(
                  width: rowFieldWidth,
                  child: FancyTextFormField(
                      fieldType: 'number',
                      keyboardType: TextInputType.number,
                      shouldResetIfNull: true,
                      isGrouped: true,
                      onSaved: (exhaleDuration){
                        customTechniqueFormModel.exhaleDuration = int.parse(exhaleDuration);
                      }
                  ),
                ),
                Container(
                  width: rowFieldWidth,
                  child: FancyTextFormField(
                      fieldType: 'number',
                      keyboardType: TextInputType.number,
                      shouldResetIfNull: true,
                      isGrouped: true,
                      onSaved: (secondHoldDuration){
                        customTechniqueFormModel.secondHoldDuration = int.parse(secondHoldDuration);
                      }
                  ),
                )
              ],
            ),
            FancyTextFormField(
                fieldLabel: 'Image',
                fieldType: 'image',
                keyboardType: TextInputType.number,
                onSaved: (assetImage){
                  customTechniqueFormModel.assetImage = assetImage;
                }
            ),
            Padding(
              padding: EdgeInsets.only(top: 42, bottom: 28),
              child: TextButton(
                onPressed: (){
                  //validate form
                  if(_formKey.currentState.validate()){
                    //store valid entries into model
                    _formKey.currentState.save();
                    //TODO: send request to add user to email list
                    //isPaidVersionOnly=true
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Text(
                    'Create Technique',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: brandPrimary
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
