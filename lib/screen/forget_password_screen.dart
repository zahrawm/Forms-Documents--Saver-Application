import 'package:document_saver_application/helper/sized_box_helper.dart';
import 'package:document_saver_application/provider/provider.dart';
import 'package:document_saver_application/screen/screen_background.dart';
import 'package:document_saver_application/widgets/custom_button.dart';
import 'package:document_saver_application/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static String routeName = "/forgetPasswordScreen";
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackgroundWidget(
            child: ListView(
      children: [
        SizedBoxHelper.sizedBox100,
        Image.asset(
          "assets/icon_image.png",
          height: 150,
        ),
        const Text(
          "Enter your email to reset the password",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBoxHelper.sizedBox20,
        Form(
          key: _key,
          child: CustomTextField(
              controller: emailController,
              labelText: "Email",
              hintText: "Enter",
              prefixIconData: Icons.email,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Please enter a value";
                }
                return null;
              }),
        ),
        SizedBoxHelper.sizedBox20,
        Consumer<AuthProvider>(builder: (context, provider, child) {
          return provider.isLoadingForgetPassword
              ? const Center(child: CircularProgressIndicator())
              : CustomButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      //code for forget password
                      provider.forgetPassword(emailController.text, context);
                    }
                  },
                  title: "Forget Password");
        })
      ],
    )));
  }
}
