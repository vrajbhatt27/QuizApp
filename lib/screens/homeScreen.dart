import 'package:flutter/material.dart';
import '../colors.dart';
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
        title: Text(
          'Quiz',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: purple,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 100,
                color: purple,
              ),
              onTap: () async {
                ques = await DatabaseManager().readData();
                for (var i = 0; i < ques.length; i++) {
                  ques[i]['colors'] = [
                    Color.fromRGBO(240, 240, 240, 1),
                    Color.fromRGBO(240, 240, 240, 1),
                    Color.fromRGBO(240, 240, 240, 1),
                    Color.fromRGBO(240, 240, 240, 1),
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
            ),
            Text(
              'Start',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
