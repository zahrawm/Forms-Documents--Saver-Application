import 'package:document_saver_application/helper/sized_box_helper.dart';
import 'package:document_saver_application/screen/settings_screen.dart';
import 'package:document_saver_application/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSize {
  final TextEditingController controller;
  final VoidCallback onSearch;
  const CustomHomeAppBar(
      {Key? key, required this.controller, required this.onSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        color: const Color(0xFF1e5376),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/icon_text.png",
                      width: 150,
                    ),
                    IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context)
                              .pushNamed(SettingsScreen.routeName);
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBoxHelper.sizedBox20,
                CustomTextField(
                    controller: controller,
                    hintText: ("Enter the title"),
                    prefixIconData: Icons.search,
                    labelText: ("Title"),
                    suffixIcon:
                        IconButton(onPressed: onSearch, icon: const Text("Go")),
                    validator: (value) {
                      return null;
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
