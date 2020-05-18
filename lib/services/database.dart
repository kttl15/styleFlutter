import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //* interacts with Firebase Database
  final String uid;
  final CollectionReference _userColRef =
      Firestore.instance.collection('users');
  DatabaseService(this.uid);

  Future<void> createUserDoc({String name, String email}) async {
    //TODO change to handle user settings
    await _userColRef.document(uid).setData({
      'name': name,
      'email': email,
    });
  }
}
