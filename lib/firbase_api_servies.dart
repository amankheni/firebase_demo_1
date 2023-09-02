import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class FirebaseApi {
  static final DatabaseReference _db = FirebaseDatabase.instance.ref('user');

  static Future<void> adduser({required String userName}) async {
    String key = _db.push().key!;
    await _db.child(key).set({
      'key': key,
      'userName': userName,
    });
  }

  static Future<List<Map>> selectData() async {
    Map data =
        await _db.once().then((value) => value.snapshot.value as Map? ?? {});

    List<Map> userData = [];
    data.forEach((key, value) {
      //  log('$value');
      userData.add(value);
    });
    // log('$userData');
    return userData;
  }

  static updateData({required String key, required String userName}) {
    _db.child(key).update({
      'key': key,
      'userName': userName,
    });
  }

  static Future<void> removeData({required String key}) async {
    await _db.child(key).remove();
  }
}
