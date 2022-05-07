import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/widgets/EmojiConverter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes/routes.dart';
import '../screens/privacy_policy_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nullify;
    Size size = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<UserProvider>(
        builder: (rootContext, userProvider, child) {
          var user = userProvider.userDetails;
          return AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Image.network(
                          user?.profilePicture ??
                              'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.firstName != null
                              ? "${user?.firstName} ${user?.lastName}"
                              : "Loading...",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user!.username != null
                              ? TextwithEmoji.text(value: user!.username!)
                              : "Loading...",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          user!.bio != null
                              ? TextwithEmoji.text(value: user!.bio!)
                              : "Loading...",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  offset: Offset(0.15 * size.width, -0.185 * size.height),
                  itemBuilder: (context) {
                    return List.generate(
                      2,
                      (index) {
                        return PopupMenuItem(
                          onTap: () async {
                            if (index == 0) {
                              context.vxNav.push(
                                Uri.parse(Routes.privacy_policy),
                                params: true,
                              );
                            } else {
                              window.localStorage.clear();
                              context.vxNav.clearAndPush(
                                Uri.parse(Routes.login),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    index == 0
                                        ? Icons.privacy_tip_outlined
                                        : Icons.logout_outlined,
                                    color: index == 0
                                        ? Colors.black
                                        : Colors.redAccent,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    index == 0 ? "Privacy Policy" : "Sign out",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                /*InkWell(
                  borderRadius: BorderRadius.circular(100),
                    onTap: () {},
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    )),*/
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
