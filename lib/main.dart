import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/router/routes.dart';
import 'package:drape_shoppe_crm/screens/task/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check login state from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeProvider.instance,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommentsScreen(),
    );
    // return MaterialApp.router(
    //   routerConfig: MyRouter.router(isLoggedIn),
    // );
  }
}
