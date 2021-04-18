import 'package:flutter/material.dart';
import './resultScreen.dart';
import '../colors.dart';

class QuizScreen extends StatefulWidget {
  final questions;

  QuizScreen(this.questions);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int seconds = 10;
  int index = 0;
  int totCorrectAns = 0;
  int totIncorrectAns = 0;
  List selectedOptions = [];
  int selOptionIndex; //temporary
  bool attempted = false;

  @override
  void initState() {
    super.initState();
    countDown();
  }

  countDown() {
    Future.doWhile(() async {
      await Future.delayed(
        Duration(seconds: 1),
      );
      if (this.mounted) {
        setState(() {
          seconds--;
        });
      }

      if (seconds == 0) {
        nextQues();
      }
      return seconds != -1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    seconds = -1;
  }

  void nextQues() {
    if (attempted == false) {
      selectedOptions.add("Not Selected");
    }
    if (index < (widget.questions.length-1)) {
      setState(() {
        index = (index + 1);
        selOptionIndex = 0;
        seconds = 10;
        attempted = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(totCorrectAns, selectedOptions, widget.questions),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var quesText; //The question text

    for (var i = 0; i < 2; i++) {
      if (widget.questions[index].keys.toList()[i] != 'ans') {
        quesText = widget.questions[index].keys.toList()[i];
        break;
      }
    }

    var options = widget.questions[index][quesText];

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 550,
                width: double.infinity,
              ),
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Column(
                children: [
                  // Question
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 140, bottom: 20),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 200,
                        width: 350,
                        child: Column(
                          children: [
                            // For correct and incorrect.
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " Correct: $totCorrectAns",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    " Incorrect: $totIncorrectAns",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Question ${index + 1}/${widget.questions.length}",
                              style: TextStyle(
                                  color: purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Text(
                                quesText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 20,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Options
                  ...(options as List).asMap().entries.map(
                    (entry) {
                      int ind = entry.key;
                      var option = entry.value;

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                        height: 45,
                        decoration: BoxDecoration(
                          color: widget.questions[index]['colors'][ind],
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: InkWell(
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: lblack),
                                ),
                              ],
                            ),
                          ),
                          onTap: selOptionIndex != -1
                              ? () {
                                  attempted = true;
                                  selOptionIndex = ind;
                                  setState(() {
                                    widget.questions[index]['colors'][ind] =
                                        Colors.blue;
                                    for (var i = 0; i < 4; i++) {
                                      if (i != selOptionIndex) {
                                        widget.questions[index]['colors'][i] =
                                            Color.fromRGBO(
                                          240,
                                          240,
                                          240,
                                          1,
                                        );
                                      }
                                    }
                                  });
                                }
                              : () {},
                        ),
                      );
                    },
                  ).toList(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: InkWell(
                          child: CircleAvatar(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white1,
                              ),
                            ),
                            radius: 30,
                            backgroundColor: purple,
                          ),
                          onTap: () {
                            selectedOptions.add(options[selOptionIndex]);
                            var ansInd = widget.questions[index]['ans'];

                            setState(() {
                              if (ansInd == selOptionIndex) {
                                widget.questions[index]['colors']
                                    [selOptionIndex] = Colors.green;
                                totCorrectAns++;
                              } else {
                                widget.questions[index]['colors']
                                    [selOptionIndex] = Colors.red;
                                widget.questions[index]['colors'][ansInd] =
                                    Colors.green;
                                totIncorrectAns++;
                              }
                            });
                            selOptionIndex = -1;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CircleAvatar(
                          child: IconButton(
                            icon: (index > (widget.questions.length - 2))
                                ? Icon(Icons.offline_pin_outlined)
                                : Icon(Icons.arrow_forward),
                            color: white1,
                            onPressed: nextQues,
                          ),
                          radius: 25,
                          backgroundColor: purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 160,
                top: 100,
                child: Container(
                  decoration: BoxDecoration(
										borderRadius: BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: Text(
                      "$seconds",
                      style: TextStyle(
                          color: purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    radius: 40,
                    backgroundColor: white1,
                  ),
                ),
              ),
              Positioned(
                left: -40,
                top: 30,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
              Positioned(
                right: -30,
                top: 100,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
              Positioned(
                left: 250,
                top: -50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
