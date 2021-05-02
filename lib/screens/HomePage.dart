import 'package:Grab_Link/db/DatabaseHelper.dart';
import 'package:Grab_Link/helper/Dialogs.dart';
import 'package:Grab_Link/screens/AddLinkPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List savedLinks = [];
  bool isLoading = true;
  TextEditingController _editingController = TextEditingController();

  _setpage() async {
    List temp = await DatabaseHelper().getCustomLinks();
    setState(() {
      savedLinks = temp;
      isLoading = false;
    });
  }

  _searchLinks(String searchString) {
    List filteredList = [];
    if (searchString.isNotEmpty) {
      for (var e in savedLinks) {
        if ("${e['title']}${e['category']}${e['link']}${e['dateAdded']}"
            .contains(searchString)) {
          filteredList.add(e);
        }
      }
      setState(() {
        this.savedLinks = filteredList;
      });
    } else {
      setState(() {
        _setpage();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setpage();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 54, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Saved\nLinks",
                style: TextStyle(
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.bold,
                    fontSize: 32),
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: TextFormField(
                          controller: _editingController,
                          onChanged: (newValue) {
                            _searchLinks(newValue);
                          },
                          style: TextStyle(fontSize: 14.5),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(fontSize: 14.5)),
                        ),
                      ),
                      margin: EdgeInsets.only(top: 12),
                      width: double.maxFinite,
                      height: 36,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: IconButton(
                        icon: Icon(Icons.clear_all),
                        onPressed: () {
                          _editingController.clear();
                          _searchLinks("");
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...savedLinks.map((e) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              onTap: () {
                                Dialogs().linkDetails(
                                    // ignore: missing_return
                                    e['title'],
                                    e['id'],
                                    e['link'],
                                    // ignore: missing_return
                                    ctx, () {
                                  _setpage();
                                });
                              },
                              title: Text(
                                e['title'] + " / " + e['category'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "\n" + e['link'] + " \n" + e['dateAdded'],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Color.fromRGBO(150, 115, 200, 1),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddLinkPage())),
      ),
    );
  }
}
