import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hookup4u_admin/model/customAlert.dart';
import 'package:hookup4u_admin/model/user.dart';
import 'package:hookup4u_admin/screens/blocked_users.dart';
import 'package:hookup4u_admin/screens/userInfoDialogBox.dart';
import 'package:hookup4u_admin/screens/reportsDialogBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  CollectionReference collectionReference =
      Firestore.instance.collection("Users");
  CollectionReference reportReference =
      Firestore.instance.collection("ReportedUsers");
  @override
  void initState() {
    _getuserList();
    super.initState();
  }

  TextEditingController searchctrlr = TextEditingController();
  bool isLargeScreen = false;

  int totalDoc;
  DocumentSnapshot lastVisible;
  int documentLimit = 25;
  List<User> user = [];
  bool sort = true;
  static const input_background_color = Color(0xFFf2f1f1);
  Future _getuserList() async {
    collectionReference
        .orderBy("userId", descending: false)
        .getDocuments()
        .then((value) {
      totalDoc = value.documents.length;
    });

    if (lastVisible != null) {
      // print("1");
      await collectionReference
          .orderBy("userId", descending: false)
          .startAfterDocument(lastVisible)
          .limit(documentLimit)
          .getDocuments()
          .then((value) {
        if (value.documents.length < 1) {
          print("no more data");
          return;
        }
        if (value.documents.length > 0)
          lastVisible = value.documents[value.documents.length - 1];
        // print(value.documents);
        for (var doc in value.documents) {
          if (doc.data.length > 4) {
            getReportsList(doc['userId']);
            User temp = User.fromDocument(doc, reportsList);
            user.add(temp);
          }
        }
      });
      if (mounted) setState(() {});
    } else {
      await collectionReference
          .orderBy('userId', descending: false)
          .limit(documentLimit)
          .getDocuments()
          .then((value) {
        if (value.documents.length > 0)
          lastVisible = value.documents[value.documents.length - 1];
        for (var doc in value.documents) {
          if (doc.data.length > 4) {
            getReportsList(doc['userId']);
            User temp = User.fromDocument(doc, reportsList);
            user.add(temp);
          }
        }
      });
      if (mounted) setState(() {});
    }
  }

  List<Widget> _getGridViewItems(BuildContext context, List<User> user) {
    List<Widget> allWidgets = new List<Widget>();
    for (int i = 0; i < user.length; i++) {
      var widget = _userCard(context, user[i]);
      allWidgets.add(widget);
    }
    return allWidgets;
  }

  Widget _userCard(BuildContext context, User user) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 20),
      height: 350,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              (user.imageUrl[0] == null)
                  ? "https://i.ibb.co/W5sfwLh/profile.png"
                  : user.imageUrl[0],
              height: 150.0,
              width: 110.0,
              fit: BoxFit.fill,
            ),
          )),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(user.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, top: 1),
                  child: GestureDetector(
                      onTap: () {
                        getReportsList(user.id);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ReportsDialogBox(
                                  reportsList: user.reports);
                            });
                      },
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.grey,
                        child: Center(
                          child: Text(
                            (user.reports.length).toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 1),
                  child: GestureDetector(
                      onTap: () {
                        getReportsList(user.id);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UserInfoDialogBox(
                                  user: user, reportsList: user.reports);
                            });
                      },
                      child: Image.asset(
                        "images/info_detail.png",
                        height: 25.0,
                        width: 25.0,
                        fit: BoxFit.fill,
                      )),
                )
              ],
            ),
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
      ),
    );
  }

  Widget userlists(BuildContext context, List<User> list) {
    // print(list.length);
    int crossCount = 1;
    double sideMargin = 5;
    if (MediaQuery.of(context).size.width > 1680) {
      crossCount = 6;
      sideMargin = 80;
    } else if (MediaQuery.of(context).size.width > 1415) {
      crossCount = 5;
      sideMargin = 60;
    } else if (MediaQuery.of(context).size.width > 1015) {
      crossCount = 4;
      sideMargin = 4;
    } else if (MediaQuery.of(context).size.width > 800) {
      crossCount = 3;
      sideMargin = 20;
    } else if (MediaQuery.of(context).size.width > 534) {
      crossCount = 2;
      sideMargin = 10;
    }
    return SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        child: Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: sideMargin, right: sideMargin),
            child: GridView.count(
              crossAxisCount: crossCount,
              padding: EdgeInsets.all(10.0),
              // childAspectRatio: 1.0,
              children: _getGridViewItems(context, list),
            )),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: DataTable(
        //     sortAscending: sort,
        //     sortColumnIndex: 2,
        //     columnSpacing: MediaQuery.of(context).size.width * .085,
        //     columns: [
        //       DataColumn(
        //         label: Text("Images"),
        //       ),
        //       DataColumn(
        //         label: Text("Name"),
        //       ),
        //       DataColumn(
        //           label: Text("Gender"),
        //           onSort: (columnIndex, ascending) {
        //             setState(() {
        //               sort = !sort;
        //             });
        //             onSortColum(columnIndex, ascending);
        //           }),
        //       DataColumn(label: Text("Phone Number")),
        //       DataColumn(label: Text("userId")),
        //       DataColumn(label: Text("view")),
        //     ],
        //     rows: list
        //         .map(
        //           (index) => DataRow(cells: [
        //             DataCell(
        //               ClipRRect(
        //                 borderRadius: BorderRadius.circular(18),
        //                 child: CircleAvatar(
        //                   child: index.imageUrl[0] != null
        //                       ? Image.network(
        //                           index.imageUrl[0],
        //                           fit: BoxFit.fill,
        //                         )
        //                       : Container(),
        //                   backgroundColor: Colors.grey,
        //                   radius: 18,
        //                 ),
        //               ),
        //               // onTap: () {
        //               //   // write your code..
        //               // },
        //             ),
        //             DataCell(
        //               Text(index.name),
        //             ),
        //             DataCell(
        //               Text(index.gender),
        //             ),
        //             DataCell(
        //               Text(index.phoneNumber),
        //             ),
        //             DataCell(
        //               Row(
        //                 children: [
        //                   Container(
        //                     width: 150,
        //                     child: Text(
        //                       index.id,
        //                       overflow: TextOverflow.ellipsis,
        //                     ),
        //                   ),
        //                   IconButton(
        //                       icon: Icon(
        //                         Icons.content_copy,
        //                         size: 20,
        //                       ),
        //                       tooltip: "copy",
        //                       onPressed: () {
        //                         Clipboard.setData(ClipboardData(
        //                           text: index.id,
        //                         ));
        //                       })
        //                 ],
        //               ),
        //             ),
        //             DataCell(
        //               IconButton(
        //                   icon: Icon(Icons.fullscreen),
        //                   tooltip: "open profile",
        //                   onPressed: () => Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => Info(index)))),
        //             ),
        //           ]),
        //         )
        //         .toList(),
        //   ),
        // ),

        searchReasultfuture != null
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("1-${list.length} of $totalDoc  "),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              _getuserList()
                                  .then((value) => Navigator.pop(context));
                              return Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ));
                            });
                      },
                    )
                  ],
                ),
              )
      ],
    ));
  }

  List<User> results = [];
  Future<QuerySnapshot> searchReasultfuture;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  searchuser(String query) {
    if (query.trim().length > 0) {
      Future<QuerySnapshot> users = collectionReference
          .where(
            isNumeric(query) ? 'phoneNumber' : 'UserName',
            isEqualTo: query,
          )
          .getDocuments();

      setState(() {
        searchReasultfuture = users;
      });
    }
  }

  List<DocumentSnapshot> reportsList = [];
  getReportsList(String userId) async {
    reportsList = [];
    await reportReference
        .where("reportedUserId", isEqualTo: userId)
        .getDocuments()
        .then((value) {
      for (var doc in value.documents) {
        reportsList.add(doc);
      }
    });
  }

  Widget buildSearchresults() {
    return FutureBuilder(
      future: searchReasultfuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                )),
              ),
              Text("Searching......"),
            ],
          );
          //
        }
        if (snapshot.data.documents.length > 0) {
          results.clear();
          snapshot.data.documents.forEach((DocumentSnapshot doc) {
            if (doc.data.length > 5) {
              getReportsList(doc["userId"]);
              User usert2 = User.fromDocument(doc, reportsList);
              results.add(usert2);
            }
          });
          return userlists(context, results);
        }
        return Center(child: Text("no data found"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _getuserList();

    return WillPopScope(
        onWillPop: () {},
        child: OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Scaffold(
            backgroundColor: Colors.white,
            // drawer: Drawer(
            //   child: ListView(
            //     children: <Widget>[
            //       DrawerHeader(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Text(
            //               'Admin Panel',
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 25,
            //                   fontWeight: FontWeight.bold),
            //               textAlign: TextAlign.center,
            //             ),
            //           ],
            //         ),
            //         decoration: BoxDecoration(
            //           color: Theme.of(context).primaryColor,
            //         ),
            //       ),
            //       ListTile(
            //         trailing: Icon(
            //           Icons.format_list_numbered,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         title: Text('PACKAGES'),
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) => Package()));
            //         },
            //       ),
            //       Divider(
            //         thickness: .5,
            //         color: Colors.black,
            //       ),
            //       ListTile(
            //         trailing: Icon(
            //           Icons.storage,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         title: Text('ITEM ACCESS'),
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => SubscriptionSettings()));
            //         },
            //       ),
            //       Divider(
            //         thickness: .5,
            //         color: Colors.black,
            //       ),
            //       ListTile(
            //         trailing: Icon(
            //           Icons.lock_open,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         title: Text('CHANGE ID/PASSWORD'),
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ChangeIdPassword()));
            //         },
            //       ),
            //       Divider(
            //         thickness: .5,
            //         color: Colors.black,
            //       ),
            //       ListTile(
            //         trailing: Icon(
            //           Icons.power_settings_new,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         title: Text('LOGOUT'),
            //         onTap: () async {
            //           _alertDialog(context);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            appBar: _appBar(context),
            //     AppBar(
            //   centerTitle: true,
            //   title: Text(
            //     "Users",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   actions: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 10),
            //       child: Container(
            //         // decoration:
            //         //     BoxDecoration(border: Border.all(color: Colors.white)),
            //         height: 4,
            //         width: isLargeScreen
            //             ? MediaQuery.of(context).size.width * .3
            //             : MediaQuery.of(context).size.width * .5,
            //         child: Card(
            //           child: TextFormField(
            //             cursorColor: Theme.of(context).primaryColor,
            //             controller: searchctrlr,
            //             decoration: InputDecoration(
            //                 hintText: "Search by name or phone number",
            //                 filled: true,
            //                 prefixIcon: IconButton(
            //                     icon: Icon(Icons.search),
            //                     onPressed: () => searchuser(searchctrlr.text)),
            //                 suffixIcon: IconButton(
            //                   icon: Icon(Icons.clear),
            //                   onPressed: () {
            //                     searchctrlr.clear();
            //                     setState(() {
            //                       searchReasultfuture = null;
            //                     });
            //                   },
            //                 )),
            //             onFieldSubmitted: searchuser,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            body: searchReasultfuture == null
                ? user.length > 0
                    ? userlists(context, user)
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      )))
                : buildSearchresults(),
          );
        }));
  }

//  App Bar Widget
  Widget _appBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      width: isLargeScreen
                          ? MediaQuery.of(context).size.width * .3
                          : MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: input_background_color),
                      // margin: EdgeInsets.only(left: 40, right: 40, top: 0),
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: searchctrlr,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                            hintText: "Search Users",
                            hintStyle: TextStyle(color: Colors.black12),
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 16.0),
                            prefixIcon: IconButton(
                                iconSize: 22,
                                icon: Icon(Icons.search),
                                onPressed: () => searchuser(searchctrlr.text)),
                            suffixIcon: IconButton(
                              iconSize: 22,
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchctrlr.clear();
                                setState(() {
                                  searchReasultfuture = null;
                                });
                              },
                            )),
                      )),
                ),
              ),
              Positioned(
                  right: 15,
                  top: 10,
                  child: Row(children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => BlockedUsers()));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage("images/show_blocked_btn.png"),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                          onTap: () {
                            logout();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage("images/logout.png"),
                          )),
                    )
                  ])

                  // GestureDetector(
                  //   onTap: () {
                  //   //do what you want here
                  //   },
                  //     child: CircleAvatar(
                  //   backgroundImage: AssetImage("images/logout.png"),
                  // ))
                  )
            ],
          ),
        ));
  }

  void logout() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('isAuth', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  _alertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog(
            text: "Do you want to logout ?",
            onYesTap: logout,
            onNoTap: () => Navigator.pop(context));
      },
    );
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 2) {
      if (ascending) {
        user.sort((a, b) => a.gender.compareTo(b.gender));
      } else {
        user.sort((a, b) => b.gender.compareTo(a.gender));
      }
    }
  }
}
