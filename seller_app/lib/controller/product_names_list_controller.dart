import 'package:get/get.dart';

class ProductListName extends GetxController {
  RxList<String> productList = <String>[].obs;
  void clearList() {
    productList.value = [];
  }

  void addProduct(String url) {
    print("inside controller");
    print(url);
    print("Check");
    productList.value.add(url);
  }
}
