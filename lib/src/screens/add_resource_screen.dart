import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/page_model.dart';
import 'package:treeved/models/user_model.dart';
import 'package:treeved/providers/user_provider.dart';
import 'package:treeved/src/widgets/all_list_screen.dart';

import '../widgets/app_bar.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({Key? key}) : super(key: key);

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

TextEditingController urlController = TextEditingController();
TextEditingController noteController = TextEditingController();
TextEditingController tagsController = TextEditingController();
double sliderValue = 3;
int selectedPoster = -1;
late RawMyPage rawMyPage;
List<MyPage> myPages = [];
List<String> posterList = [];
bool hasPage = false;
bool isPagesLoading = true;
bool isProfileDetailsLoading = true;
bool isPageManagement = false;

bool isDiaryAdding = false;
bool isDiaryShareAsPostAdding = false;


class _AddResourceScreenState extends State<AddResourceScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      UserDetails userDetails = await API.getUserDetails();
      Provider.of<UserProvider>(context, listen: false).setUserDetails(userDetails: userDetails);

      posterList.add(userDetails.username!);
      setState(() {
        isProfileDetailsLoading = false;
      });
      rawMyPage = await API.getMyPages();
      myPages = rawMyPage.results!;

      posterList.addAll(myPages.map((e) => e.name));
      myPages.isNotEmpty ? hasPage = true : hasPage = false;
      setState(() {
        isPagesLoading = false;
      });
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  static int tempId = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: isProfileDetailsLoading
            ? AppBar(
                title: Text('Loading...'),
              )
            : CustomAppBar(),
        body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              hasPage
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: const Text("Currently Managing:"),
                    )
                  : Container(),
              isPagesLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : hasPage
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(12.0),
                                ),
                              ),
                            ),
                            elevation: 5,
                            value: posterList[0],
                            items: posterList.map((myPage) {
                              return DropdownMenuItem(
                                  value: myPage,
                                  child: Text(
                                    myPage,
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPoster = posterList.indexOf(value.toString());
                                print("Current index  = ${posterList.indexOf(value.toString())}");
                                if (posterList.indexOf(value.toString()) != 0) {
                                  isPageManagement = true;
                                } else {
                                  isPageManagement = false;
                                }
                              });
                            },
                          ),
                        )
                      : Container(),
              SizedBox(
                height: 0.01 * size.height,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Url *",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextFormField(
                        enableInteractiveSelection: true,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          paste: true,
                          cut: true,
                          selectAll: true,
                        ),
                        validator: (value) {
                          if (value == null || value!.isEmpty) {
                            return "Please enter a URL";
                          }
                          return null;
                        },
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isPageManagement
                              ? SizedBox(
                                  width: 0.05 * size.width,
                                )
                              : Container(),
                          OutlinedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (isPageManagement) {
                                  await showModalBottomSheet(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (modalContext) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: AllListScreen(
                                                pageId: myPages[selectedPoster - 1].id,
                                                isPage: true,
                                                rating: sliderValue.toString(),
                                                url: urlController.text,
                                                modalContext: modalContext,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    setState(() {
                                      sliderValue = 3;
                                    });
                                  });
                                } else {
                                  await showModalBottomSheet(
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (modalContext) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: AllListScreen(
                                                pageId: 0,
                                                isPage: false,
                                                rating: sliderValue.toString(),
                                                url: urlController.text,
                                                modalContext: modalContext,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    setState(() {
                                      sliderValue = 3;
                                    });
                                  });
                                }
                              }
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
                          SizedBox(
                            width: 0.02 * size.width,
                          ),
                          isPageManagement
                              ? Container()
                              : isDiaryAdding
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : OutlinedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)))),
                                      onPressed: () async {
                                        if (isDiaryShareAsPostAdding) {
                                          debugPrint("isDiaryShareAsPostAdding");
                                        } else {
                                          if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              isDiaryAdding = true;
                                            });
                                            await API.createDiaryEntry(
                                              context: context,
                                              resourceUrl: urlController.text,
                                              rating: sliderValue.toString(),
                                            ).then((value) {
                                              print("value: $value");
                                            });
                                            urlController.clear();
                                            setState(() {
                                              isDiaryAdding = false;
                                            });
                                          }
                                        }
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
              const SizedBox(height:5 ),
              isDiaryShareAsPostAdding
                  ? Container(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)))),
                      onPressed: () async {
                        if (isDiaryAdding) {
                          debugPrint("isDiaryAdding");
                        } else {
                          setState(() {
                            isDiaryShareAsPostAdding = true;
                          });

                          if (_formKey.currentState!.validate()) {
                            await API
                                .createDiaryEntry(
                              context: context,
                              resourceUrl: urlController.text,
                              rating: sliderValue.toString(),
                            );
                            API api = API();
                            await api.shareAsPost(context: context, id: Provider.of<UserProvider>(context, listen: false).tempId);
                            urlController.clear();
                          }
                          setState(() {
                            isDiaryShareAsPostAdding = false;
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 5),
                          Text(
                            "Add to Diary and Share as post",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
