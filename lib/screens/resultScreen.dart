import 'package:flutter/material.dart';
import 'package:internship_task/screens/reviewAns.dart';
import './quizScreen.dart';

class ResultScreen extends StatelessWidget {
  final score;
  final selectedOptions;

  ResultScreen(this.score, this.selectedOptions);

  Widget disp(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.purple,
      ),
    );
  }

  Widget bullet() {
    return Container(
      height: 5.0,
      width: 5.0,
      decoration: new BoxDecoration(
        color: Colors.purple,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Column(
        children: [
          // Score in circleAvatar
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: CircleAvatar(
                radius: 50,
                child: Text("30"),
              ),
            ),
          ),

          Container(
            height: 200,
            padding: EdgeInsets.all(10),
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: disp("100%"),
                          subtitle: disp("Completed"),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: disp("3"),
                          subtitle: disp("Questions"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: disp("$score"),
                          subtitle: disp("Correct"),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: disp("${3 - score}"),
                          subtitle: disp("Incorrect"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(),
                        ),
                      );
                    },
                    child: Text("Play Again"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewAns(selectedOptions),
                        ),
                      );
                    },
                    child: Text("Review Answer"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Share Score"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text("Generate PDF"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Home"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("LeaderBoards"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
