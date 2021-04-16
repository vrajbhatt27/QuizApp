import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:async';
import './pdfPreviewScreen.dart';
import '../data.dart';
import './reviewAns.dart';
import './quizScreen.dart';

class ResultScreen extends StatelessWidget {
  final score;
  final selectedOptions;

  ResultScreen(this.score, this.selectedOptions);

  final pdf = pw.Document();

  writeOnPdf() {
    int index = 0;
    int num = 1;
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text(
                  'Quiz Result',
                  textScaleFactor: 2,
                  style: pw.TextStyle(
                    fontSize: 25,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...questions.map((ques) {
            var question = ques.keys.toList()[0];
            var ans = ques[question][ques['ans']];

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Paragraph(
                        text: "${num++} " + question,
                        style: pw.TextStyle(
                          fontSize: 25,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Paragraph(
                        text: (ans == selectedOptions[index])
                            ? "Correct"
                            : "Incorrect",
                        style: pw.TextStyle(
                          fontSize: 25,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ]),
                pw.Paragraph(
                  text: ("Answer: " + ans),
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                pw.Paragraph(
                  text: "Your Answer: " + selectedOptions[index++],
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            );
          }).toList(),
          pw.SizedBox(height: 50),
          pw.Paragraph(
            text: "Your Score: $score/${questions.length}",
            style: pw.TextStyle(
              fontSize: 30,
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline,
            ),
          ),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/result.pdf");
    file.writeAsBytesSync(await pdf.save());
  }

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
          //
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
          //
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
                    onPressed: () {
                      final String sub = "";
                      final RenderBox box = context.findRenderObject();
                      Share.share(
                        "Quiz Score: You have got $score/${questions.length}\n\nYou can check details at https://quizapp.com",
                        subject: sub,
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size,
                      );
                    },
                    child: Text("Share Score"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Generate Pdf.
                  TextButton(
                    onPressed: () async {
                      writeOnPdf();
                      await savePdf();
                      Directory documentDirectory =
                          await getApplicationDocumentsDirectory();

                      String documentPath = documentDirectory.path;

                      String fullPath = "$documentPath/result.pdf";
                      print(fullPath);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfPreviewScreen(
                                    path: fullPath,
                                  )));
                    },
                    child: Text("Generate PDF"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(),
                        ),
                      );
                    },
                    child: Text("Home"),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        barrierColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: AlertDialog(
                              title: Text('LeaderBoards'),
                              content: Text(
                                  'Connect with your friends to see you rank...'),
                            ),
                          );
                        },
                      );
                    },
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
