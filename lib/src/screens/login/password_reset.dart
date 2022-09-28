// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:email_validator/email_validator.dart';

import '/core/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '''Receive an Email to 
reset your Password''',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (emailController.text.trim() == '' ||
                            EmailValidator.validate(
                                emailController.text.trim())) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text.trim(),
                            );

                            snackBar(context, 'Password Reset Email Sent');
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          } on FirebaseException catch (e) {
                            snackBar(context, e.message.toString());
                            Navigator.pop(context);
                          }
                        } else {
                          snackBar(context, 'Invalid Email');
                        }
                      },
                      icon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
