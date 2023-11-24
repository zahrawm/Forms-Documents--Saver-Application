import 'package:document_saver_application/firebase_options.dart';
import 'package:document_saver_application/provider/document_provider.dart';
import 'package:document_saver_application/provider/provider.dart';
import 'package:document_saver_application/provider/user_info_provider.dart';
import 'package:document_saver_application/screen/add_document_screen.dart';
import 'package:document_saver_application/screen/authentication_screen.dart';
import 'package:document_saver_application/screen/document_view_screen.dart';
import 'package:document_saver_application/screen/forget_password_screen.dart';
import 'package:document_saver_application/screen/home_screen.dart';
import 'package:document_saver_application/screen/settings_screen.dart';
import 'package:document_saver_application/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: const TextTheme(
                headline6: TextStyle(fontWeight: FontWeight.bold)),
            inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2)))),
        initialRoute: SplashScreen.routeName,
        routes: {
          AuthenticationScreen.routeName: (context) =>
              const AuthenticationScreen(),
          ForgetPasswordScreen.routeName: (context) =>
              const ForgetPasswordScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          AddDocumentScreen.routeName: (context) => const AddDocumentScreen(),
          DocumentViewScreen.routeName: (context) => const DocumentViewScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          SplashScreen.routeName: (context) => const SplashScreen()
        },
      ),
    );
  }
}
