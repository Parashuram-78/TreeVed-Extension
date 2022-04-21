import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/widgets/EmojiConverter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          var user = userProvider.userDetails;
          return AppBar(
            elevation: 1,
            leading: Padding(
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(
                  user?.firstName != null ?
                  "${user?.firstName} ${user?.lastName}" : "Loading...",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                    user!.username != null ?
                  TextwithEmoji.text(value: user!.username!) : "Loading...",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Text(
                    user!.bio != null ?
                  TextwithEmoji.text(value: user!.bio!) : "Loading...",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
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
