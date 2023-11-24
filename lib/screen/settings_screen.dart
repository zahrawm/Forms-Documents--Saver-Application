import 'package:document_saver_application/helper/sized_box_helper.dart';
import 'package:document_saver_application/provider/provider.dart';
import 'package:document_saver_application/provider/user_info_provider.dart';
import 'package:document_saver_application/screen/screen_background.dart';
import 'package:document_saver_application/widgets/custom_button.dart';
import 'package:document_saver_application/widgets/custom_text_field.dart';

import 'package:document_saver_application/widgets/setting_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settingsScreen";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    provider.getUserName;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ScreenBackgroundWidget(
          child: Column(
        children: [
          Consumer<UserInfoProvider>(builder: (context, model, child) {
            return SettingsCardWidget(
              title: model.userName,
              leadingIcon: Icons.person,
              trailing: IconButton(
                  onPressed: () {
                    TextEditingController controller = TextEditingController();
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        validator: (value) {
                                          return null;
                                        },
                                        prefixIconData: Icons.person,
                                        controller: controller,
                                        hintText: "Enter a new username",
                                      ),
                                      SizedBoxHelper.sizedBox20,
                                      CustomButton(
                                          onPressed: () {
                                            model.updateUserName(
                                                controller.text, context);
                                          },
                                          title: "Update username")
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.edit)),
            );
          }),
          SettingsCardWidget(
            title: provider.user!.email!,
            leadingIcon: Icons.email,
          ),
          SettingsCardWidget(
            title: "logout",
            leadingIcon: Icons.logout,
            trailing: IconButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .logOut(context);
              },
              icon: const Icon(Icons.logout),
            ),
          )
        ],
      )),
    );
  }
}
