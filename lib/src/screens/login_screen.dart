import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/user_model.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/screens/homepage.dart';
import 'package:treeved/src/screens/privacy_policy_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool isObscure = true;
bool isLoading = false;
final _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo light mode.png',
                height: 70,
              ),
              const SizedBox(height: 10),
              /*InkWell(
                onTap: () async {
                  await API.withoutInvitesignInWithGoogle(context);
                  var _username = window.localStorage;
                  UserDetails userDetails = await API.getUserDetails();
                  _username['username'] = userDetails.username!;
                  Provider.of<UserProvider>(context, listen: false)
                      .setUserDetails(userDetails: userDetails);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text("Continue with Google"),
                ),
              ),
              SizedBox(height: 0.03 * size.height),*/
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
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
              SizedBox(height: 0.03 * size.height),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
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
                        !isObscure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.03 * size.height),
              Container(
                width: 0.25 * size.width,
                height: 0.13 * size.height,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {


                      try {
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        await API.loginUsingUsernameAndPassword(
                            username: usernameController.text,
                            password: passwordController.text);
                        UserDetails userDetails = await API.getUserDetails();
                        var _username = window.localStorage;
                        _username['username'] = userDetails.username!;

                        Provider.of<UserProvider>(context, listen: false)
                            .setUserDetails(userDetails: userDetails);
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) => const MyHomePage()),
                        );

                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }

                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Incorrect username or password"),
                          ),
                        );
                        }


                    } else {}
                  },
                  child: isLoading
                      ? Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(7),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 0.03 * size.height),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                              child: PrivacyPolicyScreen(isMainScreen: false),
                            ));
                  },
                  child: Text(
                    "Privacy Policy",
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
