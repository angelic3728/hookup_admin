import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'constants.dart';
import 'package:hookup4u_admin/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsDialogBox extends StatefulWidget {
  final List reportsList;

  const ReportsDialogBox({Key key, this.reportsList}) : super(key: key);

  @override
  _ReportsDialogBoxState createState() => _ReportsDialogBoxState();
}

class _ReportsDialogBoxState extends State<ReportsDialogBox> {
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  String _getDate(Timestamp createdAt) {
    DateTime date = createdAt.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  Widget getTextWidgets(List<DocumentSnapshot> strings) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      List<Widget> subList = new List<Widget>();
      subList.add(new Text(
          (strings[i]["reportedText"] == null)
              ? (i + 1).toString() + ". " + "No content - "
              : (i + 1).toString() + ". " + strings[i]["reportedText"] + " - ",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)));
      subList.add(new Text(
          (strings[i]["reportedText"] == null)
              ? "Nothing"
              : "User: " + strings[i]["reportedUserName"],
          style: TextStyle(fontSize: 25, color: Colors.grey)));
      list.add(new Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .15,
              right: MediaQuery.of(context).size.width * .15,
              top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [subList[0], subList[1]],
          )));
    }
    return new Column(children: list);
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: (isLargeScreen)
              ? MediaQuery.of(context).size.width * .8
              : MediaQuery.of(context).size.width * .9,
          height: MediaQuery.of(context).size.height * .6,
          padding: EdgeInsets.only(
              left: Constants.info_padding,
              top: 15,
              right: Constants.info_padding,
              bottom: Constants.info_padding),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop()),
              ),
              Column(
                children: <Widget>[
                  (widget.reportsList.length == 0)
                      ? Container(
                          alignment: Alignment.center,
                          child: Text("No reports"),
                        )
                      : getTextWidgets(widget.reportsList)
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
