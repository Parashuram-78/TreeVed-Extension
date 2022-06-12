import 'package:flutter/material.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';
import 'package:treeved/src/widgets/app_bar.dart';

import '../../controllers/api_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    API apiHandler = API();
    Future.microtask(() async {
      await apiHandler.refreshTokens();
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = true;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading ? CircularProgressIndicator() : AddResourceScreen(),
      ),
    );
  }
}
