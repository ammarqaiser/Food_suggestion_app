// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, empty_catches, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/src/screens/home/home_screen.dart';
import '../../../core/constants/constants.dart';
import '../../model/user_provider.dart';
import '../../widget/drop_down_button.dart';

class BasicInfoForm extends StatefulWidget {
  BasicInfoForm({
    required this.username,
    required this.email,
    required this.password,
  });
  final String email, username, password;
  @override
  _BasicInfoFormState createState() => _BasicInfoFormState();
}

class _BasicInfoFormState extends State<BasicInfoForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ageItems.addAll(
      List.generate(250, (index) => index.toString())
          .map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        },
      ).toList(),
    );
    weightItems.addAll(
      List.generate(150, (index) => index.toString())
          .map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        },
      ).toList(),
    );
    heightItems.addAll(
      List.generate(250, (index) => index.toString())
          .map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  void dispose() {
    model.age = 'Age';
    model.gender = 'Gender';
    model.height = 'Height';
    model.weight = 'Weight';
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    heightItems.clear();
    weightItems.clear();
    genderItems.clear();
    ageItems = [];
    weightItems = [];
    heightItems = [];
    genderItems = [
      const DropdownMenuItem<String>(
        value: 'Gender',
        child: Text(
          'Gender',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      const DropdownMenuItem<String>(
        value: 'Male',
        child: Text(
          'Male',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      const DropdownMenuItem<String>(
        value: 'Female',
        child: Text(
          'Female',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    ];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Information'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/user.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TypeAheadFormField(
                            onSuggestionSelected:
                                (DropdownMenuItem<String> suggestion) {
                              weightController.text =
                                  suggestion.value.toString();
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: weightController,
                              decoration: InputDecoration(
                                  hintText: 'Weight',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  suffix: const Text('kg'),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5)),
                                  fillColor: Colors.grey.shade100,
                                  filled: true),
                              keyboardType: TextInputType.number,
                            ),
                            itemBuilder:
                                (context, DropdownMenuItem<String> suggestion) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${suggestion.value} kg'),
                              );
                            },
                            suggestionsCallback: (pattern) async {
                              return weightItems.where((element) =>
                                  element.value.toString().contains(pattern));
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Select Weight';
                              } else if (int.parse(value!) <= 0) {
                                return 'Invalid Weight';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TypeAheadFormField(
                            onSuggestionSelected:
                                (DropdownMenuItem<String> suggestion) {
                              print(suggestion.value.toString());
                              setState(() {
                                heightController.text =
                                    suggestion.value.toString();
                              });
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: heightController,
                              decoration: InputDecoration(
                                  suffix: const Text('cm'),
                                  hintText: 'Height',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5)),
                                  fillColor: Colors.grey.shade100,
                                  filled: true),
                              keyboardType: TextInputType.number,
                            ),
                            itemBuilder:
                                (context, DropdownMenuItem<String> suggestion) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('${suggestion.value} cm'),
                              );
                            },
                            validator: (value) {
                              if (value == '') {
                                return 'Select Height';
                              } else if (int.parse(value!) <= 0) {
                                return 'Invalid Height';
                              }
                              return null;
                            },
                            suggestionsCallback: (pattern) async {
                              return heightItems.where((element) =>
                                  element.value.toString().contains(pattern));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TypeAheadFormField(
                      onSuggestionSelected:
                          (DropdownMenuItem<String> suggestion) {
                        setState(() {
                          ageController.text = suggestion.value.toString();
                        });
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: ageController,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 'Select Age';
                        } else if (int.parse(value!) <= 0) {
                          return 'Invalid Age';
                        }
                        return null;
                      },
                      itemBuilder:
                          (context, DropdownMenuItem<String> suggestion) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('${suggestion.value}'),
                        );
                      },
                      suggestionsCallback: (pattern) async {
                        return ageItems.where((element) =>
                            element.value.toString().contains(pattern));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormDropDownButton(
                    label: 'Gender',
                    items: genderItems,
                    valueController: model.gender,
                    width: MediaQuery.of(context).size.width,
                    suffix: '',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: widget.email,
                                  password: widget.password);
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(
                            {
                              'username': widget.username,
                              'password': widget.password,
                              'userId': FirebaseAuth.instance.currentUser!.uid,
                              'weight': weightController.text,
                              'height': heightController.text,
                              'age': ageController.text,
                              'gender': model.gender,
                              'customer': 'yes',
                              'progress': 0,
                            },
                          );

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(
                                index: 1,
                              ),
                            ),
                            (route) => false,
                          );
                        } on Exception {}
                      }
                    },
                    child: const SizedBox(
                      height: 40.0,
                      width: 90.0,
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
