import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:myapp/widget/our_text_field.dart';

import '../../controller/login_controller.dart';
import '../../controller/product_names_list_controller.dart';
import '../../services/addImages/product_image.dart';
import '../../services/compress image/compress_image.dart';
import '../../widget/our_spinner.dart';

class ShopAddProductScreen extends StatefulWidget {
  const ShopAddProductScreen({Key? key}) : super(key: key);

  @override
  State<ShopAddProductScreen> createState() => _ShopAddProductScreenState();
}

class _ShopAddProductScreenState extends State<ShopAddProductScreen> {
  TextEditingController _product_name_controller = TextEditingController();
  TextEditingController _product_desc_controller = TextEditingController();
  TextEditingController _product_price_controller = TextEditingController();
  TextEditingController _product_quantity_controller = TextEditingController();

  FocusNode _product_name_node = FocusNode();
  FocusNode _product_desc_node = FocusNode();
  FocusNode _product_price_node = FocusNode();
  FocusNode _product_quantity_node = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _product_name_controller.dispose();
    _product_desc_controller.dispose();
    _product_price_controller.dispose();
    _product_quantity_controller.dispose();
  }

  List<File> images = [];
  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

//  VEGETABLE&FRUITS
//  BEAUTY

  final item = [
    "Grocery",
    "Electronic",
    "Beverage",
    "Personal care",
    "Fashain and apparel",
    "Baby care",
    "Bakery and dairy",
    "Eggs and meat",
    "Household items",
    "Kitchen and pet food",
    "Vegitable and fruits",
    "Beauty",
  ];
  String? categoryItem;
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Center(
          child: Text(
            item,
            style: TextStyle(
              color: logoColor,
              fontSize: ScreenUtil().setSp(
                17.5,
              ),
            ),
          ),
        ),
      );

  int quantityValue = 1;

  @override
  void initState() {
    super.initState();
    Get.find<ProductListName>().clearList();
  }

  Future<List<File>> pickImages() async {
    List<File> images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (files != null && files.files.isNotEmpty) {
        for (var i = 0; i < files.files.length; i++) {
          images.add(File(files.files[i].path!));
        }
      } else {}
    } catch (e) {
      print(e);
      print("Error occured");
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: Get.find<LoginController>().processing.value,
        progressIndicator: OurSpinner(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(
                  ScreenUtil().setSp(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      images.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                selectImages();
                              },
                              child: DottedBorder(
                                color: logoColor,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(
                                  ScreenUtil().setSp(15),
                                ),
                                dashPattern: [10, 4],
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setSp(20),
                                  ),
                                  width: double.infinity,
                                  height: ScreenUtil().setSp(140),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(15),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: ScreenUtil().setSp(35),
                                        color: logoColor,
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "Select Product Images",
                                        style: TextStyle(
                                          color: logoColor,
                                          fontSize: ScreenUtil().setSp(
                                            17.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : CarouselSlider(
                              items: images
                                  .map((e) => Builder(
                                      builder: (context) => Image.file(e,
                                          fit: BoxFit.contain,
                                          height: ScreenUtil().setSp(200))))
                                  .toList(),
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                viewportFraction: 1,
                                height: ScreenUtil().setSp(200),
                              ),
                            ),
                      OurSizedBox(),
                      OurSizedBox(),
                      CustomTextField(
                        width: 5,
                        start: _product_name_node,
                        end: _product_desc_node,
                        letterlength: 10000,
                        controller: _product_name_controller,
                        validator: (value) {},
                        title: "Product Name",
                        type: TextInputType.name,
                        number: 0,
                        length: 1,
                      ),
                      OurSizedBox(),
                      CustomTextField(
                        width: 5,
                        height: 150,
                        start: _product_desc_node,
                        end: _product_price_node,
                        letterlength: 10000,
                        controller: _product_desc_controller,
                        validator: (value) {},
                        title: "Product Description",
                        type: TextInputType.name,
                        number: 0,
                        length: 7,
                      ),
                      CustomTextField(
                        width: 5,
                        start: _product_price_node,
                        end: _product_quantity_node,
                        letterlength: 10000,
                        controller: _product_price_controller,
                        validator: (value) {},
                        title: "Product Price",
                        type: TextInputType.number,
                        number: 0,
                        length: 1,
                      ),
                      OurSizedBox(),
                      Text(
                        "Travelling for:",
                        style: TextStyle(
                          color: darklogoColor,
                          fontSize: ScreenUtil().setSp(17.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      OurSizedBox(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey[500]!,
                            ),
                            borderRadius: BorderRadius.circular(
                              ScreenUtil().setSp(15),
                            )),
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(5),
                          vertical: ScreenUtil().setSp(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            isExpanded: true,
                            hint: Center(
                              child: Text(
                                "Category",
                                style: TextStyle(
                                  color: logoColor,
                                  fontSize: ScreenUtil().setSp(
                                    17.5,
                                  ),
                                ),
                              ),
                            ),
                            value: categoryItem,
                            onChanged: (value) => setState(() {
                              this.categoryItem = value;
                            }),
                            items: item.map(buildMenuItem).toList(),
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Stock Quantity:",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(17.5),
                              color: logoColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (quantityValue > 1) {
                                    quantityValue--;
                                  }
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: ScreenUtil().setSp(30),
                                  color: logoColor,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setSp(10),
                              ),
                              Text(
                                quantityValue.toString(),
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  color: logoColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setSp(10),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantityValue++;
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  size: ScreenUtil().setSp(30),
                                  color: logoColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      OurSizedBox(),
                      Center(
                        child: OurElevatedButton(
                          title: "Add Product",
                          function: () async {
                            Get.find<LoginController>().toggle(true);
                            List<String?>? urls;
                            urls = await AddProduct().uploadImage(
                              images,
                              _product_name_controller.text.trim(),
                              _product_desc_controller.text.trim(),
                              quantityValue,
                              double.parse(
                                _product_price_controller.text.trim(),
                              ),
                              categoryItem!,
                            );
                            print("Utsav");
                            print(
                                Get.find<ProductListName>().productList.value);
                            print("Utkrista");

                            // Get.find<LoginController>().toggle(false);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
