import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:myapp/controller/login_controller.dart';

import '../../widget/our_flutter_toast.dart';

class AddProduct{
  Future<String?> uploadImage(File pickedImage) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    String filename = pickedImage.path;
    File imageFile = File(pickedImage.path);
    File compressedFiles = await compressImage(imageFile);
    try {
      final uploadTask =
          await firebaseStorage.ref("$filename").putFile(compressedFiles);

      if (uploadTask.state == TaskState.success) {
        String downloadUrl =
            await firebaseStorage.ref("$filename").getDownloadURL();

        return downloadUrl;
        
      } else {}
    } on FirebaseException catch (e) {
      print("errorrrrr");
      OurToast().showErrorToast(e.message!);
      Get.find<LoginController>().toggle(false);
    }
  }

  Future<File> compressImage(File file) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    print("original size ${file.lengthSync()}");
    print(compressedFile.lengthSync());
    return compressedFile;
  }
}
