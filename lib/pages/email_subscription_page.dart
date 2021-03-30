import 'package:breathing_connection/models/email_form_model.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/fancy_form_page.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';
class EmailSubscriptionPage extends StatefulWidget {
  @override
  _EmailSubscriptionPageState createState() => _EmailSubscriptionPageState();
}

class _EmailSubscriptionPageState extends State<EmailSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final EmailFormModel emailFormModel = EmailFormModel();
  @override
  Widget build(BuildContext context) {
    return FancyFormPage(
      pageTitle: 'Email Subscription',
      headerIcon: Icons.email,
      headerColor: brandPrimary,
      headerIconColor: Colors.grey[50],
      bgColor: Colors.teal[50],
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
                    //TODO: send request to add user to email list
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Text(
                    'Sign Up',
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
