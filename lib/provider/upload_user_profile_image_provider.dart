import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/database/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';

class UploadUserProfileImageProvider extends ChangeNotifier {
  bool _isLoading = false;
  Reference storageRef = FirebaseStorage.instance.ref();
  File? _imageFile;

  bool get isLoading => _isLoading;

  File? get getImageFile => _imageFile;

  void setImageFile(File? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }

  void removeImageFile() {
    _imageFile = null;
    notifyListeners();
  }

  ///pick image function to pick image from the source provided
  Future<File?> pickImage(ImageSource imgSource) async {
    File? profileImage;

    try {
      final image = await ImagePicker().pickImage(
        ///changed max height and width along with image quality so images can be uploaded quicker
        source: imgSource,
        maxHeight: 480,
        maxWidth: 480,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage = File(image.path);
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      log("failed to pick image $e");
    }
    return profileImage;
  }

  Future<void> uploadImage(BuildContext context,
      {required String currentUser}) async {
    _isLoading = true;
    notifyListeners();

    UploadTask uploadTask = storageRef
        .child('UserProfileImages/$currentUser.jpeg')
        .putFile(_imageFile!);

    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    ///sets the image url for the current user in database
    await UserDatabaseConnection()
        .setUserProfileImage(userId: currentUser, imageSrc: downloadUrl);

    UserProvider _provider = Provider.of(context, listen: false);
    _provider.updateUserImageToProvider(downloadUrl);

    _isLoading = false;
    notifyListeners();
  }
}
