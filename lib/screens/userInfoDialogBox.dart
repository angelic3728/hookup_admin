import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'constants.dart';
import 'package:hookup4u_admin/model/user.dart';
import 'package:hookup4u_admin/screens/customDialogBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfoDialogBox extends StatefulWidget {
  final User user;
  final List<DocumentSnapshot> reportsList;

  const UserInfoDialogBox({Key key, this.user, this.reportsList})
      : super(key: key);

  @override
  _UserInfoDialogBoxState createState() => _UserInfoDialogBoxState();
}

class _UserInfoDialogBoxState extends State<UserInfoDialogBox> {
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

  List<Widget> _getGridViewItems(BuildContext context, User user) {
    List<Widget> allWidgets = new List<Widget>();
    if (user.imageUrl.length != 0) {
      for (int i = 0; i < user.imageUrl.length; i++) {
        print(user.imageUrl[i]);
        var widget = _userCard(context, user.imageUrl[i]);
        allWidgets.add(widget);
      }
    } else {
      var widget = _userCard(context, "https://i.ibb.co/W5sfwLh/profile.png");
      allWidgets.add(widget);
    }
    return allWidgets;
  }

  Widget _userCard(BuildContext context, String userImg) {
    return Container(
      // padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 20),
      height: 220,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              (userImg == null)
                  ? "https://i.ibb.co/W5sfwLh/profile.png"
                  : userImg,
              height: 110.0,
              width: 90.0,
              fit: BoxFit.fill,
            ),
          )),
        ],
      ),
    );
  }

  String _getDate(Timestamp createdAt) {
    DateTime date = createdAt.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  contentBox(context) {
    int crossCount = 2;
    if (MediaQuery.of(context).size.width > 1460) {
      crossCount = 3;
    } else {
      crossCount = 2;
    }
    return Stack(
      children: <Widget>[
        Container(
          width: (isLargeScreen)
              ? MediaQuery.of(context).size.width * .8
              : MediaQuery.of(context).size.width * .9,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: (isLargeScreen)
                          ? MediaQuery.of(context).size.width * .8 * .4
                          : MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.height * .6,
                      child: GridView.count(
                        crossAxisCount: crossCount,
                        padding: EdgeInsets.all(10.0),
                        // childAspectRatio: 1.0,
                        children: _getGridViewItems(context, widget.user),
                      )),
                  Expanded(
                      child: Container(
                    height: MediaQuery.of(context).size.height * .6,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Username",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    widget.user.name,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "UID",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                      child: Expanded(
                                          child: Text(
                                    (widget.user.id != null)
                                        ? widget.user.id
                                        : "No UID",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Gender",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    widget.user.gender,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Phone number",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    widget.user.phoneNumber,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Age",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    (widget.user.age).toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Job",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    (widget.user.editInfo["job_title"] == null)
                                        ? "Nothing"
                                        : widget.user.editInfo["job_title"],
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Country",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    widget.user.countryName,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      "Created Date",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    _getDate(widget.user.cretedDate),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Text(
                                          "About Bio",
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.grey),
                                        ),
                                      ),
                                      Container(
                                          child: Expanded(
                                              child: Text(
                                        (widget.user.editInfo["about"] != null)
                                            ? widget.user.editInfo["about"]
                                            : "Nothing",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      )))
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Constants.btn_background_color,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: FlatButton(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          minWidth: 150,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Report's:" +
                                                (widget.reportsList.length)
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          color: Constants.btn_background_color,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: FlatButton(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          minWidth: 150,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CustomDialogBox(
                                                    title: (widget
                                                            .user.isBlocked)
                                                        ? "Unblock this User"
                                                        : "Block this User",
                                                    blocked:
                                                        widget.user.isBlocked,
                                                    userId: widget.user.id,
                                                  );
                                                });
                                          },
                                          child: Text(
                                            (widget.user.isBlocked)
                                                ? "UNBLOCK"
                                                : "BLOCK",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          )),
                                    )
                                  ],
                                )))
                      ],
                    ),
                  )
                      // height: MediaQuery.of(context).size.height * .6,
                      )
                  // NetworkImage(user.imageUrl),
                  // Image.network(
                  //   user.imageUrl[0],
                  //   width: 20,
                  //   height: 20,
                  // ),
                  // Text(user.name),
                  // Row(
                  //   children: [
                  //     Text("fdsfds"),
                  //     Text("fdsfds"),
                  //   ],
                  // ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
