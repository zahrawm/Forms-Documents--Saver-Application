import 'package:document_saver_application/helper/sized_box_helper.dart';
import 'package:document_saver_application/provider/provider.dart';
import 'package:document_saver_application/screen/forget_password_screen.dart';
import 'package:document_saver_application/screen/screen_background.dart';
import 'package:document_saver_application/widgets/custom_button.dart';
import 'package:document_saver_application/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatefulWidget {
  static String routeName = "/authenticationScreen";
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController usernameController =
      TextEditingController(text: "Fatimah Adam");
  TextEditingController emailController =
      TextEditingController(text: "adamfatima2557@gmail.com");
  TextEditingController passwordController =
      TextEditingController(text: "jan2001*");
  TextEditingController confirmedPasswordController =
      TextEditingController(text: "jan2001*");
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return Scaffold(
        body: ScreenBackgroundWidget(
          child: Form(
            key: _key,
            child: ListView(
              children: [
                Image.asset(
                  "assets/icon_image.png",
                  height: 150,
                ),
                SizedBoxHelper.sizedBox20,
                if (!provider.isLogin)
                  CustomTextField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please enter a username";
                        } else {
                          return null;
                        }
                      },
                      controller: usernameController,
                      labelText: "Username",
                      hintText: "Enteryour username",
                      prefixIconData: Icons.person),
                SizedBoxHelper.sizedBox20,
                CustomTextField(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter  your email";
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIconData: Icons.email),
                SizedBoxHelper.sizedBox20,
                CustomTextField(
                  validator: (String? value) {
                    if (value!.isEmpty || value.length < 8) {
                      return "Please enter  your password";
                    } else if (value != passwordController.text) {
                      return "Password does not  match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: provider.obscureText,
                  controller: passwordController,
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIconData: Icons.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      provider.setobscureText();
                    },
                    icon: Icon(provider.obscureText
                        ? Icons.remove_red_eye
                        : Icons.visibility_off),
                  ),
                ),
                SizedBoxHelper.sizedBox20,
                CustomTextField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Please enter a  value";
                    } else if (value != passwordController.text) {
                      return "Password does not  match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: provider.obscureText,
                  controller: confirmedPasswordController,
                  labelText: " Confirmed Password",
                  hintText: "Enter your password again",
                  prefixIconData: Icons.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      provider.setobscureText();
                    },
                    icon: Icon(provider.obscureText
                        ? Icons.remove_red_eye
                        : Icons.visibility_off),
                  ),
                ),
                SizedBoxHelper.sizedBox20,
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            //code for authentication
                            if (provider.signIn(context,
                                email: emailController.text,
                                password: passwordController.text)) {
                            } else {
                              provider.signUp(context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  username: usernameController.text);
                            }
                          }
                        },
                        title: provider.isLogin ? "Login" : "Register"),
                MaterialButton(
                  onPressed: () {
                    provider.setIsLogin();
                  },
                  child: Text(provider.isLogin
                      ? "Don't have an account ?"
                      : "Already have an account?, Login"),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ForgetPasswordScreen.routeName);
                  },
                  child: const Text("Forget Password"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
