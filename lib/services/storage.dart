import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageService {
  final FirebaseStorage _firebaseStorage =
      FirebaseStorage(storageBucket: 'gs://flutter-bloc-1-2eb17.appspot.com');

  FirebaseStorage firebaseStorage() {
    return _firebaseStorage;
  }
}
