import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/user_model.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/widgets/all_list_screen.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({Key? key}) : super(key: key);
  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

TextEditingController urlController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController tagsController = TextEditingController();
double sliderValue = 5;

class _AddResourceScreenState extends State<AddResourceScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      UserDetails userDetails = await API.getUserDetails();
      Provider.of<UserProvider>(context, listen: false).setUserDetails(userDetails: userDetails);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Url *",
                    style: TextStyle(fontSize: 12),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintText: "Paste Url here",
                      suffixIcon: IconButton(
                        onPressed: () {
                          urlController.clear();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    controller: urlController,
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  const Text(
                    "Rating *",
                    style: TextStyle(fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Slider(
                          divisions: 10,
                          min: 0,
                          max: 5,
                          label: "Rating",
                          value: sliderValue,
                          onChanged: (va) {
                            setState(() {
                              sliderValue = va;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 20, child: Text("$sliderValue")),
                      const SizedBox(
                        width: 20,
                        child: Text("🌟"),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                            isDismissible: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return AllListScreen(
                                rating: sliderValue.toString(),
                                url: urlController.text,
                              );
                            },
                          ).then((value) {
                            setState(() {
                              urlController.text = "";
                              sliderValue = 5;
                            });
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Add to list",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await API.createDiaryEntry(
                            context: context,
                            resourceUrl: urlController.text,
                            rating: sliderValue.toString(),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.add, size: 18),
                            SizedBox(width: 5),
                            Text(
                              "Add to Diary",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
