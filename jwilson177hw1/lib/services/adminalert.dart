// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwilson177hw1/models/user.dart';
import 'package:jwilson177hw1/services/auth.dart';

class AdminAlert {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authy = AuthService();

  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  final Query messages1 =
      FirebaseFirestore.instance.collection('messages').orderBy('datetime');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<String> getUser() async {
    User uid = await _auth.currentUser!;
    String user_id = uid.uid.toString();
    DocumentSnapshot ds = await users.doc(user_id).get();
    String name = ds.get('firstName');
    return name;
  }

  Future<String> currentuid() async {
    User uid = await _auth.currentUser!;
    String user_id = uid.uid.toString();
    return user_id;
  }

  Future<String> getUsersAsString() async {
    String registered = '';
    await users.get().then((message) {
      message.docs.forEach((value) {
        if (value['firstName'] != null) {
          // print();
//just get user id?

          registered = registered + value.id + ", " + value['firstName'] + "\n";
        }
      });
    });
    return registered;
  }

  Future<bool> chatExists(String other, String current) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(other + current).get();
    final snapshot1 =
        await FirebaseFirestore.instance.collection(current + other).get();
    if (snapshot.docs.length == 0) {
      print('k');
      return false;
    }
    return true;
  }

  Future<bool> chatExists1(String other, String current) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(other + current).get();
    final snapshot1 =
        await FirebaseFirestore.instance.collection(current + other).get();
    if (snapshot.docs.length == 0 || snapshot1.docs.length == 0) {
      return false;
    }
    return true;
  }

  Future<String> getMessagesAsString(String current) async {
    String msgs = '';
    print(current);
    final Query chats1 =
        FirebaseFirestore.instance.collection(current).orderBy('datetime');
    // print(current);
    await chats1.get().then((message) {
      message.docs.forEach((value) {
        // print("54" + value["message"]);
        if (value["message"] != null)
          msgs = msgs + value["Name"] + "->" + (value['message']) + "\n";
        // print(msgs);
      });
    });
    // print('below');
    print("64" + msgs);

    return msgs;
  }

  Future addAdminMessage(String message, String current, String name) async {
    await FirebaseFirestore.instance.collection(current).doc().set({
      'message': message,
      'datetime': DateTime.now().toString(),
      'Name': name
    });
  }

  Future updateProfile(
      String first, String last, String email, String pw) async {
    await _authy.updateuserWithEmailAndPassword(email, pw, first, last);
  }

  Future updatesocial(String social, String current) async {
    await FirebaseFirestore.instance.collection('users').doc(current).update({
      'social': social,
    });
  }
}
