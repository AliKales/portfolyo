import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Funcs {
  static String uID = "";

  void showSnackBar(context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static void copy({
    required String value,
    var context,
  }) {
    Clipboard.setData(ClipboardData(text: value));
    if (context != uID) {
      Funcs().showSnackBar(context, "Copied");
    }
  }

  Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  int ageCalculator(DateTime dateTime) {
    DateTime dateTimeNow = DateTime.now();
    int age = dateTimeNow.year - dateTime.year;

    if (dateTimeNow.month < dateTime.month) {
      age--;
    } else if (dateTimeNow.month == dateTime.month &&
        dateTimeNow.day < dateTime.month) {
      age--;
    }
    return age;
  }

  Future<DateTime?> getCurrentGlobalTime(context) async {
    DateTime istanbulTime;

    Duration? timeDiffrence;

    try {
      http.Response response = await http.get(
        Uri.parse(
          "http://worldtimeapi.org/api/timezone/Europe/Istanbul",
        ),
      );
      Map worldData = jsonDecode(response.body);
      istanbulTime = DateTime(
        int.parse(worldData['datetime'].substring(0, 4)),
        int.parse(worldData['datetime'].substring(5, 7)),
        int.parse(worldData['datetime'].substring(8, 10)),
        int.parse(worldData['datetime'].substring(11, 13)),
        int.parse(worldData['datetime'].substring(14, 16)),
        int.parse(worldData['datetime'].substring(17, 19)),
      );
    } catch (e) {
      istanbulTime = await _gCGT2(context);
    }

    timeDiffrence = DateTime.now().difference(istanbulTime);

    istanbulTime = DateTime.now().subtract(timeDiffrence);

    return istanbulTime;
  }

  Future<DateTime> _gCGT2(context) async {
    DateTime now;

    http.Response response = await http.get(
      Uri.parse(
        "https://www.timeapi.io/api/Time/current/coordinate?latitude=41.015137&longitude=28.979530",
      ),
    );
    Map worldData = jsonDecode(response.body);
    now = DateTime.parse(worldData['dateTime']);

    return now;
  }

  Future<PlatformFile?> pickImage() async {
    var pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile != null) {
      try {
        return pickedFile.files.first;
      } catch (err) {}
    }
    return null;
  }

  bool checkEquality(dynamic v1, dynamic v2) {
    return const DeepCollectionEquality().equals(v1, v2);
  }
}
