// ignore_for_file: must_be_immutable

import 'package:Grab_Link/db/DatabaseHelper.dart';
import 'package:Grab_Link/models/CustomLink.dart';
import 'package:Grab_Link/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddLinkPage extends StatefulWidget {
  String link;

  AddLinkPage([this.link]) {
    if (link == null) {
      link = "";
    }
  }

  @override
  _AddLinkPageState createState() => _AddLinkPageState(link);
}

class _AddLinkPageState extends State<AddLinkPage> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String title = "";
  String link = "";
  String category = "";

  _AddLinkPageState(this.link){
    print(link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 54, left: 24, right: 24),
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromRGBO(158, 115, 200, 1),
              Color.fromRGBO(245, 185, 194, 1),
            ])),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Save\nanother link",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.bold,
                    fontSize: 32),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  onChanged: (newValue) {
                    setState(() {
                      this.title = newValue;
                    });
                  },
                  // ignore: missing_return
                  validator: (value) {
                    if (title.trim().length < 3) {
                      return "Should be greater than 3 characters";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Title",
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  initialValue: link,
                  onChanged: (newValue) {
                    setState(() {
                      this.link = newValue;
                    });
                  },
                  // ignore: missing_return
                  validator: (value) {
                    if (!value.trim().contains(".")) {
                      return "Please enter a valid link";
                    }

                    if (!value.trim().contains("://")) {
                      return "Please enter a valid link";
                    }
                    if (!value.trim().contains("http")) {
                      return "Only http and https links are allowed";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Link (e.g. https://example.com)",
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: TextFormField(
                  validator: (value) {
                    if (title.trim().length < 3) {
                      return "Should be greater than 3 characters";
                    }
                  },
                  onChanged: (newValue) {
                    setState(() {
                      this.category = newValue;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Category (e.g. Sports, Art)",
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        child: Icon(
          Icons.done,
          size: 30,
        ),
        backgroundColor: Color.fromRGBO(150, 115, 200, 1),
        onPressed: () async {
          if (key.currentState.validate()) {
            key.currentState.save();
            await DatabaseHelper().insertLink(CustomLink(
                title: title.trim(),
                link: link.trim(),
                category: category.trim(),
                dateAdded: DateFormat.yMMMd().format(DateTime.now())));

            print(CustomLink(
                    title: title,
                    link: link,
                    category: category,
                    dateAdded: DateFormat.yMMMd().format(DateTime.now()))
                .toJson());
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          }
        },
      ),
    );
  }
}
