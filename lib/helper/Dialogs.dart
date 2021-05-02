import 'package:Grab_Link/db/DatabaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Dialogs {
  String playStoreLink =
      "https://play.google.com/store/apps/details?id=suyeshlawand.grab_link";

  linkDetails(String title, int id, String link, BuildContext context,
      Function setPage()) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.5,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    title.toString().toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "Manrope"),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: double.maxFinite,
                // ignore: deprecated_member_use
                child: FlatButton(
                    minWidth: double.maxFinite,
                    onPressed: () {
                      try {
                        launch(link);
                      } catch (e) {
                        Navigator.of(context).pop();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Visit Link",
                      style: TextStyle(
                          color: Color.fromRGBO(150, 115, 200, 1),
                          fontSize: 16,
                          fontFamily: "Manrope"),
                    )),
              ),
              Container(
                width: double.maxFinite,
                // ignore: deprecated_member_use
                child: FlatButton(
                    minWidth: double.maxFinite,
                    onPressed: () async {
                      try {
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;
                        await Share.share(
                            "Hello, checkout this amazing site!\n$link\n\nAlso, please don't " +
                                "forget to download Grab Link from : $playStoreLink and save amazing websites.  ",
                            subject: "Shareing link via Grab Link",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Share",
                      style: TextStyle(
                          color: Color.fromRGBO(150, 115, 200, 1),
                          fontSize: 16,
                          fontFamily: "Manrope"),
                    )),
              ),
              Container(
                width: double.maxFinite,
                // ignore: deprecated_member_use
                child: FlatButton(
                    minWidth: double.maxFinite,
                    onPressed: () {
                      DatabaseHelper().deleteLink(id);
                      setPage();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: "Manrope"),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
