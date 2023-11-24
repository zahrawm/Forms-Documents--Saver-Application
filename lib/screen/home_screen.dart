import 'dart:async';

import 'package:document_saver_application/model/file_card_model.dart';
import 'package:document_saver_application/screen/add_document_screen.dart';
import 'package:document_saver_application/screen/screen_background.dart';
import 'package:document_saver_application/widgets/custom_app_bar.dart';
import 'package:document_saver_application/widgets/custom_floating_button.dart';
import 'package:document_saver_application/widgets/file_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  StreamController<DatabaseEvent> streamController = StreamController();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  setStream() {
    FirebaseDatabase.instance
        .ref()
        .child("files_info/$userId")
        .orderByChild("title")
        .startAt(searchController.text)
        .endAt("${searchController.text}" "\uf8ff")
        .onValue
        .listen((event) {
      streamController.add(event);
    });
  }

  @override
  void initState() {
    setStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: CustomFloatingActionButton(
            title: "Add",
            iconData: Icons.add,
            onTap: () {
              Navigator.pushNamed(context, AddDocumentScreen.routeName);
            }),
        appBar: CustomHomeAppBar(
          controller: searchController,
          onSearch: (() {
            setStream();
          }),
        ),
        body: ScreenBackgroundWidget(
            //using Streambuilder
            child: StreamBuilder<DatabaseEvent>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    List<FileCardModel> _list = [];
                    print(snapshot.data!.snapshot.value);
                    (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
                        .forEach((key, value) {
                      print(key);
                      print(value);
                      _list.add(FileCardModel.fromJson(value, key));
                    });
                    return ListView(
                      children: _list
                          .map((e) => FileCard(
                                model: FileCardModel(
                                    id: e.id,
                                    title: e.title,
                                    subTitle: e.subTitle,
                                    dateAdded: e.dateAdded,
                                    fileType: e.fileType,
                                    fileName: e.fileName,
                                    fileUrl: e.fileUrl),
                              ))
                          .toList(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon_no_file.png",
                          height: 100,
                        ),
                        const Text("No data"),
                      ],
                    );
                  }
                })),
      ),
    );
  }
}
