import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  String _userName = "";
  String get userName => _userName;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  User? get user => FirebaseAuth.instance.currentUser;

//Using the get method to get data from the user
  getUserName() async {
    await _firebaseDatabase
        .ref()
        .child("user_info/${user!.uid}")
        .get()
        .then((value) {
      print(value.value);
      _userName = (value.value as Map)["username"].toString();
      notifyListeners();
    });
  }

  updateUserName(String username, BuildContext context) async {
    await _firebaseDatabase
        .ref()
        .child("user_info/$user!.uid")
        .update({"username": userName}).then((value) {
      _userName = userName;
      notifyListeners();
      Navigator.of(context).pop;
    });
  }
}
