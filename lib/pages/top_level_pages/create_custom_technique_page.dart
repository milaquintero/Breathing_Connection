import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/asset_handler.dart';
import 'package:breathing_connection/models/current_page_handler.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
import 'package:breathing_connection/models/custom_technique_form_model.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/nav_link.dart';
import 'package:breathing_connection/models/technique.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/technique_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:breathing_connection/widgets/fancy_dropdown_form_field.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_image_selector.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_tag_selector.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCustomTechniquePage extends StatefulWidget {
  final bool isEditing;
  final Technique selectedTechnique;
  CreateCustomTechniquePage({this.isEditing = false, this.selectedTechnique});
  @override
  _CreateCustomTechniquePageState createState() => _CreateCustomTechniquePageState();
}

class _CreateCustomTechniquePageState extends State<CreateCustomTechniquePage> {
  final _formKey = GlobalKey<FormState>();
  final CustomTechniqueFormModel customTechniqueFormModel = CustomTechniqueFormModel();
  //app main data
  MainData mainData;
  //home page link from main data
  NavLink homePageLink;
  //screen height
  double screenHeight;
  //selected theme data
  AppTheme appTheme;
  //current user data
  User curUser;
  //CDN asset handler
  AssetHandler assetHandler;
  //inhale/exhale type options
  List<DropdownMenuItem<int>> inhaleExhaleTypeOptions = [];

  void initDependencies(){
    homePageLink = mainData.pages.firstWhere((link){
      return link.pageRoute == '/home';
    });
    screenHeight = MediaQuery.of(context).size.height;
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
    //current user data
    curUser = Provider.of<User>(context);
    //get CDN asset handler
    assetHandler = Provider.of<AssetHandler>(context);
    //set inhale exhale type options
    inhaleExhaleTypeOptions = mainData.inhaleExhaleTypes.map((inhaleExhaleType){
      return DropdownMenuItem<int>(
        child: Text(inhaleExhaleType.description),
        value: inhaleExhaleType.inhaleExhaleTypeID,
      );
    }).toList();
    //if editing, load data that doesn't get auto stored into model by form
    if(widget.isEditing){
      customTechniqueFormModel.assetImage = widget.selectedTechnique.assetImage;
      customTechniqueFormModel.selectedTags = widget.selectedTechnique.tags;
      customTechniqueFormModel.inhaleTypeID = widget.selectedTechnique.inhaleTypeID;
      customTechniqueFormModel.exhaleTypeID = widget.selectedTechnique.exhaleTypeID;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: MainDataService().mainData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            mainData = snapshot.data;
            initDependencies();
            return FancyFormPage(
              pageTitle: 'Custom Technique',
              headerIcon: Icons.add_circle,
              headerColor: appTheme.brandPrimaryColor,
              headerIconColor: appTheme.textPrimaryColor,
              bgColor: appTheme.bgSecondaryColor,
              decorationPrimaryColor: appTheme.decorationPrimaryColor,
              decorationSecondaryColor: appTheme.decorationSecondaryColor,
              appBarColor: appTheme.brandPrimaryColor,
              withIconHeader: true,
              appBarHeight: mainData.appBarHeight,
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
                      maxLength: 25,
                      keyboardType: TextInputType.name,
                      initialValue: widget.isEditing ? widget.selectedTechnique.title : null,
                      onSaved: (title){
                        customTechniqueFormModel.title = title;
                      },
                    ),
                    FancyTextFormField(
                        fieldLabel: 'Description',
                        fieldType: 'text',
                        maxLength: 150,
                        keyboardType: TextInputType.emailAddress,
                        initialValue: widget.isEditing ? widget.selectedTechnique.description : null,
                        onSaved: (description){
                          customTechniqueFormModel.description = description;
                        }
                    ),
                    FancyTextFormField(
                        fieldLabel: 'Minimum Session Duration in Minutes',
                        fieldType: 'number',
                        keyboardType: TextInputType.number,
                        shouldResetIfNull: true,
                        maxNum: 120,
                        minNum: 1,
                        initialValue: widget.isEditing ? widget.selectedTechnique.minSessionDurationInMinutes.toString() : null,
                        onSaved: (firstHoldDuration){
                          customTechniqueFormModel.minSessionDurationInMinutes = int.parse(firstHoldDuration);
                        }
                    ),
                    //Breathing Rhythm
                    FancyInstructionalText(
                      icon: Icons.nature,
                      iconColor: appTheme.textPrimaryColor,
                      iconBgColor: appTheme.brandAccentColor,
                      bgColor: appTheme.brandPrimaryColor,
                      title: 'Breathing Rhythm',
                      subtitle: 'Enter the Breathing Rhythm for your custom technique.',
                      textColor: appTheme.textPrimaryColor,
                      bgGradientComparisonColor: appTheme.bgAccentColor,
                    ),
                    FancyTextFormField(
                        fieldLabel: 'Inhale Duration',
                        fieldType: 'number',
                        keyboardType: TextInputType.number,
                        shouldResetIfNull: true,
                        maxNum: 9,
                        minNum: 0,
                        initialValue: widget.isEditing ? widget.selectedTechnique.inhaleDuration.toString() : null,
                        onSaved: (inhaleDuration){
                          customTechniqueFormModel.inhaleDuration = int.parse(inhaleDuration);
                        }
                    ),
                    FancyDropdownFormField(
                        title: 'Inhale Type',
                        options: inhaleExhaleTypeOptions,
                        initValue: widget.isEditing ? widget.selectedTechnique.inhaleTypeID : null,
                        onChanged: (selectedInhaleTypeID){
                          customTechniqueFormModel.inhaleTypeID = selectedInhaleTypeID;
                        }
                    ),
                    FancyTextFormField(
                        fieldLabel: 'First Hold Duration',
                        fieldType: 'number',
                        keyboardType: TextInputType.number,
                        shouldResetIfNull: true,
                        maxNum: 9,
                        minNum: 0,
                        initialValue: widget.isEditing ? widget.selectedTechnique.firstHoldDuration.toString() : null,
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
                        initialValue: widget.isEditing ? widget.selectedTechnique.exhaleDuration.toString() : null,
                        onSaved: (exhaleDuration){
                          customTechniqueFormModel.exhaleDuration = int.parse(exhaleDuration);
                        }
                    ),
                    FancyDropdownFormField(
                        title: 'Exhale Type',
                        options: inhaleExhaleTypeOptions,
                        initValue: widget.isEditing ? widget.selectedTechnique.exhaleTypeID : null,
                        onChanged: (selectedExhaleTypeID){
                          customTechniqueFormModel.exhaleTypeID = selectedExhaleTypeID;
                        }
                    ),
                    FancyTextFormField(
                        fieldLabel: 'Second Hold Duration',
                        fieldType: 'number',
                        keyboardType: TextInputType.number,
                        shouldResetIfNull: true,
                        maxNum: 9,
                        minNum: 0,
                        initialValue: widget.isEditing ? widget.selectedTechnique.secondHoldDuration.toString() : null,
                        onSaved: (secondHoldDuration){
                          customTechniqueFormModel.secondHoldDuration = int.parse(secondHoldDuration);
                        }
                    ),
                    FancyInstructionalText(
                      icon: Icons.image,
                      iconColor: appTheme.textPrimaryColor,
                      iconBgColor: appTheme.brandAccentColor,
                      bgColor: appTheme.brandPrimaryColor,
                      title: 'Technique Image',
                      subtitle: 'Select a background image.',
                      textColor: appTheme.textPrimaryColor,
                      bgGradientComparisonColor: appTheme.bgAccentColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: FancyImageSelector(
                          images: mainData.images,
                          btnColorSelected: appTheme.brandSecondaryColor,
                          btnColorUnselected: appTheme.brandPrimaryColor,
                          btnTextColorSelected: appTheme.textPrimaryColor,
                          btnTextColorUnselected: appTheme.textPrimaryColor,
                          bgGradientComparisonColor: appTheme.bgAccentColor,
                          initValue: widget.isEditing ? widget.selectedTechnique.assetImage : null,
                          assetURL: assetHandler.imageAssetURL,
                          onChange: (assetImage){
                            customTechniqueFormModel.assetImage = assetImage;
                          }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: FancyTagSelector(
                          addButtonColor: appTheme.brandPrimaryColor,
                          addButtonTextColor: appTheme.textPrimaryColor,
                          initValue: widget.isEditing ? widget.selectedTechnique.tags : [],
                          onChange: (selectedTags){
                            customTechniqueFormModel.selectedTags = selectedTags;
                          }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 48, bottom: 48),
                      child: TextButton(
                        onPressed: (){
                          //validate form
                          if(_formKey.currentState.validate() &&
                              customTechniqueFormModel.assetImage != null &&
                              customTechniqueFormModel.selectedTags != null){
                            //store valid entries into model
                            _formKey.currentState.save();
                            //custom techniques are always paid version only
                            //associatedUserID for custom techniques is id of user who created it
                            //all category assignments are allowed for custom techniques
                            Technique tempTechnique = Technique(
                                title: customTechniqueFormModel.title,
                                description: customTechniqueFormModel.description,
                                inhaleDuration: customTechniqueFormModel.inhaleDuration,
                                firstHoldDuration: customTechniqueFormModel.firstHoldDuration,
                                exhaleDuration: customTechniqueFormModel.exhaleDuration,
                                secondHoldDuration: customTechniqueFormModel.secondHoldDuration,
                                assetImage: customTechniqueFormModel.assetImage,
                                tags: customTechniqueFormModel.selectedTags,
                                associatedUserID: curUser.userId,
                                categoryDependencies: ["AM", "PM", "Emergency", "Challenge"],
                                inhaleTypeID: customTechniqueFormModel.inhaleTypeID,
                                exhaleTypeID: customTechniqueFormModel.exhaleTypeID,
                                isPaidVersionOnly: true,
                                minSessionDurationInMinutes: customTechniqueFormModel.minSessionDurationInMinutes,
                                associatedVideo: "custom"
                            );
                            //check if editing or creating
                            if(widget.isEditing){
                              tempTechnique.techniqueID = widget.selectedTechnique.techniqueID;
                              handleCustomTechnique('edit', tempTechnique, homePageLink, screenHeight, context);
                            }
                            else{
                              //add new technique to user in backend and reflect in app
                              handleCustomTechnique('create', tempTechnique, homePageLink, screenHeight, context);
                            }
                          }
                          //show alert if asset image wasn't selected
                          else{
                            String dialogBody = customTechniqueFormModel.assetImage == null ? 'Please select a Background Image.' : customTechniqueFormModel.selectedTags == null ? 'Please select at least one Tag.' : 'Please revise the form for errors.';
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context){
                                  return DialogAlert(
                                    bgColor: appTheme.bgPrimaryColor,
                                    titlePadding: EdgeInsets.only(top: 12),
                                    subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
                                    headerIcon: Icons.cancel,
                                    headerBgColor: appTheme.errorColor,
                                    buttonText: 'Back to Form',
                                    buttonColor: appTheme.brandPrimaryColor,
                                    titleText: 'Invalid Form',
                                    titleTextColor: appTheme.errorColor,
                                    subtitleText: dialogBody,
                                    cbFunction: (){},
                                  );
                                }
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            widget.isEditing ? 'Edit Technique' : 'Create Technique',
                            style: TextStyle(
                                color: appTheme.textPrimaryColor,
                                fontSize: 24
                            ),
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: appTheme.brandPrimaryColor
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          else{
            return LoadingPage();
          }
        }
    );
  }

  Future<void> handleCustomTechnique(String op, Technique selectedTechnique, NavLink homePageLink, double screenHeight, BuildContext context) async{
    if(op == 'create'){
      //add technique in technique service first which returns it with techniqueID
      Technique updatedNewTechnique =
      await TechniqueService(uid: curUser.userId).handleCustomTechnique('add', selectedTechnique);
      //add to current user techniques
      curUser.customTechniqueIDs.add(updatedNewTechnique.techniqueID);
      //persist new custom technique id list for user
      await UserService(uid: curUser.userId).handleCustomTechnique(curUser.customTechniqueIDs);
    }
    else if(op == 'edit'){
      await TechniqueService(uid: curUser.userId).handleCustomTechnique('edit', selectedTechnique);
    }
    //redirect to home page
    Provider.of<CurrentPageHandler>(context, listen: false).pageIndex = homePageLink.pageIndex;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return DialogAlert(
            bgColor: appTheme.bgPrimaryColor,
            titlePadding: EdgeInsets.only(top: 12),
            subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
            headerIcon: Icons.fact_check,
            headerBgColor: appTheme.brandPrimaryColor,
            buttonText: 'Back to Home',
            buttonColor: appTheme.brandPrimaryColor,
            titleText: mainData.customTechniqueSuccessHead,
            subtitleText: mainData.customTechniqueSuccessBody,
            subtitleTextColor: appTheme.textAccentColor,
            titleTextColor: appTheme.textAccentColor,
            cbFunction: (){
              //redirect to home page
              Navigator.of(context).pushReplacementNamed('/root');
            },
          );
        }
    );
  }
}
