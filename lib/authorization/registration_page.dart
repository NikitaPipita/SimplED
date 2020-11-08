import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> _registrationFormKey;
  TextEditingController _emailController;
  TextEditingController _fistNameController;
  TextEditingController _secondNameController;
  TextEditingController _passwordController;
  TextEditingController _repeatPasswordController;

  @override
  void initState() {
    super.initState();
    _registrationFormKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _fistNameController = TextEditingController();
    _secondNameController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fistNameController.dispose();
    _secondNameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: [
                RegistrationTextForm(
                  _registrationFormKey,
                  _emailController,
                  _fistNameController,
                  _secondNameController,
                  _passwordController,
                  _repeatPasswordController,
                ),
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

  Widget singUpButton() {
    return RaisedButton(
      child: Text(
          'SING UP'
      ),
      onPressed: () {
        //TODO: implement request that create new user.
        if (_registrationFormKey.currentState.validate()) {
          //TODO: implement alert dialog if email is already used.
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
}


class RegistrationTextForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _fistNameController;
  final TextEditingController _secondNameController;
  final TextEditingController _passwordController;
  final TextEditingController _repeatPasswordController;


  RegistrationTextForm(
      this._formKey,
      this._emailController,
      this._fistNameController,
      this._secondNameController,
      this._passwordController,
      this._repeatPasswordController,);

  @override
  _RegistrationTextFormState createState() => _RegistrationTextFormState();
}

class _RegistrationTextFormState extends State<RegistrationTextForm> {
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
                return "Email enter incorrectly";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._fistNameController,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._secondNameController,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Surname',
              hintText: 'Enter your surname',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field is required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._passwordController,
            autocorrect: false,
            maxLength: 32,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field is required";
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              } else if (widget._passwordController.text !=
                  widget._repeatPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._repeatPasswordController,
            autocorrect: false,
            maxLength: 32,
            decoration: InputDecoration(
              labelText: 'Password Repeat',
              hintText: 'Enter your password one more time',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field is required";
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              } else if (widget._passwordController.text !=
                  widget._repeatPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}