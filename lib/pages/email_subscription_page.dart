import 'package:breathing_connection/models/app_theme.dart';
import 'package:breathing_connection/models/email_form_model.dart';
import 'package:breathing_connection/models/main_data.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //selected theme data
    appTheme = Provider.of<CurrentThemeHandler>(context).currentTheme;
    //app main data
    mainData = Provider.of<MainData>(context);
  }
  @override
  Widget build(BuildContext context) {
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FancyTextFormField(
              fieldLabel: 'Enter Name',
              fieldType: 'text',
              keyboardType: TextInputType.name,
              onSaved: (name){
                emailFormModel.name = name;
              },
            ),
            FancyTextFormField(
                fieldLabel: 'Enter Email',
                fieldType: 'email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (email){
                  emailFormModel.email = email;
                }
            ),
            FancyTextFormField(
                fieldLabel: 'Enter Birth Date',
                fieldType: 'date',
                keyboardType: TextInputType.datetime,
                onSaved: (birthDate){
                  emailFormModel.birthDate = birthDate;
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
                    //TODO: send request to add user to send user confirmation email
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
            )
          ],
        ),
      ),
    );
  }
}
