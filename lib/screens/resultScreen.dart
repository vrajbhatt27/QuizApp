import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:internship_task/screens/homeScreen.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:async';
import './pdfPreviewScreen.dart';
import './reviewAns.dart';
import '../colors.dart';

class ResultScreen extends StatelessWidget {
  final score;
  final selectedOptions;
  final questions;

  ResultScreen(this.score, this.selectedOptions, this.questions);

  final pdf = pw.Document();

  writeOnPdf() {
    int index = 0;
    int num = 1;
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
					// pw.SizedBox(height: 20),
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
            var question;
            for (var i = 0; i < 2; i++) {
              if (ques.keys.toList()[i] != 'ans') {
                question = ques.keys.toList()[i];
                break;
              }
            }
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
                          fontSize: 20,
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
                  text: "Your Answer: " + selectedOptions[index],
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
								pw.Paragraph(
                        text: (ans == selectedOptions[index++])
                            ? "Correct"
                            : "Incorrect",
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
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

  Widget disp(String text, Color clr, {double size = 16}) {
    return Text(
      text,
      style: TextStyle(
        color: clr,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }

  Widget bullet(String text, Color clr) {
    return Row(
      children: [
        Container(
          height: 8.0,
          width: 8.0,
          decoration: new BoxDecoration(
            color: clr,
            shape: BoxShape.circle,
          ),
        ),
        disp(text, clr),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              // COntent
              Column(children: [
                // Card for details.
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 240, bottom: 30),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 200,
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  bullet(' 100%', purple),
                                  disp('   Completed', lblack),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  bullet(
                                    " ${questions.length}",
                                    purple,
                                  ),
                                  disp('   Questions', lblack),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  bullet(" 0$score", green),
                                  disp('   Correct', lblack),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  bullet(" 0${questions.length - score}", red),
                                  disp('   Incorrect', lblack),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Replay quiz
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: purple,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.replay,
                                    color: white1,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomeScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              disp('Play Again', lblack),
                            ],
                          ),
                          // Review Ans
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: purple,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: white1,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ReviewAns(
                                            selectedOptions, questions),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              disp('Review Answer', lblack),
                            ],
                          ),
                          // Share Score
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: purple,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: white1,
                                  ),
                                  onPressed: () {
                                    final String sub = "";
                                    final RenderBox box =
                                        context.findRenderObject();
                                    Share.share(
                                      "Quiz Score: You have got $score/${questions.length}\n\nYou can check details at https://quizapp.com",
                                      subject: sub,
                                      sharePositionOrigin:
                                          box.localToGlobal(Offset.zero) &
                                              box.size,
                                    );
                                  },
                                ),
                              ),
                              disp('Share Score', lblack),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Generate Pdf.
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: purple,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.picture_as_pdf_outlined,
                                    color: white1,
                                  ),
                                  onPressed: () async {
                                    writeOnPdf();
                                    await savePdf();
                                    Directory documentDirectory =
                                        await getApplicationDocumentsDirectory();

                                    String documentPath =
                                        documentDirectory.path;

                                    String fullPath =
                                        "$documentPath/result.pdf";
                                    print(fullPath);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PdfPreviewScreen(
                                                  path: fullPath,
                                                )));
                                  },
                                ),
                              ),
                              disp('Generate pdf', lblack),
                            ],
                          ),

                          // Home
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: purple,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.home,
                                    color: white1,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomeScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              disp('       Home     ', lblack),
                            ],
                          ),

                          // LeaderBoards
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: purple,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.star_border,
                                    color: white1,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      barrierColor: purple,
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
                                ),
                              ),
                              disp('LeaderBoards', lblack),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),

              Positioned(
                left: 130,
                top: 60,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(
                        width: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      )),
                  child: CircleAvatar(
                    child: disp("${score * 10}", purple, size: 32),
                    backgroundColor: white1,
                    radius: 60,
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
