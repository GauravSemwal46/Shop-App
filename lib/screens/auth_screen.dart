import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/helpers/app_colors.dart';
import 'package:flutter_shop_app/helpers/constants.dart';
import 'package:flutter_shop_app/models/http_exceptions.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.purpleColor.withOpacity(0.5),
                  AppColors.orangeColor.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.deepOrangeColor.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        AppConstants.myShop,
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color,
                          fontSize: 50,
                          fontFamily: AppConstants.primaryFont,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppConstants.errorOccured),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text(AppConstants.okay),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'] ?? '', _authData['password'] ?? '');
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'] ?? '', _authData['password'] ?? '');
      }
    } on HttpExceptions catch (error) {
      var errorMessage = AppConstants.authenticationFailed;
      if (error.toString().contains(AppConstants.emailExist)) {
        errorMessage = AppConstants.emailExistMessage;
      } else if (error.toString().contains(AppConstants.invalidEmail)) {
        errorMessage = AppConstants.invalidEmailMessage;
      } else if (error.toString().contains(AppConstants.weakPassword)) {
        errorMessage = AppConstants.weakPasswordMessage;
      } else if (error.toString().contains(AppConstants.emailNotFound)) {
        errorMessage = AppConstants.emailNotFoundMessage;
      } else if (error.toString().contains(AppConstants.invalidPassword)) {
        errorMessage = AppConstants.invalidPasswordMessage;
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = AppConstants.authErrorMessage;
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: AppConstants.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return AppConstants.invalidEmailMessage;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value ?? '';
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: AppConstants.password),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return AppConstants.shortPasswordMessage;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value ?? '';
                  },
                ),
                if (_authMode == AuthMode.signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.signup,
                    decoration: const InputDecoration(
                        labelText: AppConstants.confirmPassword),
                    obscureText: true,
                    validator: _authMode == AuthMode.signup
                        ? (value) => value != _passwordController.text
                            ? AppConstants.passwordNotMatch
                            : null
                        : null,
                  ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      _authMode == AuthMode.login
                          ? AppConstants.login
                          : AppConstants.signUp,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                      '${_authMode == AuthMode.login ? AppConstants.signUp : AppConstants.login} ${AppConstants.instead}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
