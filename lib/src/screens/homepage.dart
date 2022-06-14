import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treeved/models/user_model.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';
import 'package:treeved/src/widgets/app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/api_handler.dart';
import '../../routes/routes.dart';

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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString("username") == null) {

        Navigator.pushNamed(context, Routes.login);
      } else {
        await apiHandler.refreshTokens();
        Navigator.pushNamed(context, Routes.add_respurce_screen);

      }
      print("down here ");
    });
  }

  bool isLoading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}
