import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide:
        BorderSide(width: 2, color: Colors.brown)),
    focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(width: 2, color: Colors.green)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red)));