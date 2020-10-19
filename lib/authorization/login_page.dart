import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SimplED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  ),
                ),
                LoginTextForm(_loginFormKey),
                RaisedButton(
                  child: Text(
                      'LOGIN'
                  ),
                  onPressed: () {
                    if(_loginFormKey.currentState.validate()) {

                    }
                  },
                ),
                Text('Or Sing Up Using'),
                IconButton(
                  icon: Icon(Icons.fingerprint),
                  onPressed: (){},
                ),
                RaisedButton(
                  child: Text(
                      'SING UP'
                  ),
                  onPressed: (){},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class LoginTextForm extends StatefulWidget {
  final _formKey;

  LoginTextForm(this._formKey);

  @override
  _LoginTextFormState createState() => _LoginTextFormState();
}

class _LoginTextFormState extends State<LoginTextForm> {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Exeption";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Exeption";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
