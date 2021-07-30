// @dart=2.9
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/pages/addnote.dart';
import 'package:notesapp/pages/viewnote.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('notes')
      .snapshots();

  List<Color> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200],
    Colors.purple[200],
    Colors.cyan[200],
    Colors.teal[200],
    Colors.tealAccent[200],
    Colors.pink[200],
  ];

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => AddNote(),
                  ),
                )
                    .then((value) {
                  print("Calling set state!");
                  setState(() {});
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white70,
              ),
              backgroundColor: Colors.grey[700],
            ),
            appBar: AppBar(
              title: Text(
                "Notes",
                style: TextStyle(
                    fontSize: 32.0,
                    fontFamily: "lato",
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              elevation: 0.0,
              backgroundColor: Color(0xff00706),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: ref,
              // future: ref.,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Random random = new Random();
                      Color bg = myColors[random.nextInt(4)];
                      Map data = snapshot.data.docs[index].data();
                      DateTime mydateTime = data['created'].toDate();
                      String formattedTime =
                          DateFormat.yMMMd().add_jm().format(mydateTime);

                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => ViewNote(
                                data,
                                formattedTime,
                                snapshot.data.docs[index].reference,
                              ),
                            ),
                          )
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Card(
                            color: bg,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['title']}",
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: "lato",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formattedTime,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "lato",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("Loading.."),
                  );
                }
              },
            )) //Scaffold
        );
  }
}
