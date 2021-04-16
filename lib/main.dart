import 'package:flutter/material.dart';
import './screens/quizScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: QuizScreen(),
			debugShowCheckedModeBanner: false,
    );
  }
}