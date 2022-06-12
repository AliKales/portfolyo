import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:portfolyo/models/user.dart';

class Functions {
  static Future<User> sendNotification({
    required String userID,
    required String passwordForPrivacy,
  }) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getUserWithPassword');
      HttpsCallableResult response = await callable.call(<String, dynamic>{
        'userID': userID,
        'passwordForPrivacy': passwordForPrivacy,
      });
      Map map = response.data;
      if (map.containsKey('error-code')) {
        return User(fullName: "error-found&${map['error-message']}");
      } else {
        map['joinDate'] = Timestamp(
            map['joinDate']['_seconds'], map['joinDate']['_nanoseconds']);
        return User.fromJson(map as Map<String, dynamic>);
      }
    } catch (e) {
      return User(fullName: "error-found&Unexpected error!");
    }
  }
}
