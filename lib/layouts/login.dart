import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_quiz_creator/browser.dart';
import 'package:mini_quiz_creator/main.dart';
import 'package:mini_quiz_creator/models/firebase.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    String? subscription;

    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: StatefulBuilder(builder: (context, setState) {
                    _handleSumit() async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            _loading = true;
                          });
                          await supabase.auth
                              .signInWithOtp(email: _emailController.text);
                          Navigator.pushNamed(context, '/otp',
                              arguments: _emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'A 6 digits OTP had bene sent to your email. Please enter it to login!')));
                        } finally {
                          setState(() {
                            _loading = false;
                          });
                        }
                      }
                    }

                    return Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _emailController,
                        onFieldSubmitted: (value) {
                          _handleSumit();
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: IconButton(
                            icon: _loading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Icon(Icons.send),
                            onPressed: _handleSumit,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(r'^\S+@\S+\.\S+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                ),
              ),
              StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  onPressed: () async {
                    if (subscription != null) {
                      Clipboard.setData(
                          ClipboardData(text: subscription ?? ""));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Copied to clipboard: $subscription")));
                    } else {
                      String token =
                          await promiseToFuture(requestNotification());
                      print(token);
                      setState(() {
                        subscription = token;
                      });
                    }
                  },
                  icon: Icon(
                    subscription != null
                        ? Icons.copy
                        : Icons.notifications_active,
                  ),
                );
              })
            ],
          ),
        ),
      )),
    );
  }
}
