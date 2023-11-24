import 'package:flutter/material.dart';

class SettingsCardWidget extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final IconData leadingIcon;
  const SettingsCardWidget(
      {Key? key, required this.title, this.trailing, required this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 4)
          ]),
      child: ListTile(
        title: Text(title),
        trailing: trailing,
        leading: Icon(leadingIcon),
      ),
    );
  }
}
