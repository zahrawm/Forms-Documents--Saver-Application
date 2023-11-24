import 'package:document_saver_application/helper/sized_box_helper.dart';
import 'package:document_saver_application/model/file_card_model.dart';
import 'package:document_saver_application/provider/document_provider.dart';
import 'package:document_saver_application/screen/document_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileCard extends StatelessWidget {
  final FileCardModel model;
  const FileCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 4)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              model.fileType == "pdf"
                  ? Image.asset(
                      "assets/icon_pdf_type.png",
                      width: 50,
                    )
                  : Image.asset(
                      "assets/icon_image_type.png",
                      width: 50,
                    ),
              SizedBoxHelper.sizedBox_5,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      model.subTitle,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(" Date added: ${model.dateAdded.substring(0, 10)}",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.red,
                            title: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(model.title),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel",
                                      style: TextStyle(color: Colors.white))),
                              TextButton(
                                  onPressed: () {
                                    Provider.of<DocumentProvider>(context,
                                            listen: false)
                                        .deleteDocument(
                                            model.id, model.fileName, context)
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text("OK",
                                      style: TextStyle(color: Colors.white))),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(DocumentViewScreen.routeName,
                    arguments: DocumentViewScreenArgs(
                        fileUrl: model.fileUrl,
                        fileName: model.fileName,
                        fileType: model.fileType));
              },
              child: Text("View",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.blue)))
        ],
      ),
    );
  }
}
