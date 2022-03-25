import 'package:flutter/material.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';
import 'package:treeved/src/widgets/app_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: AddResourceScreen(),
      ),
    );
  }
}
