// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import '../nutritionist/upload_plan.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/util/logo_widget.dart';
import '/src/screens/message/inbox_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  mood(dynamic value) {
    value = (value).toDouble();
    if (value == 0.0) {
      return const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      );
    }
    if (value == 0.25) {
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.red.shade300,
      );
    }
    if (value == 0.5) {
      return const Icon(
        Icons.sentiment_neutral,
        color: Colors.grey,
      );
    }
    if (value == 0.75) {
      return Icon(
        Icons.sentiment_satisfied_outlined,
        color: Colors.green.shade200,
      );
    }
    if (value == 1) {
      return const Icon(
        Icons.mood,
        color: Colors.green,
      );
    }
  }

  List body(BuildContext context) {
    return [
      Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Users Progress Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var object = snapshot.data!.docs[index];

                          print(object['progress'].runtimeType);
                          return object['progress'] != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade300,
                                            // offset: Offset(2, 2),
                                            blurRadius: 5,
                                            spreadRadius: 2),
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Name:   ${object['username']}'),
                                                  Text(
                                                      'Gender:   ${object['gender']}'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Progress',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child:
                                                          LinearPercentIndicator(
                                                        animation: true,
                                                        trailing: mood(
                                                          object['progress']
                                                              .toDouble(),
                                                        ),
                                                        lineHeight: 20.0,
                                                        animationDuration: 500,
                                                        percent:
                                                            object['progress']
                                                                .toDouble(),
                                                        center: Text(
                                                          "${snapshot.data!.docs[index]['progress'] * 100} %",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        barRadius: const Radius
                                                            .circular(15),
                                                        progressColor:
                                                            Colors.orange,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Age:   ${object['age']}'),
                                                  Text(
                                                      'Weight:   ${object['weight']}'),
                                                  Text(
                                                      'Height:   ${object['height']}'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Something Went Wrong');
                    } else {
                      return const Text('No Progress of Users');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Dashboard",
          style: const TextStyle(color: Colors.black),
        ),
        // leading: const Padding(
        //   padding: EdgeInsets.only(
        //     left: 10,
        //     bottom: 10,
        //     top: 10,
        //   ),
        //   child: Logo(
        //     width: 50,
        //     height: 50,
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text('You want to Sign-Out?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            HapticFeedback.lightImpact();

                            await FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      body: body(context)[_selectedIndex],
    );
  }

  button(String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UploadPlanScreen()));
      },
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width > 600 ? 400 : 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              // offset: Offset(2, 2),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
        ),
        height: 65,
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
