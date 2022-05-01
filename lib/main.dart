import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/screens/homepage.dart';
import 'package:treeved/src/screens/login_screen.dart';

import 'providers/list_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ListNotifier()),
  ], child: const MyApp()));
}

check() {
  if (window.localStorage["username"] != null) {
    return const MyHomePage();
  } else {
    return const LoginScreen();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "TreeVed",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        home: check(),
      ),
    );
  }
}
