import 'package:flutter/material.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/all_list_model.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';

class AllListScreen extends StatefulWidget {
  final String url;
  final String rating;

  const AllListScreen({Key? key, required this.url, required this.rating}) : super(key: key);

  @override
  State<AllListScreen> createState() => _AllListScreenState();
}

List<Result> allList = [];
String selectedList = "";
String selectedListName = "";

class _AllListScreenState extends State<AllListScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      List<Result> results = await API.getUserLists();
      setState(() {
        allList = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: allList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(allList[index].name),
                subtitle: Text(allList[index].description),
                trailing: Radio(
                  value: allList[index].id.toString(),
                  groupValue: selectedList,
                  onChanged: (value) {
                    setState(() {
                      selectedListName = allList[index].name;
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
