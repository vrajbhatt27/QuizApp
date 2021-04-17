import 'package:flutter/material.dart';
import './quizScreen.dart';
import '../dataBase.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> ques = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            ques = await DatabaseManager().readData();
            for (var i = 0; i < ques.length; i++) {
              ques[i]['colors'] = [
                Colors.black54,
                Colors.black54,
                Colors.black54,
                Colors.black54
              ];
            }
            // print(ques);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(ques),
              ),
            );
          },
          child: Text("Click"),
        ),
      ),
    );
  }
}
