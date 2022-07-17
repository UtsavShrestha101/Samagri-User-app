import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';

Future<File> compressImage(File file) async {
  print("Inside compress file");
  File compressedFile =
      await FlutterNativeImage.compressImage(file.path, quality: 50);
  print("original size ${file.lengthSync()}");
  print(compressedFile.lengthSync());
  return compressedFile;
}
