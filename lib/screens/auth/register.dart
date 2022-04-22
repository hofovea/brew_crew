import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({required this.toggleView});

  final Function toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text('Sign up to Brew Crew'),
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
                  const Text('Sign in', style: TextStyle(color: Colors.black)))
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
                  validator: (val) {
                    if (val != null) {
                      val = val.trim();
                      return val.isNotEmpty ? null : 'Please try again';
                    }
                    return 'Please try again';
                  },
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  decoration: textInputDecoration.copyWith(hintText: 'Email')
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
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _authService
                          .registerWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Invalid credentials';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Sign up',
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
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            ),
          )),
    );
  }
}
