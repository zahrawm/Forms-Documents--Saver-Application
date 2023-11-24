// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:document_saver_application/helper/snack_bar_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

class DocumentProvider extends ChangeNotifier {
  //displaying the file name
  String _selectedFileName = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  File? _file;
  String get selectedFileName => _selectedFileName;
  // creating a firebase instance
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  setSelectedFileName(String value) {
    _selectedFileName = value;
    notifyListeners();
  }

  pickDocument(BuildContext context) async {
    await FilePicker.platform
        .pickFiles(
            allowMultiple: false,
            allowedExtensions: ["pdf", "png", "jpg", "jpeg"],
            type: FileType.custom)
        .then((result) {
      if (result != null) {
        PlatformFile selectedFile = result.files.first;
        setSelectedFileName(selectedFile.name);
        _file = File(selectedFile.path!);
        // ignore: avoid_print
        print(selectedFile.name);
      } else {
        SnackBarHelper.showErrorSnackBar(context, "No files selected");
      }
    });
  }

  // sending data to our database
  bool _isFileUploading = false;
  bool get isFileUploading => _isFileUploading;
  setIsFileUpLoading(bool value) {
    _isFileUploading = value;
    notifyListeners();
  }

  resetAll() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    _selectedFileName = "";
    _file = null;
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;

  sendDocumentData({required BuildContext context}) async {
    try {
      setIsFileUpLoading(true);
      UploadTask uploadTask = _firebaseStorage
          .ref()
          .child("files/$userId")
          .child(_selectedFileName)
          .putFile(_file!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String uploadedFileUrl = await taskSnapshot.ref.getDownloadURL();
      await _firebaseDatabase.ref().child("files_info/$userId").push().set({
        "title": titleController.text,
        "note": noteController.text,
        "fileUrl": uploadedFileUrl,
        "dateAdded": DateTime.now().toString(),
        "fileName": _selectedFileName,
        "fileType": _selectedFileName.split("").last
      });
      resetAll();
      setIsFileUpLoading(false);
    } on FirebaseException catch (firebaseError) {
      SnackBarHelper.showErrorSnackBar(context, firebaseError.message!);
      setIsFileUpLoading(false);
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(context, error.toString());
      setIsFileUpLoading(false);
    }
  }

  Future<void> deleteDocument(
      String id, String fileName, BuildContext context) async {
    try {
      await _firebaseStorage.ref().child("files/$userId/$fileName").delete();
      await _firebaseDatabase
          .ref()
          .child("files_info/$userId/$id")
          .remove()
          .then((value) {
        SnackBarHelper.showSuccessSnackBar(
            context, "$fileName is successfully deleted");
      });
    } on FirebaseException catch (firebaseError) {
      SnackBarHelper.showErrorSnackBar(context, firebaseError.message!);
    } catch (error) {
      SnackBarHelper.showErrorSnackBar(context, error.toString());
    }
  }
}
