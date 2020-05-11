
import 'package:epasbar/login.dart';

import 'package:epasbar/second_main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('id_user');   
  
  print(email);
  runApp(
    MaterialApp(home: email == null ? LoginScreen() : MyBottomNavigationBar()));
  
}