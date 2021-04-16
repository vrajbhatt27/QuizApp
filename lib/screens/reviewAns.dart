import 'package:flutter/material.dart';
import '../data.dart';

class ReviewAns extends StatelessWidget {
  final selOptions;

  ReviewAns(this.selOptions);

  Widget disp(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Answer"),
      ),
      body: Container(
        height: 500,
        child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (_, ind) {
              var listItem = questions[ind];
              var ques = listItem.keys.toList()[0];
              var ans = listItem[ques][listItem['ans']];
							return Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Card(
									color: (ans == selOptions[ind])? Colors.green:Colors.red,
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      disp(ques),
                      disp("Answer: " + ans),
											disp("Your Answer: " + selOptions[ind]),											
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
