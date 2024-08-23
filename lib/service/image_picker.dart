// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static Future<File?> fromGalleryNCrop({double? aspectRatio, int? maxHeight, int? maxWidth, required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) throw Fluttertoast.showToast(msg: "No image selected");
    File file = File(pickedFile.path);
    return await cropImage(file: file, context: context, aspectRatio: aspectRatio, maxWidth: maxWidth, maxHeight: maxHeight, cropStyle: CropStyle.circle);
  }
  static Future<File?> fromCameraNCrop({double? aspectRatio, int? maxHeight, int? maxWidth, required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) throw Fluttertoast.showToast(msg: "No image selected");
    File file = File(pickedFile.path);
    return await cropImage(file: file, context: context, aspectRatio: aspectRatio, maxWidth: maxWidth, maxHeight: maxHeight, cropStyle: CropStyle.circle);
  }

  static Future<File?> cropImage({required File file, required BuildContext context, double? aspectRatio, int? maxHeight, int? maxWidth, CropStyle? cropStyle}) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop/Resize Image',
              toolbarColor: CupertinoColors.black,
              toolbarWidgetColor: CupertinoColors.white,
              lockAspectRatio: aspectRatio != null,
              activeControlsWidgetColor: CupertinoColors.activeBlue,
              cropStyle: cropStyle ?? CropStyle.rectangle),
          IOSUiSettings(),
          WebUiSettings(context: context),
        ],
        maxHeight: maxHeight ?? 800,
        maxWidth: maxWidth ?? 800,
        aspectRatio: aspectRatio == null ? null : CropAspectRatio(ratioX: aspectRatio, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 80);
    if (croppedFile == null) throw Fluttertoast.showToast(msg: "Image cropping failed");
    return file;
  }

  static Future<Uint8List?> cropImageInWeb({required XFile pickedFile, required BuildContext context, double? aspectRatio, int? maxHeight, int? maxWidth}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        aspectRatio: aspectRatio == null ? null : CropAspectRatio(ratioX: aspectRatio, ratioY: 1),
        maxHeight: maxHeight ?? 800,
        maxWidth: maxWidth ?? 800,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 80,
        sourcePath: pickedFile.path,
        uiSettings: [WebUiSettings(context: context, initialAspectRatio: 1)]);
    if (croppedFile != null) return croppedFile.readAsBytes();
    return null;
  }

  static String base64toApiBase64(String base64Image, {String format = "jpg"}) => "data:image/$format;base64,$base64Image";
}
