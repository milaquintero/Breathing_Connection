import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/email_form_model.dart';
import 'package:breathing_connection/models/email_list_entry.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/models/subscription_type.dart';
import 'package:breathing_connection/models/user.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/email_service.dart';
import 'package:breathing_connection/services/main_data_service.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/dialog_alert.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_subscription_selector.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathing_connection/models/current_theme_handler.dart';
class EmailSubscriptionPage extends StatefulWidget {
  @override
  _EmailSubscriptionPageState createState() => _EmailSubscriptionPageState();
}

class _EmailSubscriptionPageState extends State<EmailSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final EmailFormModel emailFormModel = EmailFormModel();
  //app theme data
  AppTheme appTheme;
  //app main data
  MainData mainData;
  //birth date where person is at least 13
  DateTime dateWhenThirteen;
  //track if birthday is selected
  bool isBirthdaySelected = false;
  //formatted subscription options
  List<SubscriptionType> formattedSubscriptionTypes = [];
  //current user data
  User curUser;
  //list of subscription types from main data
  List<String> emailSubscriptionTypes = [];
  //flag for handling enabling birthday selection
  bool shouldEnableBirthday = true;
  //handle setting birthday
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(emailFormModel.birthday.seconds * 1000),
      firstDate: DateTime(1920),
      lastDate: dateWhenThirteen,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: appTheme.brandPrimaryColor,
            accentColor: appTheme.brandPrimaryColor,
            dialogBackgroundColor: appTheme.bgPrimaryColor,
            colorScheme: ColorScheme.light(
              primary: appTheme.brandPrimaryColor,
              onSurface: appTheme.textAccentColor,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.accent
            ),
          ),
          child: child,
        );
      }
    );
    if (picked != null)
      setState(() {
        emailFormModel.birthday = Timestamp.fromDate(picked);
        isBirthdaySelected = true;
      });
    else{
      setState(() {
        isBirthdaySelected = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateWhenThirteen = DateTime(
      now.year - 13,
      now.month,
      now.day
    );
  }
  String formatTimestampToDisplay(Timestamp timestamp){
    DateTime tempDate = timestamp.toDate();
    return "${tempDate.month}/${tempDate.day}/${tempDate.year}";
  }
  void displayCurSubscriptionSelections() async{
    if(mainData != null && emailSubscriptionTypes.length == 0){
      //get email list entry if it exists
      EmailListEntry curEmailListEntry = await EmailService(curUser.userId).getEmailListEntry();
      setState(() {
        //get email subscription types from main data
        emailSubscriptionTypes = mainData.emailSubscriptionTypes ?? [];
        //format subscription types for checkboxes
        formattedSubscriptionTypes = emailSubscriptionTypes.map((subscriptionType){
          return SubscriptionType(
              name: subscriptionType,
              isSelected:
              curEmailListEntry.emailSubscriptionTypes != null ?
              curEmailListEntry.emailSubscriptionTypes.contains(subscriptionType) : false
          );
        }).toList();
        shouldEnableBirthday = curEmailListEntry.birthday != null ? false : true;
        //handle loading values for subscription types in form model
        emailFormModel.emailSubscriptionTypes = curEmailListEntry.emailSubscriptionTypes ?? [];
        //load birthday into form
        emailFormModel.birthday = curEmailListEntry.birthday != null ? curEmailListEntry.birthday : Timestamp.fromDate(dateWhenThirteen);
        //handle displaying date after loading
        isBirthdaySelected = curEmailListEntry.birthday != null ? true : false;
      });
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MainDataService().mainData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          mainData = snapshot.data;
          return StreamBuilder(
            stream: UserService().userWithData,
            builder: (context, userSnapshot){
              if(userSnapshot.hasData){
                curUser = userSnapshot.data;
                displayCurSubscriptionSelections();
                return FancyFormPage(
                  pageTitle: 'Email Subscription',
                  headerIcon: Icons.email,
                  headerColor: appTheme.brandPrimaryColor,
                  headerIconColor: appTheme.textPrimaryColor,
                  bgColor: appTheme.bgSecondaryColor,
                  decorationPrimaryColor: appTheme.decorationPrimaryColor,
                  decorationSecondaryColor: appTheme.decorationSecondaryColor,
                  withIconHeader: true,
                  appBarColor: appTheme.brandPrimaryColor,
                  appBarHeight: mainData.appBarHeight,
                  form: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FancyTextFormField(
                          fieldLabel: 'Username',
                          fieldType: 'text',
                          initialValue: curUser.username,
                          keyboardType: TextInputType.name,
                          onSaved: (name){
                            emailFormModel.username = name;
                          },
                          enabled: false,
                        ),
                        FancyTextFormField(
                          fieldLabel: 'Email',
                          fieldType: 'email',
                          initialValue: curUser.email,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (email){
                            emailFormModel.email = email;
                          },
                          enabled: false,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 24, bottom: 30),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1,
                                        color: shouldEnableBirthday ? Colors.black26 : Colors.black12
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  isBirthdaySelected ? formatTimestampToDisplay(emailFormModel.birthday) : 'Enter your birthday',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: shouldEnableBirthday ? Colors.grey[850] : Colors.black54
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: shouldEnableBirthday ? () => _selectDate(context) : (){},
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                child: Text(
                                  'Select Birthday',
                                  style: TextStyle(
                                      color: shouldEnableBirthday ? appTheme.textPrimaryColor : appTheme.disabledCardTextColor,
                                      fontSize: 24
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: shouldEnableBirthday ? appTheme.brandPrimaryColor : appTheme.disabledCardBgColor,
                              ),
                            ),
                          ],
                        ),
                        if(formattedSubscriptionTypes != null) Column(
                          children: [
                            FancyInstructionalText(
                              icon: Icons.alternate_email,
                              iconBgColor: appTheme.brandPrimaryColor,
                              iconColor: Colors.grey[50],
                              bgColor: Colors.grey[850],
                              textColor: Colors.grey[50],
                              margin: EdgeInsets.only(top: 88, bottom: 12),
                              bgGradientComparisonColor: Colors.blueGrey,
                              title: 'Subscriptions',
                              subtitle: "Select the topics you'd like to subscribe to.",
                            ),
                            FancySubscriptionSelector(
                              subscriptionSelections: formattedSubscriptionTypes,
                              bgColor: Colors.grey[850],
                              textColor: appTheme.textPrimaryColor,
                              bgGradientComparisonColor: Colors.blueGrey,
                              checkboxColor: appTheme.brandPrimaryColor,
                              callbackFn: (subscriptionType, isSelected){
                                if(!emailFormModel.emailSubscriptionTypes.contains(subscriptionType)
                                    && isSelected == true){
                                  emailFormModel.emailSubscriptionTypes.add(subscriptionType);
                                }
                                else if(emailFormModel.emailSubscriptionTypes.contains(subscriptionType)
                                    && isSelected != true){
                                  emailFormModel.emailSubscriptionTypes.removeWhere((selectedSubscriptionType){
                                    return selectedSubscriptionType == subscriptionType;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 38, bottom: 24),
                          child: TextButton(
                            onPressed: () async{
                              //validate form
                              if(_formKey.currentState.validate() && isBirthdaySelected){
                                //store valid entries into model
                                _formKey.currentState.save();
                                //add user to email list in firestore
                                bool isSuccessful = await EmailService(curUser.userId).addToEmailList(emailFormModel);
                                //show success message
                                if(isSuccessful){
                                  await showDialog(
                                      context: context,
                                      builder: (context){
                                        return DialogAlert(
                                          titlePadding: EdgeInsets.only(top: 12),
                                          subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
                                          buttonText: 'Back to Main',
                                          cbFunction: (){
                                            Navigator.of(context).pushReplacementNamed("/root");
                                          },
                                          titleText: mainData.emailSubSuccessHead,
                                          subtitleText: mainData.emailSubSuccessBody,
                                          headerIcon: Icons.fact_check,
                                          headerBgColor: Colors.green[600],
                                          buttonColor: appTheme.brandPrimaryColor,
                                          titleTextColor: appTheme.textAccentColor,
                                          bgColor: appTheme.bgPrimaryColor,
                                          subtitleTextColor: appTheme.textAccentColor,
                                        );
                                      }
                                  );
                                }
                              }
                              else{
                                await showDialog(
                                    context: context,
                                    builder: (context){
                                      return DialogAlert(
                                        titlePadding: EdgeInsets.only(top: 12),
                                        subtitlePadding: EdgeInsets.only(top: 16, bottom: 28, left: 24, right: 24),
                                        buttonText: 'Close',
                                        cbFunction: (){},
                                        titleText: 'Invalid Data',
                                        subtitleText: 'Please complete the form before submitting',
                                        headerIcon: Icons.cancel,
                                        headerBgColor: appTheme.errorColor,
                                        buttonColor: appTheme.errorColor,
                                        titleTextColor: appTheme.textAccentColor,
                                        bgColor: appTheme.bgPrimaryColor,
                                        subtitleTextColor: appTheme.textAccentColor,
                                      );
                                    }
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              child: Text(
                                mainData.emailPageSubmitBtnText,
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 68),
                          child: TextButton(
                            onPressed: () async{
                              Navigator.of(context).pushReplacementNamed("/root");
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              child: Text(
                                'Return to Main',
                                style: TextStyle(
                                    color: appTheme.textPrimaryColor,
                                    fontSize: 24
                                ),
                              ),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: appTheme.errorColor
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              else{
                return LoadingPage(shouldRetrieveMainData: false,);
              }
            },
          );
        }
        else{
          return LoadingPage();
        }
      },
    );
  }
}
