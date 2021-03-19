import 'package:breathing_connection/models/email_form_model.dart';
import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/fancy_text_form_field.dart';
import 'package:flutter/material.dart';
class EmailSubscriptionPage extends StatefulWidget {
  final BuildContext rootContext;
  EmailSubscriptionPage({this.rootContext});

  @override
  _EmailSubscriptionPageState createState() => _EmailSubscriptionPageState();
}

class _EmailSubscriptionPageState extends State<EmailSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final EmailFormModel emailFormModel = EmailFormModel();
  @override
  Widget build(BuildContext context) {
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text(
            'Email Subscription',
            style: appBarTextStyle,
        ),
        centerTitle: true,
        backgroundColor: brandPrimary,
      ),
      body: Container(
        color: Colors.blue[50],
        padding: EdgeInsets.symmetric(horizontal: 36),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                bottom: -200,
                right: -240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: Container(
                    width: 400,
                    height: 400,
                    color: Colors.grey,
                  ),
                )
            ),
            Positioned(
                bottom: 0,
                right: -280,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: Container(
                    width: 400,
                    height: 400,
                    color: Colors.blue[200].withOpacity(0.4),
                  ),
                )
            ),
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 12),
                  child: CircleAvatar(
                    backgroundColor: brandPrimary,
                    radius: screenHeight / 12,
                    child: Icon(
                      Icons.email,
                      size: screenHeight / 12,
                      color: Colors.grey[50],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FancyTextFormField(
                        fieldLabel: 'Enter Name',
                        fieldType: 'name',
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
                        padding: EdgeInsets.only(top: 36, bottom: 28),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
