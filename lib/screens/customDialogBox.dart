import 'dart:ui';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hookup4u_admin/model/customAlert.dart';
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final String title;
  final bool blocked;
  final String userId;

  const CustomDialogBox({Key key, this.title, this.blocked, this.userId})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  bool isLargeScreen = false;
  Timer _timer;

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

  blockAction(context, bool blocked, String userId) {
    Firestore.instance
        .collection("Users")
        .document(userId)
        .updateData({"isBlocked": (blocked) ? false : true}).then((result) {
      print("good updating!");
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text('Successfully updated'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(backgroundColor: Colors.grey),
                  ),
                )
              ]);
        },
      );

      setState(() {});
      // _timer = new Timer(const Duration(milliseconds: 1000), () {
      //   setState(() {});
      // });
      setState(() {});
    }).catchError((onError) {
      print("onError");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: (isLargeScreen)
              ? MediaQuery.of(context).size.width * .3
              : MediaQuery.of(context).size.width * .8,
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Constants.btn_background_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: FlatButton(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            minWidth: 150,
                            onPressed: () {
                              blockAction(context, this.widget.blocked,
                                  this.widget.userId);
                            },
                            child: Text(
                              "YES",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: Constants.btn_background_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: FlatButton(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            minWidth: 150,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "NO",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            )),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
