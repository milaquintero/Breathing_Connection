import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/custom_technique_form_model.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_image_selector.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class CreateCustomTechniquePage extends StatefulWidget {
  @override
  _CreateCustomTechniquePageState createState() => _CreateCustomTechniquePageState();
}

class _CreateCustomTechniquePageState extends State<CreateCustomTechniquePage> {
  final _formKey = GlobalKey<FormState>();
  final CustomTechniqueFormModel customTechniqueFormModel = CustomTechniqueFormModel();

  Future<void> addCustomTechnique(Technique newTechnique, NavLink homePageLink) async{
    //add technique in service first which returns it with techniqueID
    Technique updatedNewTechnique = await UserService.handleCustomTechnique('add', newTechnique);
    //add technique to user
    Provider.of<User>(context, listen: false).handleCustomTechnique('add', updatedNewTechnique);
    //redirect to home page
    Provider.of<CurrentPageHandler>(context, listen: false).pageIndex = homePageLink.pageIndex;
    Navigator.of(context).pushReplacementNamed('/root');
  }

  @override
  Widget build(BuildContext context) {
    MainData mainData = Provider.of<MainData>(context);
    NavLink homePageLink = mainData.pages.firstWhere((link){
      return link.pageRoute == '/home';
    });
    return FancyFormPage(
      pageTitle: 'Custom Technique',
      headerIcon: Icons.web_rounded,
      headerColor: Colors.grey[850],
      headerIconColor: Colors.grey[200],
      bgColor: Colors.teal[50],
      form: Form(
        key: _formKey,
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
            FancyInstructionalText(
              icon: Icons.nature,
              iconColor: Colors.grey[50],
              iconBgColor: Colors.grey[850],
              bgColor: brandPrimary,
              title: 'Breathing Rhythm',
              subtitle: 'Enter the Breathing Rhythm for your custom technique.',
              textColor: Colors.white,
            ),
            FancyTextFormField(
                fieldLabel: 'Inhale Duration',
                fieldType: 'number',
                keyboardType: TextInputType.number,
                shouldResetIfNull: true,
                maxNum: 9,
                minNum: 0,
                onSaved: (inhaleDuration){
                  customTechniqueFormModel.inhaleDuration = int.parse(inhaleDuration);
                }
            ),
            FancyTextFormField(
                fieldLabel: 'First Hold Duration',
                fieldType: 'number',
                keyboardType: TextInputType.number,
                shouldResetIfNull: true,
                maxNum: 9,
                minNum: 0,
                onSaved: (firstHoldDuration){
                  customTechniqueFormModel.firstHoldDuration = int.parse(firstHoldDuration);
                }
            ),
            FancyTextFormField(
                fieldLabel: 'Exhale Duration',
                fieldType: 'number',
                keyboardType: TextInputType.number,
                shouldResetIfNull: true,
                maxNum: 9,
                minNum: 0,
                onSaved: (exhaleDuration){
                  customTechniqueFormModel.exhaleDuration = int.parse(exhaleDuration);
                }
            ),
            FancyTextFormField(
                fieldLabel: 'Second Hold Duration',
                fieldType: 'number',
                keyboardType: TextInputType.number,
                shouldResetIfNull: true,
                maxNum: 9,
                minNum: 0,
                onSaved: (secondHoldDuration){
                  customTechniqueFormModel.secondHoldDuration = int.parse(secondHoldDuration);
                }
            ),
            FancyInstructionalText(
              icon: Icons.image,
              iconColor: Colors.grey[50],
              iconBgColor: Colors.grey[850],
              bgColor: brandPrimary,
              title: 'Technique Image',
              subtitle: 'Select a background image.',
              textColor: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: FancyImageSelector(
                  images: mainData.images,
                  onChange: (assetImage){
                    customTechniqueFormModel.assetImage = assetImage;
                  }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 48),
              child: TextButton(
                onPressed: (){
                  //validate form
                  if(_formKey.currentState.validate()){
                    //store valid entries into model
                    _formKey.currentState.save();
                    //custom techniques are always paid version only
                    Technique newTechnique = Technique(
                      title: customTechniqueFormModel.title,
                      description: customTechniqueFormModel.description,
                      inhaleDuration: customTechniqueFormModel.inhaleDuration,
                      firstHoldDuration: customTechniqueFormModel.firstHoldDuration,
                      exhaleDuration: customTechniqueFormModel.exhaleDuration,
                      secondHoldDuration: customTechniqueFormModel.secondHoldDuration,
                      assetImage: customTechniqueFormModel.assetImage,
                      isPaidVersionOnly: true
                    );
                    //add new technique to user in backend and reflect in app
                    addCustomTechnique(newTechnique, homePageLink);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Create Technique',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrange
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
