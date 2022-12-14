import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/constants/constants.dart';
import '../../model/user_provider.dart';
import '../../widget/drop_down_button.dart';
import '../../widget/text_form_field.dart';

class InformationEditScreen extends StatefulWidget {
  const InformationEditScreen({Key? key}) : super(key: key);

  @override
  State<InformationEditScreen> createState() => _InformationEditScreenState();
}

class _InformationEditScreenState extends State<InformationEditScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();

    firebaseData();
  }

  firebaseData() async {
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
    await Future.delayed(Duration.zero);
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    ageController.text = snapshot.data()!['age'];
    model.gender = snapshot.data()!['gender'];
    heightController.text = snapshot.data()!['height'];
    weightController.text = snapshot.data()!['weight'];
    nameController.text = snapshot.data()!['username'];
    setState(() {});
  }

  @override
  void dispose() {
    model.age = 'Age';
    model.gender = 'Gender';
    model.height = 'Height';
    model.weight = 'Weight';
    nameController.dispose();
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
        title: const Text('Account Screen'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              MyTextFormField(
                hintText: 'Name',
                controller: nameController,
                onSaved: () {},
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
                            weightController.text = suggestion.value.toString();
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
                          validator: (value) {
                            if (value == '') {
                              return 'Select Weight';
                            } else if (int.parse(value!) <= 0) {
                              return 'Invalid Weight';
                            }
                            return null;
                          },
                          suggestionsCallback: (pattern) async {
                            return weightItems.where((element) =>
                                element.value.toString().contains(pattern));
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
                          validator: (value) {
                            if (value == '') {
                              return 'Select Height';
                            } else if (int.parse(value!) <= 0) {
                              return 'Invalid Height';
                            }
                            return null;
                          },
                          itemBuilder:
                              (context, DropdownMenuItem<String> suggestion) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('${suggestion.value} cm'),
                            );
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
                    validator: (value) {
                      if (value == '') {
                        return 'Select Age';
                      } else if (int.parse(value!) <= 0) {
                        return 'Invalid Age';
                      }
                      return null;
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
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'username': nameController.text,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'weight': weightController.text,
                          'height': heightController.text,
                          'age': ageController.text,
                          'gender': model.gender,
                          'customer': 'yes',
                        });
                      } on FirebaseException catch (e) {
                        snackBar(context, e.message.toString());
                      }
                    }
                  },
                  child: const SizedBox(
                    width: 50.0,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
