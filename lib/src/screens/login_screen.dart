import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/user_model.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/screens/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool isObscure = true;
bool isLoading = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo light mode.png',
                height: 70,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  await API.withoutInvitesignInWithGoogle(context);
                  var _username = window.localStorage;
                  UserDetails userDetails = await API.getUserDetails();
                  _username['username'] = userDetails.username!;
                  Provider.of<UserProvider>(context, listen: false).setUserDetails(userDetails: userDetails);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Text("Continue with Google"),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      child: Icon(
                        !isObscure ? Icons.remove_red_eye : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if(mounted)
                    {
                      setState(() {
                        isLoading = true;
                      });
                    }
                  await API.loginUsingUsernameAndPassword(username: usernameController.text, password: passwordController.text);
                  UserDetails userDetails = await API.getUserDetails();
                  var _username = window.localStorage;
                  _username['username'] = userDetails.username!;
                  Provider.of<UserProvider>(context, listen: false).setUserDetails(userDetails: userDetails);
                  if(mounted)
                  {
                    setState(() {
                      isLoading = false;
                    });
                  }
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                child:

                isLoading ?
                   CircularProgressIndicator(
                     color: Colors.white,
                   ) :
                Container(
                  margin: const EdgeInsets.all(7),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
