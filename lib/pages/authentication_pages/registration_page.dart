import 'package:breathing_connection/models/user_form_model.dart';
import 'package:breathing_connection/pages/top_level_pages/loading_page.dart';
import 'package:breathing_connection/services/user_service.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_instructional_text.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final Function switchViewFn;
  RegistrationPage({this.switchViewFn});
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  UserFormModel userFormModel = UserFormModel();
  String error = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingPage() : FancyFormPage(
      pageTitle: 'Breathing Connection',
      bgColor: Colors.blue[50],
      decorationPrimaryColor: Colors.grey[600],
      decorationSecondaryColor: Colors.blueGrey[300],
      withAppBar: false,
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 16),
              child: Image.asset(
                "assets/logo_with_name.png",
                height: 250,
              ),
            ),
            FancyTextFormField(
              fieldType: 'text',
              fieldLabel: 'Username',
              keyboardType: TextInputType.text,
              maxLength: 15,
              onSaved: (username){
                userFormModel.username = username;
              },
            ),
            FancyTextFormField(
              fieldType: 'email',
              fieldLabel: 'Email',
              keyboardType: TextInputType.text,
              onSaved: (email){
                userFormModel.email = email;
              },
            ),
            FancyTextFormField(
              fieldType: 'text',
              fieldLabel: 'Password',
              keyboardType: TextInputType.text,
              minLength: 6,
              shouldObscureText: true,
              onSaved: (password){
                userFormModel.password = password;
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 28),
              child: TextButton(
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    setState(() => isLoading = true);
                    dynamic result = await _userService.registerWithEmailAndPassword(
                        userFormModel
                    );
                    if(result == null){
                      setState(() {
                        isLoading = false;
                        error = "Please enter a valid email";
                      });
                    }
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepOrange[600],
                  padding: EdgeInsets.symmetric(horizontal: 52, vertical: 16),
                ),
              ),
            ),
            FancyInstructionalText(
              icon: Icons.account_circle,
              iconBgColor: Colors.lightBlue[900],
              iconColor: Colors.grey[50],
              bgColor: Colors.grey[850],
              textColor: Colors.grey[50],
              margin: EdgeInsets.only(top: 56, bottom: 48),
              bgGradientComparisonColor: Colors.blueGrey,
              title: 'Have an account?',
              subtitle: 'Press the Sign In button below to access your Breathing Connection account',
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 76),
              child: TextButton(
                onPressed: () async{
                  widget.switchViewFn();
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepOrange[600],
                  padding: EdgeInsets.symmetric(horizontal: 52, vertical: 16),
                ),
              ),
            ),
            error.length != 0 ? Padding(
              padding: EdgeInsets.only(top: 44),
              child: FancyInstructionalText(
                title: 'Error Registering',
                subtitle: error,
                icon: Icons.error,
                iconBgColor: Colors.grey[850],
                iconColor: Colors.grey[50],
                bgColor: Colors.red[600],
                textColor: Colors.grey[50],
                margin: EdgeInsets.only(top: 56, bottom: 48),
                bgGradientComparisonColor: Colors.blueGrey,
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }
}
