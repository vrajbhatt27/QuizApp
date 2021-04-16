import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [
    {
      "Which is ur fav language?": ['python', 'Java', 'Dart', 'JS'],
      'ans': 0,
      'colors': [
        Colors.black54,
        Colors.black54,
        Colors.black54,
        Colors.black54
      ],
    },
    {
      "Which is ur fav Color?": ['Blue', 'White', 'Yellow', 'Block'],
      'ans': 0,
      'colors': [
        Colors.black54,
        Colors.black54,
        Colors.black54,
        Colors.black54
      ],
    },
    {
      "Which is ur fav country?": ['India', 'America', 'Canada', 'London'],
      'ans': 0,
      'colors': [
        Colors.black54,
        Colors.black54,
        Colors.black54,
        Colors.black54
      ],
    },
  ];

  int seconds = 7;
  int index = 0;
  int totCorrectAns = 0;
  int totIncorrectAns = 0;
  List selectedOptions = [];
  int selOptionIndex; //temporary

  @override
  void initState() {
    super.initState();
    // countDown();
  }

  countDown() {
    Future.doWhile(() async {
      //this changes the value by -1 every second until it reaches zero
      await Future.delayed(
        Duration(seconds: 1),
      );
      setState(() {
        //add text widget in your build method which takes t as the data
        seconds--;
      });
      if (seconds == 0) {
        setState(() {
          setState(() {
            index = (index + 1) % 3;
            selOptionIndex = 0;
            seconds = 7;
            totIncorrectAns++;
          });
        });
      }
      return seconds != -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var quesText = questions[index].keys.toList()[0]; //The question text
    var options = questions[index][quesText];

    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Column(
          children: [
            //For  Question
            Container(
              height: 100,
              width: double.infinity,
              child: Card(
                color: Colors.blue,
                elevation: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " Correct: $totCorrectAns",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text("$seconds"),
                        Text(
                          " Incorrect: $totIncorrectAns",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Question ${index + 1}/3"),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        quesText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //For Option
            Container(
              height: 250,
              child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, ind) {
                    return Card(
                      color: questions[index]['colors'][ind],
                      elevation: 5,
                      child: ListTile(
                        title: Text(options[ind]),
                        onTap: selOptionIndex != -1
                            ? () {
                                selOptionIndex = ind;
                                setState(() {
                                  questions[index]['colors'][ind] = Colors.blue;
                                  for (var i = 0; i < 4; i++) {
                                    if (i != selOptionIndex) {
                                      questions[index]['colors'][i] =
                                          Colors.black54;
                                    }
                                  }
                                });
                              }
                            : () {},
                      ),
                    );
                  }),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: ElevatedButton(
                    onPressed: () {
                      selectedOptions.add(options[selOptionIndex]);
                      var ansInd = questions[index]['ans'];

                      setState(() {
                        if (ansInd == selOptionIndex) {
                          questions[index]['colors'][selOptionIndex] =
                              Colors.green;
                          totCorrectAns++;
                        } else {
                          questions[index]['colors'][selOptionIndex] =
                              Colors.red;
                          questions[index]['colors'][ansInd] = Colors.green;
                          totIncorrectAns++;
                        }
                      });
                      selOptionIndex = -1;
                    },
                    child: Text('Submit'),
                  ),
                ),

                // Next Question
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index = (index + 1) % 3;
                        selOptionIndex = 0;
                        seconds = 7;
                      });
                    },
                    child: Text('Next'),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
