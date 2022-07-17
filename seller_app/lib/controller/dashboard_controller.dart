import 'package:get/state_manager.dart';

class DashboardController extends GetxController{
  var indexs = 0.obs;

  changeIndexs(int value){
    indexs.value = value;
  }
}