import 'package:flutter/material.dart';
import 'screens/Home.dart';

void main() => runApp(PhonebookApp());

class PhonebookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Phonebook',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
