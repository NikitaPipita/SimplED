import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginFormKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36.0),
            child: Column(
              children: [
                Text(
                  'SimplED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                LoginTextForm(
                  _loginFormKey,
                  _emailController,
                  _passwordController,
                ),
                SizedBox(
                  height: 16.0,
                ),
                singInButton(),
                SizedBox(
                  height: 16.0,
                ),
                singUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget singInButton() {
    return RaisedButton(
      child: Text(
          'SING IN'
      ),
      onPressed: () {
        //TODO: implement request that checks info at the server.
        if (_loginFormKey.currentState.validate()) {
          _emailController.text = '';
          _passwordController.text = '';
          //TODO: implement alert dialog if email or password are incorrect.
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigation(),
            ),
          );
        }
      },
    );
  }

  Widget singUpButton() {
    return RaisedButton(
      child: Text(
          'SING UP'
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationPage(),
          ),
        );
      },
    );
  }
}


class LoginTextForm extends StatefulWidget {
  final _formKey;
  final _emailController;
  final _passwordController;

  LoginTextForm(
      this._formKey,
      this._emailController,
      this._passwordController);

  @override
  _LoginTextFormState createState() => _LoginTextFormState();
}

class _LoginTextFormState extends State<LoginTextForm> {

  bool _isPasswordHide = true;

  void changePasswordHideState() {
    setState(() {
      _isPasswordHide = !_isPasswordHide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget._emailController,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
            validator: (value) {
              if (!EmailValidator.validate(value)) {
                return "Email entered incorrectly";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._passwordController,
            autocorrect: false,
            obscureText: _isPasswordHide,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: _isPasswordHide
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: changePasswordHideState,
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field is required";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
