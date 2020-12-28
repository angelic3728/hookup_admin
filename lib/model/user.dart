import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String id;
  final String name;
  bool isBlocked;
  final String address;
  final Map coordinates;
  final List sexualOrientation;
  final String gender;
  final String showGender;
  final int age;
  final String phoneNumber;
  final maxDistance;
  final String countryName;
  final Timestamp cretedDate;

  final Map ageRange;
  final Map editInfo;
  List imageUrl = [];
  List reports = [];
  var distanceBW;
  User(
      {@required this.id,
      @required this.age,
      @required this.address,
      this.coordinates,
      @required this.name,
      @required this.imageUrl,
      this.isBlocked,
      this.phoneNumber,
      this.gender,
      this.showGender,
      this.ageRange,
      this.maxDistance,
      this.editInfo,
      this.distanceBW,
      this.sexualOrientation,
      this.countryName,
      this.cretedDate,
      this.reports});
  factory User.fromDocument(DocumentSnapshot doc, reportsList) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return User(
        reports: reportsList,
        id: doc['userId'],
        isBlocked: doc['isBlocked'] != null ? doc['isBlocked'] : false,
        phoneNumber: doc['phoneNumber'] ?? "",
        name: doc['UserName'] ?? "",
        editInfo: doc['editInfo'] ?? "",
        gender: doc['editInfo']['userGender'] ?? "",
        ageRange: doc['age_range'] ?? "",
        showGender: doc['showGender'] ?? "",
        maxDistance: doc['maximum_distance'] ?? "",
        // sexualOrientation: doc['sexualOrientation']['orientation'] ?? "",
        age: ((DateTime.now()
                        .difference(DateTime.parse(doc["user_DOB"]))
                        .inDays) /
                    365.2425)
                .truncate() ??
            "",
        address: doc['location']['address'] ?? "",
        coordinates: doc['location'] ?? "",
        countryName: doc['location']['countryName'] ?? "",
        cretedDate: doc['timestamp'] ?? "",
        // university: doc['editInfo']['university'],
        imageUrl: doc['Pictures'] != null
            ? List.generate(doc['Pictures'].length, (index) {
                return doc['Pictures'][index];
              })
            : null);
  }
}
