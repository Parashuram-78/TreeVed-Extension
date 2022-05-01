import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/all_list_model.dart';
import 'package:treeved/providers/list_notifier.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';
import 'package:treeved/src/widgets/EmojiConverter.dart';

class AllListScreen extends StatefulWidget {
  final String url;
  final String rating;
  final BuildContext modalContext;
  final bool isPage;
  final int pageId;

  const AllListScreen(
      {Key? key,
      required this.url,
      required this.rating,
      required this.modalContext,
      required this.isPage,
      required this.pageId})
      : super(key: key);

  @override
  State<AllListScreen> createState() => _AllListScreenState();
}

String selectedList = "";
String selectedListName = "";
bool isLoading = true;
bool isAdding = false;

class _AllListScreenState extends State<AllListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    var results;

    Future.microtask(() async {
      var listNotifier = Provider.of<ListNotifier>(context, listen: false);
      await listNotifier.getUserList(
          firstRun: true, isPage: widget.isPage, pageId: widget.pageId);
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        print("Function called");
        Provider.of<ListNotifier>(context, listen: false).getUserList(
          isPage: widget.isPage,
          firstRun: false,
          pageId: widget.pageId,
        );
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<ListNotifier>(
      builder: (context, listNotifier, child) => isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : listNotifier.myList.isEmpty
              ? Center(
                  child: Text("No Lists"),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Select list to add to",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: listNotifier.myList.length,
                        itemBuilder: (context, index) {
                          var rawList = listNotifier.myList[index];
                          return Column(
                            children: [
                              ListTile(
                                title:
                                    Text(TextwithEmoji.text(value: rawList.name!)),
                                subtitle: Text(
                                    TextwithEmoji.text(value: rawList.description!)),
                                trailing: Radio(
                                  value: rawList.id.toString(),
                                  groupValue: selectedList,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedListName = rawList.name!;
                                      selectedList = value!.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 0.01 * size.height,
                              ),
                              index == listNotifier.myList.length - 1 &&
                                  listNotifier.hasMore
                                  ? Container(
                                  margin: EdgeInsets.only(top: 0.015 * size.height),
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                                  : index == listNotifier.myList.length - 1 &&
                                  listNotifier.myList.length > 6
                                  ? Container(
                                margin:
                                EdgeInsets.only(top: 0.015 * size.height),
                                child: const Text(
                                    "You have reached the bottom of the page!"),
                              )
                                  : Container()
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Container(
                        width: 0.13 * size.width,
                        height: 0.08 * size.height,
                        child: MaterialButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () async {
                            try {
                              if (mounted) {
                                setState(() {
                                  isAdding = true;
                                });
                              }
                              await API.addtoList(
                                addedUrl: widget.url,
                                context: context,
                                listId: selectedList,
                                rating: widget.rating,
                                listName: selectedListName,
                              );
                              if (mounted) {
                                setState(() {
                                  isAdding = false;
                                });
                              }

                              customSnackBar(context,
                                  "Successfully added Link to $selectedListName");
                            } catch (e) {
                              customSnackBar(context, e.toString());
                            }
                            Navigator.pop(context);
                          },
                          child: isAdding
                              ? Center(
                                  child: Container(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      )),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text("Add"),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
    );
  }
}
