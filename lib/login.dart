import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppj_coins_app/riverpod/login/userFSP.dart';
import 'package:ppj_coins_app/riverpod/login/userModel.dart';
import 'package:ppj_coins_app/riverpod/utilities/strings.dart';
import 'package:ppj_coins_app/riverpod/login/login_pod.dart';
import 'package:blobs/blobs.dart';

void main() {
  runApp(
    ProviderScope(
      child: const SimpleLoginApp(),
    ),
  );
}

class SimpleLoginApp extends StatelessWidget {
  const SimpleLoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: LoginScreen(),
        ),
      ),
    );
  }
}


class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String pwd = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text(
                  'I-Fleet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                    onSaved: (value) => email = value!, // Save email value
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    onSaved: (value) => pwd = value!, // Save password value
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 20),

                  Consumer(
                  builder: (context, ref, child) {
                    final runLogin = ref.watch(loginProvider);
                    return GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Change the login state to loading
                          // ref.read(loginProvider.notifier).setLoading();

                          // Call the login function
                          ref.read(loginProvider.notifier).loginUser(
                            email,
                            pwd,
                            ref.read(userDetailCtrl.notifier).getUserDetails(),
                            ref
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        color: runLogin.maybeWhen(
                          loading: () => Colors.grey, // Change color to grey when loading
                          orElse: () => Colors.blue, // Otherwise, keep it blue
                        ),
                        child: Center(
                          child: Text(
                            runLogin.maybeWhen(
                              loading: () => 'Loading...', // Change text to "Loading..." when loading
                              orElse: () => 'Sign In',
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Add your forgot password functionality here
                    },
                    child: Text(
                      'Forgot Password? Contact Your Amirul',
                      style: TextStyle(color: Colors.blue),
                    ),
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




class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Text('Welcome to the main page!'),
      ),
    );
  }
}







