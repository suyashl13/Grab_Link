import 'package:flutter/cupertino.dart';

class CustomLink {
  int id;
  String title;
  String link;
  String category;
  String dateAdded;

  CustomLink({
    this.id,
    @required this.title,
    @required this.link,
    @required this.category,
    @required this.dateAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "link": this.link,
      "category": this.category,
      "dateAdded": this.dateAdded,
    };
  }
}
