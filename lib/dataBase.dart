import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {
  final dbref = FirebaseDatabase.instance.reference();
  Map data;

  // Future<List<dynamic>> readData() async {
  //   DataSnapshot dataSnapshot = await dbref.;
  //   data = dataSnapshot.value;

  //   return data.values.toList();
  // }
  Future<List<dynamic>> readData() async {
    DataSnapshot dataSnapshot = await dbref.once();
    data = dataSnapshot.value;

    Map<String, dynamic> ques = {};
    List<Map> qlist = [];

    var x = data.values.toList();

    for (var i = 0; i < x.length; i++) {
      ques = {};
      var keys = x[i].keys.toList();
      var values = x[i].values.toList();

      for (var i = 0; i < 2; i++) {
        var key = keys[i];
        var value = values[i];
        ques[key] = value;
      }
      qlist.add(ques);
    }

    return qlist;
  }
}
