import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:portfolyo/everything/funcs.dart';

class Storage {
  static Future<String?> uploadImage(
      {required context,
      required String locationWithName,
      required Uint8List data}) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(locationWithName);

      await ref.putData(data);

      return await ref.getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return null;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return null;
    }
  }

  static Future<bool> deleteImage(
      {required context, required String path}) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(path);

      await ref.delete();
      return true;
    } on firebase_core.FirebaseException catch (e) {

      return false;
    } catch (e) {

      return false;
    }
  }
}
