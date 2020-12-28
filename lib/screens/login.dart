import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hookup4u_admin/screens/users_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController id = new TextEditingController();
  TextEditingController passwd = new TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool isLargeScreen = false;
  static const gradi_top_color = Color(0xFFff976e);
  static const gradi_bottom_color = Color(0xFFff1586);
  static const input_background_color = Color(0xFFf2f1f1);
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () {},
        child: Container(
          width: mq.width,
          height: mq.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradi_top_color, gradi_bottom_color])),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldKey,
              body: OrientationBuilder(builder: (context, orientation) {
                if (MediaQuery.of(context).size.width > 600) {
                  isLargeScreen = true;
                } else {
                  isLargeScreen = false;
                }
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    width: isLargeScreen
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.width * 0.8,
                    // width: mq.width,
                    height: mq.height * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            child: Image.asset("images/logo.png")),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                color: input_background_color),
                            margin:
                                EdgeInsets.only(left: 40, right: 40, top: 30),
                            child: TextField(
                              cursorColor: Theme.of(context).primaryColor,
                              controller: id,
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                  hintText: "Username",
                                  hintStyle: TextStyle(color: Colors.black12),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 16.0)),
                            )),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                color: input_background_color),
                            margin:
                                EdgeInsets.only(left: 40, right: 40, top: 15),
                            child: TextField(
                              cursorColor: Theme.of(context).primaryColor,
                              controller: passwd,
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black12),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 16.0)),
                            )),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              color: input_background_color),
                          margin: EdgeInsets.only(left: 40, right: 40, top: 55),
                          child: isLoading
                              ? CupertinoActivityIndicator(
                                  radius: 30,
                                )
                              : RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20.0),
                                  color: Theme.of(context).primaryColor,
                                  elevation: 11,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0))),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () async {
                                    bool isValid =
                                        await auth(id.text, passwd.text);
                                    snackbar(
                                        isValid
                                            ? "Logged in Successfully..."
                                            : "Incorrect Username or Password!",
                                        _scaffoldKey);
                                    if (isValid) {
                                      final sharedPrefs =
                                          await SharedPreferences.getInstance();
                                      sharedPrefs.setBool('isAuth', true);
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => Users()));
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                ),
                        )
                        // Text("Forgot your password?",
                        //     style: TextStyle(color: Theme.of(context).primaryColor))
                      ],
                    ),
                  ),
                );
              })),
        ));
  }

  Future auth(String id, String paswd) async {
    setState(() {
      isLoading = true;
    });
    Map authData = await Firestore.instance
        .collection("Admin")
        .document("id_password")
        .get()
        .then((value) {
      return value.data;
    });

    if (authData['id'] == id && authData['password'] == paswd) {
      return true;
    }
    return false;
  }
}

snackbar(String text, GlobalKey<ScaffoldState> _scaffoldKey) {
  final snackBar = SnackBar(
    backgroundColor: Color(0xffff3a5a),
    content: Text('$text '),
    duration: Duration(seconds: 3),
  );
  _scaffoldKey.currentState.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(snackBar);
}
