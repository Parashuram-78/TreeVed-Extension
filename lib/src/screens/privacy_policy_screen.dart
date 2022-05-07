import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key, required this.isMainScreen}) : super(key: key);
  final bool isMainScreen;

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isMainScreen ?  AppBar(
        iconTheme: IconThemeData(color: Colors.black),
          title: const Text('Privacy Policy')) : null,
      body:  FutureBuilder<String>(
          future: DefaultAssetBundle.of(context).loadString("assets/images/privacy_policy.md"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                physics: const BouncingScrollPhysics(),
                data: snapshot.data!,
                styleSheet: MarkdownStyleSheet(
                  h6: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
