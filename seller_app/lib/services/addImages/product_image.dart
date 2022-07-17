import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:myapp/controller/product_names_list_controller.dart';
import 'package:myapp/services/firestore_service/product_detail.dart';

import '../../controller/login_controller.dart';
import '../../widget/our_flutter_toast.dart';

class AddProduct {
  Future<List<String?>?> uploadImage(
    List<File> pickedImagess,
    String name,
    String desc,
    int quantity,
    double price,
  ) async {
    int n = 1;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    List<String> dataUrl = [];
    pickedImagess.forEach((pickedImage) async {
      String filename = pickedImage.path;
      File imageFile = File(pickedImage.path);
      File compressedFiles = await compressImage(imageFile);
      try {
        final uploadTask =
            await firebaseStorage.ref("${filename}").putFile(compressedFiles);

        if (uploadTask.state == TaskState.success) {
          String? downloadUrl;
          downloadUrl =
              await firebaseStorage.ref("${filename}").getDownloadURL();
          print("==================");
          print("DONE DONE DONE");
          print(downloadUrl);
          Get.find<ProductListName>().addProduct(downloadUrl);
          print("==================");
          dataUrl.add(downloadUrl);
          if (n == pickedImagess.length) {
            print(n);
            print(pickedImagess.length);
            print("Sending data");
            print(dataUrl);
            ProductDetailFirestore()
                .AddProductToCart(dataUrl, name, desc, quantity, price);
            // return dataUrl;
          } else {
            print(n);
            print(pickedImagess.length);
            print("Not sending data");
          }
          n = n + 1;

          // return downloadUrl;
          // .add({"url": downloadUrl}).then((value) => print("UtsavUrls"));

          // print("Download Url:::    $downloadUrl");
        } else {}
      } on FirebaseException catch (e) {
        print("errorrrrr");
        OurToast().showErrorToast(e.message!);
        Get.find<LoginController>().toggle(false);
      }
    });
  }

  Future<File> compressImage(File file) async {
    print("Inside compress images");
    File compressedFile =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    print("original size ${file.lengthSync()}");
    print(compressedFile.lengthSync());
    return compressedFile;
  }
}
