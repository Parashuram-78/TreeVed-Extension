import 'package:flutter/material.dart';
import 'package:treeved/controllers/api_handler.dart';
import 'package:treeved/models/all_list_model.dart';
import 'package:treeved/src/screens/add_resource_screen.dart';
import 'package:treeved/src/widgets/EmojiConverter.dart';

class AllListScreen extends StatefulWidget {
  final String url;
  final String rating;
  final BuildContext modalContext;

  const AllListScreen({Key? key, required this.url, required this.rating, required this.modalContext})
      : super(key: key);

  @override
  State<AllListScreen> createState() => _AllListScreenState();
}

late AllListModel list;
String selectedList = "";
String selectedListName = "";
bool isLoading = true;
bool isAdding = false;

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
    Size size = MediaQuery.of(context).size;
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
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: list.results.length,
            itemBuilder: (context, index) {
              var rawList = list.results[index];
              return ListTile(
                title: Text(TextwithEmoji.text(value: rawList.name)),
                subtitle: Text(TextwithEmoji.text(value: rawList.description)),
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
        const SizedBox(height: 5),
        Center(
          child: Container(
            width: 0.13 * size.width,
            height: 0.08 * size.height,
            child: MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              onPressed: () async {
                try {
                  if(mounted)
                    {
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
                  if(mounted)
                  {
                    setState(() {
                      isAdding = false;
                    });
                  }

                  customSnackBar(context, "Successfully added Link to $selectedListName");
                } catch (e) {
                  customSnackBar(context, e.toString());
                }
                Navigator.pop(context);
              },
              child:
              isAdding ?
                  Center(
                    child: Container(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(color: Colors.white,)),
                  ) :

              const Padding(
                padding: EdgeInsets.all(6.0),
                child: Text("Add"),
              ),
            ),
          ),
        ),
        const SizedBox(height:5),
      ],
    );
  }
}
