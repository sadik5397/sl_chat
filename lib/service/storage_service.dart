import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sl_chat/service/auth_service.dart';
import 'package:sl_chat/service/image_picker.dart';

class StorageService {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<List<String>> fetchAllFilesFromAFirebaseStorageFolder({required String folderName}) async {
    final ListResult result = await firebaseStorage.ref("$folderName/").listAll();
    final List<String> urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    return urls;
  }

  Future<void> uploadProfilePictureToFirebaseStorageFolder(BuildContext context) async {
    User user = AuthService().getCurrentUserInfo();
    String filepath = "profile_picture/${user.uid}.jpg";
    File? imageFile = await PickImage.fromGalleryNCrop(context: context, aspectRatio: 1);
    if (imageFile != null) {
      await firebaseStorage.ref(filepath).putFile(imageFile);
      String imageUrl = await firebaseStorage.ref(filepath).getDownloadURL();
      await AuthService().updateProfile(photoUrl: imageUrl);
    }
  }
}
