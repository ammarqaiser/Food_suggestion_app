// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_suggestion_app/src/screens/login/login_screen.dart';
import 'package:diet_suggestion_app/src/screens/welcome/welcome_screen.dart';
import '../../../main.dart';
import '/src/screens/detail/desease_form.dart';
import '/src/screens/info/information_edit_screen.dart';
import '/src/screens/message/message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    this.index = 0,
  }) : super(key: key);
  final index;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String disease = 'Diabetes 1';
  String username = '';
  String currentDisease = '';
  var _selectedIndex = 0;
  String status = 'No Plan Generated';
  double percent = 0;

  @override
  initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getDietPlan();
    _selectedIndex = widget.index;
  }

  getName() async {
    var name = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = name.data()!['username'].toString();
      currentDisease = name.data()!['disease'].toString();
    });
  }

  var data;
  getDietPlan() async {
    getName();

    var id = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (id.data()!['dietplanId'].toString().trim() != '' &&
        id.data()!['dietplanId'] != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('diet-plan')
          .doc(id.data()!['dietplanId'])
          .get();
      if (snapshot.data() == null) {
        setState(() {
          _isLoading = false;
        });
      }
      data = snapshot.data();
    } else {
      data = null;
    }
    if (id.data()!['status'] != null) {
      status = id.data()!['status'];
      if (id.data()!['progress'] != null)
        percent = id.data()!['progress'].toDouble();
    }
    setState(() {
      _isLoading = false;
    });
  }

  List buttonNames = [
    'Diabetes I',
    'Diabetes II',
    'Liver',
    'Heart Disease',
    'Stomach Disease'
  ];
  bool _isLoading = false;
  List<String> label = ['Diet Plans', 'Disease'];
  mood(double value) {
    if (value == 0.0) {
      return const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      );
    }
    if (value <= 0.15) {
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.red.shade300,
      );
    }
    if (value <= 0.45) {
      return const Icon(
        Icons.sentiment_neutral,
        color: Colors.grey,
      );
    }
    if (value <= 0.75) {
      return const Icon(
        Icons.sentiment_satisfied_outlined,
        color: Colors.orange,
      );
    }
    if (value <= 1) {
      return const Icon(
        Icons.mood,
        color: Colors.green,
      );
    }
  }

  week(double value) {
    if (value == 0.0) {
      return 'Complete Monday';
    }
    if (value == 0.15) {
      return 'Complete Tuesday';
    }
    if (value == 0.30) {
      return 'Complete Wednesday';
    }
    if (value == 0.45) {
      return 'Complete Thursday';
    }
    if (value == 0.60) {
      return 'Complete Friday';
    }
    if (value == 0.75) {
      return 'Complete Saturday';
    }
    if (value == 0.90) {
      return 'Complete Sunday';
    }
    if (value == 1) {
      return 'Completed';
    }
  }

  body() => [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Status: $status',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : data != null
                          ? Center(
                              child: SingleChildScrollView(
                                  child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Diet Plan for ${currentDisease.contains('Disease') ? currentDisease : currentDisease + (' Disease')}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Progress',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: LinearPercentIndicator(
                                              animation: true,
                                              trailing: mood(percent),
                                              lineHeight: 20.0,
                                              animationDuration: 500,
                                              percent: percent,
                                              center: Text(
                                                "${percent * 100} %",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              barRadius:
                                                  const Radius.circular(15),
                                              progressColor: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'Pre-Breakfast',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 250,
                                          child: Text(data['prebreakfast']),
                                        )
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'Breakfast',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 250,
                                          child: Text(data['breakfast']),
                                        )
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'Snacks',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 250,
                                          child: Text(data['snacks']),
                                        )
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Lunch',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: 250,
                                            child: Text(data['lunch']))
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Dinner',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            data['dinner'].toString(),
                                            maxLines: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Bed Time',
                                            maxLines: 3,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: 250,
                                            child: Text(data['bedtime']))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              )),
                            )
                          : const Center(
                              child: Text(
                                  'Tap on Generate Button to Generate Plan'),
                            ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 160.0,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _isLoading ? Colors.grey : Colors.orange,
                        ),
                        onPressed: _isLoading ? () {} : fetchDietPlan,
                        child: Center(
                          child: Text(
                            status == 'No Plan Generated' ||
                                    status == 'Completed'
                                ? "Generate Meal Plan"
                                : week(percent),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hey $username',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Choose the disease you have...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            button(0),
            button(1),
            button(2),
            button(3),
            button(4),
          ],
        )
      ];

  fetchDietPlan() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String newstatus = 'No Plan Generated';
    if (status == 'No Plan Generated' || status == 'Completed') {
      setState(() {
        _isLoading = true;
      });

      var snapshot = await FirebaseFirestore.instance
          .collection('diet-plan')
          .where('type', isEqualTo: currentDisease)
          .get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                'You didn\'t specified any disease!',
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
          );
        return;
      }
      newstatus = 'In Progress';
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'status': newstatus,
        'progress': percent,
        'dietplanId': snapshot.docs[Random().nextInt(snapshot.docs.length)].id,
      });
    } else if (status == 'In Progress' && percent < 1) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'progress': percent == 0.90
              ? 1
              : percent == 0.30
                  ? 0.45
                  : (percent + 0.15)
        },
      );
    } else if (status == 'In Progress') {
      setState(() {
        _isLoading = true;
      });

      newstatus = 'Completed';
      setState(() {
        status = newstatus;
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'status': newstatus,
          'dietplanId': '',
          'progress': 0.0,
        },
      );
    }

    await getDietPlan();
    setState(() {
      _isLoading = false;
    });
  }

  button(int i) {
    return GestureDetector(
      onTap: () {
        if (status == 'Completed' || status == 'No Plan Generated') {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => DiseaseForm(
                diseaseName: buttonNames[i],
              ),
            ),
          )
              .then(
            (value) async {
              await getName();
              setState(() => _selectedIndex = 0);
            },
          );
        } else {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Complete the Current Diet Plan to Generate Plan for Other Diseases!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ),
            );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 2),
              blurRadius: 2,
            )
          ],
        ),
        height: 65,
        alignment: Alignment.center,
        child: Text(
          buttonNames[i],
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Disease',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: floatingButton(context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InformationEditScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
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

                        try {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DietApp(),
                              ),
                              (route) => false); // ignore: empty_catches
                        } on Exception {}
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
            ),
          )
        ],
        centerTitle: true,
        title: Text(label[_selectedIndex]),
      ),
      body: body()[_selectedIndex],
    ));
  }

  FloatingActionButton floatingButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      child: const Icon(
        Icons.chat,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Chat'),
                centerTitle: true,
              ),
              body: MessageScreen(
                user: FirebaseAuth.instance.currentUser!.uid,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
