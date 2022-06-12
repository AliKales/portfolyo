import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolyo/everything/funcs.dart';
import 'package:portfolyo/firebase/auth.dart';
import 'package:portfolyo/firebase/functions.dart';
import 'package:portfolyo/models/user.dart';
import 'package:portfolyo/models/work.dart';

class Firestore {
  static Future<User?> getUser({
    context,
    required String uid,
    String? passwordForPrivacy,
  }) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!documentSnapshot.exists) {
        return null;
      }

      return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        if (Auth().isItMe()) {
          return null;
        } else {
          return User(fullName: "error-found&User not found!");
        }
      } else if (e.code == "permission-denied") {
        if (passwordForPrivacy == null) {
          return User(
              fullName:
                  "error-found&This user has an private page. To access you need the privacy password!");
        } else {
          return await Functions.sendNotification(
              userID: uid, passwordForPrivacy: passwordForPrivacy);
        }
      }
      return User(fullName: "error-found&ERROR!");
    } catch (e) {
      return User(fullName: "error-found&ERROR!");
    }
  }

  static Future<User?> createUser({
    context,
    required User user,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uID)
          .set(user.toJson());

      return user;
    } on FirebaseException {
      Funcs().showSnackBar(context, "ERROR");
      return null;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return null;
    }
  }

  static Future<bool> update({
    required context,
    required var val,
    required String where,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Auth().getUID())
          .update({where: val});
      return true;
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(Auth().getUID())
            .set({where: val});
        return true;
      } else {
        Funcs().showSnackBar(context, "ERROR");
        return false;
      }
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return false;
    }
  }

  static Future<bool> addWork({
    context,
    required Work work,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Funcs.uID)
          .update({
        "works": FieldValue.arrayUnion([work.toJson()])
      });

      return true;
    } on FirebaseException {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateWork({
    context,
    required Work work,
    Work? exWork,
  }) async {
    try {
      if (exWork != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(Funcs.uID)
            .update({
          "works": FieldValue.arrayRemove([exWork.toJson()])
        });
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(Funcs.uID)
          .update({
        "works": FieldValue.arrayUnion([work.toJson()])
      });

      return true;
    } on FirebaseException {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteWork({
    context,
    required Work work,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Funcs.uID)
          .update({
        "works": FieldValue.arrayRemove([work.toJson()])
      });

      return true;
    } on FirebaseException {
      Funcs().showSnackBar(context, "ERROR!");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR!");
      return false;
    }
  }
}
