import 'package:flutter/material.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/all_list_model.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';

class AllListScreen extends StatefulWidget {
  final String url;
  final String rating;

  const AllListScreen({Key? key, required this.url, required this.rating})
      : super(key: key);

  @override
  State<AllListScreen> createState() => _AllListScreenState();
}

late AllListModel list;
String selectedList = "";
String selectedListName = "";
bool isLoading = true;

class _AllListScreenState extends State<AllListScreen> {
  @override
  void initState() {
    var results;
    Future.microtask(() async {
      results = await API.getUserLists();
    }).then((value) {
      setState(() {
        list = results;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.results.length,
            itemBuilder: (context, index) {
              var rawList = list.results[index];
              return ListTile(
                title: Text(rawList.name),
                subtitle: Text(rawList.description),
                trailing: Radio(
                  value: rawList.id.toString(),
                  groupValue: selectedList,
                  onChanged: (value) {
                    setState(() {
                      selectedListName = rawList.name;
                      selectedList = value!.toString();
                    });
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () async {
            try {
              await API.addtoList(
                addedUrl: widget.url,
                context: context,
                listId: selectedList,
                rating: widget.rating,
                listName: selectedListName,
              );
            } catch (e) {
              customSnackBar(context, e.toString());
            }
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Text("Add"),
          ),
        ),
      ],
    );
  }
}
