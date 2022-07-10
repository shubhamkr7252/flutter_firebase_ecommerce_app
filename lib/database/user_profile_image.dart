import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileImageDatabaseConnection {
  Future<Map<String, dynamic>?> getUserProfileImage(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> _doc = await FirebaseFirestore
        .instance
        .collection("UserProfileImage")
        .doc(userId)
        .get();

    if (_doc.exists) {
      return _doc.data();
    } else {
      return {};
    }
  }

  Future<void> setUserProfileImage(
      {required String userId, required String imageSrc}) async {
    await FirebaseFirestore.instance
        .collection("UserProfileImage")
        .doc(userId)
        .set({
      "image": imageSrc,
      "userId": userId,
    });
  }
}
