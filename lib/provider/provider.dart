import 'package:document_saver_application/helper/snack_bar_helper.dart';
import 'package:document_saver_application/screen/authentication_screen.dart';
import 'package:document_saver_application/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLogin = true;
  bool get isLogin => _isLogin;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  setIsLogin() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  setobscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  signUp(BuildContext context,
      {required String email,
      required String password,
      required String username}) async {
    try {
      setIsLoading(true);
      // ignore: unused_local_variable
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await _firebaseDatabase
            .ref()
            .child("user_info/${value.user!.uid}")
            .set({"username": username});
        SnackBarHelper.showSuccessSnackBar(context, "Sign Up is successful");
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return value;
      });
      setIsLoading(false);
    } on FirebaseAuthException catch (error) {
      setIsLoading(false);
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      setIsLoading(true);
      // ignore: unused_local_variable
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SnackBarHelper.showSuccessSnackBar(context, "Sign in is successful");
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return value;
      });
      setIsLoading(false);
    } on FirebaseAuthException catch (firebaseError) {
      setIsLoading(false);
      SnackBarHelper.showErrorSnackBar(
          context, firebaseError.message.toString());
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(context, error.toString());
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
  }

  bool _isLoadingForgetPassword = false;
  bool get isLoadingForgetPassword => _isLoadingForgetPassword;
  setIsLoadingForgetPassword(bool value) {
    _isLoadingForgetPassword = value;
    notifyListeners();
  }

  forgetPassword(String email, BuildContext context) async {
    try {
      setIsLoadingForgetPassword(true);
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        setIsLoadingForgetPassword(false);
        SnackBarHelper.showSuccessSnackBar(
            context, "Reset password link has been successfully sent");
      });
    } on FirebaseAuthException catch (firebaseError) {
      setIsLoading(false);
      SnackBarHelper.showErrorSnackBar(
          context, firebaseError.message.toString());
    } catch (error) {
      setIsLoadingForgetPassword(false);
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
  }

  bool _isLoadingLogout = false;
  bool get isLoadingLogout => _isLoadingLogout;
  setIsLoadingLogout(bool value) {
    _isLoadingLogout = value;
    notifyListeners();
  }

  logOut(BuildContext context) async {
    try {
      setIsLoadingLogout(true);
      await _firebaseAuth.signOut().then((value) {
        SnackBarHelper.showSuccessSnackBar(context, "Logout Successful");
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, AuthenticationScreen.routeName);
      });
      setIsLoadingLogout(false);
    } on FirebaseAuthException catch (firebaseError) {
      setIsLoadingLogout(false);
      SnackBarHelper.showErrorSnackBar(
          context, firebaseError.message.toString());
    } catch (error) {
      setIsLoadingLogout(false);
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
  }
}
