import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign in to Brew Crew'),
        actions: [
          TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              label:
                  const Text('Register', style: TextStyle(color: Colors.black)))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  validator: (val) {
                    if (val != null) {
                      val = val.trim();
                      return val.isNotEmpty ? null : 'Please try again';
                    }
                    return 'Please try again';
                  },
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  validator: (val) {
                    if (val != null) {
                      val = val.trim();
                      return val.isNotEmpty && val.length > 5
                          ? null
                          : 'Password must be at least 6 characters long';
                    }
                    return 'Please try again';
                  },
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(hintText: 'Password')
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _authService
                          .signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Invalid credentials';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(Colors.pink[400]),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
