import 'package:get/get.dart';

class ResourcesController extends GetxController {

  int drawerIndex = 1;
  double drawerWidth = 70;

  bool getIsMobile() {
    if (Get.size.width <
        Get.size.height) {
      return true;
    } else {
      return false;
    }
  }

  void setDrawerIndex(int index){
    this.drawerIndex = index;
    update();
  }

  void setDrawerWidth(double width){
    this.drawerWidth = width;
    update();
  }


}

