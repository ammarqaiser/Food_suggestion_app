import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF4F4F4F);
const kBackgroundColor = Color(0xFF333333);
const kRedColor = Color(0xFFEB5757);

const kDefaultPadding = 20.0;

snackBar(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: context.size!.width * 0.7,
              child: Text(
                message.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );

List<DropdownMenuItem<String>> ageItems = [];

List<DropdownMenuItem<String>> weightItems = [];

List<DropdownMenuItem<String>> heightItems = [];

List<DropdownMenuItem<String>> genderItems = [
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

List<DropdownMenuItem<String>> diseaseItem = [
  const DropdownMenuItem<String>(
    value: 'Diabetes I',
    child: Text(
      'Diabetes I',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
  const DropdownMenuItem<String>(
    value: 'Diabetes II',
    child: Text(
      'Diabetes II',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
  const DropdownMenuItem<String>(
    value: 'Liver',
    child: Text(
      'Liver',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
  const DropdownMenuItem<String>(
    value: 'Heart Disease',
    child: Text(
      'Heart Disease',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
  const DropdownMenuItem<String>(
    value: 'Stomach Disease',
    child: Text(
      'Stomach Disease',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  ),
];
