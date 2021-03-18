import 'package:breathing_connection/styles.dart';
import 'package:breathing_connection/widgets/icon_page.dart';
import 'package:flutter/material.dart';
class EmailSubscriptionPage extends StatefulWidget {
  final BuildContext rootContext;
  EmailSubscriptionPage({this.rootContext});

  @override
  _EmailSubscriptionPageState createState() => _EmailSubscriptionPageState();
}

class _EmailSubscriptionPageState extends State<EmailSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //screen height
    double screenHeight = MediaQuery.of(context).size.height;
    DateTime birthDate;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        color: Colors.grey,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                top: screenHeight / 52,
                child: CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  radius: screenHeight / 12,
                  child: Icon(
                    Icons.email,
                    size: screenHeight / 12,
                    color: brandPrimary,
                  ),
                )
            ),
            Positioned(
                bottom: screenHeight / 20,
                child: Container(
                  width: screenHeight / 2,
                  height: screenHeight / 1.7,
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 32, right: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue[50],
                  ),
                  //form to get full name, email and birth date
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Enter Full Name',
                                  hintText: 'Full Name',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.always,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Enter Email',
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty || !RegExp(r'(?:[a-z0-9!#$%&*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.always,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Enter Birth Date',
                                  hintText: 'Birth Date',
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty || !RegExp(r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$').hasMatch(value)) {
                                    return 'Invalid date format';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.always,
                                keyboardType: TextInputType.datetime,
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: (){
                            //validate form
                            if(_formKey.currentState.validate()){
                              //TODO: sent request to add user to email list
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
                        )
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
