import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolyo/models/cv.dart';
import 'package:portfolyo/models/work.dart';

class User {
  String? fullName;
  String? birth;
  DateTime? joinDate;
  String? contactEmail;
  String? uID;
  String? country;
  bool? private;
  String? passwordForPrivacy;
  String? email;
  CV? cv;
  List<Work>? works;

  User(
      {this.fullName,
      this.birth,
      this.joinDate,
      this.uID,
      this.country,
      this.private,
      this.passwordForPrivacy,
      this.contactEmail,
      this.email,
      this.cv,
      this.works});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    birth = json['birth'];
    joinDate = (json['joinDate'] as Timestamp).toDate();
    uID = json['uID'];
    country = json['country'];
    private = json['private'];
    passwordForPrivacy = json['passwordForPrivacy'];
    contactEmail = json['contactEmail'];
    email = json['email'];
    if (json['cv'] != null) {
      cv = CV.fromJson(json['cv']);
    }
    if (json['works'] != null) {
      works = <Work>[];
      json['works'].forEach((v) {
        works!.add(Work.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['birth'] = birth;
    data['joinDate'] = FieldValue.serverTimestamp();
    data['uID'] = uID;
    data['country'] = country;
    data['private'] = private;
    data['passwordForPrivacy'] = passwordForPrivacy;
    data['contactEmail'] = contactEmail;
    data['email'] = email;
    data['cv'] = cv?.toJson();
    if (works != null) {
      data['works'] = works!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
