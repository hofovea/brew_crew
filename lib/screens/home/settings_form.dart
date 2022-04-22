import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({Key? key}) : super(key: key);

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName = '';
  String _currentSugars = '0';
  int _currentStrength = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    return StreamBuilder<CustomUserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CustomUserData customUserData = snapshot.data!;
            return Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Update your brew settings',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration,
                      validator: (val) {
                        if (val != null) {
                          return val.isEmpty ? 'Please enter a name' : null;
                        }
                        return 'Enter your name';
                      },
                      initialValue: customUserData.name,
                      onChanged: (val) => setState(() {
                        _currentName = val;
                      }),
                    ),
                    const SizedBox(height: 20.0),
                    //dropdown
                    DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: customUserData.sugars,
                      items: sugars
                          .map((sugar) => DropdownMenuItem(
                                child: Text('$sugar sugars'),
                                value: sugar,
                              ))
                          .toList(),
                      onChanged: (String? val) => setState(() {
                        if (val != null) {
                          _currentSugars = val;
                        } else {
                          _currentSugars = customUserData.sugars!;
                        }
                      }),
                    ),
                    //slider
                    Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value: _currentStrength != 0
                          ? _currentStrength.toDouble()
                          : customUserData.strength!.toDouble(),
                      onChanged: (val) => setState(() {
                        _currentStrength = val.round();
                      }),
                      activeColor: Colors.brown[_currentStrength != 0
                          ? _currentStrength
                          : customUserData.strength!],
                      inactiveColor: Colors.brown[50],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user!.uid).updateUserData(
                              _currentSugars == '0'
                                  ? customUserData.sugars!
                                  : _currentSugars,
                              _currentName == ''
                                  ? customUserData.name!
                                  : _currentName,
                              _currentStrength == 0
                                  ? customUserData.strength!
                                  : _currentStrength);
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[400])),
                      child: const Text('Save changes'),
                    )
                  ],
                ));
          } else {
            return const Loading();
          }
        });
  }
}
