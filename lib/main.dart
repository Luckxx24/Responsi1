import 'package:flutter/material.dart';
import 'main/login_page.dart';
import 'main/register_page.dart';
import 'main/authors_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Management App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Times New Roman',
        scaffoldBackgroundColor: Colors.green[900],
        cardColor: Colors.green[800],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/authors': (context) => AuthorsPage(),
      },
    );
  }
}