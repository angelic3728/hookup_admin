import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Reports {
  final List reports;
  Reports({this.reports});
  factory Reports.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return Reports(reports: doc["reporterName"]);
  }
}
