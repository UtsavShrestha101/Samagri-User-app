import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTextController extends GetxController {
  var searchText = "".obs;
  var search_controller = TextEditingController().obs;

  void changeValue(String value) {
    searchText.value = value;
  }

  void clearController() {
    searchText.value = "";
    search_controller.value.clear();
  }
}
