import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/models/user_model.dart';

import '../compress image/compress_image.dart';
import 'chat_info_detail.dart';


class ChatImageUpload {
  uploadImage(UserModel usermodel, File file) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String downloadUrl = "";
    try {
      File compressedFile = await compressImage(file);
      String filename = compressedFile.path.split('/').last;
      final uploadFile = await firebaseStorage
          .ref(
              "${FirebaseAuth.instance.currentUser!.uid}${usermodel.uid}/chats/${filename}")
          .putFile(compressedFile);
      if (uploadFile.state == TaskState.success) {
        downloadUrl = await firebaseStorage
            .ref(
                "${FirebaseAuth.instance.currentUser!.uid}${usermodel.uid}/chats/${filename}")
            .getDownloadURL();
        await ChatDetailFirebase().imageDetail(downloadUrl, usermodel);
        print("image uploaded");
      }
    } catch (e) {}
  }
}
