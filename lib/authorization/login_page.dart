import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:simpleed/api_interection/requests.dart';

import '../api_interection/authorized_user_info.dart';
import '../api_interection/json_web_token.dart';
import '../bottom_navigation_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<FormState> _loginFormKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  bool _singInButtonLoading = false;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
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
                singInButton(_scaffoldKey),
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

  Widget singInButton(GlobalKey<ScaffoldState> _scaffoldKey) {
    return RaisedButton(
      child: _singInButtonLoading
          ? CircularProgressIndicator()
          : Text('SING IN'),
      onPressed: () async {
        if (_loginFormKey.currentState.validate()) {
          setState(() {
            _singInButtonLoading = true;
          });
          int userId = await JsonWebToken.passwordAuthentication(
              _emailController.text, _passwordController.text);
          if (userId != null) {
            _emailController.text = '';
            _passwordController.text = '';
            AuthorizedUserInfo.userInfo = await getUserInfo(userId);
            AuthorizedUserInfo.needToUpdateInformation = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigation(),
              ),
            );
          } else {
            final snackBar = SnackBar(
              content: Text('Email or password entered incorrectly')
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
          setState(() {
            _singInButtonLoading = false;
          });
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
